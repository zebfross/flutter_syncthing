import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter_syncthing/bridge/ffi.dart';
import 'package:flutter_syncthing/bridge/isolate.dart';
import 'package:flutter_syncthing/flutter_syncthing.dart';

class Binding {
  static const String _callFuncName = 'SyncthingBridgeCall';
  static const String _libraryName = 'libsyncthing_bridge';
  static final Binding _singleton = Binding._internal();

  late ffi.DynamicLibrary _library;

  factory Binding() {
    return _singleton;
  }

  Binding._internal() {
    _library = openLib();
  }

  static callBridge(IsolateArguments args) async {
    var result = await Binding().call(args.name, args.payload);
    args.port.send(result);
  }

  Future<Uint8List> callAsync(String name, Uint8List payload) async {
    final port = ReceivePort();
    final args = IsolateArguments(name, payload, port.sendPort);

    Isolate.spawn<IsolateArguments>(
      callBridge,
      args,
      onError: port.sendPort,
      onExit: port.sendPort,
    );

    Completer<Uint8List> completer = new Completer();

    StreamSubscription? subscription;
    subscription = port.listen((message) async {
      await subscription?.cancel();
      completer.complete(message);
    });
    return completer.future;
  }

  Future<Uint8List> call(String name, Uint8List payload) async {
    final callable = _library
        .lookup<ffi.NativeFunction<call_func>>(_callFuncName)
        .asFunction<Call>();

    final pointer = malloc<ffi.Uint8>(payload.length);

    // https://github.com/dart-lang/ffi/issues/27
    // https://github.com/objectbox/objectbox-dart/issues/69
    for (var i = 0; i < payload.length; i++) {
      pointer[i] = payload[i];
    }
    final payloadPointer = pointer.cast<ffi.Void>();
    final namePointer = toUtf8(name);

    final result = callable(namePointer, payloadPointer, payload.length);

    malloc.free(namePointer);
    malloc.free(payloadPointer);

    handleError(result.ref.error, result);

    final output =
        result.ref.message.cast<ffi.Uint8>().asTypedList(result.ref.size);
    freeResult(result);
    return output;
  }

  void handleError(
      ffi.Pointer<Utf8> error, ffi.Pointer<FFIBytesReturn> result) {
    if (error.address != ffi.nullptr.address) {
      var message = fromUtf8(error);
      freeResult(result);
      throw new SyncthingException(message);
    }
  }

  ffi.Pointer<Utf8> toUtf8(String? text) {
    return text == null ? "".toNativeUtf8() : text.toNativeUtf8();
  }

  String fromUtf8(ffi.Pointer<Utf8>? text) {
    return text == null ? "" : text.toDartString();
  }

  void freeResult(ffi.Pointer<FFIBytesReturn> result) {
    if (!Platform.isWindows) {
      malloc.free(result);
    }
  }

  bool isSupported() {
    return Platform.isWindows || Platform.isAndroid || Platform.isIOS;
  }

  ffi.DynamicLibrary openLib() {
    if (Platform.isMacOS) {
      return ffi.DynamicLibrary.open("$_libraryName.dylib");
    }
    if (Platform.isWindows) {
      return ffi.DynamicLibrary.open("$_libraryName.dll");
    }
    if (Platform.isIOS) {
      return ffi.DynamicLibrary.process();
    }
    if (Platform.isLinux) {
      return ffi.DynamicLibrary.open("$_libraryName.so");
    }
    try {
      return ffi.DynamicLibrary.open("$_libraryName.so");
    } catch (e) {
      print("fallback to open DynamicLibrary on older devices");
      //fallback for devices that cannot load dynamic libraries by name: load the library with an absolute path
      //read the app id
      var appid = File("/proc/self/cmdline").readAsStringSync();
      // the file /proc/self/cmdline returns a string with many trailing \0 characters, which makes the string pretty useless for dart, many
      // operations will not work correctly. remove these trailing zero bytes.
      appid = String.fromCharCodes(
          appid.codeUnits.where((element) => element != 0));
      final loadPath = "/data/data/$appid/lib/$_libraryName.so";
      return ffi.DynamicLibrary.open(loadPath);
    }
  }
}

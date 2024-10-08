import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

enum LoadingProgress { notStarted, started, done }

mixin AssetsInitializer<T extends StatefulWidget> on State<T> {
  LoadingProgress loadingState = LoadingProgress.notStarted;
  bool initOK = false;

  @override
  void initState() {
    super.initState();
  }

  Future<String> localText(final String name) =>
      DefaultAssetBundle.of(context).loadString(name);

  bool tryLock() {
    log('trying to lock: state $loadingState', name: 'tools.Assets');
    sleep(const Duration(seconds: 1));

    if (loadingState == LoadingProgress.notStarted) {
      setState(() {
        loadingState = LoadingProgress.started;
      });

      return true;
    }

    return false;
  }

  Future<void> reset(final Function() onEnd) async {
    setState(() {
      loadingState = LoadingProgress.started;
    });

    await _load(onEnd);
  }

  Future<void> init(final Function() onEnd) async {
    setState(() {
      initOK = false;
    });

    await _load(onEnd);

    setState(() {
      initOK = true;
    });
  }

  Future<void> _load(final Function() onEnd) async {
    onEnd();
  }
}

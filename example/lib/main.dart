import 'package:flutter/material.dart';
import 'package:magic_receipts/magic_receipts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String _androidApiKey = "ANDROID_API_KEY";
  static const String _iOSApiKey = "IOS_API_KEY";

  String? _logMessage;
  bool _incentiveMode = false;

  _initializePollfish() {
    MagicReceipts.setMagicReceiptsWallLoadedListener(
        _onMagicReceiptsWallLoaded);
    MagicReceipts.setMagicReceiptsWallLoadFailedListener(
        _onMagicReceiptsWallLoadFailed);
    MagicReceipts.setMagicReceiptsWallShowedListener(
        _onMagicReceiptsWallShowed);
    MagicReceipts.setMagicReceiptsWallShowFailedListener(
        _onMagicReceiptsWallShowFailed);

    MagicReceipts.initialize(
        androidApiKey: _androidApiKey,
        iosApiKey: _iOSApiKey,
        incentiveMode: _incentiveMode,
        userId: "pollfish-fotis");
  }

  _onMagicReceiptsWallLoaded() {
    setState(() {
      _logMessage = "Wall loaded";
    });
  }

  _onMagicReceiptsWallLoadFailed(MagicReceiptsLoadError error) {
    setState(() {
      _logMessage = "Wall load failed with error: ${error.message}";
    });
  }

  _onMagicReceiptsWallShowed() {
    setState(() {
      _logMessage = "Wall Showed";
    });
  }

  _onMagicReceiptsWallShowFailed(MagicReceiptsShowError error) {
    setState(() {
      _logMessage = "Wall load failed with error: ${error.message}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Magic Receipts sample app'),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: const Text('Initialize'),
                onPressed: () => _initializePollfish(),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () => MagicReceipts.show(),
                        child: const Text("Show")),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () => MagicReceipts.hide(),
                        child: const Text("Hide")),
                  )
                ],
              ),
              Row(
                children: [
                  const Text("Incentive mode"),
                  const Spacer(),
                  Switch(
                      value: _incentiveMode,
                      onChanged: (value) {
                        setState(() {
                          _incentiveMode = value;
                        });
                      })
                ],
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                  onPressed: () {
                    MagicReceipts.isReady().then((value) => {
                          setState(() {
                            _logMessage =
                                value ? "SDK is ready" : "SDK is not ready";
                          })
                        });
                  },
                  child: const Text("Is Ready?")),
              const SizedBox(
                width: 8,
              ),
              _logMessage != null
                  ? Text("Last log: $_logMessage")
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:ai_barcode/src/creator/ai_barcode_mobile_creator_plugin.dart';
import 'package:ai_barcode/src/scanner/ai_barcode_mobile_scanner_plugin.dart';
import 'package:ai_barcode_platform_interface/ai_barcode_platform_interface.dart';
import 'package:flutter/material.dart';

///
/// PlatformScannerWidget
///
/// Supported android and ios platform read barcode
// ignore: must_be_immutable
class PlatformAiBarcodeScannerWidget extends StatefulWidget {
  ///
  /// Controller.
  ScannerController _platformScannerController;

  ///
  /// UnsupportedDescription
  String _unsupportedDescription;

  ///
  /// Constructor.
  PlatformAiBarcodeScannerWidget({
    required ScannerController platformScannerController,
    String? unsupportedDescription,
  }) :
      this._platformScannerController = platformScannerController,
      this._unsupportedDescription = unsupportedDescription ?? "";

  @override
  State<StatefulWidget> createState() {
    return _PlatformScannerWidgetState();
  }
}

///
/// _PlatformScannerWidgetState
class _PlatformScannerWidgetState
    extends State<PlatformAiBarcodeScannerWidget> {
//  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
  }

  ///
  /// CreatedListener.
  _widgetCreatedListener() {
    widget._platformScannerController._scannerViewCreated();
  }

  ///
  /// Web result callback
  void _webResultCallback(String result) {
    if (widget._platformScannerController != null) {
      if (widget._platformScannerController._scannerResult != null) {
        //callback
        widget._platformScannerController._scannerResult(result);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    //Release
    AiBarcodeScannerPlatform.instance.removeListener(_widgetCreatedListener);
    AiBarcodeScannerPlatform.instance.removeResultCallback(_webResultCallback);
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android || platform == TargetPlatform.iOS) {
      AiBarcodeScannerPlatform.instance = AiBarcodeMobileScannerPlugin();
    }
    //Create
    AiBarcodeScannerPlatform.instance.addListener(_widgetCreatedListener);
    AiBarcodeScannerPlatform.instance.addResultCallback(_webResultCallback);
    AiBarcodeScannerPlatform.instance.unsupportedPlatformDescription =
        widget._unsupportedDescription;
    return AiBarcodeScannerPlatform.instance.buildScannerView(context);
  }
}

///
/// PlatformScannerController
class ScannerController {
  ///
  /// Result
  Function(String result) _scannerResult;
  Function() _scannerViewCreated;

  ///
  /// Constructor.
  ScannerController({
    required scannerResult(String result),
    required scannerViewCreated(),
  }) :
      this._scannerResult = scannerResult,
      this._scannerViewCreated = scannerViewCreated;

  Function() get scannerViewCreated => _scannerViewCreated;

  bool get isStartCamera => AiBarcodeScannerPlatform.instance.isStartCamera;
  bool get isStartCameraPreview =>
      AiBarcodeScannerPlatform.instance.isStartCameraPreview;

  bool get isOpenFlash => AiBarcodeScannerPlatform.instance.isOpenFlash;

  ///
  /// Start camera without open QRCode、BarCode scanner,this is just open camera.
  startCamera() {
    AiBarcodeScannerPlatform.instance.startCamera();
  }

  ///
  /// Stop camera.
  stopCamera() async {
    AiBarcodeScannerPlatform.instance.stopCamera();
  }

  ///
  /// Start camera preview with open QRCode、BarCode scanner,this is open code scanner.
  startCameraPreview() async {
    String code = await AiBarcodeScannerPlatform.instance.startCameraPreview();
    _scannerResult(code);
  }

  ///
  /// Stop camera preview.
  stopCameraPreview() async {
    AiBarcodeScannerPlatform.instance.stopCameraPreview();
  }

  ///
  /// Open camera flash.
  openFlash() async {
    AiBarcodeScannerPlatform.instance.openFlash();
  }

  ///
  /// Close camera flash.
  closeFlash() async {
    AiBarcodeScannerPlatform.instance.closeFlash();
  }

  ///
  /// Toggle camera flash.
  toggleFlash() async {
    AiBarcodeScannerPlatform.instance.toggleFlash();
  }
}

///
/// PlatformAiBarcodeCreatorWidget
///
/// Supported android and ios write barcode
// ignore: must_be_immutable
class PlatformAiBarcodeCreatorWidget extends StatefulWidget {
  CreatorController _creatorController;
  String _initialValue;
  String _unsupportedDescription;
  PlatformAiBarcodeCreatorWidget({
    required CreatorController creatorController,
    required String initialValue,
    required String unsupportedDescription,
  }) :
      this._creatorController = creatorController,
      this._initialValue = initialValue,
      this._unsupportedDescription = unsupportedDescription;

  @override
  State<StatefulWidget> createState() {
    return _PlatformAiBarcodeCreatorState();
  }
}

///
/// _PlatformAiBarcodeCreatorState
class _PlatformAiBarcodeCreatorState
    extends State<PlatformAiBarcodeCreatorWidget> {
  @override
  void initState() {
    super.initState();
  }

  _creatorCreatedCallback() {
    if (widget._creatorController != null &&
        widget._creatorController._creatorViewCreated != null) {
      widget._creatorController._creatorViewCreated();
    }
  }

  @override
  void dispose() {
    super.dispose();
    //release
    AiBarcodeCreatorPlatform.instance.removeListener(_creatorCreatedCallback);
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android || platform == TargetPlatform.iOS) {
      AiBarcodeCreatorPlatform.instance = AiBarcodeMobileCreatorPlugin();
    }
    //create
    AiBarcodeCreatorPlatform.instance.unsupportedPlatformDescription =
        widget._unsupportedDescription;
    AiBarcodeCreatorPlatform.instance.initialValueOfCreator =
        widget._initialValue;
    AiBarcodeCreatorPlatform.instance.addListener(_creatorCreatedCallback);
    return AiBarcodeCreatorPlatform.instance.buildCreatorView(context);
  }
}

///
/// CreatorController
class CreatorController {
  Function() _creatorViewCreated;

  CreatorController({
    required Function() creatorViewCreated,
  }) :
      this._creatorViewCreated = creatorViewCreated;

  void updateValue({
    required String value,
  }) {
    AiBarcodeCreatorPlatform.instance.updateQRCodeValue(value);
  }
}

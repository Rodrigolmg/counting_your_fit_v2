part of util;

class OverlayController {
  OverlayController._();

  static const MethodChannel _channel =
      MethodChannel('rl/main_channel');
  static final StreamController _controller = StreamController();
  static const MethodChannel _channelOverlay =
    MethodChannel('rl/overlay_channel');

  static Future<bool> get isPermissionGranted async {
    try {
      return await _channel.invokeMethod<bool>('checkPermission') ?? false;
    } on PlatformException {
      return Future.value(false);
    }
  }

  static Future<bool?> get requestPermission async {
    try {
      return await _channel.invokeMethod<bool?>('requestPermission');
    } on PlatformException {
      rethrow;
    }
  }

  static Future<void> showOverlay({
    int height = WindowSize.fullCover,
    int width = WindowSize.matchParent,
    OverlayAlignment alignment = OverlayAlignment.center,
    OverlayNotificationVisibility visibility = OverlayNotificationVisibility
        .visibilitySecret,
    OverlayFlag overlayFlag = OverlayFlag.defaultFlag,
    String overlayTitle = "overlay activated",
    String? overlayContent,
    bool enableDrag = false,
    OverlayPositionGravity positionGravity = OverlayPositionGravity.none
  }) async {
      await _channel.invokeMethod('showOverlay',{
        "height": height,
        "width": width,
        "alignment": alignment.name,
        "flag": overlayFlag.name,
        "overlayTitle": overlayTitle,
        "overlayContent": overlayContent,
        "enableDrag": enableDrag,
        "notificationVisibility": visibility.name,
        "positionGravity": positionGravity.name
      });
  }

  static Future<bool?> closeOverlay() async{
    bool? res = await _channel.invokeMethod('closeOverlay');
    return res;
  }

  static Future<bool?> updateFlag(OverlayFlag flag) async {
    final bool? resFlag = await _channelOverlay.invokeMethod<bool?>(
      'updateFlag',
      {
        'flag': flag.name
      }
    );

    return resFlag;
  }

  static Future<bool?> resizeOverlay(int width, int height) async {
    final bool? res = await _channelOverlay.invokeMethod<bool?>(
      'resizeOverlay',
      {
        'width': width,
        'height': height
      }
    );

    return res;
  }

  static Future<bool> get isActive async {
    return await _channel.invokeMethod<bool?>('isOverlayActive') ?? false;
  }

  static void disposeOverlayListener(){
    _controller.close();
  }
}
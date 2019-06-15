package flutter.audiorecorder.flexible_audio_recorder;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlexibleAudioRecorderPlugin */
public class FlexibleAudioRecorderPlugin implements MethodCallHandler {

  private final AudioRecorderDelegate delegate;

  private  FlexibleAudioRecorderPlugin(AudioRecorderDelegate delegate) {
    this.delegate = delegate;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flexible_audio_recorder");

    AudioRecorderDelegate delegate = new AudioRecorderDelegate(registrar.activity());
    FlexibleAudioRecorderPlugin handler = new FlexibleAudioRecorderPlugin(delegate);
    channel.setMethodCallHandler(handler);
    registrar.addRequestPermissionsResultListener(delegate);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    final String method = call.method;
    switch (method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "hasAudioPermission":
        delegate.handleHasAudioPermission(call, result);
        break;
      case "isRecording":
        delegate.handleIsRecording(call, result);
        break;
      case "startRecording":
        delegate.handleStartRecording(call, result);
        break;
      case "stopRecording":
        delegate.handleStopRecording(call, result);
        break;
      case "requestAudioPermission":
        delegate.handleRequestAudioPermission(call, result);
        break;
      case "setConfig":
        delegate.handleSetConfig(call, result);
        break;
      case "getConfig":
        delegate.handleGetConfig(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}

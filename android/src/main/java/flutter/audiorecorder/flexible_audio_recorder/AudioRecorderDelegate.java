package flutter.audiorecorder.flexible_audio_recorder;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.media.MediaRecorder;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * Created by Ivan Kuznetsov
 * 14.06.2019.
 */
public class AudioRecorderDelegate implements PluginRegistry.RequestPermissionsResultListener {

    private static final int REQUEST_CODE = 346346;
    private final Activity activity;

    private MethodChannel.Result pendingRequestAudioPermissionResult;

    private MediaRecorder recorder = null;
    private String filePath;

    private AudioRecorderConfig recorderConfig = AudioRecorderConfig.defaultConfig();

    AudioRecorderDelegate(Activity activity) {
        this.activity = activity;
    }

    void handleHasAudioPermission(MethodCall call, MethodChannel.Result result) {
        result.success(isAudioPermissionGranded());
    }

    void handleRequestAudioPermission(MethodCall call, MethodChannel.Result result) {
        if (!isAudioPermissionGranded()) {
            pendingRequestAudioPermissionResult = result;
            ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.RECORD_AUDIO}, REQUEST_CODE);
        } else {
            result.success(true);
        }
    }

    void handleIsRecording(MethodCall call, MethodChannel.Result result) {
        result.success(isRecording());
    }

    private boolean isRecording() {
        return recorder != null;
    }

    @SuppressWarnings("unchecked")
    void handleStartRecording(MethodCall call, MethodChannel.Result result) {
        if (!isAudioPermissionGranded()) {
            result.error("error", "startRecording", "Need request Audio permission!");
            return;
        }

        if (isRecording()) {
            result.error("error", "startRecording", "Already recording!");
            return;
        }

        Map<String, Object> arguments = (Map<String, Object>) call.arguments;

        this.filePath = (String) arguments.get("filePath");

        if (this.filePath == null) {
            this.filePath = generateFileName();
        }

        try {
            startRecording();
            result.success(filePath);
        } catch (Exception e) {
            e.printStackTrace();
            result.error("error", "startRecording", e.toString());
            recorder = null;
        }
    }

    void handleSetConfig(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> arguments = (Map<String, Object>) call.arguments;

        final Integer audioChannels = (Integer) arguments.get("audioChannels");
        final Integer audioEncoder = (Integer) arguments.get("audioEncoder");
        final Integer audioEncodingBitRate = (Integer) arguments.get("audioEncodingBitRate");
        final Integer audioSource = (Integer) arguments.get("audioSource");
        final Integer outputFormat = (Integer) arguments.get("outputFormat");

        this.recorderConfig = new AudioRecorderConfig(audioChannels, audioEncoder, audioEncodingBitRate, audioSource, outputFormat);

        result.success(null);
    }

    void handleGetConfig(MethodCall call, MethodChannel.Result result) {
        AudioRecorderConfig config = this.recorderConfig;

        final Map<String, Integer> map = new HashMap<>();
        map.put("audioChannels", config.getAudioChannels());
        map.put("audioEncoder", config.getAudioEncoder());
        map.put("audioEncodingBitRate", config.getAudioEncodingBitRate());
        map.put("audioSource", config.getAudioSource());
        map.put("outputFormat", config.getOutputFormat());

        result.success(map);
    }

    private boolean isAudioPermissionGranded() {
        return ContextCompat.checkSelfPermission(activity, Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED;
    }

    void handleStopRecording(MethodCall call, MethodChannel.Result result) {
        if (!isRecording()) {
            result.error("error", "stopRecording", "Not recording!");
            return;
        }

        stopRecording();
        result.success(filePath);
        filePath = null;
    }

    private void stopRecording() {
        recorder.stop();
        recorder.release();
        recorder = null;
    }

    private void startRecording() throws IOException {
        recorder = new MediaRecorder();

        setupRecorder();
        recorder.setOutputFile(filePath);

        recorder.prepare();
        recorder.start();
    }

    private void setupRecorder() {
        if (recorderConfig.getAudioChannels() != null) {
            recorder.setAudioChannels(recorderConfig.getAudioChannels());
        }

        if (recorderConfig.getAudioEncodingBitRate() != null) {
            recorder.setAudioEncodingBitRate(recorderConfig.getAudioEncodingBitRate());
        }

        if (recorderConfig.getAudioSource() != null) {
            recorder.setAudioSource(recorderConfig.getAudioSource());
        }

        if (recorderConfig.getOutputFormat() != null) {
            recorder.setOutputFormat(recorderConfig.getOutputFormat());
        }

        if (recorderConfig.getAudioEncoder() != null) {
            recorder.setAudioEncoder(recorderConfig.getAudioEncoder());
        }
    }

    private String generateFileName() {
        File audioRecordsFolder = new File(activity.getCacheDir() + "/AudioRecords");
        audioRecordsFolder.mkdir();

        return new File(audioRecordsFolder + "/" + System.currentTimeMillis()).getPath();
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == REQUEST_CODE ) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                pendingRequestAudioPermissionResult.success(true);
            } else {
                pendingRequestAudioPermissionResult.success(false);
            }
            pendingRequestAudioPermissionResult = null;
            return true;
        }
        return false;
    }
}

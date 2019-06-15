package flutter.audiorecorder.flexible_audio_recorder;

import android.media.MediaRecorder;

/**
 * Created by Ivan Kuznetsov
 * 15.06.2019.
 */
final class AudioRecorderConfig {

    static AudioRecorderConfig defaultConfig() {
        return new AudioRecorderConfig(null, MediaRecorder.AudioEncoder.AMR_NB, null, MediaRecorder.AudioSource.MIC, MediaRecorder.OutputFormat.THREE_GPP, null);
    }

    private final Integer audioChannels;
    private final Integer audioEncoder;
    private final Integer audioEncodingBitRate;
    private final Integer audioSource;
    private final Integer outputFormat;
    private final Integer audioSamplingRate;

    AudioRecorderConfig(Integer audioChannels, Integer audioEncoder, Integer audioEncodingBitRate, Integer audioSource, Integer outputFormat, Integer audioSamplingRate) {
        this.audioChannels = audioChannels;
        this.audioEncoder = audioEncoder;
        this.audioEncodingBitRate = audioEncodingBitRate;
        this.audioSource = audioSource;
        this.outputFormat = outputFormat;
        this.audioSamplingRate = audioSamplingRate;
    }


    Integer getAudioChannels() {
        return audioChannels;
    }

    Integer getAudioEncoder() {
        return audioEncoder;
    }

    Integer getAudioEncodingBitRate() {
        return audioEncodingBitRate;
    }

    Integer getAudioSource() {
        return audioSource;
    }

    Integer getOutputFormat() {
        return outputFormat;
    }

    public Integer getAudioSamplingRate() {
        return audioSamplingRate;
    }
}

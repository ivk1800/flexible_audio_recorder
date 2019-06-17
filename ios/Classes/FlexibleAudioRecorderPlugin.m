#import "FlexibleAudioRecorderPlugin.h"

@implementation FlexibleAudioRecorderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flexible_audio_recorder"
            binaryMessenger:[registrar messenger]];
  FlexibleAudioRecorderPlugin* instance = [[FlexibleAudioRecorderPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"isRecording" isEqualToString:call.method]) {
      result([self isRecording]);
  } else if ([@"hasAudioPermission" isEqualToString:call.method]) {
      result([self hasAudioPermission]);
  } else if ([@"requestAudioPermission" isEqualToString:call.method]) {
      [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
          result([NSNumber numberWithBool:granted ? YES : NO]);
      }];
  } else if ([@"startRecording" isEqualToString:call.method]) {
      [self startRecording:call result:result];
  } else if ([@"stopRecording" isEqualToString:call.method]) {
      if (_audioRecorder) {
          [_audioRecorder stop];
          _audioRecorder = nil;
          
          result(_soundFileURL.path);
          _soundFileURL = nil;
      }
      result(nil);
  } else {
      result(FlutterMethodNotImplemented);
  }
}

- (NSNumber *) isRecording {
    return [NSNumber numberWithBool:_audioRecorder != nil ? YES : NO];
}

- (NSString *) generateFileName {
    NSError *error;
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/AudioRecords"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *UUID = [[NSUUID UUID] UUIDString];
    return [NSString stringWithFormat:@"%@/%@%@", dataPath, UUID, @".caf"];
}

- (NSNumber *) hasAudioPermission {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    AVAudioSessionRecordPermission sessionRecordPermission = [session recordPermission];
    return [NSNumber numberWithBool:sessionRecordPermission == AVAudioSessionRecordPermissionGranted ? YES : NO];
}

- (void) startRecording:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([self hasAudioPermission] == NO) {
        result([FlutterError errorWithCode:@"error"
                                   message:@"startRecording"
                                   details:@"Need request Audio permission!"]);
        return;
    }

    if (_audioRecorder != nil) {
        result([FlutterError errorWithCode:@"error"
                                   message:@"startRecording"
                                   details:@"Already recording!"]);
        return;
    }
    
    NSDictionary *_arguments = call.arguments;
    NSString *filePath = [_arguments objectForKey:@"filePath"];
    
    if ([filePath isEqual:[NSNull null]]) {
        filePath = [self generateFileName];
    }
    
    NSURL *soundFileURL = [NSURL URLWithString:filePath];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSettings setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    NSError *error = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    
    _soundFileURL = soundFileURL;
    
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:soundFileURL
                      settings:recordSettings
                      error:&error];
    
    if (error) {
        result([FlutterError errorWithCode:@"error"
                                   message:@"startRecording"
                                   details:error]);
    } else {
        [_audioRecorder prepareToRecord];
        [_audioRecorder record];
        result(soundFileURL.path);
    }
}

@end

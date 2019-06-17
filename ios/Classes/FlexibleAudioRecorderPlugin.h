#import <Flutter/Flutter.h>
#import <AVFoundation/AVFoundation.h>

@interface FlexibleAudioRecorderPlugin : NSObject<FlutterPlugin>
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) NSURL *soundFileURL;
@end

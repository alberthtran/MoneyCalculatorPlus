//
//  voiceMemoController.h
//  pocketCalc
//
//  Created by Wilson Kong on 12/14/11.
//  Copyright (c) 2011 WKode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "AudioQueueObject.h"
#import "AudioRecorder.h"
#import "AudioPlayer.h"
#import "ConstantValues.h"
#import "UserDatabase.h"
#import "pocketCalcViewController.h"

@interface voiceMemoController : UIViewController
{
    //UserDatabase *sharedUserInfo;
    //pocketCalcViewController *myBoss;
    NSTimer *recTimer;
    IBOutlet UIButton *recBtn;
    IBOutlet UIButton *playBtn;
    IBOutlet UIButton *trashBtn;
    UserDatabase *sharedUserInfo;
    IBOutlet UIButton *recBar;
    UIButton *recStatusBar;
    pocketCalcViewController *myBoss;
//    AudioRecorder				*audioRecorder;
//	AudioPlayer					*audioPlayer;
//	NSURL						*soundFileURL;
//	NSString					*recordingDirectory;
//    BOOL isRecording;
//    BOOL isPlaying;
    
//    = [UIButton buttonWithType:UIButtonTypeCustom];
//    [recBar setImage:[UIImage imageNamed:@"recBar.png"] forState:UIControlStateNormal];
//    recBar.backgroundColor = [UIColor redColor];
//    recBar.frame = CGRectMake(10, 185, 0, 12);
//    
//    recBar.hidden = YES;
    
    

    
}

//@property (nonatomic, retain)	AudioRecorder				*audioRecorder;
//@property (nonatomic, retain)	AudioPlayer					*audioPlayer;
//@property (nonatomic, retain)	NSURL						*soundFileURL;
//@property (nonatomic, retain)	NSString					*recordingDirectory;
//
///* for sound recording */
//- (void) recordOrStop:(id)sender;
//- (void) playOrStop:(id)sender;
//- (void) stopPlay:(id)sender;
//- (BOOL)RecordingState;
//- (BOOL)PlayingState;

@end

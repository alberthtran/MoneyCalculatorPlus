//
//  voiceRecorder.h
//  pocketCalc
//
//  Created by Albert Tran on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UserDatabase.h"

@interface voiceRecorder : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>{
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *recButton;
    IBOutlet UILabel *recStateLabel;
    
    BOOL isNotRecording;
    NSURL *temporaryRecFile;
    AVAudioRecorder *myRecorder;
    
    AVAudioPlayer *myPlayer;
    
    NSTimer *playTimer;
    NSTimer *recTimer;
    IBOutlet UIButton *recBar;
    UIButton *recStatusBar;
    
    //SystemSoundID soundID;
    BOOL isPlaying;
    
    UserDatabase *sharedUserInfo;
    NSDictionary *recordSetting;
}

@property (nonatomic,retain) IBOutlet UIButton *playButton;
@property (nonatomic,retain) IBOutlet UIButton *recButton;

- (IBAction)recording:(id)sender;
- (IBAction)playback:(id)sender;

- (void) itouchUserWarning;

@end


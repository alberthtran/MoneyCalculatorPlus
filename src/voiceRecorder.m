//
//  voiceRecorder.m
//  pocketCalc
//
//  Created by Albert Tran on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "voiceRecorder.h"
#import "ConstantValues.h"

BOOL playing = NO;

@implementation voiceRecorder

@synthesize recButton,playButton;



- (void)recCounter:(NSTimer *)theTimer
{
    if (recTimer != NULL) {
        
        if (recStatusBar.frame.size.width < 300) {
            recStatusBar.frame = CGRectMake(recStatusBar.frame.origin.x, recStatusBar.frame.origin.y, recStatusBar.frame.size.width + 1, recStatusBar.frame.size.height);
            recTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(recCounter:) userInfo:nil repeats:NO];
            
        }
        else
        {
            [recTimer invalidate];
            recTimer = NULL;
            [self recording:nil];
        }
    }
}

- (void)checkPlay:(NSTimer *)theTimer
{
    if (playTimer != NULL) {
        
        if (playing == YES) {
            
            playTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkPlay:) userInfo:nil repeats:NO];
            
        }
        else
        {
            [playButton setImage:[UIImage imageNamed:@"playoffbtn.png"] forState:UIControlStateNormal];
            recButton.hidden = NO;
            [playTimer invalidate];
            playTimer = NULL;
        }
    }
}

- (void)playBack:(NSTimer *)theTimer
{
    [self playback:nil];
}

- (IBAction)recording:(id)sender
{
    if (isNotRecording) {
        isNotRecording = NO;
        //[recButton setTitle:@"STOP" forState:UIControlStateNormal];
        [recButton setImage:[UIImage imageNamed:@"recordonbtn.png"] forState:UIControlStateNormal];
        playButton.hidden = YES;
        recStateLabel.text = @"Recording";

        /*
        BOOL success = [fileManager fileExistsAtPath:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]];
        
        if(!success)
            return;
        
        //self.recordingDirectory = [filePaths objectAtIndex: 0];
        CFStringRef fileString = (CFStringRef) [NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER];
        */
        
        temporaryRecFile = [NSURL fileURLWithPath:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]];
        
        //temporaryRecFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithString:@"VoiceFile.aif"]]];
        
        myRecorder = [[AVAudioRecorder alloc] initWithURL:temporaryRecFile settings:recordSetting error:nil];
        [myRecorder setDelegate:self];
        [myRecorder prepareToRecord];
        [myRecorder record];
        
        recStatusBar.frame = CGRectMake(recStatusBar.frame.origin.x, recStatusBar.frame.origin.y, 0, recStatusBar.frame.size.height);
        recBar.hidden = NO;
        recTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(recCounter:) userInfo:nil repeats:NO];
                
    }
    else {
        
        [recTimer invalidate];
        recTimer = NULL;

        
        isNotRecording = YES;
        
        [recButton setImage:[UIImage imageNamed:@"recordoffbtn.png"] forState:UIControlStateNormal];
        playButton.hidden = NO;
        recStateLabel.text = @"";
        
        [myRecorder stop];
//        [myRecorder release];
//        myRecorder = nil;
        
        recStatusBar.frame = CGRectMake(recStatusBar.frame.origin.x, recStatusBar.frame.origin.y, 0, recStatusBar.frame.size.height);
        recBar.hidden = YES;
        
        //isPlaying = NO;
        //[self playback:nil];
        //[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(playBack:) userInfo:nil repeats:NO];
    }
    
    [sharedUserInfo setGotRecordedMemo:YES];
    
}


- (IBAction)playback:(id)sender
{
    if (playing == NO) 
    {
        playing = YES;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        
        BOOL success = [fileManager fileExistsAtPath:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]]; 
        
        if (success) {
            
            [playButton setImage:[UIImage imageNamed:@"playonbtn.png"] forState:UIControlStateNormal];
            //            myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error:nil];
            myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]] error:nil];
            
            myPlayer.delegate = self;
            myPlayer.volume = 1.0;
            [myPlayer play];
            recButton.hidden = YES;
        }
        
    }
    else
    {
        playing = NO;
        [playButton setImage:[UIImage imageNamed:@"playoffbtn.png"] forState:UIControlStateNormal];
        [myPlayer stop];
        [myPlayer release];
        myPlayer = nil;
        recButton.hidden = NO;
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        recordSetting = [[NSMutableDictionary alloc] init];
//        
//        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
//        [recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey]; 
//        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
//        
//        [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//        [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
//        [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        
        
        /*
         recordSetting =[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:kAudioFormatMPEGLayer3],AVFormatIDKey,
                                      [NSNumber numberWithInt:8000.0],AVSampleRateKey,
                                      [NSNumber numberWithInt: 1],AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                      [NSNumber numberWithInt:AVAudioQualityMax],AVEncoderAudioQualityKey,
                                      nil];
        */
        recordSetting = [[NSMutableDictionary alloc] init];
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


-(void) backBtn
{
    [myRecorder stop];
    if (myPlayer != nil) {
        [myPlayer stop];
    }
    [self.navigationController popViewControllerAnimated:YES];
    return;
    
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    
    sharedUserInfo = [UserDatabase shared];
    
    isPlaying = NO;
    recBar.hidden = YES;
    recStatusBar = [UIButton buttonWithType:UIButtonTypeCustom];
    recStatusBar.frame = CGRectMake(0, 0, 0, 12);
    recStatusBar.backgroundColor = [UIColor redColor];
    [recBar addSubview:recStatusBar];

    
    UIImage *normalBackImage = [UIImage imageNamed:@"vmbtn.png"]; 
    //UIImage *higlightedBackImage = [UIImage imageNamed:@"back button pressed.png"]; 
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom]; backButton.bounds = CGRectMake( 0, 0, normalBackImage.size.width, normalBackImage.size.height ); 
    
    [backButton setImage:normalBackImage forState:UIControlStateNormal]; 
    
    //[backButton setImage:higlightedBackImage forState:UIControlStateHighlighted]; 
    
    [backButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton]; 
    self.navigationItem.leftBarButtonItem = backBarItem;
    self.title = @"Voice Memo";
    [backBarItem release];

    myPlayer = nil;
    myRecorder = nil;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mic.jpg"]];

    isNotRecording = YES;
 /*   
    if ([sharedUserInfo gotRecordedMemo]) {
        playButton.hidden = NO;
    }
    else
  */
    //     playButton.hidden = YES;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    BOOL success = [fileManager fileExistsAtPath:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]]; 
    
    if (!success || ![sharedUserInfo gotRecordedMemo]) {
        playButton.hidden = YES;
    }
    
    //recStateLabel.text = @"Not Recording";
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
//    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];

    [audioSession setActive:YES error:nil];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([sharedUserInfo showItouchWarning])
        [self itouchUserWarning];
    
}

- (void)viewDidUnload
{
    //NSFileManager *fileHandler = [NSFileManager defaultManager];
    //[fileHandler removeItemAtPath:temporaryRecFile error:nil];
    //[myRecorder dealloc];
    //myRecorder = nil;
    //temporaryRecFile = nil;
    playButton.hidden = YES;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc{
    
    [recordSetting release];
    if (myPlayer != nil) {
        [myPlayer release];
        myPlayer = nil;
    }
    if (myRecorder != nil) {
        [myRecorder release];
        myRecorder = nil;
    }
    
    [recButton release];
    [playButton release];
    [super dealloc];
}


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    isPlaying = NO;
    [self playback:nil];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{    
    playing = NO;
    [playButton setImage:[UIImage imageNamed:@"playoffbtn.png"] forState:UIControlStateNormal];
    [myPlayer stop];
    [myPlayer release];
    myPlayer = nil;
    recButton.hidden = NO;
}

- (void) itouchUserWarning{
    
    NSString *deviceType = [[UIDevice currentDevice] model];  
    
    if ([deviceType isEqualToString:@"iPod touch"] || [deviceType isEqualToString:@"iPod touch 2G"]){  
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Friendly Note" message:@"Your iPod Touch needs to be connected to a Microphone to record voice memos." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"OK",nil];
        
        [alert show];
        [alert release];
    }
    
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        // this is close selection
        [sharedUserInfo setShowItouchWarning:YES];
    }
    else
    {
        // this is ok selection
        [sharedUserInfo setShowItouchWarning:NO];
    }
}

@end

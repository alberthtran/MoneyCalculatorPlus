//
//  voiceMemoController.m
//  pocketCalc
//
//  Created by Wilson Kong on 12/14/11.
//  Copyright (c) 2011 WKode. All rights reserved.
//

#import "voiceMemoController.h"
@implementation voiceMemoController

///* for sound recording */
//@synthesize audioPlayer;			// the playback audio queue object
//@synthesize audioRecorder;			// the recording audio queue object
//@synthesize soundFileURL;			// the sound file to record to and to play back
//@synthesize recordingDirectory;		// the location to record into; it's the application's 
/* for sound recording */




- (IBAction)delRec:(id)sender
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success = [fileManager fileExistsAtPath:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]];
    
    if(!success)
        return;
    else
    {
        if([fileManager removeItemAtPath:(NSString *)[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER] error:nil])
        {
            playBtn.enabled = NO;
            playBtn.alpha = 0.5;
        }
    
        
    }
}


- (IBAction)playToggle:(id)sender
{
    if([myBoss PlayingState] == YES)
    {

        [myBoss stopPlay:nil];
        
        
        //attachedVoiceMemo.hidden = NO;
    }
    else
    {
        

        [myBoss playOrStop:nil];
        
        
        //attachedVoiceMemo.hidden = NO;
    }
}

- (IBAction)recToggle:(id)sender
{
    //UIButton *tmp = sender;
    if([myBoss RecordingState] == YES)
    {

        
        [recTimer invalidate];
        recTimer = NULL;
        
        [myBoss recordOrStop:nil];
        
        
        //[self playOrStop:nil];
        
        
        recStatusBar.frame = CGRectMake(recStatusBar.frame.origin.x, recStatusBar.frame.origin.y, 0, recStatusBar.frame.size.height);
        recBar.hidden = YES;
    }
    else
    {

        
        [myBoss recordOrStop:nil];
        recStatusBar.frame = CGRectMake(recStatusBar.frame.origin.x, recStatusBar.frame.origin.y, 0, recStatusBar.frame.size.height);
        recBar.hidden = NO;
        //attachedVoiceMemo.hidden = NO;
        
        recTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(recCounter:) userInfo:nil repeats:NO];
    }
}

- (void)recCounter:(NSTimer *)theTimer
{
    if (recTimer != NULL) {
        
        if (recStatusBar.frame.size.width < 300) {
            recStatusBar.frame = CGRectMake(recStatusBar.frame.origin.x, recStatusBar.frame.origin.y, recStatusBar.frame.size.width + 1, recStatusBar.frame.size.height);
            recTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(recCounter:) userInfo:nil repeats:NO];
            
        }
        else
        {
            [recTimer invalidate];
            recTimer = NULL;
            [self recToggle:nil];
        }
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        
        sharedUserInfo = [UserDatabase shared];
        myBoss = (pocketCalcViewController*)[sharedUserInfo ctrl_for_Audio];
        self.view.alpha = 0.85;
        
        // Custom initialization
        //sharedUserInfo = [UserDatabase shared];
        //myBoss = (pocketCalcViewController*)[sharedUserInfo ctrl_for_Audio];
        
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
    [myBoss stopRecord:nil];
    [myBoss stopPlay:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    return;
    
}

- (void)viewDidLoad
{
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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mic.jpg"]];
    myBoss.playBtn = playBtn;
    myBoss.recBtn = recBtn;
    myBoss.trashBtn = trashBtn;
    recBar.hidden = YES;
    recStatusBar = [UIButton buttonWithType:UIButtonTypeCustom];
    recStatusBar.frame = CGRectMake(0, 0, 0, 12);
    recStatusBar.backgroundColor = [UIColor redColor];
    [recBar addSubview:recStatusBar];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]];
    if(success)
    {
        playBtn.enabled = YES;
        playBtn.alpha = 1.0;
    }
    else
    {
        playBtn.enabled = NO;
        playBtn.alpha = 0.5;
    }
    [myBoss stopRecord:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc
{
    [super dealloc];
}
- (void)viewDidUnload
{ 
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

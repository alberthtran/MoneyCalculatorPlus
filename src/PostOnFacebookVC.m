//
//  PostOnFacebookVC.m
//  pocketCalc
//
//  Created by Albert Tran on 10/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PostOnFacebookVC.h"

@implementation PostOnFacebookVC

@synthesize msgToPost,imageView,imageToPost,userMsg_textView;

- (IBAction) btnPostPress:(id) sender {
    if (imageView.image != nil) {
        // post msg and photo
        [self postMsgWithPhoto];
    }
    else{
        // just post msg
        [self postMsg];
    }
    
}

- (void) postMsg{
	[self resignFirstResponder];
	
	//we will release this object when it is finished posting
	FBFeedPost *post = [[FBFeedPost alloc] initWithPostMessage:userMsg_textView.text];
	[post publishPostWithDelegate:self];
	
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeLoading;
	display.tag = NOTIFICATION_DISPLAY_TAG;
	[display setNotificationText:@"Posting Msg"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:0.0];
	[display release];    
}

- (void) postMsgWithPhoto {
	
	[self.userMsg_textView resignFirstResponder];
	
	//we will release this object when it is finished posting
	FBFeedPost *post = [[FBFeedPost alloc] initWithPhoto:self.imageView.image name:self.userMsg_textView.text];
	[post publishPostWithDelegate:self];
	
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeLoading;
	display.tag = NOTIFICATION_DISPLAY_TAG;
	[display setNotificationText:@"Posting Msg & Photo"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:0.0];
	[display release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //imageToPost = [[UIImageView alloc] initWithImage:nil];
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

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    userMsg_textView.text = msgToPost;
    /*
    if (imageToPost.image != nil) {
        imageView.image = imageToPost.image;
        imageToPost.image = nil;
    }
    else{
        imageView.image = nil;
    }
      */
    
    if ([sharedUserInfo userPhoto] != nil){
        imageView.image = [sharedUserInfo userPhoto];
    }
    else{
        imageView.image = nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    // initiallly keyboard is hide
    keyboardVisible = NO;

}

- (void) viewWillDisappear:(BOOL)animated{
    
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Unregistering for keyboard events");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //msgToPost = [[NSMutableString alloc] init];
    
    self.title = @"FB Post";
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
	UIBarButtonItem *btnPost = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(btnPostPress:)];
	self.navigationItem.rightBarButtonItem = btnPost;
	[btnPost release];
	
	//[userMsg_textView becomeFirstResponder];
    
    // set the scrollview frame size same as the view frame size
    scrollView.contentSize = self.view.frame.size;    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gradientBackground.png"]]];
    
    sharedUserInfo = [UserDatabase shared];
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

- (void)dealloc{
    [msgToPost release];
    [userMsg_textView release];
    [imageToPost release];
    [imageView release];
    [super dealloc];
}

#pragma mark -
#pragma mark FBFeedPostDelegate

-(void)cancelLogin {
    UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
    [dv removeFromSuperview];
}

- (void) failedToPublishPost:(FBFeedPost*) _post {
    
	UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
	
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeText;
	[display setNotificationText:@"Failed To Post"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
	[display release];
	
    //fbDidNotLogin
    
	//release the alloc'd post
	[_post release];
}

- (void) finishedPublishingPost:(FBFeedPost*) _post {
    
	UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
	
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeText;
	[display setNotificationText:@"Finished Posting"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
	[display release];
	
	//release the alloc'd post
	[_post release];
}

-(void) keyboardDidShow:(NSNotification *)notif{
    if (keyboardVisible) {
        if (DEBUG_MODE_ENABLE)
            NSLog(@"Keyboard is already visible. Ignore notification");
        return;
    }
    
    // keyboard wasn't visible before
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Resizing smaller for keyboard");
    
    // Get the keyboard's size
    NSDictionary* info = [notif userInfo];
    //NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    
    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    // Resize the scroll view to make room for the keyboard
    CGRect viewFrame = self.view.frame;
    
    viewFrame.size.height -= keyboardSize.height;
    scrollView.frame = viewFrame;
    keyboardVisible = YES;
    
}

- (IBAction) keyboardDidHide:(NSNotification *)notif {
    if (!keyboardVisible){
        if (DEBUG_MODE_ENABLE)
            NSLog(@"Keyboard is already hidden. Ignoring notification");
        return;
    }
    
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Resizing bigger with no keyboard");
    
    // Get the keyboard's size
    //    NSDictionary* info = [notif userInfo];
    //    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    //    CGSize keyboardSize = [aValue CGRectValue].size;
    
    // reset the height of the scroll view
    CGRect viewFrame = self.view.frame;
    
    
    scrollView.frame = viewFrame;
    keyboardVisible = NO;
    
}

@end

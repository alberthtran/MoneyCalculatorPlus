//
//  DealFeedback.m
//  pocketCalc
//
//  Created by Albert Tran on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DealFeedback.h"
#import "ConstantValues.h"
#import "PostOnFacebookVC.h"
#import "PostOnTwitter.h"

@implementation DealFeedback

@synthesize item_name,store_name,store_location,outgoing_message,save_feedback_button,scrollView,textMsgStatus;

@synthesize photoIcon,voiceIcon;

- (void)delRec:(id)sender
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success = [fileManager fileExistsAtPath:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]];
    
    if(success)
    {
        [fileManager removeItemAtPath:(NSString *)[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER] error:nil];  
        voiceIcon.hidden = YES;
        [sharedUserInfo setGotRecordedMemo:NO];
    }
}
-(IBAction) delVoice: (id) sender
{
    UIActionSheet *option;
    option = [[UIActionSheet alloc] initWithTitle:@"Remove Voice Memo" delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
    [option showInView:self.view];
    [option release];
}
-(IBAction) delPic: (id) sender
{
    UIActionSheet *option;
    option = [[UIActionSheet alloc] initWithTitle:@"Remove Photo" delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
    [option showInView:self.view];
    [option release];
}
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

/* for sound recording */
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil PVC:(UIViewController *)cntr
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    // get the reference of the user database
        
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction) useMedia: (id) sender
{
    UIActionSheet *option;   
    
    option = [[UIActionSheet alloc] initWithTitle:@"Attach Media To Email / Facebook" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Record Voice (Email)", @"Photo",nil];  

    [option showInView:self.view];
    [option release];
    
}

- (void)dealloc
{
    [photoIcon release];
    [voiceIcon release];
    
    [item_name release];
    [store_name release];
    [store_location release];
    [outgoing_message release];
    
    [save_feedback_button release];
    [scrollView release];
    
    [textMsgStatus release];
    
    [sharethis release];
    [deal_rating_seg release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)sendSMS {
    if (![self validateUserInputs])
        return;
    
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
	{
        //controller.body = [NSString stringWithFormat:@"%@",outgoing_message.text];    
        controller.body = [NSString stringWithFormat:@"%@\n\n%via Money Calculator +\nhttp://ezfunapps.com/get.php",outgoing_message.text];
        
		controller.recipients = [NSArray arrayWithObjects:nil];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
	}	
    
    [controller release];
    
}

#pragma mark - View lifecycle
#pragma mark Dismiss Mail/SMS view controller

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    // initiallly keyboard is hide
    keyboardVisible = NO;

    
    bool gotItemName = NO;
    bool gotStoreName = NO;
    bool gotStoreLocation = NO;
    
    if (![[sharedUserInfo item_name] isEqualToString:@""] && ([item_name.text isEqualToString:@""])){
        item_name.text = [sharedUserInfo item_name];
        gotItemName = YES;
    }
    
    if (![[sharedUserInfo store_name] isEqualToString:@""] && ([store_name.text isEqualToString:@""])){
        store_name.text = [sharedUserInfo store_name];
        gotStoreName = YES;
    }
    
    if (![[sharedUserInfo store_location] isEqualToString:@""] && ([store_location.text isEqualToString:@""])){
        store_location.text = [sharedUserInfo store_location];
        gotStoreLocation = YES;
    }
    
    if (gotItemName || gotStoreName || gotStoreLocation)
        [self displayOutgoingMsg];
    if ([sharedUserInfo userPhoto] != nil){
        photoIcon.hidden = NO;
    }
    else
        photoIcon.hidden = YES;
    
    if ([sharedUserInfo gotRecordedMemo]){
        voiceIcon.hidden = NO;
    }
    else
        voiceIcon.hidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated{
    
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Unregistering for keyboard events");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad
{
    sharedUserInfo = [UserDatabase shared];
    self.title = DEAL_FEEDBACK_TITLE;
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [self initDealFeedback];
    
    self.navigationItem.rightBarButtonItem = self.save_feedback_button;
    
    // set the scrollview frame size same as the view frame size
    scrollView.contentSize = self.view.frame.size;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Remove previous audio and photo icon
    if ([sharedUserInfo gotRecordedMemo]){
        [sharedUserInfo setGotRecordedMemo:NO];
        voiceIcon.hidden = YES;
    }
    
    if ([sharedUserInfo userPhoto] != nil){
        [sharedUserInfo setUserPhoto:nil];
        photoIcon.hidden = YES;
    }
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

-(IBAction)itemNameFieldDoneEditing: (id) sender {
	[sender resignFirstResponder];
    [self displayOutgoingMsg];
}

-(IBAction)storeNameFieldDoneEditing:(id)sender{
	[sender resignFirstResponder];
    [self displayOutgoingMsg];
}

-(IBAction)storeLocationFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
    [self displayOutgoingMsg];
}

- (void) emailNow: (id) sender{
    
    if(![MFMailComposeViewController canSendMail])
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your device are not configured to send email" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return;
    }
    
    if (![self validateUserInputs])
        return;
    
    // Add a app link to the text
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    [mailComposer setSubject:DEAL_EMAIL_SUBJECT];
    //UIImage *pic = [UIImage imageNamed:@"picture.jpg"];
    //NSData *imageData = UIImageJPEGRepresentation(pic, 1);
    //[picker addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"picture.jpg"];
    
    //    UIImageView *tmpImgView = [imageView.subviews objectAtIndex:0];
    
    
    //    if (tmpImgView.image != nil) {
    if ([sharedUserInfo userPhoto] != nil){
        [mailComposer addAttachmentData:UIImageJPEGRepresentation([sharedUserInfo userPhoto], 1) mimeType:@"image/jpg" fileName:@"picture.jpg"];
    }
    
    if ([sharedUserInfo gotRecordedMemo]){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL success = [fileManager fileExistsAtPath:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]]; 
        
        if (success) {
            [mailComposer addAttachmentData:[NSData dataWithContentsOfFile:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]] mimeType:@"audio/aif" fileName:@"voicememo.aif"];
        }        
    }
    
    NSString *emailBody = [NSString stringWithFormat:@"%@\n\n%via Money Calculator +\nhttp://ezfunapps.com/get.php",outgoing_message.text];
    
    //NSString* emailBody = [[NSString alloc] initWithString:outgoing_message.text];
    
    [mailComposer setMessageBody:emailBody isHTML:NO];
    [self presentModalViewController:mailComposer animated:YES];
    
    [mailComposer release];    
    //[emailBody release];
}


-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    NSMutableString *status = [[NSMutableString alloc] init];
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [status setString:[NSString stringWithFormat:@"Email Cancelled"]];
            break;
        case MFMailComposeResultSaved:
            [status setString:[NSString stringWithFormat:@"Email Saved"]];
            break;
        case MFMailComposeResultSent:
            [status setString:[NSString stringWithFormat:@"Email Sent"]];
            break;
        case MFMailComposeResultFailed:
            [status setString:[NSString stringWithFormat:@"Email Failed"]];
            break;
        default:
            [status setString:[NSString stringWithFormat:@"Email Abort"]];
            break;
    }
    
    IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
    display.type = NotificationDisplayTypeText;
    [display setNotificationText:status];
    [display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
    [display release];
    
    [status release];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void) initDealFeedback{

}

// by wilson
- (IBAction) shareThis: (id) sender
{
    UIActionSheet *option;  
    
    if ([MFMessageComposeViewController canSendText]){  
        
        option = [[UIActionSheet alloc] initWithTitle:@"Share Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"SMS", @"Email", @"Facebook", @"Twitter", nil];
    }
    else{
        option = [[UIActionSheet alloc] initWithTitle:@"Share Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email", @"Facebook", @"Twitter", nil];
    }
    
    [option showInView:self.view];
    [option release];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([actionSheet.title isEqualToString:@"Share Options"] == YES)
	{
        if ([MFMessageComposeViewController canSendText]){  
            
            // shuffle puzzle
            if(buttonIndex == 0)
            {
                [self sendSMS];
            }
            else if(buttonIndex == 1)
            {
                [self emailNow:nil];
            }
            else if(buttonIndex == 2)        
            {
                [self pushFacebookPost];
            }
            else if(buttonIndex == 3)        
            {
                [self pushTwitterPost];
            } 
        }
        else{
            // shuffle puzzle
            if(buttonIndex == 0)
            {
                [self emailNow:nil];
            }
            else if(buttonIndex == 1)        
            {
                [self pushFacebookPost];
            }
            else if(buttonIndex == 2)        
            {
                [self pushTwitterPost];
            }
        }
        
    }
    
    if([actionSheet.title isEqualToString:@"Attach Media To Email / Facebook"] == YES)
	{
		// media option
        switch (buttonIndex) {
            case 0:
                [self pushVoiceRecorder];
                break;
            case 1:
                [self pushPhotoPage];
                break;
            default:
                break;
        }

        
    }
    else if([actionSheet.title isEqualToString:@"Remove Voice Memo"] == YES)
	{
		// media option
        switch (buttonIndex) {
            case 0:
                [self delRec:nil];
                break;
            case 1:
            default:
                break;
        }
        
    }
    else if([actionSheet.title isEqualToString:@"Remove Photo"] == YES)
	{
		// media option
        switch (buttonIndex) {
            case 0:
                //photo.image = nil;
                [sharedUserInfo setUserPhoto:nil];
                photoIcon.hidden = YES;
                break;
            case 1:
            default:
                break;
        }
        
    }

}

- (void)fadeSave:(NSTimer *)theTimer
{
    [[theTimer userInfo] removeFromSuperview];
}

- (IBAction) pushSaveFeedback:(id) sender{
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Save button is pressed");

    if (![self validateUserInputs])
        return;
    
    UILabel *saving = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    saving.text = @"Saving ...";
    saving.textAlignment = UITextAlignmentCenter;
    saving.backgroundColor = [UIColor whiteColor];
    saving.font = [UIFont boldSystemFontOfSize:50.0];
    saving.alpha = 0.7;
    [self.view addSubview:saving];
    saving.userInteractionEnabled = YES;
    saving.multipleTouchEnabled = YES;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fadeSave:) userInfo:saving repeats:NO];
    [saving release];
    
	// Create a new deal record dictionary for the new values
	NSMutableDictionary* newDeal = [[NSMutableDictionary alloc] init];

    [newDeal setObject:DEAL_TAG forKey:NAME_KEY];
        
    [newDeal setValue:item_name.text forKey:PURCHASED_ITEM_KEY];
    
    [newDeal setValue:outgoing_message.text forKey:EMAIL_MSG_KEY];

    [newDeal setObject:[NSDate date] forKey:PURCHASED_DATE_KEY];
    
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Adding %@ with name %@", [newDeal objectForKey:PURCHASED_ITEM_KEY], [newDeal objectForKey:EMAIL_MSG_KEY]);
    
	// Add it to the master deal array and release our reference
	[[sharedUserInfo deal_records] addObject:newDeal];
    
	// Sort the array since we just aded a new deal
    if ([[sharedUserInfo deal_records] count] > 1){
        NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] initWithKey:PURCHASED_DATE_KEY ascending:NO ];
    
        [[sharedUserInfo deal_records] sortUsingDescriptors:[NSArray arrayWithObject:nameSorter]];
        [nameSorter release];
    }
    
    if (DEBUG_MODE_ENABLE)
        for (int i=0;i<[[sharedUserInfo deal_records] count];i++){
            NSLog(@"%@",[[sharedUserInfo deal_records] objectAtIndex:i]);
        }
    
    // -- THIS IS FOR DEBUG ONLY ---- save the data into plist
    if (RUN_ON_SIM_ONLY)
        [sharedUserInfo saveUserDataToPlist];
    
    // release the new record
	[newDeal release];
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

// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the 
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
				 didFinishWithResult:(MessageComposeResult)result {
	
    NSMutableString *status = [[NSMutableString alloc] init];
    
    switch (result)
	{
		case MessageComposeResultCancelled:
            [status setString:[NSString stringWithFormat:@"Texting Cancelled"]];
			break;
		case MessageComposeResultSent:
            [status setString:[NSString stringWithFormat:@"Finished Texting"]];
			break;
		case MessageComposeResultFailed:
            [status setString:[NSString stringWithFormat:@"Texting Failed"]];
			break;
		default:
            [status setString:[NSString stringWithFormat:@"Texting Abort"]];
			break;
	}
    
    IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
    display.type = NotificationDisplayTypeText;
    [display setNotificationText:status];
    [display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
    [display release];
    
    [status release];
    
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)dealRating:(id)sender
{
    [self displayOutgoingMsg];
}

- (void) displayOutgoingMsg{
    NSArray *inss = [RATING_STARS_LABEL componentsSeparatedByString:@"_"];
    // outgoing message
    outgoing_message.text = [NSString stringWithFormat:@"I just bought %@.\nStore Name: %@\nStore Location: %@\nOriginal Price: %@\nDiscount Rate: %@ \nMy rating for this deal: %@", [item_name.text isEqualToString:@""] ? @"[xxx]" : item_name.text, store_name.text, store_location.text,[sharedUserInfo item_price],[sharedUserInfo item_discount_rate],[inss objectAtIndex:deal_rating_seg.selectedSegmentIndex]];
}

- (bool) validateUserInputs{
    if ([item_name.text isEqualToString:@""] || [store_name.text isEqualToString:@""] ||
        [store_location.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter item name, store name, and store location" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return NO;
    }    
    
    return YES;
}

- (void)pushFacebookPost{
    
    if (![self validateUserInputs])
        return;
    
    PostOnFacebookVC * postVC;
    postVC = [[PostOnFacebookVC alloc] initWithNibName:@"PostOnFacebookVC" bundle:nil];
    postVC.msgToPost = [NSString stringWithFormat:@"%@",outgoing_message.text];
    [self.navigationController pushViewController:postVC animated:YES];
    [postVC release];    
}


- (void)pushTwitterPost{
    
    if (![self validateUserInputs])
        return;
    
    PostOnTwitter * postTwitterVC;
    
    postTwitterVC = [[PostOnTwitter alloc] initWithNibName:@"PostOnTwitter" bundle:nil];
    postTwitterVC.msgToPost = [NSString stringWithFormat:@"%@",outgoing_message.text];
    //postVC.imageToPost = imageView;
    [self.navigationController pushViewController:postTwitterVC animated:YES];
    [postTwitterVC release];    
    
}

- (void)pushPhotoPage{
    PhotoController * photoVC;
    photoVC = [[PhotoController alloc] initWithNibName:@"PhotoController" bundle:nil];
    [self.navigationController pushViewController:photoVC animated:YES];
    [photoVC release];
}

- (void)pushVoiceRecorder{
    voiceRecorder * voiceRecVC;
    voiceRecVC = [[voiceRecorder alloc] initWithNibName:@"voiceRecorder" bundle:nil];
    [self.navigationController pushViewController:voiceRecVC animated:YES];
    [voiceRecVC release];    
}

@end

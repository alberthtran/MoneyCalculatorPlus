//
//  ShoppingReceiptHistory.m
//  pocketCalc
//
//  Created by Albert Tran on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShoppingReceiptHistory.h"
#import "ConstantValues.h"
#import "PostOnFacebookVC.h"
#import "PostOnTwitter.h"

@implementation ShoppingReceiptHistory

@synthesize receipt,shareAgain,store_name,store_location,email_msg,purchased_date;

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
    
    [receipt release];
    [shareAgain release];
    [store_name release];
    [store_location release];
    [email_msg release];
    [purchased_date release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)sendSMS {
    
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
	{
        //controller.body = [NSString stringWithFormat:@"%@",email_msg.text];
        
        controller.body = [NSString stringWithFormat:@"Store Name: %@\nStore Location: %@\nPurchase Date: %@\n%@\n%@\n\n%via Money Calculator +\nhttp://ezfunapps.com/get.php",store_name.text,store_location.text,purchased_date.text,DISPLAY_ITEM_DIVIDER_LINE,email_msg.text];
        
		controller.recipients = [NSArray arrayWithObjects:nil];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
	}	
	
    [controller release];
}

#pragma mark - View lifecycle
#pragma mark Dismiss Mail/SMS view controller

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    NSDate *myDate = [receipt objectForKey:PURCHASED_DATE_KEY];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:DISPLAY_DATE_FORMAT];
    
    self.title = SHOPPING_RECEIPT_TAG;
    purchased_date.text = [df stringFromDate:myDate];
	email_msg.text = [receipt objectForKey:EMAIL_MSG_KEY];   
    
    store_name.text = [receipt objectForKey:STORE_NAME_KEY];
    store_location.text = [receipt objectForKey:STORE_LOCATION_KEY];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:HISTORY_BACKGROUND_IMG]]];

    [df release];
    
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

- (void)viewDidLoad
{
     sharedUserInfo = [UserDatabase shared];
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

- (void) emailNow: (id) sender{
    
    if(![MFMailComposeViewController canSendMail])
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your device are not configured to send email" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return;
    }
    
   
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    [mailComposer setSubject:SHOPPING_RECEIPT_SUBJECT];
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
    
    NSString* emailBody = [NSString stringWithFormat:@"Store Name: %@\nStore Location: %@\nPurchase Date: %@\n%@\n%@\n\n%via Money Calculator +\nhttp://ezfunapps.com/get.php",store_name.text,store_location.text,purchased_date.text,DISPLAY_ITEM_DIVIDER_LINE,email_msg.text];
    
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
// by wilson
- (IBAction) shareIt: (id) sender
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

- (void)pushFacebookPost{
    
    PostOnFacebookVC * postVC;
    postVC = [[PostOnFacebookVC alloc] initWithNibName:@"PostOnFacebookVC" bundle:nil];
    postVC.msgToPost = [NSString stringWithFormat:@"Store Name: %@\nStore Location: %@\nPurchase Date: %@\n%@\n%@",store_name.text,store_location.text,purchased_date.text,DISPLAY_ITEM_DIVIDER_LINE,email_msg.text];
    
    [self.navigationController pushViewController:postVC animated:YES];
    [postVC release];    
}

- (void)pushTwitterPost{
    PostOnTwitter * postTwitterVC;
    
    postTwitterVC = [[PostOnTwitter alloc] initWithNibName:@"PostOnTwitter" bundle:nil];
    postTwitterVC.msgToPost = [NSString stringWithFormat:@"Store Name: %@\nStore Location: %@\nPurchase Date: %@\n%@\n%@",store_name.text,store_location.text,purchased_date.text,DISPLAY_ITEM_DIVIDER_LINE,email_msg.text];
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

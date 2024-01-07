//
//  AboutPocketCalc.m
//  pocketCalc
//
//  Created by Albert Tran on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutPocketCalc.h"
#import "ConstantValues.h"
#import "PostOnTwitter.h"
#import "PostOnFacebookVC.h"

@implementation AboutPocketCalc

@synthesize issuesFeedback;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgAboutView.png"]];
    }
    return self;
}

- (void)dealloc
{
    [issuesFeedback release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title = ABOUT_POCKET_CALC_TITLE;
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //tellAFriendMsg = @"Hi,\nCheck out the Money Calculator + app, I think you would like it. It's a very cool and useful calculator. http://www.ezfunapps.com";
    
    tellAFriendMsg = @"Hi, I just got Money Calculator +; It's got these awesome features: Calculate tip, sales tax, unit conversion, IOU, and shopping receipts.";
    
    tellAFriendMsgFB = @"Hi, I just got Money Calculator +.\nIt's got these awesome features:\nCalculate tip & sales tax\nConvert measurement units\nRate & share restaurants & deals\nCreate IOUs & shopping receipts.\n\nDownload it from http://www.ezfunapps.com/get.php\n\nVisit the website @ http://www.ezfunapps.com\nhttp://www.wkode.com";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction) pushWeb: (id) sender
{
    NSString *reviewURL2 = @"http://www.ezfunapps.com";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL2]]; 
}

- (IBAction) showDetailCredits: (id) sender
{
    UIAlertView *cdt = [[UIAlertView alloc] initWithTitle:@"Credits" message:@"EZ Fun Apps - Money Calculator +\n\nProgrammers:\nAlbert Tran (Lead)\nWilson Kong\n\nGraphics Designers:\nWilson Kong (Lead)\nAlbert Tran\n\nSpecial Thanks:\nJasmine Taketa-Tran\nShoko Aoshima Kong\nJames Kong\n\nhttp:///www.ezfunapps.com\n\n© 2011 EZ Fun Apps.\nAll rights reserved." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [cdt show];
    [cdt release];
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
                [self pushEmail2];
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
                [self pushEmail2];
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
}

- (IBAction) pushApps: (id) sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"moreApps"];
    NSString *reviewURL2 = @"itms://search.itunes.apple.com/WebObjects/MZContentLink.woa/wa/link?path=ezfunapps";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL2]]; 
}

- (IBAction) pushShare: (id) sender
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

- (IBAction) pushRate: (id) sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"rated"];
    NSString *reviewURL2 = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=481958167&onlyLatestVersion=false&type=Purple+Software";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL2]]; 
}

- (IBAction) pushFAQ: (id) sender
{
    NSString *reviewURL2 = @"http://www.ezfunapps.com/faq/";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL2]];
}

- (IBAction) pushEmail: (id) sender{
    NSArray *emailAddress = [[NSArray alloc] initWithObjects:DEVELOPER_EMAIL_ADDRESS, nil];
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    [mailComposer setSubject:ABOUT_EMAIL_SUBJECT];
    [mailComposer setToRecipients:emailAddress];
    
    [self presentModalViewController:mailComposer animated:YES];
    
    [mailComposer release];
    [emailAddress release];
    
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

- (void) pushEmail2{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    
    mailComposer.mailComposeDelegate = self;
    
    [mailComposer setSubject:@"I Recommend Money Calculator +"];
    
    NSString *emailMsg = @"Hi, I just got Money Calculator +.\nIt's got these awesome features:\nCalculate tip & sales tax\nConvert measurement units\nRate & share restaurants & deals\nCreate IOUs & shopping receipts.\n\nDownload it from http://www.ezfunapps.com/get.php\n\nVisit the website @ http://www.ezfunapps.com\nhttp://www.wkode.com";
    
    [mailComposer setMessageBody:emailMsg isHTML:NO];
    
    [self presentModalViewController:mailComposer animated:YES];
    
    [mailComposer release];
}

- (void)sendSMS {
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
	{
           
        controller.body = [NSString stringWithFormat:@"%@\nDownload it from http://ezfunapps.com/get.php",tellAFriendMsg];
        
		controller.recipients = [NSArray arrayWithObjects:nil];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
	}	
    
    [controller release];
    
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
    postVC.msgToPost = [NSString stringWithString:tellAFriendMsgFB];
    
    [self.navigationController pushViewController:postVC animated:YES];
    [postVC release];    
}

- (void)pushTwitterPost{
    PostOnTwitter * postTwitterVC;
    
    postTwitterVC = [[PostOnTwitter alloc] initWithNibName:@"PostOnTwitter" bundle:nil];
    postTwitterVC.msgToPost = [NSString stringWithString:tellAFriendMsg];
    //postVC.imageToPost = imageView;
    [self.navigationController pushViewController:postTwitterVC animated:YES];
    [postTwitterVC release];    
    
}

@end

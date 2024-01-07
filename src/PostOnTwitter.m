//
//  PostOnTwitter.m
//  pocketCalc
//
//  Created by Albert Tran on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PostOnTwitter.h"
#import "SA_OAuthTwitterEngine.h"

/* Define the constants below with the Twitter 
 Key and Secret for your application. Create
 Twitter OAuth credentials by registering your
 application as an OAuth Client here: http://twitter.com/apps/new
 */

//#define kOAuthConsumerKey				@"L2x6MeD0vieXWqPG7hRMrA"		//REPLACE With Twitter App OAuth Key  ---- slick calculator
//#define kOAuthConsumerSecret			@"2vM8cGdmCSY71oUsUURc17lgY5JS9XZm4VuWknyrk"		//REPLACE With Twitter App OAuth Secret    ---- slick calculator


#define kOAuthConsumerKey				@"adElJZXiFkDr30ZdWoBIWA"		//REPLACE With Twitter App OAuth Key  ---- Money Calculator +
#define kOAuthConsumerSecret			@"LSccWYARdZCsrAMObqQCQobHvFqO8xI1VUY9D8mLzQ"		//REPLACE With Twitter App OAuth Secret    ---- Money Calculator +

@implementation PostOnTwitter

@synthesize msgToPost,userMsg_textView,tweetTextField; 

- (IBAction) btnPostPress:(id) sender {
    // just post msg
    [self postMsg];
}

- (void) postMsg{
	[self resignFirstResponder];
	
	//Twitter Integration Code Goes Here
    [_engine sendUpdate:userMsg_textView.text];

    IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeText;
	[display setNotificationText:@"Posting Msg"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:0.8];
	[display release];
    
}

#pragma mark Custom Methods

-(IBAction)updateTwitter:(id)sender
{
	//Dismiss Keyboard
	[tweetTextField resignFirstResponder];
	
	//Twitter Integration Code Goes Here
    [_engine sendUpdate:tweetTextField.text];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

#pragma mark ViewController Lifecycle

- (void)viewDidAppear: (BOOL)animated {
	
    userMsg_textView.text = msgToPost;
    //userMsg_textView.text = @"Test me";
    
	// Twitter Initialization / Login Code Goes Here
    if(!_engine){  
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        _engine.consumerKey    = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret;  
    }  	
    
    if(![_engine isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        
        if (controller){  
            [self presentModalViewController: controller animated: YES];  
        }  
    }    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Twitter Post";
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIBarButtonItem *btnPost = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(btnPostPress:)];
	self.navigationItem.rightBarButtonItem = btnPost;
	[btnPost release];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gradientBackground.png"]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [tweetTextField release];
	tweetTextField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_engine release];
    [msgToPost release];
    [userMsg_textView release];
    
	[tweetTextField release];
    [super dealloc];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	//NSLog(@"Request %@ succeeded", requestIdentifier);
    
    IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeText;
	[display setNotificationText:@"Finished Posting"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
	[display release];

}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	//NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
    
    IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeText;
	[display setNotificationText:@"Failed To Post"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
	[display release];

}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller{   
    //[self removeFromParentViewController];
    //[self.view removeFromSuperview];
    //[controller removeFromParentViewController];
    //[self.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

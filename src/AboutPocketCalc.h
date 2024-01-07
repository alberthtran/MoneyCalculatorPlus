//
//  AboutPocketCalc.h
//  pocketCalc
//
//  Created by Albert Tran on 9/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutPocketCalc : UIViewController
<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate> {

    IBOutlet UITextField *issuesFeedback;
    NSString *tellAFriendMsg;
    NSString *tellAFriendMsgFB;

}


@property (nonatomic,retain) UITextField *issuesFeedback;

- (IBAction) pushEmail: (id) sender; 
- (IBAction) showDetailCredits: (id) sender;
- (IBAction) pushWeb: (id) sender; 
- (IBAction) pushShare: (id) sender; 
- (IBAction) pushRate: (id) sender; 
- (IBAction) pushFAQ: (id) sender; 

- (IBAction) pushApps: (id) sender; 


- (void)pushEmail2;
- (void)sendSMS;
- (void)pushFacebookPost;
- (void)pushTwitterPost;

@end

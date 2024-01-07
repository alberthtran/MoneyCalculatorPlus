//
//  ShoppingReceiptHistory.h
//  pocketCalc
//
//  Created by Albert Tran on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "voiceRecorder.h"
#import "PhotoController.h"
#import "UserDatabase.h"


@interface ShoppingReceiptHistory : UIViewController
<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{

    UserDatabase *sharedUserInfo;
    NSDictionary* receipt;
    IBOutlet UILabel *purchased_date;
    IBOutlet UILabel *store_name;
    IBOutlet UILabel *store_location;
    
    IBOutlet UITextView *email_msg;
    IBOutlet UIButton *shareAgain;
    IBOutlet UIButton *photoIcon;
    IBOutlet UIButton *voiceIcon;
    
   	//UIImageView * photo;
    //bool takenPhoto;
}

@property (nonatomic,retain) UIButton *photoIcon;
@property (nonatomic,retain) UIButton *voiceIcon;

@property (nonatomic,retain) NSDictionary* receipt;
@property (nonatomic,retain) UILabel* purchased_date;
@property (nonatomic,retain) UILabel* store_name;
@property (nonatomic,retain) UILabel* store_location;
@property (nonatomic,retain) UITextView *email_msg;
@property (nonatomic,retain) UIButton *shareAgain;
- (IBAction) useMedia: (id) sender;

- (IBAction) shareIt: (id) sender;
- (IBAction)sendSMS;

/* for sound recording */
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil PVC:(UIViewController *)cntr;
-(IBAction) delVoice: (id) sender;
-(IBAction) delPic: (id) sender;
- (void)pushFacebookPost;
- (void)pushTwitterPost;
- (void)pushPhotoPage;
- (void)pushVoiceRecorder;
@end

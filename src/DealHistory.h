//
//  DealHistory.h
//  pocketCalc
//
//  Created by Albert Tran on 9/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "voiceRecorder.h"
#import "PhotoController.h"
#import "UserDatabase.h"


@interface DealHistory : UIViewController 
<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    /* for sound recording */
    UserDatabase *sharedUserInfo;
    
    NSDictionary* deal_record;
    IBOutlet UILabel *purchased_date;
    IBOutlet UITextView *email_msg;
    IBOutlet UIButton *shareAgain;
    IBOutlet UIButton *photoIcon;
    IBOutlet UIButton *voiceIcon;
    
   	//UIImageView * photo;
    //bool takenPhoto;
    
}

@property (nonatomic,retain) UIButton *photoIcon;
@property (nonatomic,retain) UIButton *voiceIcon;

@property (nonatomic,retain) NSDictionary* deal_record;
@property (nonatomic,retain) UILabel* purchased_date;
@property (nonatomic,retain) UITextView *email_msg;
@property (nonatomic,retain) UIButton *shareAgain;
- (IBAction) useMedia: (id) sender;

- (IBAction) shareIt: (id) sender;
- (IBAction)sendSMS;

-(IBAction) delVoice: (id) sender;
-(IBAction) delPic: (id) sender;
- (void)pushFacebookPost;
- (void)pushTwitterPost;
- (void)pushPhotoPage;
- (void)pushVoiceRecorder;
@end

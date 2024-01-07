//
//  RestaurantHistory.h
//  pocketCalc
//
//  Created by Albert Tran on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "voiceRecorder.h"
#import "PhotoController.h"
#import "UserDatabase.h"



@interface RestaurantHistory : UIViewController 
<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{

    UserDatabase *sharedUserInfo;
    NSDictionary* restaurant_record;
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

@property (nonatomic,retain) NSDictionary* restaurant_record;
@property (nonatomic,retain) UILabel* purchased_date;
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

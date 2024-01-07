//
//  DealFeedback.h
//  pocketCalc
//
//  Created by Albert Tran on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "UserDatabase.h"
#import "voiceRecorder.h"
#import "PhotoController.h"

@interface DealFeedback : UIViewController
<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
        
   	//UIImageView * photo;
    //bool takenPhoto;
    UserDatabase *sharedUserInfo;
    IBOutlet UITextField* item_name;
    IBOutlet UITextField* store_name;
    IBOutlet UITextField* store_location;
    IBOutlet UITextView* outgoing_message;
    
    IBOutlet UIBarButtonItem* save_feedback_button;
    IBOutlet UIScrollView* scrollView;
    
    // TEXT message feedback
    IBOutlet UILabel *textMsgStatus;
    
    BOOL keyboardVisible;

    IBOutlet UISegmentedControl *deal_rating_seg;
    IBOutlet UIButton *sharethis;
    // User Database
    IBOutlet UIButton *photoIcon;
    IBOutlet UIButton *voiceIcon;
   
}

@property (nonatomic,retain) UIButton *photoIcon;
@property (nonatomic,retain) UIButton *voiceIcon;

@property (nonatomic,retain) UITextField* item_name;
@property (nonatomic,retain) UITextField* store_name;
@property (nonatomic,retain) UITextField* store_location;
@property (nonatomic,retain) UITextView* outgoing_message;

@property (nonatomic,retain) UIBarButtonItem* save_feedback_button;
@property (nonatomic,retain) UIScrollView* scrollView;

@property (nonatomic, retain) IBOutlet UILabel *textMsgStatus;

- (IBAction) useMedia: (id) sender;
-(IBAction) delVoice: (id) sender;
-(IBAction) delPic: (id) sender;
-(IBAction)itemNameFieldDoneEditing: (id) sender;
-(IBAction)storeNameFieldDoneEditing: (id) sender;
-(IBAction)storeLocationFieldDoneEditing: (id) sender;

- (IBAction) pushSaveFeedback:(id) sender;
- (IBAction) keyboardDidShow: (NSNotification*)notif;
- (IBAction) keyboardDidHide: (NSNotification*)notif;

- (IBAction)sendSMS;
- (void) initDealFeedback;

- (IBAction) shareThis: (id) sender;
- (IBAction)dealRating:(id)sender;
- (void) displayOutgoingMsg;
- (bool) validateUserInputs;

- (void)pushFacebookPost;
- (void)pushTwitterPost;
- (void)pushPhotoPage;
- (void)pushVoiceRecorder;
@end

//
//  RestaurantFeedback.h
//  pocketCalc
//
//  Created by Albert Tran on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ConstantValues.h" // only use for media
#import "UserDatabase.h"
#import "voiceRecorder.h"
#import "PhotoController.h"


@interface RestaurantFeedback : UIViewController
<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

    UserDatabase *sharedUserInfo;
    IBOutlet UITextField* restaurant_name;
    IBOutlet UITextField* restaurant_location;
    IBOutlet UITextField* user_message;
    IBOutlet UITextView* outgoing_message;

    IBOutlet UISegmentedControl *food_rating_seg;
    IBOutlet UISegmentedControl *service_rating_seg;
    IBOutlet UISegmentedControl *atmosphere_rating_seg;
    IBOutlet UISegmentedControl *price_rating_seg;
    IBOutlet UIButton *sharethis;
    
    IBOutlet UIBarButtonItem* save_feedback_button;
    IBOutlet UIScrollView* scrollView;
    IBOutlet UIButton *photoIcon;
    IBOutlet UIButton *voiceIcon;
    // TEXT message feedback
    IBOutlet UILabel *textMsgStatus;
    
    BOOL keyboardVisible;
    
    
   	//UIImageView * photo;
    //bool takenPhoto;
    

    
}

@property (nonatomic,retain) UIButton *photoIcon;
@property (nonatomic,retain) UIButton *voiceIcon;

@property (nonatomic,retain) UITextField* restaurant_name;
@property (nonatomic,retain) UITextField* restaurant_location;
@property (nonatomic,retain) UITextField* user_message;
@property (nonatomic,retain) UITextView* outgoing_message;

@property (nonatomic,retain) UIBarButtonItem* save_feedback_button;
@property (nonatomic,retain) UIScrollView* scrollView;

@property (nonatomic, retain) IBOutlet UILabel *textMsgStatus;


-(IBAction) delVoice: (id) sender;
-(IBAction) delPic: (id) sender;
- (IBAction) shareThis: (id) sender;
- (IBAction)foodRating:(id)sender;
-(IBAction) nameFieldDoneEditing: (id) sender;
-(IBAction)userMsgFieldDoneEditing: (id) sender;
-(IBAction)locationFieldDoneEditing: (id) sender;

- (IBAction) pushSaveFeedback:(id) sender;
- (IBAction) keyboardDidShow: (NSNotification*)notif;
- (IBAction) keyboardDidHide: (NSNotification*)notif;

- (void) initRestaurantFeedback;
- (IBAction)sendSMS;
- (void) displayOutgoingMsg;
- (bool) validateUserInputs;

- (IBAction) useMedia: (id) sender;

- (void)pushFacebookPost;
- (void)pushTwitterPost;
- (void)pushPhotoPage;
- (void)pushVoiceRecorder;
@end

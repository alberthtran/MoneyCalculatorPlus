//
//  IOUManager.h
//  pocketCalc
//
//  Created by Albert Tran on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Calculator.h"
#import "UserDatabase.h"
#import "voiceRecorder.h"
#import "PhotoController.h"

#import <MobileCoreServices/UTCoreTypes.h>

@interface IOUManager : UIViewController 
<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    UserDatabase *sharedUserInfo;
    
    IBOutlet UIButton *photoIcon;
    IBOutlet UIButton *voiceIcon;
    
    IBOutlet UILabel* display_number;
    
    IBOutlet UILabel* display_numberFake;

    //bool takenPhoto;

    //UIImageView *photo;
    
    IBOutlet UITextField* other_person_name;
    IBOutlet UITextField* amount;
    
    IBOutlet UITextView* outgoing_message;
    
    IBOutlet UIBarButtonItem* save_button;
    IBOutlet UIScrollView* scrollView;
    
    BOOL keyboardVisible;

    // TEXT message feedback
    IBOutlet UILabel *textMsgStatus;
    
    //IBOutlet UILabel *cur;
    
    
    IBOutlet UISegmentedControl *person_type_seg;
    IBOutlet UIButton *sharethis;
    
    IBOutlet UIView *numPad;
    
    IBOutlet UILabel *date_label;
    UIDatePicker *date_picker;
    
     IBOutlet UIButton *amountButn;
    
    IBOutlet UIButton *addMedia;
    // Calculator Object
    Calculator* calc_obj;
    
    //bool useSavedNum;
    float savedCurNum;
    bool sameNumber;
    int numberCnt;
    bool gotEqual;
    
    int step;
    
    BOOL newNumEnter;
    BOOL equalPressed;
    int lastOp;
    float total;
    float newNum;
    
    bool previewImage;
    
}

@property (nonatomic,retain) UIButton *photoIcon;
@property (nonatomic,retain) UIButton *voiceIcon;

@property (nonatomic,retain) UITextField* other_person_name;
@property (nonatomic,retain) UITextField* amount;

@property (nonatomic,retain) UITextView* outgoing_message;

@property (nonatomic,retain) UIBarButtonItem* save_button;
@property (nonatomic,retain) UIScrollView* scrollView;

@property (nonatomic, retain) IBOutlet UILabel *textMsgStatus;

@property (nonatomic, retain) IBOutlet UISegmentedControl *person_type_seg;

@property (nonatomic,retain) UILabel* date_label;

- (void) emailNow: (id) sender;
//- (void) pushMathOp: (enum MathOperator) mathOpType;
- (IBAction) useMedia: (id) sender;

-(IBAction) delVoice: (id) sender;
-(IBAction) delPic: (id) sender;

-(IBAction) personNameFieldDoneEditing: (id) sender;
-(IBAction) amountFieldDoneEditing: (id) sender;

- (IBAction) pushSaveIOUInfo:(id) sender;
- (IBAction) keyboardDidShow: (NSNotification*)notif;
- (IBAction) keyboardDidHide: (NSNotification*)notif;

- (void) initIOUManager;

- (IBAction)sendSMS;

- (IBAction) sendThis: (id) sender;
- (IBAction)personType:(id)sender;
- (void) displayOutgoingMsg;
- (bool) validateUserInputs;

- (IBAction) pushDateButton: (id) sender;
- (void) displayRepaymentDate:(id)sender;
- (IBAction) pushHideDatePicker: (id) sender;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil PVC:(UIViewController *)cntr;

// Numeric button events
- (IBAction) pushAmount: (id) sender;

- (IBAction) pushZero: (id) sender;
- (IBAction) pushOne: (id) sender;
- (IBAction) pushTwo: (id) sender;
- (IBAction) pushThree: (id) sender;
- (IBAction) pushFour: (id) sender;
- (IBAction) pushFive: (id) sender;
- (IBAction) pushSix: (id) sender;
- (IBAction) pushSeven: (id) sender;
- (IBAction) pushEight: (id) sender;
- (IBAction) pushNine: (id) sender;

// Other Button Events
- (IBAction) pushDelete: (id) sender;
- (IBAction) pushClear: (id) sender;
- (IBAction) pushDecimal: (id) sender;

// math button
- (IBAction) pushAdd: (id) sender;
- (IBAction) pushSubstract: (id) sender;
- (IBAction) pushMultiply: (id) sender;
- (IBAction) pushDivide: (id) sender;
- (IBAction) pushEqual: (id) sender;
//- (IBAction) pushSign: (id) sender;

// internal helper functions
- (void) pushNumber: (id) sender;
//- (void) pushMathOp;

//- (void) displayResults;

- (void)pushFacebookPost;
- (void)pushTwitterPost;
- (void)pushPhotoPage;
- (void)pushVoiceRecorder;

@end

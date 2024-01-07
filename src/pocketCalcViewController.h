//
//  pocketCalcViewController.h
//  pocketCalc
//
//  Created by Albert Tran on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calculator.h"
#import "UserDatabase.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "AudioQueueObject.h"
#import "AudioRecorder.h"
#import "AudioPlayer.h"


@interface pocketCalcViewController : UIViewController
<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    // Display Variables
    IBOutlet UILabel* display_number;
    IBOutlet UILabel* display_each_amount;
    IBOutlet UILabel* display_total_amount;
    IBOutlet UILabel* display_each_tip;
    IBOutlet UILabel* display_total_tip;
    
    // Picker Outlet
    IBOutlet UIPickerView* tipPicker;
    
    // UIButton for changing background color
    
    // Tip Information
    NSMutableArray* tips;
    NSMutableArray* heads;

    // Calculator Object
    Calculator* calc_obj;
    
    // User Database
    UserDatabase *sharedUserInfo;
}

@property (nonatomic,retain) UILabel* display_number;
@property (nonatomic,retain) UILabel* display_each_amount;
@property (nonatomic,retain) UILabel* display_total_amount;
@property (nonatomic,retain) UILabel* display_each_tip;
@property (nonatomic,retain) UILabel* display_total_tip;
@property (nonatomic,retain) UIPickerView* tipPicker;

// Numeric button events
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

// open other feature GUI
- (IBAction) pushTaxCalc:(id)sender;
- (IBAction) pushIOU:(id)sender;
- (IBAction) pushProfile:(id)sender;
- (IBAction) pushLikeIt:(id)sender;
- (IBAction) pushUnitConverter:(id)sender;
- (IBAction) pushAboutPocketCalc:(id)sender;

// internal helper functions
- (void) pushNumber: (id) sender;
- (void) displayResults;

//-(void) applicationWillTerminate: (NSNotification *)notification;

@end

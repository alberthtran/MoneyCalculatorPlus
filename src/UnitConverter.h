//
//  UnitConverter.h
//  pocketCalc
//
//  Created by Albert Tran on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calculator.h"

@interface UnitConverter : UIViewController
<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    // Display Variables
    IBOutlet UILabel* display_to_value;
    IBOutlet UILabel* display_number;

    IBOutlet UILabel* display_from_unit;
    IBOutlet UILabel* display_to_unit;
    
    // Picker Outlet
    IBOutlet UIPickerView* unitConvPicker;
    
    IBOutlet UIImageView *topView;
    IBOutlet UIImageView *bottomView;
    // UIButton for changing background color
    
    // Unit Conversion Information
    NSMutableArray* unit_selection;
    NSMutableArray* from_option;
    NSMutableArray* to_option;
    
    // Calculator Object
    Calculator* calc_obj;
    
    //bool useSavedNum;
    float savedCurNum;
    bool sameNumber;
    int numberCnt;
    bool gotEqual;
}

@property (nonatomic,retain) UILabel* display_to_value;
@property (nonatomic,retain) UILabel* display_number;
@property (nonatomic,retain) UIPickerView* unitConvPicker;

@property (nonatomic,retain) UILabel* display_from_unit;
@property (nonatomic,retain) UILabel* display_to_unit;

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

// math button
- (IBAction) pushAdd: (id) sender;
- (IBAction) pushSubstract: (id) sender;
- (IBAction) pushMultiply: (id) sender;
- (IBAction) pushDivide: (id) sender;
- (IBAction) pushEqual: (id) sender;
- (IBAction) pushSign: (id) sender;

// internal helper functions
- (void) pushNumber: (id) sender;
- (void) pushMathOp: (enum MathOperator) mathOpType;

- (void) displayResults;
- (void) initUnitConv;

- (void) initMathFlags;

@end

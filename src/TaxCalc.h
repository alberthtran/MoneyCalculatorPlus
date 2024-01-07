//
//  TaxCalc.h
//  pocketCalc
//
//  Created by Albert Tran on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calculator.h"
#import "UserDatabase.h"

/* for sound recording */
//#import "pocketCalcViewController.h"


@interface TaxCalc : UIViewController{
        
    //pocketCalcViewController *myBoss;
    
    // Display Variables
    IBOutlet UILabel* display_tax_percent;
    IBOutlet UILabel* display_tax_amount;
    IBOutlet UILabel* display_orig_price;
    IBOutlet UILabel* display_discount_rate;
    IBOutlet UILabel* display_discount_amount;
    IBOutlet UILabel* display_total_after_tax;
    IBOutlet UILabel* display_saved;
    IBOutlet UILabel* display_coupon;     
    
    IBOutlet UITextField* item_name;
    IBOutlet UITextField* store_name;
    IBOutlet UITextField* store_location;
    bool gotStoreInfo;
    
    // Picker Outlet
    IBOutlet UIPickerView* taxPicker;
    
    NSMutableArray* shopping_receipt;
    bool gotShoppingItem;
    bool origPriceActive;
    bool saleTaxActive;
    bool couponActive;
    bool discountActive;
    
    IBOutlet UIButton* orig_price_btn;
    IBOutlet UIButton* sale_tax_btn;
    IBOutlet UIButton* coupon_btn;
    IBOutlet UIButton* discount_btn;
    
    // UIButton for changing background color
        
    // Tip Information
    
    // Calculator Object
    Calculator* calc_obj;
    
    UserDatabase *sharedUserInfo;
    
    NSMutableDictionary* shoppingRecord;
    bool newReceipt;
    
}

@property (nonatomic,retain) UILabel* display_tax_percent;
@property (nonatomic,retain) UILabel* display_tax_amount;
@property (nonatomic,retain) UILabel* display_orig_price;
@property (nonatomic,retain) UILabel* display_discount_rate;
@property (nonatomic,retain) UILabel* display_discount_amount;
@property (nonatomic,retain) UILabel* display_total_after_tax;
@property (nonatomic,retain) UILabel* display_saved;
@property (nonatomic,retain) UILabel* display_coupon;

@property (nonatomic,retain) UIPickerView* taxPicker;
    
@property (nonatomic,retain) UITextField* item_name;
@property (nonatomic,retain) UITextField* store_name;
@property (nonatomic,retain) UITextField* store_location;

@property (nonatomic,retain) UIButton* orig_price_btn;
@property (nonatomic,retain) UIButton* sale_tax_btn;
@property (nonatomic,retain) UIButton* coupon_btn;
@property (nonatomic,retain) UIButton* discount_btn;


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
- (IBAction) pushOrigPrice: (id) sender;
- (IBAction) pushSaleTax: (id) sender;
- (IBAction) pushDiscountRate: (id) sender;
- (IBAction) pushCoupon: (id) sender;

- (IBAction) pushStoreRecord:(id) sender;
- (IBAction) pushShowReceipt:(id) sender;

// open other feature GUI
- (IBAction) pushGotDeal:(id)sender;
    
// internal helper functions
- (void) pushNumber: (id) sender;
- (void) displayResults;

- (bool) validateUserInputs;
- (void) initTaxCalc;

-(IBAction)itemNameFieldDoneEditing: (id) sender;
-(IBAction)storeNameFieldDoneEditing: (id) sender;
-(IBAction)storeLocationFieldDoneEditing: (id) sender;

/* for sound recording */
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil PVC:(UIViewController *)cntr;
-(void) backBtn;
- (void)saveReceiptRecord;
- (void)addShoppingItem;
- (void)addStoreInfo;

@end

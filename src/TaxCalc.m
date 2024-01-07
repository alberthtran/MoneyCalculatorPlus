//
//  TaxCalc.m
//  pocketCalc
//
//  Created by Albert Tran on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaxCalc.h"
#import "ConstantValues.h"
#import "DealFeedback.h"
#import "UserDatabase.h"
#import "ShoppingReceiptVC.h"

@implementation TaxCalc

@synthesize display_tax_percent,display_tax_amount,display_orig_price,display_discount_rate, display_discount_amount, display_total_after_tax,display_saved,display_coupon,taxPicker,item_name,store_name,store_location,discount_btn,coupon_btn,orig_price_btn,sale_tax_btn;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil PVC:(UIViewController *)cntr
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Custom initialization
        
        //myBoss = cntr;
        //myBoss = (pocketCalcViewController*)[sharedUserInfo ctrl_for_Audio];
    }
    return self;
}

- (void)dealloc
{
    [display_tax_percent release];
    [display_tax_amount release];
    [display_orig_price release];
    [display_discount_rate release];
    [display_discount_amount release];
    [display_total_after_tax release];
    [display_saved release];    
    [display_coupon release];      
    [taxPicker release];
    
    [item_name release];
    [shopping_receipt release];
    [store_name release];
    [store_location release];
    
    [shoppingRecord release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    origPriceActive = TRUE;
    saleTaxActive = FALSE;
    couponActive = FALSE;
    discountActive = FALSE;
 
    discount_btn.selected = FALSE;
    orig_price_btn.selected = TRUE;
    coupon_btn.selected = FALSE;
    sale_tax_btn.selected = FALSE;
    
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [sharedUserInfo setItem_discount_rate:[NSString stringWithFormat:@"%@",display_discount_rate.text]];
    [sharedUserInfo setItem_price:[NSString stringWithFormat:@"%@",display_orig_price.text]];

    [sharedUserInfo setItem_name:[NSString stringWithFormat:@"%@",item_name.text]];
    
    [sharedUserInfo setStore_name:[NSString stringWithFormat:@"%@",store_name.text]];
    [sharedUserInfo setStore_location:[NSString stringWithFormat:@"%@",store_location.text]];
    
    // store the sale tax to be default sale tax
    //[sharedUserInfo setDefault_sale_tax:[NSNumber numberWithFloat:[display_tax_percent.text floatValue]]];
    [sharedUserInfo setDefault_sale_tax:[display_tax_percent.text floatValue]];
}

-(void) backBtn
{
    if ([[sharedUserInfo one_receipt] count] != 0){
        [self saveReceiptRecord];
        // clear the receipt
        [[sharedUserInfo one_receipt] removeAllObjects];
    }
    [self.navigationController popViewControllerAnimated:YES];
    return;
    
}

- (void)viewDidLoad
{    
    self.title = TAX_TITLE;
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    UIImage *normalBackImage = [UIImage imageNamed:@"customBackBtn.png"]; 
    //UIImage *higlightedBackImage = [UIImage imageNamed:@"back button pressed.png"]; 
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom]; backButton.bounds = CGRectMake( 0, 0, normalBackImage.size.width, normalBackImage.size.height ); 
    
    [backButton setImage:normalBackImage forState:UIControlStateNormal]; 
    
    //[backButton setImage:higlightedBackImage forState:UIControlStateHighlighted]; 
    
    [backButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton]; 
    
    self.navigationItem.leftBarButtonItem = backBarItem;
    [backBarItem release];

    // Get the reference of the Calculator Instance and initialize the tax calc
    calc_obj = [Calculator calcInstance];
    [calc_obj setDefaultTaxVal];
    
    [self displayResults];
    
    [self initTaxCalc];

    gotShoppingItem = FALSE;
    
    sharedUserInfo = [UserDatabase shared];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Numeric button events
- (IBAction) pushZero: (id) sender {
    // call the pushNumber routine for processing
    [self pushNumber:sender];
    
}

- (IBAction) pushOne: (id) sender {
    // call the pushNumber routine for processing
    [self pushNumber:sender];
    
}

- (IBAction) pushTwo: (id) sender {
    // call the pushNumber routine for processing
    [self pushNumber:sender];    
}

- (IBAction) pushThree: (id) sender {
    // call the pushNumber routine for processing
    [self pushNumber:sender];    
}

- (IBAction) pushFour: (id) sender {
    // call the pushNumber routine for processing
    [self pushNumber:sender];    
}

- (IBAction) pushFive: (id) sender {
    // call the pushNumber routine for processing
    [self pushNumber:sender];    
}

- (IBAction) pushSix: (id) sender {
    // call the pushNumber routine for processing
    [self pushNumber:sender];
}

- (IBAction) pushSeven: (id) sender {
    // call the pushNumber routine for processing
    [self pushNumber:sender];    
}

- (IBAction) pushEight: (id) sender {
    // call the pushNumber routine for processing
    [self pushNumber:sender];    
}

- (IBAction) pushNine: (id) sender {
    // call the pushNumber routine for processing
    [self pushNumber:sender];    
}

// Other Button Events
- (IBAction) pushDelete: (id) sender {
    
    if([[calc_obj tax_current_number] hasSuffix:@"."]) {
        [calc_obj setTax_decimal_number:NO];
    }
    
    if ( [[calc_obj tax_current_number] length] > 0 ) {
        [[calc_obj tax_current_number] replaceCharactersInRange:NSMakeRange([[calc_obj tax_current_number] length]-1, 1) withString:@""];  
        // check to see if current_number contain any character
        if ( [[calc_obj tax_current_number] length] == 0 ) {
            [[calc_obj tax_current_number] setString:@"0"];
        }
    }

    // compute sale tax
    [calc_obj computeSaleTaxResult];
    
    // display new number
    [self displayResults];
    
}

- (IBAction) pushClear: (id) sender {
    
    // re-initialize the parameter values
    [calc_obj setDefaultTaxVal];
    
    // display result
    [self displayResults];
    
    discount_btn.selected = FALSE;
    orig_price_btn.selected = TRUE;
    coupon_btn.selected = FALSE;
    sale_tax_btn.selected = FALSE;
    
}

- (IBAction) pushDecimal: (id) sender {
    
    if (![calc_obj tax_decimal_number]) {
        [calc_obj setTax_decimal_number:YES];
        
        // call the pushNumber routine for processing
        [self pushNumber:sender];        

    }
    
}

- (IBAction) pushOrigPrice: (id) sender {
    [store_name resignFirstResponder];
    [store_location resignFirstResponder];
    [item_name resignFirstResponder];
    discount_btn.selected = FALSE;
    orig_price_btn.selected = TRUE;
    coupon_btn.selected = FALSE;
    sale_tax_btn.selected = FALSE;
    
    // indicate orig price is selected
    [calc_obj setGotOrigPrice:YES];
    
    [calc_obj setGotCoupon:NO];
    [calc_obj setGotDiscountRate:NO];
    [calc_obj setGotSaleTax:NO];
    
    // Clear the current number
    [[calc_obj tax_current_number] setString:@""];
    [calc_obj setTax_decimal_number:NO];
    
}

- (IBAction) pushSaleTax: (id) sender {
    
    discount_btn.selected = FALSE;
    orig_price_btn.selected = FALSE;
    coupon_btn.selected = FALSE;
    sale_tax_btn.selected = TRUE;
    
    [calc_obj setGotOrigPrice:NO];
    
    [calc_obj setGotCoupon:NO];
    [calc_obj setGotDiscountRate:NO];
    [calc_obj setGotSaleTax:YES];
    
    // Clear the current number
    [[calc_obj tax_current_number] setString:@""];
    [calc_obj setTax_decimal_number:NO];
    
}

- (IBAction) pushDiscountRate: (id) sender {
    [store_name resignFirstResponder];
    [store_location resignFirstResponder];
    [item_name resignFirstResponder];
    discount_btn.selected = TRUE;
    orig_price_btn.selected = FALSE;
    coupon_btn.selected = FALSE;
    sale_tax_btn.selected = FALSE;
    
    [calc_obj setGotOrigPrice:NO];
    
    [calc_obj setGotCoupon:NO];
    [calc_obj setGotDiscountRate:YES];
    [calc_obj setGotSaleTax:NO];
    // Clear the current number
    [[calc_obj tax_current_number] setString:@""];
    [calc_obj setTax_decimal_number:NO];
}

- (IBAction) pushCoupon: (id) sender {
    [store_name resignFirstResponder];
    [store_location resignFirstResponder];
    [item_name resignFirstResponder];
    discount_btn.selected = FALSE;
    orig_price_btn.selected = FALSE;
    coupon_btn.selected = TRUE;
    sale_tax_btn.selected = FALSE;
    
    [calc_obj setGotOrigPrice:NO];
    
    [calc_obj setGotCoupon:YES];
    [calc_obj setGotDiscountRate:NO];
    [calc_obj setGotSaleTax:NO];
    // Clear the current number
    [[calc_obj tax_current_number] setString:@""];
    [calc_obj setTax_decimal_number:NO];
    
}

// internal helper functions
- (void) pushNumber: (id) sender {
    
    NSString *senderTitle = [sender currentTitle]; 
    enum SaleTaxCalcStatus status;
    
    BOOL gotPeriod = [senderTitle isEqualToString:@"."];
    
    if ( ([[calc_obj tax_current_number] isEqualToString:@"0"]) && 
        (gotPeriod == NO) ){
        // existing number is zero, then set the new number
        [[calc_obj tax_current_number] setString:senderTitle];
        
    }
    else {
        [[calc_obj tax_current_number] appendString:senderTitle];
    }
    
    // compute sale tax
    status = [calc_obj computeSaleTaxResult];
    
    if (status == INVALID_COUPON_AMOUNT) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Amount" message:@"Coupon amount cannot exceed original price" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            
        [alert show];
        [alert release];
    }

    if (status == INVALID_TAX_PERCENTAGE) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Value" message:@"Sale tax percentage can only be whole number." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    
    // display result
    [self displayResults];
    
}

- (void) displayResults {
    // Show the user enter number
    display_orig_price.text = [NSString stringWithFormat:@"%@",
                                [calc_obj orig_price]]; 
    display_tax_percent.text = [NSString stringWithFormat:@"%@%%",
                             [calc_obj tax_percent]]; 
    display_tax_amount.text = [NSString stringWithFormat:@"%@",
                                 [calc_obj tax_amount]]; 
    display_discount_rate.text = [NSString stringWithFormat:@"%@%%",
                              [calc_obj discount_rate]]; 
    
    display_discount_amount.text = [NSString stringWithFormat:@"%@",
                               [calc_obj discount_amount]]; 
    display_total_after_tax.text = [NSString stringWithFormat:@"%@",
                                [calc_obj total_after_tax]]; 
    display_saved.text = [NSString stringWithFormat:@"%@",
                               [calc_obj saved_amount]];
    
    display_coupon.text = [NSString stringWithFormat:@"%@",
                                  [calc_obj coupon]]; 
    
}

// open other feature GUI
- (IBAction) pushGotDeal:(id)sender {
    
    DealFeedback *dealFeedBackViewController = [[DealFeedback alloc] initWithNibName:@"DealFeedback" bundle:nil];
    //[[DealFeedback alloc] initWithNibName:@"DealFeedback" bundle:nil PVC:myBoss];
    
    [self.navigationController pushViewController:dealFeedBackViewController animated:YES];
    [dealFeedBackViewController release];    

}

- (IBAction) pushStoreRecord:(id) sender{ 
    bool notifyUser = NO;
    
    if (![self validateUserInputs])
        return; 
    
    // store the store name and location
    if (!gotStoreInfo){
        [self addStoreInfo];
    }  
    else{
        if (![[shoppingRecord objectForKey:STORE_NAME_KEY] isEqualToString:store_name.text] ||
            ![[shoppingRecord objectForKey:STORE_LOCATION_KEY] isEqualToString:store_location.text] ){
            if ([[sharedUserInfo one_receipt] count] > 0){
                
                notifyUser = YES;
                
                // user did not save receipt or has more new items that haven't been saved yet
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create New Receipt" message:@"You've changed store information, do you want to save current receipt and create a new one?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",@"No",nil];
                
                [alert show];
                [alert release];
            }
            else{
                newReceipt = NO;
            }
        }        
    }
    
    if (!notifyUser){
        [self addShoppingItem];
    }
    
}

- (void)addShoppingItem{
    // Create a new deal record dictionary for the new values
	NSMutableDictionary* newItem = [[NSMutableDictionary alloc] init];
    
    [newItem setObject:PURCHASE_ITEM_DETAIL_TAG forKey:NAME_KEY];
    [newItem setValue:item_name.text forKey:PURCHASED_ITEM_KEY];    
    [newItem setValue:display_orig_price.text forKey:ITEM_PRICE_KEY];
    [newItem setValue:display_discount_rate.text forKey:ITEM_DISCOUNT_RATE_KEY]; 
    [newItem setValue:display_discount_amount.text forKey:ITEM_COUPONS_AMOUNT_KEY]; 
    [newItem setValue:display_saved.text forKey:ITEM_SAVINGS_KEY];
    [newItem setValue:display_coupon.text forKey:ITEM_COUPONS_AMOUNT_KEY];   
    [newItem setValue:display_discount_amount.text forKey:ITEM_DISCOUNT_AMOUNT_KEY];
    [newItem setValue:display_total_after_tax.text forKey:ITEM_TOTAL_AFTER_TAX_KEY];
    [newItem setValue:display_tax_percent.text forKey:ITEM_SALE_TAX_PERCENT_KEY];
    [newItem setValue:display_tax_amount.text forKey:ITEM_SALE_TAX_AMOUNT_KEY];
    
	// Add it to the shopping receipt
	//[shopping_receipt addObject:newItem];
    
    // add item into a temp receipt
    [[sharedUserInfo one_receipt] addObject:newItem];
    
    //if ([[sharedUserInfo default_sale_tax] floatValue] != [display_tax_percent.text floatValue]){
    if ([sharedUserInfo default_sale_tax] != [display_tax_percent.text floatValue]){
        // store the sale tax to be default sale tax
        //[sharedUserInfo setDefault_sale_tax:[NSNumber numberWithFloat:[display_tax_percent.text floatValue]]];
        [sharedUserInfo setDefault_sale_tax:[display_tax_percent.text floatValue]];
    }
    
    // clear the fields
    // re-initialize the parameter values
    [calc_obj setDefaultTaxVal];
    
    // display result
    [self displayResults];
    
    item_name.text = @"";
    
    gotShoppingItem = TRUE;
    
    discount_btn.selected = FALSE;
    orig_price_btn.selected = TRUE;
    coupon_btn.selected = FALSE;
    sale_tax_btn.selected = FALSE;
    
    // release the new record
	[newItem release];
    
}

- (void)addStoreInfo{
    [shoppingRecord setObject:SHOPPING_RECEIPT_TAG forKey:NAME_KEY];
    [shoppingRecord setValue:store_name.text forKey:STORE_NAME_KEY];
    [shoppingRecord setValue:store_location.text forKey:STORE_LOCATION_KEY];
    [shoppingRecord setObject:[NSDate date] forKey:PURCHASED_DATE_KEY];
    gotStoreInfo = TRUE;
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"Cancel is selected");
            break;
        case 1:
            NSLog(@"YES is selected");

            newReceipt = YES;
            [self saveReceiptRecord];
            [[sharedUserInfo one_receipt] removeAllObjects];
            
            [self addStoreInfo];
            
            [self addShoppingItem];
            
            break;
        case 2:
            NSLog(@"No is selected");
            
            store_name.text = [shoppingRecord objectForKey:STORE_NAME_KEY];
            store_location.text = [shoppingRecord objectForKey:STORE_LOCATION_KEY];
            
            [self addShoppingItem];
            
            break;
        default:
            break;
    }
}

- (IBAction) pushShowReceipt:(id) sender{
    
    if (!gotShoppingItem){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Record Found" message:@"Please store your purchase item information first." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return;        
    }
    
    ShoppingReceiptVC * shoppingReceiptVC;
    
    //shoppingReceiptVC = [[ShoppingReceiptVC alloc] initWithNibName:@"ShoppingReceiptVC" bundle:nil PVC:myBoss];
    shoppingReceiptVC = [[ShoppingReceiptVC alloc] initWithNibName:@"ShoppingReceiptVC" bundle:nil];
                         
    shoppingReceiptVC.storeInfo = shoppingRecord;
    [self.navigationController pushViewController:shoppingReceiptVC animated:YES];
    [shoppingReceiptVC release]; 
    
}

- (bool) validateUserInputs{
    if (!gotStoreInfo){
        if ([store_name.text isEqualToString:@""] || [store_location.text isEqualToString:@""] || (store_name.text == NULL) || (store_location.text == NULL)){   
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter store name, store location for the first time" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            
            return NO;
        }             
    }
    
    if ([display_orig_price.text isEqualToString:@"$0"] || [display_orig_price.text isEqualToString:@""] || ([item_name.text isEqualToString:@""] || (item_name.text == NULL))){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter item name, price amount" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return NO;
    }    
    
    return YES;
    
}

- (void) initTaxCalc{
    // initialize shopping receipt
    shopping_receipt = [[NSMutableArray alloc] init];  
    
    shoppingRecord = [[NSMutableDictionary alloc] init];
    
    gotStoreInfo = FALSE;
    newReceipt = NO;
}

-(IBAction)itemNameFieldDoneEditing: (id) sender {
	[sender resignFirstResponder];
}

-(IBAction)storeNameFieldDoneEditing:(id)sender{
	[sender resignFirstResponder];
}

-(IBAction)storeLocationFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}


- (void)saveReceiptRecord{
    
    NSMutableString * receiptDetail = [[NSMutableString alloc] init];
    float total_after_tax =0.0;
    float total_savings = 0.0;
    NSMutableString *tempVal = [[NSMutableString alloc] init ];
    NSMutableString *saleTax = [[NSMutableString alloc] init];
    //NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    //NSLog(@"saveReceiptRecord: # of items in receipt = %d",[[sharedUserInfo one_receipt] count]);
    
    for (int i=0;i<[[sharedUserInfo one_receipt] count];i++){
        if ([[[[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:NAME_KEY] isEqualToString:PURCHASE_ITEM_DETAIL_TAG]) {
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:PURCHASED_ITEM_KEY] isEqualToString:@""] &&
                ([ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:PURCHASED_ITEM_KEY] != NULL)){
                [receiptDetail appendString:[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:PURCHASED_ITEM_KEY]];
            }
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_PRICE_KEY] isEqualToString:@""])
                [receiptDetail appendFormat:@"      %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_PRICE_KEY]];
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_DISCOUNT_RATE_KEY] isEqualToString:@"0%"]){
                
                [receiptDetail appendFormat:@"%@ OFF = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_DISCOUNT_RATE_KEY],
                 [ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_DISCOUNT_AMOUNT_KEY]];                
            }
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_COUPONS_AMOUNT_KEY] isEqualToString:@"0"]){
                
                [receiptDetail appendFormat:@"Coupon = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_COUPONS_AMOUNT_KEY]];                
            }
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY] isEqualToString:@"$0"] && ![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY] isEqualToString:@"$0.00"]){
                
                [receiptDetail appendFormat:@"Savings = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY]];  
                
                [tempVal setString:[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY]];
                if([tempVal hasPrefix:@"$"]) {
                    // remove the dollar sign
                    [tempVal replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];  
                }
                
                [tempVal replaceOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempVal length])];
                
                total_savings += [tempVal floatValue];
                
            }
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SALE_TAX_PERCENT_KEY] isEqualToString:@"0%"]){
                [receiptDetail appendFormat:@"%@ Tax = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SALE_TAX_PERCENT_KEY], [ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SALE_TAX_AMOUNT_KEY]];                 
            }
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_TOTAL_AFTER_TAX_KEY] isEqualToString:@"$0"]){
                
                [receiptDetail appendFormat:@"Cost = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_TOTAL_AFTER_TAX_KEY]];      
                
                [tempVal setString:[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_TOTAL_AFTER_TAX_KEY]];
                if([tempVal hasPrefix:@"$"]) {
                    // remove the dollar sign
                    [tempVal replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];  
                }
                
                [tempVal replaceOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempVal length])];
                
                total_after_tax += [tempVal floatValue];
                
                [saleTax setString:[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SALE_TAX_PERCENT_KEY]];
                
            }
            
            [receiptDetail appendFormat:@"%@\n",DISPLAY_ITEM_DIVIDER_LINE];
            
        }
    }
    
//    NSLog(@"total after tax = %f",total_after_tax);
//    NSLog(@"Total saving = %f", total_savings);
    
    NSNumberFormatter *numFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numFormatter setNumberStyle: NSNumberFormatterCurrencyStyle ];
    [numFormatter setMinimumFractionDigits:2];
    
    [receiptDetail appendFormat:@"%@\n",DISPLAY_RECEIPT_SUMMARY_LINE];
    [receiptDetail appendFormat:@"There %@ %d purchased item%@.\n",([[sharedUserInfo one_receipt] count]) == 1 ? @"is" : @"are",[[sharedUserInfo one_receipt] count],([[sharedUserInfo one_receipt] count]) == 1 ? @"" : @"s"];
    [receiptDetail appendFormat:@"Total Amount = %@\n",[numFormatter stringFromNumber:[NSNumber numberWithFloat:total_after_tax]]];
    [receiptDetail appendFormat:@"Total Savings = %@\n",[numFormatter stringFromNumber:[NSNumber numberWithFloat:total_savings]]];
    [receiptDetail appendFormat:@"%@\n",DISPLAY_ITEM_DIVIDER_LINE];
    
    /*
    NSLog(@"About to add shopping history");

    NSLog(@"%@",shoppingRecord);
     */
    
    [shoppingRecord setValue:receiptDetail forKey:EMAIL_MSG_KEY];
    
    /*
    NSLog(@"AFTER ADDING DETAIL");
    NSLog(@"%@",shoppingRecord);
    */
    if (newReceipt){
        NSMutableDictionary *mutable = [NSMutableDictionary dictionaryWithDictionary:shoppingRecord];
    
        [[sharedUserInfo shopping_receipt_records] addObject:mutable];
        newReceipt = NO;
    }
    else{
        [[sharedUserInfo shopping_receipt_records] addObject:shoppingRecord];
    }
    
    /*
    for (int i=0;i<[[sharedUserInfo shopping_receipt_records] count];i++){
        NSLog(@"%@",[[sharedUserInfo shopping_receipt_records] objectAtIndex:i]);
    }
    */
    
	// Sort the array since we just aded a new deal
    if ([[sharedUserInfo shopping_receipt_records] count] > 1){
        NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] initWithKey:PURCHASED_DATE_KEY ascending:NO ];
        
        [[sharedUserInfo shopping_receipt_records] sortUsingDescriptors:[NSArray arrayWithObject:nameSorter]];
        [nameSorter release];
    }
    
    // -- THIS IS FOR DEBUG ONLY ---- save the data into plist
    if (RUN_ON_SIM_ONLY)
        [sharedUserInfo saveUserDataToPlist];
    
    [receiptDetail release];
    [tempVal release];
    [saleTax release];
    
}

@end

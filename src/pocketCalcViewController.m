//
//  pocketCalcViewController.m
//  pocketCalc
//
//  Created by Albert Tran on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "pocketCalcViewController.h"
#import "ConstantValues.h"
#import "TaxCalc.h"
#import "UnitConverter.h"
#import "UserDatabase.h"
#import "RestaurantFeedback.h"
#import "IOUManager.h"
#import "AboutPocketCalc.h"

#import "UserProfileVC.h"

@implementation pocketCalcViewController

// synthesize properties for having getters and setters
@synthesize display_number,display_each_amount,display_each_tip,display_total_tip,display_total_amount,tipPicker;



- (void)dealloc
{
    if (DEBUG_MODE_ENABLE)
        NSLog(@"inside pocketCalc dealloc");
    
    // release array memory first
    [tips release];
    [heads release];
    
    // release outlet memory
    [display_number release];
    [display_each_amount release];
    [display_total_amount release];
    [display_each_tip release];
    [display_total_tip release];
    
    [tipPicker release];
        
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
    
    //NSLog(@"inside pocketCalc viewWillAppear");

}

- (void) viewWillDisappear:(BOOL)animated{
    if (DEBUG_MODE_ENABLE)
        NSLog(@"inside pocketCalc viewWillDisappear");
    
    [sharedUserInfo setEach_person_amount:[NSString stringWithFormat:@"%@",display_each_amount.text]];
    
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Person Amount: %@",[sharedUserInfo each_person_amount]);
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    UILabel *pickerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 50, 32.0)] autorelease];
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = UITextAlignmentCenter;
    pickerLabel.backgroundColor = [UIColor clearColor];
    pickerLabel.textColor = [UIColor blackColor];
    if (row != 0) {
        pickerLabel.font = [UIFont systemFontOfSize:18];
        
    }
    else
    {
        pickerLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return pickerLabel;
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //[self prepareAmbientAudio];
    /* for sound recording */

    
    //NSLog(@"inside pocketCalc viewDidLoad");
    
    // this shrinks the picker to match the height of the number pad
    tipPicker.transform = CGAffineTransformMakeScale(1.0, 0.91);

    // start the user database
    sharedUserInfo = [UserDatabase shared];
    
    self.title = TIP_TITLE;
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    heads = [[NSMutableArray alloc] initWithCapacity:100];
    tips = [[NSMutableArray alloc] initWithCapacity:100];
    
    [heads addObject:[NSString stringWithFormat:@"Head"]];
    [tips addObject:[NSString stringWithFormat:@"Tip"]];
    
    for ( int i = 1 ; i < 100 ; i++ ) {
        [heads addObject:[NSString stringWithFormat:@"%d",i+1]];
        [tips addObject:[NSString stringWithFormat:@"%d%%",i]];
    }
    
    // Get the reference of the Calculator Instance and initialize the Tip Calc
    calc_obj = [Calculator calcInstance];
    [calc_obj setDefaultTipVal];
    
    // Register for application exiting information so we can save data
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];

    //[sharedUserInfo setCtrl_for_Audio:(int*)self];
    
    [super viewDidLoad];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
	if (component == 0) {
		return [tips count];
	}
	else {
		return [heads count];
	}
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent: (NSInteger)component{
	switch (component) {
        case 0:
            return [tips objectAtIndex:row];
        case 1:
            return [heads objectAtIndex:row];
	}
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // this callback function is called when user made a selection from the picker view
    // Get the tip and head count
    NSMutableString* selectedTip = [[NSMutableString alloc] init];
    NSMutableString* selectedHead = [[NSMutableString alloc] init];
    
	switch (component) {
        case 0:
            
            
            // this is tips selection
            [selectedTip setString:[tips objectAtIndex:row]];  
            
            if ([selectedTip isEqualToString:@"Tip"]) {
                [selectedTip setString:@"0"];
            }
            else {
                // remove the % symbol
                if ( [selectedTip length] > 0 ) {
                    [selectedTip replaceCharactersInRange:NSMakeRange([selectedTip length]-1, 1) withString:@""]; 
                }
                                   
            }
                
            // store selected tip to calc_obj
            [[calc_obj tips_percentage] setString:selectedTip];
            break;
        case 1:
            // this is heads selection
            [selectedHead setString:[heads objectAtIndex:row]];  
            
            if ([selectedHead isEqualToString:@"Head"]) {
                [selectedHead setString:@"1"];
            }
                
            [[calc_obj heads_count] setString:selectedHead];
            
            break;
	}    

    // Calculate tip 
    [calc_obj computeTipsResult];
    
    // display result
    [self displayResults];
    
    [selectedTip release];
    [selectedHead release];   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    // Unregister for notifications
	//[[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    if([[calc_obj tip_current_number] hasSuffix:@"."]) {
        [calc_obj setTip_decimal_number:NO];
    }
    
    if ( [[calc_obj tip_current_number] length] > 0 ) {
        [[calc_obj tip_current_number] replaceCharactersInRange:NSMakeRange([[calc_obj tip_current_number] length]-1, 1) withString:@""];  
        // check to see if current_number contain any character
        if ( [[calc_obj tip_current_number] length] == 0 ) {
            [[calc_obj tip_current_number] setString:@"0"];
        }
    }
    
    // Calculate tip 
    [calc_obj computeTipsResult];
    
    // display result
    [self displayResults];

}

- (IBAction) pushClear: (id) sender {
    
    // re-initialize the parameter values
    [calc_obj setDefaultTipVal];
    
    // display result
    [self displayResults];
}

- (IBAction) pushDecimal: (id) sender {
    if (![calc_obj tip_decimal_number]) {
        // call the pushNumber routine for processing
        [self pushNumber:sender];        
        [calc_obj setTip_decimal_number:YES];
    }

}

// internal helper functions
- (void) pushNumber: (id) sender {
    
    NSString *senderTitle = [sender currentTitle]; 
    
    BOOL gotPeriod = [senderTitle isEqualToString:@"."];
    
    if ( ([[calc_obj tip_current_number] isEqualToString:@"0"]) && 
         (gotPeriod == NO) ){
        // existing number is zero, then set the new number
        [[calc_obj tip_current_number] setString:senderTitle];
        
    }
    else {
        [[calc_obj tip_current_number] appendString:senderTitle];
    }
    
    // store the tip information
    NSMutableString* selectedTip = [[NSMutableString alloc] init];
    
    [selectedTip setString:[tips objectAtIndex:[tipPicker selectedRowInComponent:0]]];
    
    if ([selectedTip isEqualToString:@"Tip"]) {
        [selectedTip setString:@"0"];
    }
    else {
        
        // remove the % symbol
        if ( [selectedTip length] > 0 ) {
            [selectedTip replaceCharactersInRange:NSMakeRange([selectedTip length]-1, 1) withString:@""]; 
        }
    }

    [[calc_obj tips_percentage] setString:selectedTip];    
    
    // store selected tip to calc_obj
    NSMutableString* selectedHead = [[NSMutableString alloc] init];
    
    [selectedHead setString:[heads objectAtIndex:[tipPicker selectedRowInComponent:1]]];

    if ([selectedHead isEqualToString:@"Head"]) {
        [selectedHead setString:@"1"];
    }
    
    [[calc_obj heads_count] setString:selectedHead];
    
    // Calculate tip 
    [calc_obj computeTipsResult];
    
    // display result
    [self displayResults];
    
    [selectedTip release];
    [selectedHead release];
    
}

- (void) displayResults {
    // Show the user enter number
    display_number.text = [NSString stringWithFormat:@"%@",
                           [calc_obj tip_current_number]];    
    display_each_amount.text = [NSString stringWithFormat:@"%@",
                           [calc_obj each_amount]]; 
    display_each_tip.text = [NSString stringWithFormat:@"%@",
                           [calc_obj each_tip]]; 
    display_total_amount.text = [NSString stringWithFormat:@"%@",
                           [calc_obj total_amount]]; 
    display_total_tip.text = [NSString stringWithFormat:@"%@",
                           [calc_obj total_tip]]; 
}

- (IBAction)pushTaxCalc:(id)sender {
//    NSLog(@"tax calc page called");
    /*
    if ([[sharedUserInfo one_receipt] count]){
        // remove all items in the one receipt
        [[sharedUserInfo one_receipt] removeAllObjects];
    }
    */
    
    TaxCalc *taxCalcViewController = [[TaxCalc alloc] initWithNibName:@"TaxCalc" bundle:nil];
    
    //[[TaxCalc alloc] initWithNibName:@"TaxCalc" bundle:nil PVC:self];
    
    [self.navigationController pushViewController:taxCalcViewController animated:YES];
    [taxCalcViewController release];    
}

- (IBAction) pushIOU:(id)sender {
    //    NSLog(@"tax calc page called");
    
    IOUManager *iouManagerVC = [[IOUManager alloc] initWithNibName:@"IOUManager" bundle:nil];
    
    //[[IOUManager alloc] initWithNibName:@"IOUManager" bundle:nil];
    
    //[[IOUManager alloc] initWithNibName:@"IOUManager" bundle:nil                PVC:self];
    
    
    [self.navigationController pushViewController:iouManagerVC animated:YES];
    [iouManagerVC release];    
}

- (IBAction) pushProfile:(id)sender{
    //    NSLog(@"tax calc page called");
    
    UserProfileVC *profileViewController = [[UserProfileVC alloc] initWithNibName:@"UserProfileVC" bundle:nil];
    
    //[[UserProfileVC alloc] initWithNibName:@"UserProfileVC" bundle:nil PVC:self];
    
    [self.navigationController pushViewController:profileViewController animated:YES];
    [profileViewController release];    
}

- (IBAction) pushLikeIt:(id)sender{
    //    NSLog(@"tax calc page called");
    
    RestaurantFeedback *restaurantViewController = [[RestaurantFeedback alloc] initWithNibName:@"RestaurantFeedback" bundle:nil];
    
    /* for sound recording */
    //[[RestaurantFeedback alloc] initWithNibName:@"RestaurantFeedback" bundle:nil PVC:self];
    
    [self.navigationController pushViewController:restaurantViewController animated:YES];
    [restaurantViewController release];    
}

- (IBAction) pushUnitConverter:(id)sender{
    //    NSLog(@"tax calc page called");
    
    UnitConverter *unitConverterViewController = 
    [[UnitConverter alloc] initWithNibName:@"UnitConverter" bundle:nil];
    
    [self.navigationController pushViewController:unitConverterViewController animated:YES];
    [unitConverterViewController release];    
}

- (IBAction) pushAboutPocketCalc:(id)sender{
    AboutPocketCalc *aboutPocketCalcVC = 
    [[AboutPocketCalc alloc] initWithNibName:@"AboutPocketCalc" bundle:nil];
    
    [self.navigationController pushViewController:aboutPocketCalcVC animated:YES];
    //[self.navigationController presentModalViewController:aboutPocketCalcVC animated:YES];
    
    [aboutPocketCalcVC release];    
}
/*
-(void) applicationWillTerminate: (NSNotification *)notification {
    //NSLog(@"applicationWillTerminate is called");
    
    // save the data into plist
    [sharedUserInfo saveUserDataToPlist];
    
    // release memory from the singleton objects
    [calc_obj dealloc];
    [sharedUserInfo dealloc];
}
*/

@end

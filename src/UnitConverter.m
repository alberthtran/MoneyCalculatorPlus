//
//  UnitConverter.m
//  pocketCalc
//
//  Created by Albert Tran on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UnitConverter.h"
#import "ConstantValues.h"

@implementation UnitConverter

@synthesize display_to_value,display_number,unitConvPicker,display_to_unit,display_from_unit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)dealloc
{
    [display_to_value release];
    [display_number release];
    [unitConvPicker release];
    
    [unit_selection release];
    [from_option release];
    [to_option release];
    
    [display_to_unit release];
    [display_from_unit release];
    
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
    
    //NSLog(@"inside UnitConverter viewWillAppear");
    
}

- (void)viewDidLoad
{
    // initialize the object
    [self initUnitConv];
    
    unitConvPicker.transform = CGAffineTransformMakeScale(0.9, 0.68);
    unitConvPicker.center = CGPointMake(unitConvPicker.center.x, unitConvPicker.center.y - 40);
    
//    NSLog([NSString stringWithFormat:@"%f", unitConvPicker.frame.origin.y + unitConvPicker.frame.size.height]);
    
    display_number.frame = CGRectMake(10, 0, 290, display_number.frame.size.height);
    
    display_from_unit.frame = CGRectMake(227, 0, display_from_unit.frame.size.width, display_from_unit.frame.size.height);
    display_from_unit.alpha = 0.0;
    [topView addSubview:display_number];
    [topView addSubview:display_from_unit];
    //topView.transform = CGAffineTransformMakeScale(1.0, 2.0);
    
    //topView.frame = CGRectMake(topView.frame.origin.x, 45, topView.frame.size.width, topView.frame.size.height);
    
    display_to_value.frame = CGRectMake(10, 0, display_to_value.frame.size.width, display_to_value.frame.size.height);

    display_to_unit.frame = CGRectMake(227, 0, display_to_unit.frame.size.width, display_to_unit.frame.size.height);
    [bottomView addSubview:display_to_value];
    [bottomView addSubview:display_to_unit];
    bottomView.alpha = 0.0;
    
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


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    if (component == 0) {
        NSArray *notes = [@"xx cups.png length.png weight.png temperature.png pressure.png area.png volume.png" componentsSeparatedByString:@" "];

        if (row == 0) 
        {
            UILabel *pickerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 45)] autorelease];
            pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
            pickerLabel.textAlignment = UITextAlignmentCenter;
            pickerLabel.backgroundColor = [UIColor clearColor];
            pickerLabel.textColor = [UIColor blackColor];
            //if ([pickerView selectedRowInComponent:0] == 0) {
                pickerLabel.font = [UIFont boldSystemFontOfSize:18];
//            }
//            else
//                pickerLabel.font = [UIFont systemFontOfSize:18];
            
            return pickerLabel; 
        }
        else 
        {
                        
            UIImageView *tmp = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[notes objectAtIndex:row]]] autorelease];
            
            tmp.frame = CGRectMake(0.0, 0.0, 50, 45.0);
            
            return tmp;
        }
        

     
    }
    else
    {
        UILabel *pickerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 45.0)] autorelease];
        pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        pickerLabel.textAlignment = UITextAlignmentCenter;
                pickerLabel.backgroundColor = [UIColor clearColor];
                pickerLabel.textColor = [UIColor blackColor];
        if ([pickerView selectedRowInComponent:0] == 0) {
             pickerLabel.font = [UIFont boldSystemFontOfSize:18];
        }
        else
            pickerLabel.font = [UIFont systemFontOfSize:18];

        return pickerLabel;
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return TOTAL_NUM_PICKERVIEW_COMPONENTS;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component {
	
    switch (component) {
        case 0:
            return [unit_selection count];
        case 1:
            return [from_option count];
        case 2:
            return [to_option count];
        default:
            return 0;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent: (NSInteger)component{
	switch (component) {
        case 0:
            return [unit_selection objectAtIndex:row];
        case 1:
            return [from_option objectAtIndex:row];
        case 2:
            return [to_option objectAtIndex:row];
        default:
            return nil;
	}

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // this callback function is called when user made a selection from the picker view
    // Get the tip and head count
    NSMutableString* selectedOption = [[NSMutableString alloc] init];
    //NSMutableString* unitType = [[NSMutableString alloc] init];
    
	switch (component) {
        case 0:
            // Clear the from and to option
            [from_option removeAllObjects];
            [to_option removeAllObjects];
            
            // clear the previous result
            [calc_obj setDefaultUnitConvVal:NO];
            
            // this is type of conversion selection
            [selectedOption setString:[unit_selection objectAtIndex:row]];  
            
            if ([selectedOption isEqualToString:SELECT_OPTION_TITLE]) {
                //[selectedOption setString:@""];
                
                // Show title for both from unit and to unit column on picker view
                // Add from unit title
                [from_option addObject:FROM_OPTION_TITLE];
                // Add to unit title
                [to_option addObject:TO_OPTION_TITLE];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:.3];
                topView.frame = CGRectMake(5, 64, 310, 33);
                bottomView.alpha = 0.0;
                display_number.frame = CGRectMake(10, 0, 290, display_number.frame.size.height);
                display_from_unit.alpha = 0.0;
                [UIView commitAnimations];
                self.title = BASIC_CALC_TITLE;
            }
            else if ([selectedOption isEqualToString:LENGTH_CONVERSION_TITLE]){
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:.3];
                topView.frame = CGRectMake(5, 45, 310, 33);
                bottomView.alpha = 1.0;
                display_number.frame = CGRectMake(10, 0, 215, display_number.frame.size.height);
                display_from_unit.alpha = 1.0;
                [UIView commitAnimations];
                self.title = UNIT_CONV_TITLE;
                
                // Show the length conversion in the from and to column of the pickerview
                [from_option addObjectsFromArray:[calc_obj length_conversion_list]];
                [to_option addObjectsFromArray:[calc_obj length_conversion_list]];
                
                // Set length conversion
                [calc_obj setConversion_type:LENGTH_UNIT];
                
            }
            else if ([selectedOption isEqualToString:MASS_CONVERSION_TITLE]){
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:.3];
                topView.frame = CGRectMake(5, 45, 310, 33);
                display_number.frame = CGRectMake(10, 0, 215, display_number.frame.size.height);
                display_from_unit.alpha = 1.0;
                bottomView.alpha = 1.0;
                [UIView commitAnimations];
                self.title = UNIT_CONV_TITLE;
                
                // Show the MASS conversion in the from and to column of the pickerview
                [from_option addObjectsFromArray:[calc_obj mass_conversion_list]];
                [to_option addObjectsFromArray:[calc_obj mass_conversion_list]];
                // set mass conversion
                [calc_obj setConversion_type:MASS_UNIT];
            }            
            else if ([selectedOption isEqualToString:PRESSURE_CONVERSION_TITLE]){
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:.3];
                topView.frame = CGRectMake(5, 45, 310, 33);
                display_number.frame = CGRectMake(10, 0, 215, display_number.frame.size.height);
                display_from_unit.alpha = 1.0;
                bottomView.alpha = 1.0;
                [UIView commitAnimations];
                self.title = UNIT_CONV_TITLE;
                
                // Show the Pressure conversion in the from and to column of the pickerview
                [from_option addObjectsFromArray:[calc_obj pressure_conversion_list]];
                [to_option addObjectsFromArray:[calc_obj pressure_conversion_list]];
                // set mass conversion
                [calc_obj setConversion_type:PRESSURE_UNIT];
            }
            else if ([selectedOption isEqualToString:AREA_CONVERSION_TITLE]){
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:.3];
                topView.frame = CGRectMake(5, 45, 310, 33);
                display_number.frame = CGRectMake(10, 0, 215, display_number.frame.size.height);
                display_from_unit.alpha = 1.0;
                bottomView.alpha = 1.0;
                [UIView commitAnimations];
                self.title = UNIT_CONV_TITLE;
                
                // Show the area conversion in the from and to column of the pickerview
                [from_option addObjectsFromArray:[calc_obj area_conversion_list]];
                [to_option addObjectsFromArray:[calc_obj area_conversion_list]];
                // set mass conversion
                [calc_obj setConversion_type:AREA_UNIT];
            }
            else if ([selectedOption isEqualToString:VOLUMN_CONVERSION_TITLE]){
                
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:.3];
                topView.frame = CGRectMake(5, 45, 310, 33);
                display_number.frame = CGRectMake(10, 0, 215, display_number.frame.size.height);
                display_from_unit.alpha = 1.0;
                bottomView.alpha = 1.0;
                [UIView commitAnimations];
                self.title = UNIT_CONV_TITLE;
                
                // Show the volumn conversion in the from and to column of the pickerview
                [from_option addObjectsFromArray:[calc_obj volumn_conversion_list]];
                [to_option addObjectsFromArray:[calc_obj volumn_conversion_list]];
                // set mass conversion
                [calc_obj setConversion_type:VOLUMN_UNIT];
            }
            else if ([selectedOption isEqualToString:COOKING_CONVERSION_TITLE]){
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:.3];
                topView.frame = CGRectMake(5, 45, 310, 33);
                display_number.frame = CGRectMake(10, 0, 215, display_number.frame.size.height);
                display_from_unit.alpha = 1.0;
                bottomView.alpha = 1.0;
                [UIView commitAnimations];
                self.title = UNIT_CONV_TITLE;
                
                // Show the cooking conversion in the from and to column of the pickerview
                [from_option addObjectsFromArray:[calc_obj cooking_conversion_list]];
                [to_option addObjectsFromArray:[calc_obj cooking_conversion_list]];
                // set mass conversion
                [calc_obj setConversion_type:COOKING_UNIT];
            }
            else {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:.3];
                topView.frame = CGRectMake(5, 45, 310, 33);
                display_number.frame = CGRectMake(10, 0, 215, display_number.frame.size.height);
                display_from_unit.alpha = 1.0;
                bottomView.alpha = 1.0;
                [UIView commitAnimations];
                self.title = UNIT_CONV_TITLE;
                
                // Show the temperature conversion in the from and to column of the pickerview
                [from_option addObjectsFromArray:[calc_obj temperature_conversion_list]];
                [to_option addObjectsFromArray:[calc_obj temperature_conversion_list]];
                //set temperature conversion
                [calc_obj setConversion_type:TEMPERATURE_UNIT];
                
            }
            
            // reload from unit option
            [pickerView reloadComponent:1];
            // reload to unit option
            [pickerView reloadComponent:2];
            
            // store the indexes for the table
            [calc_obj setTable_row:[pickerView selectedRowInComponent:1]];
            [calc_obj setTable_col:[pickerView selectedRowInComponent:2]];
            // start to convert the unit once user selected the to_unit 
            [calc_obj convertUnit];
            // display result
            [self displayResults];            
            break;
        case 1:
            
            //Set the from unit
            [calc_obj setTable_row:row];
            
            // start to convert the unit once user selected the to_unit 
            [calc_obj convertUnit];
            
            // display result
            [self displayResults];
            
            break;
        case 2:

            //Set the to unit
            [calc_obj setTable_col:row];
            
            // start to convert the unit once user selected the to_unit 
            [calc_obj convertUnit];
            
            // display result
            [self displayResults];
            
            break;            
	}    
    
    [selectedOption release];
    
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
    
    if([[calc_obj unitConv_current_number] hasSuffix:@"."]) {
        [calc_obj setUnitConv_decimal_number:NO];
    }
    
    if ( [[calc_obj unitConv_current_number] length] > 0 ) {
        [[calc_obj unitConv_current_number] replaceCharactersInRange:NSMakeRange([[calc_obj unitConv_current_number] length]-1, 1) withString:@""];  
        // check to see if current_number contain any character
        if ( [[calc_obj unitConv_current_number] length] == 0 ) {
            [[calc_obj unitConv_current_number] setString:@"0"];
        }
    }
    
    // Calculate tip 
    [calc_obj convertUnit];
    
    // display result
    [self displayResults];
    
}

- (IBAction) pushClear: (id) sender {
    [calc_obj clearUnitResults];
    [self initMathFlags];
    // display result
    [self displayResults];
}

- (IBAction) pushDecimal: (id) sender {
    if (![calc_obj unitConv_decimal_number]) {
        // call the pushNumber routine for processing
        [self pushNumber:sender];        
        [calc_obj setUnitConv_decimal_number:YES];
    }
    
}

// math button
- (IBAction) pushAdd: (id) sender{
//    [calc_obj setMathOp:Addition];
    
    [self pushMathOp:Addition];
    
}

- (IBAction) pushSubstract: (id) sender{
//    [calc_obj setMathOp:Subtraction];
    
    [self pushMathOp:Subtraction];
}

- (IBAction) pushMultiply: (id) sender{
//    [calc_obj setMathOp:Multiplication];
    
    [self pushMathOp:Multiplication];
    
}

- (IBAction) pushDivide: (id) sender{
//    [calc_obj setMathOp:Division];
    
    [self pushMathOp:Division];
    
}

- (IBAction) pushEqual: (id) sender{
    
    enum MathOpStatus opStatus = NO_ERRORS;
    
    if ([calc_obj mathOp] == TOTAL_NUM_MATH_OP_CNT){
        return;
    }
    
    if (gotEqual){
        [[calc_obj unitConv_current_number] setString:[NSString stringWithFormat:@"%f",savedCurNum]];
    }
    else{
        savedCurNum = [[calc_obj unitConv_current_number] floatValue];
        gotEqual = TRUE;
    }
    
    //NSLog(@"EQUAL: numberCnt = %d",numberCnt);
    
    //  NSLog(@"EQUAL: before compute, running total = %f",[calc_obj running_total]);
    
    opStatus = [calc_obj basicMathOperator];

    //NSLog(@"EQUAL: after compute, running total = %f",[calc_obj running_total]);
    
    if (opStatus == DIVISION_BY_ZERO){
        // error - division by zero
        display_number.text = [NSString stringWithFormat:@"Error: Division by zero"];  
        //clear the math op
        [calc_obj setMathOp:TOTAL_NUM_MATH_OP_CNT];
        return;
    }
        
    if (opStatus == INVALID_OP){
        // error - division by zero
        display_number.text = [NSString stringWithFormat:@"Error: Invalid Operation"];  
        return;
    }
        
    numberCnt = 1;
    sameNumber = FALSE;
    
    [calc_obj convertUnit];
    // display result
    [self displayResults];
    
    [calc_obj setUnitConv_decimal_number:NO];
    
}

- (IBAction) pushSign: (id) sender{
    // do nothing if current number is zero
    if([[calc_obj unitConv_current_number] isEqualToString:@"0"]) {
        return;
    }
    
    if([[calc_obj unitConv_current_number] hasPrefix:@"-"]) {
        // remove the negative sign
        [[calc_obj unitConv_current_number] replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];  
    }
    else {
        NSString *tempNumber = [[NSString alloc] initWithString:[calc_obj unitConv_current_number]];
        
        // add the negative sign
        [[calc_obj unitConv_current_number] setString:[NSString stringWithFormat:@"-%@",tempNumber]]; 
        
        // release temp memory
        [tempNumber release];
    }
    
    // Calculate tip 
    [calc_obj convertUnit];
    
    // display result
    [self displayResults];
        
}

// internal helper functions
- (void) pushNumber: (id) sender{
    NSString *senderTitle = [sender currentTitle]; 
    
    BOOL gotPeriod = [senderTitle isEqualToString:@"."];
    
    //if ( ([[calc_obj unitConv_current_number] isEqualToString:@"0"]) && 
    //    (gotPeriod == NO) ){
    
    if (!sameNumber){
        // store the new number
        [[calc_obj unitConv_current_number] setString:senderTitle];
        sameNumber = TRUE;
        numberCnt++;
        
        if ((numberCnt ==2) && gotEqual)
            gotEqual=FALSE;
    }
    else {
        if (!gotPeriod && [[calc_obj unitConv_current_number] isEqualToString:@"0"])
            [[calc_obj unitConv_current_number] setString:senderTitle];
        else{
            // append the new number into current number
            [[calc_obj unitConv_current_number] appendString:senderTitle];
        }
    }
    
    // Calculate tip 
    [calc_obj convertUnit];
    
    // display result
    [self displayResults];
    
}

- (void) pushMathOp: (enum MathOperator) mathOpType{

    if ([calc_obj mathOp] == TOTAL_NUM_MATH_OP_CNT)
        [calc_obj setMathOp:mathOpType];

  //  NSLog(@"MathOp: numberCnt = %d",numberCnt);
    
    if (numberCnt==1){
        // set the running total to cur num
        [calc_obj setRunning_total:[[calc_obj unitConv_current_number] floatValue]];
    //    NSLog(@"running total = %f",[calc_obj running_total]);
        
        [[calc_obj unitConv_current_number] setString:@"0"];
        
        sameNumber = FALSE;               
    }
    else if (numberCnt ==2){
        enum MathOpStatus opStatus = NO_ERRORS;
        
        // perform basic math
        opStatus = [calc_obj basicMathOperator];
        
     //   NSLog(@"after compute, running total = %f",[calc_obj running_total]);
        
        if (opStatus == DIVISION_BY_ZERO){
            // error - division by zero
            display_number.text = [NSString stringWithFormat:@"Error: Division by zero"];  
            //clear the math op
            [calc_obj setMathOp:TOTAL_NUM_MATH_OP_CNT];
            return;
        }
        
        if (opStatus == INVALID_OP){
            // error - division by zero
            display_number.text = [NSString stringWithFormat:@"Error: Invalid Operation"];  
            return;
        }
        
        [calc_obj convertUnit];
     
        [self displayResults];
        // reset number counter
        numberCnt=1;
        sameNumber = FALSE;
    }
    else{
    //    NSLog(@"Exceed number counter");
        return;
    }
    
    [calc_obj setMathOp:mathOpType];
    [calc_obj setUnitConv_decimal_number:NO];

}

- (void) displayResults{
    
    // Show the user enter number
    display_number.text = [NSString stringWithFormat:@"%@",
                           [calc_obj unitConv_current_number]]; 
    display_number.textColor = [UIColor blueColor];
    
    display_to_value.text = [NSString stringWithFormat:@"%@",
                             [calc_obj to_result_val]]; 
    display_to_value.textColor = [UIColor purpleColor];
    
    if ([calc_obj conversion_type] == TEMPERATURE_UNIT){
        display_from_unit.text = [NSString stringWithFormat:@"%@",
                                  [calc_obj from_unit_type]];
        
        display_to_unit.text = [NSString stringWithFormat:@"%@",
                                [calc_obj to_unit_type]]; 
    }
    else{
        display_from_unit.text = [NSString stringWithFormat:@"%@",
                                  [calc_obj from_unit_type]];

        display_to_unit.text = [NSString stringWithFormat:@"%@",
                                [calc_obj to_unit_type]];        
    }
    
    display_from_unit.textColor = [UIColor blueColor];
    display_to_unit.textColor = [UIColor purpleColor];
}

- (void) initUnitConv{
    self.title = BASIC_CALC_TITLE;
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // allocate memory
    unit_selection = [[NSMutableArray alloc] initWithObjects:SELECT_OPTION_TITLE,COOKING_CONVERSION_TITLE,LENGTH_CONVERSION_TITLE,MASS_CONVERSION_TITLE,TEMPERATURE_CONVERSION_TITLE, PRESSURE_CONVERSION_TITLE, AREA_CONVERSION_TITLE, VOLUMN_CONVERSION_TITLE, nil];
    from_option = [[NSMutableArray alloc] initWithObjects:FROM_OPTION_TITLE, nil];
    to_option = [[NSMutableArray alloc] initWithObjects:TO_OPTION_TITLE, nil];

    // Get the reference of the Calculator Instance and initialize the Tip Calc
    calc_obj = [Calculator calcInstance];
    [calc_obj setDefaultUnitConvVal:YES];
    
    // initialize the flags
    [self initMathFlags];
    
}

- (void) initMathFlags{
    //useSavedNum = FALSE;
    savedCurNum = 0.0;
    sameNumber = FALSE;
    numberCnt = 0;
    gotEqual = FALSE;
}

@end

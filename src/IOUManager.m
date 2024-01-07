//
//  IOUManager.m
//  pocketCalc
//
//  Created by Albert Tran on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IOUManager.h"
#import "ConstantValues.h"
#import "PostOnFacebookVC.h"
#import "PostOnTwitter.h"
//#import "PhotoController.h"
//#import "voiceRecorder.h"

@implementation IOUManager

@synthesize other_person_name,amount,outgoing_message,scrollView,save_button,person_type_seg,textMsgStatus,date_label;

@synthesize photoIcon,voiceIcon;

- (void)delRec:(id)sender
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success = [fileManager fileExistsAtPath:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]];
    
    if(success)
    {
        [fileManager removeItemAtPath:(NSString *)[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER] error:nil];  
        voiceIcon.hidden = YES;
        [sharedUserInfo setGotRecordedMemo:NO];
    }
}
-(IBAction) delVoice: (id) sender
{
    UIActionSheet *option;
    option = [[UIActionSheet alloc] initWithTitle:@"Remove Voice Memo" delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
    [option showInView:self.view];
    [option release];
}
-(IBAction) delPic: (id) sender
{
    UIActionSheet *option;
    option = [[UIActionSheet alloc] initWithTitle:@"Remove Photo" delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
    [option showInView:self.view];
    [option release];
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
    
//    if([[calc_obj unitConv_current_number] hasSuffix:@"."]) {
//        [calc_obj setUnitConv_decimal_number:NO];
//    }
//    
//    if ( [[calc_obj unitConv_current_number] length] > 0 ) {
//        [[calc_obj unitConv_current_number] replaceCharactersInRange:NSMakeRange([[calc_obj unitConv_current_number] length]-1, 1) withString:@""];  
//        // check to see if current_number contain any character
//        if ( [[calc_obj unitConv_current_number] length] == 0 ) {
//            [[calc_obj unitConv_current_number] setString:@"0"];
//        }
//    }
//    
//    // Calculate tip 
//    [calc_obj convertUnit];
//    
//    // display result
//    [self displayResults];
    if ([display_number.text length] >= 1) {
        display_number.text = [display_number.text substringToIndex:[display_number.text length] - 1];
        
        
    }
    else
    {
        display_number.text = @"";
    }
    [self displayOutgoingMsg];
}

- (IBAction) pushClear: (id) sender {
//    [calc_obj clearUnitResults];
//    // display result
//    [self displayResults];
    
    display_number.text = @"";
    
//    NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:display_number.text];
//    
//    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//    
//    display_number.text = [currencyFormatter stringFromNumber:someAmount];
//    display_number.text = [display_number.text stringByReplacingOccurrencesOfString:@"2.99" withString:@""];

    
    total = 0;
    newNum = 0;
    step = 0;
    lastOp = -1;
    newNumEnter = NO;
    
    [self displayOutgoingMsg];
}

- (IBAction) pushDecimal: (id) sender {
//    if (![calc_obj unitConv_decimal_number]) {
//        // call the pushNumber routine for processing
//        [self pushNumber:sender];        
//        [calc_obj setUnitConv_decimal_number:YES];
//    }
    if ([display_number.text rangeOfString:@"."].length == 0 || step == 1) {
         [self pushNumber:sender]; 
    }
   
}

/*
// math button
- (IBAction) pushAdd: (id) sender{
    [calc_obj setMathOp:Addition];
    [self pushMathOp];
}

- (IBAction) pushSubstract: (id) sender{
    [calc_obj setMathOp:Subtraction];
    [self pushMathOp];
}

- (IBAction) pushMultiply: (id) sender{
    [calc_obj setMathOp:Multiplication];
    [self pushMathOp];
    
}

- (IBAction) pushDivide: (id) sender{
    [calc_obj setMathOp:Division];
    [self pushMathOp];
}
*/
// math button
- (IBAction) pushAdd: (id) sender{
    //    [calc_obj setMathOp:Addition];
    
    //[self pushMathOp:Addition];
    
    if (lastOp == -1 || equalPressed == YES) {
        step = 1;
        
//        NSString *stripped = [display_number.text stringByReplacingOccurrencesOfString:@"," withString:@""]; 
//        stripped = [stripped substringFromIndex:1];
//        if (![display_number.text isEqualToString:@""]) {
//            NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""]];
//        
//            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//            [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//            
//            display_number.text = [currencyFormatter stringFromNumber:someAmount];
//        }
        
        total = [display_number.text floatValue];
        newNum = 0;
    }
    else
    {
        step = 1;
        if (newNumEnter) {
            
//            if (![display_number.text isEqualToString:@""]) {
//                NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""]];
//                
//                NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//                [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//                
//                display_number.text = [currencyFormatter stringFromNumber:someAmount];
//            }
            newNum = [display_number.text floatValue];
        }
        
        switch (lastOp) {
            case 0:
                total += newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 1:
                total -= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 2:
                total *= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 3:
                total /= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            default:
                total += newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
        }
        
//        NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", total]];
//        
//        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//        
//        display_number.text = [currencyFormatter stringFromNumber:someAmount];
    }
    equalPressed = NO;
    lastOp = 0;
    [self displayOutgoingMsg];
}

- (IBAction) pushSubstract: (id) sender{
    //    [calc_obj setMathOp:Subtraction];
    
//    [self pushMathOp:Subtraction];
    
    if (lastOp == -1 || equalPressed == YES) {
        step = 1;
        
//        if (![display_number.text isEqualToString:@""]) {
//            NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""]];
//            
//            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//            [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//            
//            display_number.text = [currencyFormatter stringFromNumber:someAmount];
//        }        
        total = [display_number.text floatValue];
        newNum = 0;
    }
    else
    {
        step = 1;
        if (newNumEnter) {
            
//            if (![display_number.text isEqualToString:@""]) {
//                NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""]];
//                
//                NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//                [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//                
//                display_number.text = [currencyFormatter stringFromNumber:someAmount];
//            }
            newNum = [display_number.text floatValue];
        }
        
        switch (lastOp) {
            case 0:
                total += newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 1:
                total -= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 2:
                total *= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 3:
                total /= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            default:
                total += newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
        }
        
        
    }
    
    lastOp = 1;
    equalPressed = NO;
    [self displayOutgoingMsg];
}

- (IBAction) pushMultiply: (id) sender{
    //    [calc_obj setMathOp:Multiplication];
    
//    [self pushMathOp:Multiplication];
    
    if (lastOp == -1 || equalPressed == YES) {
        step = 1;
        
//        if (![display_number.text isEqualToString:@""]) {
//            NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""]];
//            
//            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//            [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//            
//            display_number.text = [currencyFormatter stringFromNumber:someAmount];
//        }
        total = [display_number.text floatValue];
        newNum = 0;
    }
    else
    {
        step = 1;
        
        if (newNumEnter) {
            
//            if (![display_number.text isEqualToString:@""]) {
//                NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""]];
//                
//                NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//                [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//                
//                display_number.text = [currencyFormatter stringFromNumber:someAmount];
//            }
            newNum = [display_number.text floatValue];
        }
        
        switch (lastOp) {
            case 0:
                total += newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 1:
                total -= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 2:
                total *= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 3:
                total /= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            default:
                total += newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
        }
        
    }
    
    lastOp = 2;
    equalPressed = NO;
    [self displayOutgoingMsg];
}

- (IBAction) pushDivide: (id) sender{
    //    [calc_obj setMathOp:Division];
    
//    [self pushMathOp:Division];
    
    if (lastOp == -1 || equalPressed == YES) {
        step = 1;
        
//        if (![display_number.text isEqualToString:@""]) {
//            NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""]];
//            
//            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//            [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//            
//            display_number.text = [currencyFormatter stringFromNumber:someAmount];
//        }
        total = [display_number.text floatValue];
        newNum = 0;
    }
    else
    {
        step = 1;
        if (newNumEnter) {
            
//            if (![display_number.text isEqualToString:@""]) {
//                NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""]];
//                
//                NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//                [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//                
//                display_number.text = [currencyFormatter stringFromNumber:someAmount];
            newNum = [display_number.text floatValue];
        }
        
        switch (lastOp) {
            case 0:
                total += newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 1:
                total -= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 2:
                total *= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 3:
                total /= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            default:
                total += newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
        }
        
    }
    
    lastOp = 3;
    equalPressed = NO;
    [self displayOutgoingMsg];
}

- (IBAction) pushEqual: (id) sender{
    //enum MathOpStatus opStatus = NO_ERRORS;
    
//    opStatus = [calc_obj basicMathOperator];
//    
//    if (opStatus == DIVISION_BY_ZERO){
//        // error - division by zero
//        display_number.text = [NSString stringWithFormat:@"Error: Division by zero"];  
//        //clear the math op
//        [calc_obj setMathOp:TOTAL_NUM_MATH_OP_CNT];
//        return;
//    }
//    
//    if (opStatus == INVALID_OP){
//        // error - division by zero
//        display_number.text = [NSString stringWithFormat:@"Error: Invalid Operation"];  
//        return;
//    }
//    
//    [calc_obj convertUnit];
//    // display result
//    [self displayResults];
//    
//    // reset math operator
//    [calc_obj setMathOp:TOTAL_NUM_MATH_OP_CNT];
    step = 1;
    equalPressed = YES;
    if (lastOp == -1) {
        
//        if (![display_number.text isEqualToString:@""]) {
//            NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""]];
//            
//            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//            [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//            
//            display_number.text = [currencyFormatter stringFromNumber:someAmount];
//        }
        total = [display_number.text floatValue];
        
    }
    else
    {
        
        if (newNumEnter) {
//            if (![display_number.text isEqualToString:@""]) {
//                NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:[display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""]];
//                
//                NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//                [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//                
//                display_number.text = [currencyFormatter stringFromNumber:someAmount];
//            }
            newNum = [display_number.text floatValue];
        }
        
        switch (lastOp) {
            case 0:
                total += newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 1:
                total -= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 2:
                total *= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            case 3:
                total /= newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
            default:
                total += newNum;
                display_number.text = [NSString stringWithFormat:@"%.2f", total];
                newNumEnter = NO;
                break;
        }
        
        
    }
    //lastOp = -1;
    [self displayOutgoingMsg];
    
}
/*
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
*/
// internal helper functions
- (void) pushNumber: (id) sender{
    NSString *senderTitle = [sender currentTitle]; 
    
    //BOOL gotPeriod = [senderTitle isEqualToString:@"."];
    
//    if ( ([[calc_obj unitConv_current_number] isEqualToString:@"0"]) && 
//        (gotPeriod == NO) ){
//    if (gotPeriod == NO){
//        // existing number is zero, then set the new number
//        [[calc_obj unitConv_current_number] setString:senderTitle];
//        
//    }
//    else {
//        [[calc_obj unitConv_current_number] appendString:senderTitle];
//    }
    
    // Calculate tip 
    //[calc_obj convertUnit];
    
    // display result
    //[self displayResults];
    
    
    if(step == 0)
    {
        //total = display_number.text;
        display_number.text = [NSString stringWithFormat:@"%@%@", display_number.text, senderTitle];
        
//        NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:display_number.text];
//        
//        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//        
//        display_number.text = [currencyFormatter stringFromNumber:someAmount];
        
        
    }
    else if(step == 1)
    {
        newNumEnter = YES;
        step = 0;
        
        display_number.text = [NSString stringWithFormat:@"%@", senderTitle];
        if (equalPressed == YES) {
            equalPressed = NO;
            total = 0;
            lastOp = -1;
        }
//        NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:display_number.text];
//        
//        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//        
//        display_number.text = [currencyFormatter stringFromNumber:someAmount];
        //newNum = display_number.text;
        
        
    }
    equalPressed = NO;
    [self displayOutgoingMsg];
//    else if(step == 2)
//    {
//        display_number.text = [NSString stringWithFormat:@"%@%@", display_number.text, senderTitle];
//        //newNum = display_number.text;
//    }
    
}

/*
- (void) pushMathOp2{
    [calc_obj setRunning_total:[[calc_obj unitConv_current_number] floatValue]];
    [[calc_obj unitConv_current_number] setString:@"0"];
    // reset the decimal flag
    [calc_obj setUnitConv_decimal_number:NO];
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
    

    
    
    display_number.text = [NSString stringWithFormat:@"%@",
                                  [calc_obj from_unit_type]];
        

    
    display_number.textColor = [UIColor blueColor];
}

- (void) displayResults2{
    
    // Show the user enter number
    display_number.text =  [calc_obj unitConv_current_number]; //[NSString stringWithFormat:@"%@",
                           //[calc_obj unitConv_current_number]]; 
    display_number.textColor = [UIColor blueColor];
    
    //amount.text = display_number.text;

}
*/
- (IBAction) pushAmount: (id) sender{
    
  
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    date_picker.frame = CGRectMake(0, 480, date_picker.frame.size.width, date_picker.frame.size.height);
    [UIView commitAnimations];
    
    if (numPad.frame.origin.y >= 480) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        numPad.frame = CGRectMake(0, 260, numPad.frame.size.width, numPad.frame.size.height);
        [UIView commitAnimations];
        [other_person_name resignFirstResponder];
        
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        numPad.frame = CGRectMake(0, 480, numPad.frame.size.width, numPad.frame.size.height);
        [UIView commitAnimations];
        step = 0;
        lastOp = -1;
       
//        if (![display_number.text isEqualToString:@""]) {
//            NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:display_number.text];
//            
//            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//            [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//            
//            display_number.text = [currencyFormatter stringFromNumber:someAmount];
//            display_number.text = [display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""];
//        }
        
        [self displayOutgoingMsg];
    }
    
}


- (void) takeAudio:(enum MediaOptionsList) mediaOption{
    NSLog(@"%d",mediaOption);
    NSLog(@"record was hit");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    // get the reference of the user database
    //sharedUserInfo = [UserDatabase shared];
    if (self) {
        //sharedUserInfo = [UserDatabase shared];
        total = 0;
        newNum = 0;
        step = 0;
        lastOp = -1;
        equalPressed = NO;
        newNumEnter = NO;
        display_number.text = @"";
        
//        NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:@"0.00"];
//        
//        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//        
//        cur.text = [currencyFormatter stringFromNumber:someAmount];
//        cur.text = [cur.text stringByReplacingOccurrencesOfString:@"0" withString:@""];
//        cur.text = [cur.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        if (numPad.frame.origin.y < 480) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.3];
            numPad.frame = CGRectMake(0, 480, numPad.frame.size.width, numPad.frame.size.height);
            [UIView commitAnimations];
        }
      
        UIButton *datepick = [UIButton buttonWithType:UIButtonTypeCustom];
        datepick.frame = CGRectMake(0, 138, 320, 40);
        [datepick addTarget:self action:@selector(pushDateButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:datepick];

        [self.view addSubview:date_picker];
        
        [self.view addSubview:numPad];
        
  
        // Custom initialization
    }
    return self;
}

- (IBAction) useMedia: (id) sender
{
    UIActionSheet *option;
    option = [[UIActionSheet alloc] initWithTitle:@"Attach Media To Email / Facebook" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Record Voice (Email)", @"Photo",nil];  

    [option showInView:self.view];
    [option release];
    
}

- (void)dealloc
{
    [other_person_name release];
    [amount release];
    [outgoing_message release];
    [scrollView release];
    [save_button release];
    [person_type_seg release];
    [textMsgStatus release];
    [sharethis release];
    
    [date_label release];
	[date_picker release];
    
    [photoIcon release];
    [voiceIcon release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    UIAlertView *tt = [[UIAlertView alloc] initWithTitle:@"oops" message:@"The device is running out of memory.\nPlease close other apps running in the background:\n1. Double press the home button\n2. Hold down on an app until it wiggles and shows a minus sign\n3. Tap the minus sign to close apps" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [tt show];
    [tt release];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)sendSMS {
    if (![self validateUserInputs])
        return;
    
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
	if([MFMessageComposeViewController canSendText])
	{
        controller.body = [NSString stringWithFormat:@"%@\n\n%via Money Calculator +\nhttp://ezfunapps.com/get.php",outgoing_message.text];    
		//controller.body = @"Hi";
		controller.recipients = [NSArray arrayWithObjects:nil];
		controller.messageComposeDelegate = self;
        
        
        
		[self presentModalViewController:controller animated:YES];
	}	
	
    [controller release];
}

#pragma mark - View lifecycle
#pragma mark Dismiss Mail/SMS view controller

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

    // start the user database
   // sharedUserInfo = [UserDatabase shared];
    
    if (![[sharedUserInfo each_person_amount] isEqualToString:@"0"]) {
        amount.text = [sharedUserInfo each_person_amount];
        [self displayOutgoingMsg];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    // initiallly keyboard is hide
    keyboardVisible = NO;

    
   
    if ([sharedUserInfo userPhoto] != nil){
        //photo.image = [sharedUserInfo userPhoto];
        photoIcon.hidden = NO;
    }
    else
        photoIcon.hidden = YES;
    
    if ([sharedUserInfo gotRecordedMemo]){
        voiceIcon.hidden = NO;
    }
    else
        voiceIcon.hidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated{
    
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Unregistering for keyboard events");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (void)viewDidLoad
{
    sharedUserInfo = [UserDatabase shared];
    
    self.title = IOU_TITLE;
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self initIOUManager];
    
    self.navigationItem.rightBarButtonItem = self.save_button;

    // set the scrollview frame size same as the view frame size
    scrollView.contentSize = self.view.frame.size;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Remove previous audio and photo icon
    if ([sharedUserInfo gotRecordedMemo]){
        [sharedUserInfo setGotRecordedMemo:NO];
        voiceIcon.hidden = YES;
    }
    
    if ([sharedUserInfo userPhoto] != nil){
        [sharedUserInfo setUserPhoto:nil];
        photoIcon.hidden = YES;
    }
        
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

- (bool) validateUserInputs{
    
    //    if (![display_number.text isEqualToString:@""]) {
    //        NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:display_number.text];
    //        
    //        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    //        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    //        
    //        display_number.text = [currencyFormatter stringFromNumber:someAmount];
    //        display_number.text = [display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""];
    //    }
    [self displayOutgoingMsg];
    
        
    if ([other_person_name.text isEqualToString:@""] || [date_label.text isEqualToString:@""] ||
        [display_number.text isEqualToString:@""] || [display_numberFake.text isEqualToString:@"NaN"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter other person name, repayment date, and total amount" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return NO;
    }    
    
    return YES;
}

- (void) emailNow: (id) sender{
    
    if(![MFMailComposeViewController canSendMail])
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your device are not configured to send email" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return;
    }

    
    if (![self validateUserInputs])
        return;
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    [mailComposer setSubject:IOU_EMAIL_SUBJECT];

    if ([sharedUserInfo userPhoto] != nil){
        [mailComposer addAttachmentData:UIImageJPEGRepresentation([sharedUserInfo userPhoto], 1) mimeType:@"image/jpg" fileName:@"picture.jpg"];
    }
    
    if ([sharedUserInfo gotRecordedMemo]){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL success = [fileManager fileExistsAtPath:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]]; 
        
        if (success) {
            [mailComposer addAttachmentData:[NSData dataWithContentsOfFile:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]] mimeType:@"audio/aif" fileName:@"voicememo.aif"];
        }        
    }
    
    NSString *emailBody = [NSString stringWithFormat:@"%@\n\n%via Money Calculator +\nhttp://ezfunapps.com/get.php",outgoing_message.text];

    //NSString* emailBody = [[NSString alloc] initWithString:outgoing_message.text];
    
    [mailComposer setMessageBody:emailBody isHTML:NO];
    [self presentModalViewController:mailComposer animated:YES];
    
    [mailComposer release];    
    //[emailBody release];
}


-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    NSMutableString *status = [[NSMutableString alloc] init];
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [status setString:[NSString stringWithFormat:@"Email Cancelled"]];
            break;
        case MFMailComposeResultSaved:
            [status setString:[NSString stringWithFormat:@"Email Saved"]];
            break;
        case MFMailComposeResultSent:
            [status setString:[NSString stringWithFormat:@"Email Sent"]];
            break;
        case MFMailComposeResultFailed:
            [status setString:[NSString stringWithFormat:@"Email Failed"]];
            break;
        default:
            [status setString:[NSString stringWithFormat:@"Email Abort"]];
            break;
    }
    
    IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
    display.type = NotificationDisplayTypeText;
    [display setNotificationText:status];
    [display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
    [display release];
    
    [status release];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) personNameFieldDoneEditing: (id) sender{
	[sender resignFirstResponder];
    [self displayOutgoingMsg];
    
//    if (!date_picker.hidden)
//        date_picker.hidden = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    date_picker.frame = CGRectMake(0, 480, date_picker.frame.size.width, date_picker.frame.size.height);
    [UIView commitAnimations];
}

-(IBAction) amountFieldDoneEditing: (id) sender{
    [sender resignFirstResponder]; 
    [self displayOutgoingMsg];
    
//    if (!date_picker.hidden)
//        date_picker.hidden = YES;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    date_picker.frame = CGRectMake(0, 480, date_picker.frame.size.width, date_picker.frame.size.height);
    [UIView commitAnimations];

}

- (void)fadeSave:(NSTimer *)theTimer
{
    [[theTimer userInfo] removeFromSuperview];
}
- (IBAction) pushSaveIOUInfo:(id) sender{
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Save button is pressed");
    
    if (![self validateUserInputs])
        return;
    
    UILabel *saving = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    saving.text = @"Saving ...";
    saving.textAlignment = UITextAlignmentCenter;
    saving.backgroundColor = [UIColor whiteColor];
    saving.font = [UIFont boldSystemFontOfSize:50.0];
    saving.alpha = 0.7;
    [self.view addSubview:saving];
    saving.userInteractionEnabled = YES;
    saving.multipleTouchEnabled = YES;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fadeSave:) userInfo:saving repeats:NO];
    [saving release];
    
    // Create a new restaurant record dictionary for the new values
	NSMutableDictionary* newIOURecord = [[NSMutableDictionary alloc] init];
        
    [newIOURecord setObject:IOU_TAG forKey:NAME_KEY];
    [newIOURecord setValue:other_person_name.text forKey:BORROWER_NAME_KEY];
    
    [newIOURecord setValue:outgoing_message.text forKey:EMAIL_MSG_KEY];
    
    [newIOURecord setObject:[NSDate date] forKey:PURCHASED_DATE_KEY];
    
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Adding %@ with name %@", [newIOURecord objectForKey:PURCHASED_ITEM_KEY], [newIOURecord objectForKey:EMAIL_MSG_KEY]);
    
	// Add it to the master drink array and release our reference
	[[sharedUserInfo iou_records] addObject:newIOURecord];
    
	// Sort the array since we just aded a new drink
    if ([[sharedUserInfo iou_records] count] > 1){
        //NSLog(@"Inside sorting condition");
        NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] initWithKey:PURCHASED_DATE_KEY ascending:NO ];
        
        [[sharedUserInfo iou_records] sortUsingDescriptors:[NSArray arrayWithObject:nameSorter]];
        [nameSorter release];
    }
    
    if (DEBUG_MODE_ENABLE)
        for (int i=0;i<[[sharedUserInfo iou_records] count];i++){
            NSLog(@"%@",[[sharedUserInfo iou_records] objectAtIndex:i]);
        }
    
    // -- THIS IS FOR DEBUG ONLY ---- save the data into plist
    if (RUN_ON_SIM_ONLY)
        [sharedUserInfo saveUserDataToPlist];
    
    // release the new record
	[newIOURecord release];   
    
//    if (!date_picker.hidden)
//        date_picker.hidden = YES;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    date_picker.frame = CGRectMake(0, 480, date_picker.frame.size.width, date_picker.frame.size.height);
    [UIView commitAnimations];
}

-(void) keyboardDidShow:(NSNotification *)notif{
    if (keyboardVisible) {
        if (DEBUG_MODE_ENABLE)
            NSLog(@"Keyboard is already visible. Ignore notification");
        return;
    }
    
    // keyboard wasn't visible before
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Resizing smaller for keyboard");
    
    // Get the keyboard's size
    NSDictionary* info = [notif userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    // Resize the scroll view to make room for the keyboard
    CGRect viewFrame = self.view.frame;
    
    viewFrame.size.height -= keyboardSize.height;
    scrollView.frame = viewFrame;
    keyboardVisible = YES;
    
}

- (IBAction) keyboardDidHide:(NSNotification *)notif {
    if (!keyboardVisible){
        if (DEBUG_MODE_ENABLE)
            NSLog(@"Keyboard is already hidden. Ignoring notification");
        return;
    }
    
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Resizing bigger with no keyboard");
    
    // Get the keyboard's size
 //   NSDictionary* info = [notif userInfo];
 //   NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [aValue CGRectValue].size;
    
    // reset the height of the scroll view
    CGRect viewFrame = self.view.frame;
    
    //viewFrame.size.height += 5;
    
    // viewFrame.size.height += keyboardSize.height;
    
    scrollView.frame = viewFrame;
    keyboardVisible = NO;
    
}

- (void) initIOUManager{
    
    //Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	date_label.text = [NSString stringWithFormat:@"%@",
                  [df stringFromDate:[NSDate date]]];
	[df release];
    
        
	// Initialization code
	date_picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 480, 325, 230)];
	date_picker.datePickerMode = UIDatePickerModeDate;
	//date_picker.hidden = YES;
	date_picker.date = [NSDate date];
	[date_picker addTarget:self
                    action:@selector(displayRepaymentDate:)
          forControlEvents:UIControlEventValueChanged];
	//[self.view addSubview:date_picker];   
    
//    NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    //cur.text = [currencyFormatter currencySymbol]; 
    
    display_numberFake.text = [currencyFormatter currencySymbol]; 
    
    
    [currencyFormatter release];
//    [currencyFormatter stringFromNumber:someAmount];
//    cur.text = [cur.text stringByReplacingOccurrencesOfString:@"0" withString:@""];
//    cur.text = [cur.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    previewImage = NO;
    
}

// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the 
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
				 didFinishWithResult:(MessageComposeResult)result {
	
    NSMutableString *status = [[NSMutableString alloc] init];
    
    switch (result)
	{
		case MessageComposeResultCancelled:
            [status setString:[NSString stringWithFormat:@"Texting Cancelled"]];
			break;
		case MessageComposeResultSent:
            [status setString:[NSString stringWithFormat:@"Finished Texting"]];
			break;
		case MessageComposeResultFailed:
            [status setString:[NSString stringWithFormat:@"Texting Failed"]];
			break;
		default:
            [status setString:[NSString stringWithFormat:@"Texting Abort"]];
			break;
	}
    
    IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
    display.type = NotificationDisplayTypeText;
    [display setNotificationText:status];
    [display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
    [display release];
    
    [status release];
    
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) sendThis: (id) sender
{
    UIActionSheet *option;  
    
    if ([MFMessageComposeViewController canSendText]){  
        
        option = [[UIActionSheet alloc] initWithTitle:@"Share Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"SMS", @"Email", @"Facebook", @"Twitter", nil];
    }
    else{
        option = [[UIActionSheet alloc] initWithTitle:@"Share Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email", @"Facebook", @"Twitter", nil];
    }
    
    [option showInView:self.view];
    [option release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{ 
    
    if([actionSheet.title isEqualToString:@"Share Options"] == YES)
	{
        
        if ([MFMessageComposeViewController canSendText]){  

            // shuffle puzzle
            if(buttonIndex == 0)
            {
                [self sendSMS];
            }
            else if(buttonIndex == 1)
            {
                [self emailNow:nil];
            }
            else if(buttonIndex == 2)        
            {
                [self pushFacebookPost];
            }
            else if(buttonIndex == 3)        
            {
                [self pushTwitterPost];
            } 
        }
        else{
            // shuffle puzzle
            if(buttonIndex == 0)
            {
                [self emailNow:nil];
            }
            else if(buttonIndex == 1)        
            {
                [self pushFacebookPost];
            }
            else if(buttonIndex == 2)        
            {
                [self pushTwitterPost];
            }
        }
    }
    else if([actionSheet.title isEqualToString:@"Attach Media To Email / Facebook"] == YES)
	{
		// media option
        switch (buttonIndex) {
            case 0:
                [self pushVoiceRecorder];
                break;
            case 1:
                [self pushPhotoPage];
                break;
            default:
                break;
        }
        
    }
    else if([actionSheet.title isEqualToString:@"Remove Voice Memo"] == YES)
	{
		// media option
        switch (buttonIndex) {
            case 0:
                [self delRec:nil];
                break;
            case 1:
            default:
                break;
        }
        
    }
    else if([actionSheet.title isEqualToString:@"Remove Photo"] == YES)
	{
		// media option
        switch (buttonIndex) {
            case 0:
                //photo.image = nil;
                [sharedUserInfo setUserPhoto:nil];
                photoIcon.hidden = YES;
                break;
            case 1:
            default:
                break;
        }
        
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    date_picker.frame = CGRectMake(0, 480, date_picker.frame.size.width, date_picker.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)personType:(id)sender
{
    [self displayOutgoingMsg];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    date_picker.frame = CGRectMake(0, 480, date_picker.frame.size.width, date_picker.frame.size.height);
    [UIView commitAnimations];
    
    if (numPad.frame.origin.y < 480) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        numPad.frame = CGRectMake(0, 480, numPad.frame.size.width, numPad.frame.size.height);
        [UIView commitAnimations];
        
        step = 0;
        lastOp = -1;
        
//        if (![display_number.text isEqualToString:@""]) {
//            NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:display_number.text];
//            
//            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//            [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//            
//            display_number.text = [currencyFormatter stringFromNumber:someAmount];
//            display_number.text = [display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""];
//        }
        

        [self displayOutgoingMsg];
    }
}

- (void) displayOutgoingMsg{
    
    NSString *curValue;
    if (![display_number.text isEqualToString:@""]) {
        NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:display_number.text];
        
        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        curValue = [currencyFormatter stringFromNumber:someAmount];
       // curValue = [curValue stringByReplacingOccurrencesOfString:cur.text withString:@""];
        
        display_numberFake.text = curValue;
        [currencyFormatter release];
    }
    else
    {    
        curValue = @"";
        display_numberFake.text = curValue;
    }
        
    
    
    if (person_type_seg.selectedSegmentIndex == 0) {
        // user is a lender
        // outgoing message
        outgoing_message.text = [NSString stringWithFormat:@"%@, I owe you %@.\nRepayment Date: %@", [other_person_name.text isEqualToString:@""] ? @"[xxx]" : other_person_name.text, curValue, date_label.text];        
    }
    else{
        // user is a borrower
        // outgoing message
        outgoing_message.text = [NSString stringWithFormat:@"%@, you owe me %@.\nRepayment Date: %@", [other_person_name.text isEqualToString:@""] ? @"[xxx]" : other_person_name.text, curValue, date_label.text]; 
    }
      
}



- (IBAction) pushDateButton: (id) sender{
    
    // don't display date picker if image is previewing
    if (previewImage)
        return;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    numPad.frame = CGRectMake(0, 480, numPad.frame.size.width, numPad.frame.size.height);
   
    [UIView commitAnimations];
    
    step = 0;
    lastOp = -1;
    
//    if (![display_number.text isEqualToString:@""]) {
//        NSDecimalNumber *someAmount = [NSDecimalNumber decimalNumberWithString:display_number.text];
//        
//        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
//        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//        
//        display_number.text = [currencyFormatter stringFromNumber:someAmount];
//        display_number.text = [display_number.text stringByReplacingOccurrencesOfString:cur.text withString:@""];
//    }

    [self displayOutgoingMsg];
    
    if (date_picker.frame.origin.y >= 480) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        date_picker.frame = CGRectMake(0, 245, date_picker.frame.size.width, date_picker.frame.size.height);
        [UIView commitAnimations];
        
        [other_person_name resignFirstResponder];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        date_picker.frame = CGRectMake(0, 480, date_picker.frame.size.width, date_picker.frame.size.height);
        [UIView commitAnimations];
    }
    
    
//	if (date_picker.hidden)
//        date_picker.hidden = NO;
//    else
//        date_picker.hidden = YES;
  
}

- (void) displayRepaymentDate:(id)sender{
	//Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	date_label.text = [NSString stringWithFormat:@"%@",
                  [df stringFromDate:date_picker.date]];
	[df release]; 
    
    [self displayOutgoingMsg];
}

- (IBAction) pushHideDatePicker: (id) sender{
//    if (!date_picker.hidden)
//        date_picker.hidden = YES;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    date_picker.frame = CGRectMake(0, 480, date_picker.frame.size.width, date_picker.frame.size.height);
    [UIView commitAnimations];
}

- (void)pushFacebookPost{
    if (![self validateUserInputs])
        return;
    
    PostOnFacebookVC * postVC;
    //UIImageView *tmpImgView = [imageView.subviews objectAtIndex:0];
    postVC = [[PostOnFacebookVC alloc] initWithNibName:@"PostOnFacebookVC" bundle:nil];
    postVC.msgToPost = [NSString stringWithFormat:@"%@",outgoing_message.text];
    
    //if ([sharedUserInfo userPhoto] != nil){
    //    postVC.imageToPost.image = [sharedUserInfo userPhoto];
    //}
    
    //postVC.imageToPost = photo; // tmpImgView;
    //photo.image = nil;
    [self.navigationController pushViewController:postVC animated:YES];
    [postVC release];    
}

- (void)pushTwitterPost{
    
    if (![self validateUserInputs])
        return;
    
    PostOnTwitter * postTwitterVC;
    postTwitterVC = [[PostOnTwitter alloc] initWithNibName:@"PostOnTwitter" bundle:nil];
    postTwitterVC.msgToPost = [NSString stringWithFormat:@"%@",outgoing_message.text];
    //postVC.imageToPost = imageView;
    [self.navigationController pushViewController:postTwitterVC animated:YES];
    [postTwitterVC release];    
    
}

- (void)pushPhotoPage{
    PhotoController * photoVC;
    photoVC = [[PhotoController alloc] initWithNibName:@"PhotoController" bundle:nil];
    [self.navigationController pushViewController:photoVC animated:YES];
    [photoVC release];
}

- (void)pushVoiceRecorder{
    voiceRecorder * voiceRecVC;
    voiceRecVC = [[voiceRecorder alloc] initWithNibName:@"voiceRecorder" bundle:nil];
    [self.navigationController pushViewController:voiceRecVC animated:YES];
    [voiceRecVC release];    
}

@end

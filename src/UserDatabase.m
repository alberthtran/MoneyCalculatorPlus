//
//  UserDatabase.m
//  pocketCalc
//
//  Created by Albert Tran on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserDatabase.h"
#import "ConstantValues.h"

static UserDatabase *sharedUserDatabase = nil;

@implementation UserDatabase

@synthesize deal_records,restaurant_records,item_price,item_discount_rate,each_person_amount,iou_records,default_sale_tax,shopping_receipt_records,item_name,store_name,store_location,one_receipt;//,ctrl_for_Audio;

@synthesize userPhoto,gotRecordedMemo,showItouchWarning;

- (void)dealloc
{
    if (DEBUG_MODE_ENABLE)
        NSLog(@"inside UserDatabase dealloc");
    
    [deal_records release];
    [iou_records release];
    [restaurant_records release];
    [item_price release];
    [item_discount_rate release];
    [each_person_amount release];

    [shopping_receipt_records release];
    [one_receipt release];

    [item_name release];
    [store_name release];
    [store_location release];
    
    [userPhoto release];
    
    [super dealloc];
}


// init funciton to initial variables in the constructor level
- (id) init {
  //  if (DEBUG_MODE_ENABLE)
    //    NSLog(@"Inside userDatabase init");

    if ( self = [super init] )
    {
        item_price = [[NSMutableString alloc] init];
        
        item_discount_rate = [[NSMutableString alloc] init];
        
        item_name = [[NSMutableString alloc] init];
        store_name = [[NSMutableString alloc] init];
        store_location = [[NSMutableString alloc] init];
        
        each_person_amount = [[NSMutableString alloc] init];
        
        deal_records = [[NSMutableArray alloc] init];
        restaurant_records = [[NSMutableArray alloc] init];
        iou_records = [[NSMutableArray alloc] init];
        
        shopping_receipt_records = [[NSMutableArray alloc] init];
        
        one_receipt = [[NSMutableArray alloc] init];
        
        //ctrl_for_Audio = NULL; // set it to null  --- this is used strictly for audio feature
        
       // userPhoto = [[UIImage alloc] init];  ---- HERE
        userPhoto = nil;
        
        gotRecordedMemo = NO;
        
        showItouchWarning = YES;
        
        // read data from property list
        [self readUserDataFromPlist];
    }

    return self;
}

- (void) readUserDataFromPlist {
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Inside readUserDataFromPlist");
    
    NSError *error = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    
    NSString *p = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",PLIST_FILENAME]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:p]){
        NSString *bundle = [[NSBundle mainBundle] pathForResource:PLIST_FILENAME ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:p error:&error];
    }
 
    if (DEBUG_MODE_ENABLE)
        NSLog(@"%@",p);
    
    NSMutableArray* tmpArray = [[NSMutableArray alloc] initWithContentsOfFile:p];

    // Store the Deal & Restaurant Records
    for (int i=0;i<[tmpArray count];i++){
        if ([[[tmpArray objectAtIndex:i] objectForKey:NAME_KEY] isEqualToString:DEAL_TAG]) {
            [deal_records addObject:[tmpArray objectAtIndex:i]];
        }
        
        if ([[[tmpArray objectAtIndex:i] objectForKey:NAME_KEY] isEqualToString:RESTAURANT_TAG]) {
            [restaurant_records addObject:[tmpArray objectAtIndex:i]];
        }        
        
        if ([[[tmpArray objectAtIndex:i] objectForKey:NAME_KEY] isEqualToString:IOU_TAG]) {
            [iou_records addObject:[tmpArray objectAtIndex:i]];
        } 

        
        // store the default sale tax
        if ([[[tmpArray objectAtIndex:i] objectForKey:NAME_KEY] isEqualToString:DEFAULT_SALE_TAX_TAG]){
            default_sale_tax = [[[tmpArray objectAtIndex:i] objectForKey:DEFAULT_SALE_TAX_KEY] floatValue];
            //[default_sale_tax 
            if (DEBUG_MODE_ENABLE){
                NSLog(@"Just retrieved default sale tax");
                NSLog(@"%@",[[tmpArray objectAtIndex:i] objectForKey:DEFAULT_SALE_TAX_KEY]);
            }
        } 

        if ([[[tmpArray objectAtIndex:i] objectForKey:NAME_KEY] isEqualToString:SHOPPING_RECEIPT_TAG]) {
            [shopping_receipt_records addObject:[tmpArray objectAtIndex:i]];
        } 
        
    }
    
    if (DEBUG_MODE_ENABLE){
        for (int i=0;i<[deal_records count];i++){
            NSLog(@"%@",[deal_records objectAtIndex:i]);
        }

        for (int i=0;i<[restaurant_records count];i++){
            NSLog(@"%@",[restaurant_records objectAtIndex:i]);
        }
        
        for (int i=0;i<[iou_records count];i++){
            NSLog(@"%@",[iou_records objectAtIndex:i]);
        }
        
        for (int i=0;i<[shopping_receipt_records count];i++){
            NSLog(@"%@",[shopping_receipt_records objectAtIndex:i]);
        }
    }

    [tmpArray release];

}

- (void) saveUserDataToPlist {
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Inside saveUserDataToPlist");

    NSError *error = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    
    NSString *p = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",PLIST_FILENAME]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:p]){
        NSString *bundle = [[NSBundle mainBundle] pathForResource:PLIST_FILENAME ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:p error:&error];
    }

    // store default sale tax into a dictionary
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    [mutableDictionary setObject:[NSNumber numberWithFloat:default_sale_tax] forKey:DEFAULT_SALE_TAX_KEY];
    [mutableDictionary setObject:DEFAULT_SALE_TAX_TAG forKey:NAME_KEY];
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    
    // store all records into temp array
    [tmpArray addObjectsFromArray:deal_records];
    [tmpArray addObjectsFromArray:restaurant_records];
    [tmpArray addObjectsFromArray:iou_records];
    [tmpArray addObject:mutableDictionary];
    [tmpArray addObjectsFromArray:shopping_receipt_records];
    
    if (DEBUG_MODE_ENABLE)
        NSLog(@"Saving Property List using NSPropertyListSerialization");
    
    NSData *xmlData = [NSPropertyListSerialization dataFromPropertyList:tmpArray format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    
    if (DEBUG_MODE_ENABLE)
        NSLog(@"PATH = %@",p);
    
    [xmlData writeToFile:p atomically:YES];

    [tmpArray release];
    
}

+ (UserDatabase*)shared {
    @synchronized (sharedUserDatabase)
    {
        // the instance of this class is stored here
        //static UserDatabase *sharedUserDatabase = nil;
    
        // check to see if an instance already exists
        if (!sharedUserDatabase) {
            sharedUserDatabase = [[self alloc] init];
        }
    }
	return sharedUserDatabase;
    
}

@end

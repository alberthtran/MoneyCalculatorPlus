//
//  UserDatabase.h
//  pocketCalc
//
//  Created by Albert Tran on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDatabase : NSObject {
    // Here are the shared user's information
    // deal feedback dictionary
    NSMutableArray* deal_records;
    NSMutableArray* restaurant_records;
    NSMutableArray* iou_records;
    NSMutableArray* shopping_receipt_records;
    
    // restaurant experience dictionary
    NSMutableString* item_price;
    NSMutableString* item_discount_rate;
    NSMutableString* item_name;
    NSMutableString* store_location;
    NSMutableString* store_name;
    
    NSMutableString* each_person_amount;
    
    float default_sale_tax;
    
    NSMutableArray* one_receipt;

    UIImage *userPhoto;
    bool gotRecordedMemo;
    
    bool showItouchWarning;
    
}

@property (nonatomic,retain) NSMutableArray* deal_records;
@property (nonatomic,retain) NSMutableArray* restaurant_records;
@property (nonatomic,retain) NSMutableArray* iou_records;
@property (nonatomic,retain) NSMutableString* item_price;
@property (nonatomic,retain) NSMutableString* item_discount_rate;
@property (nonatomic,retain) NSMutableString* each_person_amount;
@property (nonatomic,readwrite) float default_sale_tax;

@property (nonatomic,retain) NSMutableString* item_name;
@property (nonatomic,retain) NSMutableString* store_location;
@property (nonatomic,retain) NSMutableString* store_name;

@property (nonatomic,retain) NSMutableArray* shopping_receipt_records;
@property (nonatomic,retain) NSMutableArray* one_receipt;

//@property (nonatomic,readwrite) int* ctrl_for_Audio;

@property (nonatomic,retain) UIImage *userPhoto;
@property (nonatomic,readwrite) bool gotRecordedMemo;

@property (nonatomic,readwrite) bool showItouchWarning;

// method to load and read the user information from the Property List File
- (void) readUserDataFromPlist;

// method to store user data back into Property List File
- (void) saveUserDataToPlist;

// Singleton or an instance
+ (UserDatabase*) shared;

@end

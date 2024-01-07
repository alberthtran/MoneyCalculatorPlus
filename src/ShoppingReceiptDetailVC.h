//
//  ShoppingReceiptDetailVC.h
//  pocketCalc
//
//  Created by Albert Tran on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingReceiptDetailVC : UIViewController{
    NSMutableString *itemDetail;
    IBOutlet UITextView *itemInfo;
}

@property (nonatomic,retain) UITextView *itemInfo;
@property (nonatomic,retain) NSMutableString *itemDetail;

@end

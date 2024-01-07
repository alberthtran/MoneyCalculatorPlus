//
//  pocketCalcAppDelegate.h
//  pocketCalc
//
//  Created by Albert Tran on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDatabase.h"
#import "Calculator.h"

@class pocketCalcViewController;

@interface pocketCalcAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    // Calculator Object
    Calculator* calc_obj;
    
    // User Database
    UserDatabase *sharedUserInfo;
    
    UINavigationController *navCntlr;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet pocketCalcViewController *viewController;

@end

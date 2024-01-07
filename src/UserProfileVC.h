//
//  UserProfileVC.h
//  pocketCalc
//
//  Created by Albert Tran on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDatabase.h"

/* for sound recording */
//#import "pocketCalcViewController.h"

@interface UserProfileVC : UIViewController{
    UITableView *tableView;
    UIImageView *imageView;
    
    UserDatabase *sharedUserInfo;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;


@end

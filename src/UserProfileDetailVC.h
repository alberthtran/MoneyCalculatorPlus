//
//  UserProfileDetailVC.h
//  pocketCalc
//
//  Created by Albert Tran on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDatabase.h"
#import "ConstantValues.h"

@interface UserProfileDetailVC : UIViewController {
    UserDatabase *sharedUserInfo;
    enum UserProfileRecord userProfileRecord;
    
    UITableView *tableView;
    UIImageView *imageView;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@property (nonatomic,readwrite) enum UserProfileRecord userProfileRecord;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated; 

@end

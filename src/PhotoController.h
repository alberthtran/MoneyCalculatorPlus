//
//  PhotoController.h
//  pocketCalc
//
//  Created by Albert Tran on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDatabase.h"

@interface PhotoController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImageView *imageView;
    UIButton *choosePhotoBtn;
    UIButton *takePhotoBtn;
    bool takenPhoto;
    
    UserDatabase *sharedUserInfo;
}

@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property (nonatomic,retain) IBOutlet UIButton *choosePhotoBtn;
@property (nonatomic,retain) IBOutlet UIButton *takePhotoBtn;

- (IBAction) getPhoto:(id)sender;

@end

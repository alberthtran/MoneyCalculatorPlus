//
//  PostOnFacebookVC.h
//  pocketCalc
//
//  Created by Albert Tran on 10/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBFeedPost.h"
#import "IFNNotificationDisplay.h"
#import "ConstantValues.h"
#import "UserDatabase.h"

@interface PostOnFacebookVC : UIViewController <FBFeedPostDelegate>{
    NSMutableString *msgToPost;
    UIImageView *imageToPost;
    
    IBOutlet UITextView *userMsg_textView;
    IBOutlet UIImageView *imageView;
    
    IBOutlet UIScrollView* scrollView;
    
    BOOL keyboardVisible;
    
    UserDatabase *sharedUserInfo;
}

@property (nonatomic,retain) NSMutableString *msgToPost;
@property (nonatomic,retain) UIImageView *imageToPost;

@property (nonatomic,retain) UITextView *userMsg_textView;
@property (nonatomic,retain) UIImageView *imageView;

- (IBAction) btnPostPress:(id) sender;
- (IBAction) keyboardDidShow: (NSNotification*)notif;
- (IBAction) keyboardDidHide: (NSNotification*)notif;

- (void) postMsg;
- (void) postMsgWithPhoto;

@end

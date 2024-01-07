//
//  PostOnTwitter.h
//  pocketCalc
//
//  Created by Albert Tran on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"

#import "IFNNotificationDisplay.h"
#import "ConstantValues.h"

@class SA_OAuthTwitterEngine;

@interface PostOnTwitter : UIViewController
<UITextFieldDelegate, SA_OAuthTwitterControllerDelegate>
{ 
    NSMutableString *msgToPost;
    
    IBOutlet UITextView *userMsg_textView;    
	IBOutlet UITextField *tweetTextField;
    
    SA_OAuthTwitterEngine *_engine;
	
}

@property(nonatomic, retain) IBOutlet UITextField *tweetTextField;

@property (nonatomic,retain) NSMutableString *msgToPost;

@property (nonatomic,retain) UITextView *userMsg_textView;

- (IBAction) btnPostPress:(id) sender;

- (void) postMsg;

-(IBAction)updateTwitter:(id)sender; 


@end

//
//  ShoppingReceiptVC.h
//  pocketCalc
//
//  Created by Albert Tran on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "UserDatabase.h"
#import "voiceRecorder.h"
#import "PhotoController.h"
#import "UserDatabase.h"


@interface ShoppingReceiptVC : UIViewController
<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

    UserDatabase *sharedUserInfo;
    
    UITableView *tableView;
    UIImageView *imageViewForReceipt;
    
    NSMutableDictionary* storeInfo;
    NSMutableString *receiptDetail;
    NSMutableString *receiptSummary;
    
    float total_after_tax;
    float total_savings;
    NSMutableString *itemDetail;

    IBOutlet UIButton *sharethis;
    IBOutlet UIButton *photoIcon;
    IBOutlet UIButton *voiceIcon;
   	//UIImageView * photo;
    //bool takenPhoto;

}

@property (nonatomic,retain) UIButton *photoIcon;
@property (nonatomic,retain) UIButton *voiceIcon;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewForReceipt;

@property (nonatomic, retain) NSMutableDictionary* storeInfo;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;  
- (void)computeExpense;
- (void)displayTotal;
- (void)generateItemDetail:(int)itemNum;
- (void)generateReceiptDetail;

- (IBAction) useMedia: (id) sender;

- (IBAction)sendSMS;
- (IBAction) shareThis: (id) sender;

-(IBAction) delVoice: (id) sender;
-(IBAction) delPic: (id) sender;
- (void)pushFacebookPost;
- (void)pushTwitterPost;
- (void)pushPhotoPage;
- (void)pushVoiceRecorder;
@end

//
//  ShoppingReceiptDetailVC.m
//  pocketCalc
//
//  Created by Albert Tran on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ShoppingReceiptDetailVC.h"
#import "ConstantValues.h"

@implementation ShoppingReceiptDetailVC

@synthesize itemInfo,itemDetail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    self.title = @"Item Detail";
    itemInfo.text = itemDetail;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:HISTORY_BACKGROUND_IMG]]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    [itemDetail release];
    [itemInfo release];
    [super dealloc];
}

@end

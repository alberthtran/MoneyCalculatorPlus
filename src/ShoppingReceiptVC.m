//
//  ShoppingReceiptVC.m
//  pocketCalc
//
//  Created by Albert Tran on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ShoppingReceiptVC.h"
#import "ShoppingReceiptDetailVC.h"
#import "ConstantValues.h"
#import "PostOnFacebookVC.h"
#import "PostOnTwitter.h"

@implementation ShoppingReceiptVC

@synthesize imageViewForReceipt,tableView,storeInfo;

@synthesize photoIcon,voiceIcon;

- (void)delRec:(id)sender
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success = [fileManager fileExistsAtPath:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]];
    
    if(success)
    {
        [fileManager removeItemAtPath:(NSString *)[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER] error:nil];  
        voiceIcon.hidden = YES;
        [sharedUserInfo setGotRecordedMemo:NO];
    }
}
-(IBAction) delVoice: (id) sender
{
    UIActionSheet *option;
    option = [[UIActionSheet alloc] initWithTitle:@"Remove Voice Memo" delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
    [option showInView:self.view];
    [option release];
}
-(IBAction) delPic: (id) sender
{
    UIActionSheet *option;
    option = [[UIActionSheet alloc] initWithTitle:@"Remove Photo" delegate:self cancelButtonTitle:@"NO" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
    [option showInView:self.view];
    [option release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    // get the reference of the user database
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction) useMedia: (id) sender
{
    UIActionSheet *option;
    option = [[UIActionSheet alloc] initWithTitle:@"Attach Media To Email / Facebook" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Record Voice (Email)", @"Photo",nil];  
   
    [option showInView:self.view];
    [option release];
    
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

	//
	// Change the properties of the imageViewForReceipt and tableView (these could be set
	// in interface builder instead).
	//
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.rowHeight = 70;
	tableView.backgroundColor = [UIColor clearColor];
	imageViewForReceipt.image = [UIImage imageNamed:@"receiptBackground.png"];
	
    /*  make gradient affective
     UIImage *backgroundImage = [UIImage imageNamed:@"gradientBackground.png"]; 
     UIImageView *background = [[[UIImageView alloc ]initWithImage:backgroundImage] autorelease]; 
     [tableView.superview insertSubview:background belowSubview:tableView]; 
     */
    
	//
	//
	// Create a header view. Wrap it in a container to allow us to position
	// it better.
	//
	UIView *containerView =
    [[[UIView alloc]
      initWithFrame:CGRectMake(0, 0, 300, 100)]
     autorelease];
	UILabel *headerLabel =
    [[[UILabel alloc]
      initWithFrame:CGRectMake(0, 0, 300, 40)]
     autorelease];
    
	headerLabel.text = [storeInfo objectForKey:STORE_NAME_KEY];  
	headerLabel.textColor = [UIColor blueColor];
	headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = [UIFont boldSystemFontOfSize:30]; 
    headerLabel.textAlignment = UITextAlignmentCenter;
    
	headerLabel.backgroundColor = [UIColor clearColor];
	[containerView addSubview:headerLabel];
    
    UILabel *headerLabel2 =
    [[[UILabel alloc]
      initWithFrame:CGRectMake(0, 30, 300, 40)]
     autorelease];
    
    headerLabel2.text = [storeInfo objectForKey:STORE_LOCATION_KEY];
    
    headerLabel2.textColor = [UIColor whiteColor];
	headerLabel2.shadowColor = [UIColor blackColor];
	headerLabel2.shadowOffset = CGSizeMake(0, 1);
	headerLabel2.font = [UIFont boldSystemFontOfSize:22];
	headerLabel2.backgroundColor = [UIColor clearColor];
    headerLabel2.textAlignment = UITextAlignmentCenter;
    [containerView addSubview:headerLabel2];
    
    NSDate *myDate = [storeInfo objectForKey:PURCHASED_DATE_KEY];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:DISPLAY_DATE_FORMAT];
    
    UILabel *headerLabel3 =
    [[[UILabel alloc]
      initWithFrame:CGRectMake(0, 50, 300, 40)]
     autorelease];
    
    headerLabel3.text = [df stringFromDate:myDate];
    
    headerLabel3.textColor = [UIColor whiteColor];
	headerLabel3.shadowColor = [UIColor blackColor];
	headerLabel3.shadowOffset = CGSizeMake(0, 1);
	headerLabel3.font = [UIFont boldSystemFontOfSize:14];
	headerLabel3.backgroundColor = [UIColor clearColor];
    headerLabel3.textAlignment = UITextAlignmentCenter;
    [containerView addSubview:headerLabel3];
    [df release];
    
    [self displayTotal];
    
	self.tableView.tableHeaderView = containerView;
    
    if ([sharedUserInfo userPhoto] != nil){
        //photo.image = [sharedUserInfo userPhoto];
        photoIcon.hidden = NO;
    }
    else
        photoIcon.hidden = YES;
    
    if ([sharedUserInfo gotRecordedMemo]){
        voiceIcon.hidden = NO;
    }
    else
        voiceIcon.hidden = YES;
    
}

- (void)viewDidLoad
{
    
    sharedUserInfo = [UserDatabase shared];

    itemDetail = [[NSMutableString alloc] init];
    receiptDetail = [[NSMutableString alloc] init];
    receiptSummary = [[NSMutableString alloc] init];
    
    self.title = @"Receipt";
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setEditing:NO animated:YES];
    /*
    NSLog(@"one receipt count = %d",[[sharedUserInfo one_receipt] count]);
    
    for (int i=0;i<[[sharedUserInfo one_receipt] count];i++){
        NSLog(@"%@",[[sharedUserInfo one_receipt] objectAtIndex:i]);
    }
    */
    
    // Remove previous audio and photo icon
    if ([sharedUserInfo gotRecordedMemo]){
        [sharedUserInfo setGotRecordedMemo:NO];
        voiceIcon.hidden = YES;
    }
    
    if ([sharedUserInfo userPhoto] != nil){
        [sharedUserInfo setUserPhoto:nil];
        photoIcon.hidden = YES;
    }
    
    [super viewDidLoad];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

//
// tableView:numberOfRowsInSection:
//
// Returns the number of rows in a given section.
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[sharedUserInfo one_receipt] count];
}

//
// tableView:cellForRowAtIndexPath:
//
// Returns the cell for a given indexPath.
//
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	const NSInteger TOP_LABEL_TAG = 1001;
	const NSInteger BOTTOM_LABEL_TAG = 1002;
	UILabel *topLabel;
	UILabel *bottomLabel;
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
	{
		//
		// Create the cell.
		//
        
		cell =
        [[[UITableViewCell alloc]
          initWithFrame:CGRectZero
          reuseIdentifier:CellIdentifier]
         autorelease];
        
		UIImage *indicatorImage = [UIImage imageNamed:@"receipt_indicator.png"];
		cell.accessoryView =
        [[[UIImageView alloc]
          initWithImage:indicatorImage]
         autorelease];
		
		const CGFloat LABEL_HEIGHT = 20;
		//UIImage *image = [UIImage imageNamed:@"imageA.png"];
        
		//
		// Create the label for the top row of text
		//
        /*
		topLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     image.size.width + 2.0 * cell.indentationWidth,
                     0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT),
                     aTableView.bounds.size.width -
                     image.size.width - 4.0 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
         */
        
        topLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     10,
                     0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT),
                     aTableView.bounds.size.width -
                     4.0 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
        
		[cell.contentView addSubview:topLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		topLabel.tag = TOP_LABEL_TAG;
		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		//topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
        topLabel.highlightedTextColor = [UIColor blueColor];
		topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
		//
		// Create the label for the top row of text
		//
        /*
		bottomLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     image.size.width + 2.0 * cell.indentationWidth,
                     0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT) + LABEL_HEIGHT,
                     aTableView.bounds.size.width -
                     image.size.width - 4.0 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
         */
        
        bottomLabel =
        [[[UILabel alloc]
          initWithFrame:
          CGRectMake(
                     10,
                     0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT) + LABEL_HEIGHT,
                     aTableView.bounds.size.width -
                     4.0 * cell.indentationWidth
                     - indicatorImage.size.width,
                     LABEL_HEIGHT)]
         autorelease];
		[cell.contentView addSubview:bottomLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		bottomLabel.tag = BOTTOM_LABEL_TAG;
		bottomLabel.backgroundColor = [UIColor clearColor];
		bottomLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		//bottomLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
        bottomLabel.highlightedTextColor = [UIColor blueColor];
		bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];
        
		//
		// Create a background image view.
		//
		cell.backgroundView =
        [[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView =
        [[[UIImageView alloc] init] autorelease];
	}
	else
	{
		topLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
		bottomLabel = (UILabel *)[cell viewWithTag:BOTTOM_LABEL_TAG];
	}

    topLabel.text = [NSString stringWithFormat:@"%d. %@   %@", [indexPath row]+1,                 
                     [[[sharedUserInfo one_receipt] objectAtIndex:indexPath.row] objectForKey:PURCHASED_ITEM_KEY],
                     [[[sharedUserInfo one_receipt] objectAtIndex:indexPath.row] objectForKey:ITEM_PRICE_KEY]];
    
	bottomLabel.text = [NSString stringWithFormat:@"%@Savings = %@",(([indexPath row]+1) < 10) ? @"     " : @"       ", 
                        [[[sharedUserInfo one_receipt] objectAtIndex:indexPath.row] objectForKey:ITEM_SAVINGS_KEY]];
    
	//
	// Set the background and selected background images for the text.
	// Since we will round the corners at the top and bottom of sections, we
	// need to conditionally choose the images based on the row index and the
	// number of rows in the section.
	//
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger sectionRows = [aTableView numberOfRowsInSection:[indexPath section]];
	NSInteger row = [indexPath row];
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"receiptTopBottom2.png"]; // topAndBottomRow.png
		selectionBackground = [UIImage imageNamed:@"receiptTopBottom2Sel.png"]; //topAndBottomRowSelected.png
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"receiptTop2.png"]; //topRow.png
		selectionBackground = [UIImage imageNamed:@"receiptTop2Sel.png"]; //topRowSelected.png
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"receiptBottom2.png"]; //bottomRow.png
		selectionBackground = [UIImage imageNamed:@"receiptBottom2Sel.png"]; //bottomRowSelected.png
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"receiptMid2.png"];//middleRow.png
		selectionBackground = [UIImage imageNamed:@"receiptMid2Sel.png"]; //middleRowSelected.png
	}
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
    
	return cell;
}

//
// dealloc
//
// Releases instance memory.
//
- (void)dealloc
{
    [photoIcon release];
    [voiceIcon release];
    
	[tableView release];
	[imageViewForReceipt release];
    [storeInfo release];
    [itemDetail release];
    [receiptDetail release];
    [receiptSummary release];

    [sharethis release];
    
	[super dealloc];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated { 
    [super setEditing:editing animated:animated]; 
    [self.tableView setEditing:editing animated:animated]; 
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView2 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [[sharedUserInfo one_receipt] removeObjectAtIndex:indexPath.row];
        
        [tableView2 deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self displayTotal];
        [self.tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get the item info
    [self generateItemDetail:indexPath.row];
    
    // Navigation logic may go here. Create and push another view controller.
    
    ShoppingReceiptDetailVC * shoppingReceiptDetailVC;
    
    shoppingReceiptDetailVC = [[ShoppingReceiptDetailVC alloc] initWithNibName:@"ShoppingReceiptDetailVC" bundle:nil];
    shoppingReceiptDetailVC.itemDetail = itemDetail;
    [self.navigationController pushViewController:shoppingReceiptDetailVC animated:YES];
    [shoppingReceiptDetailVC release];
    
}

- (void)computeExpense{
    NSMutableString *tempVal = [[NSMutableString alloc] init ];
    
    total_savings = 0.0;
    total_after_tax = 0.0;
    
    for (int i=0;i<[[sharedUserInfo one_receipt] count];i++){
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY] isEqualToString:@"$0"] && ![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY] isEqualToString:@"$0.00"]){
                                
                [tempVal setString:[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY]];
                if([tempVal hasPrefix:@"$"]) {
                    // remove the dollar sign
                    [tempVal replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];  
                }
                
                [tempVal replaceOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempVal length])];
                
                total_savings += [tempVal floatValue];
                
            }
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_TOTAL_AFTER_TAX_KEY] isEqualToString:@"$0"]){
                                
                [tempVal setString:[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_TOTAL_AFTER_TAX_KEY]];
                if([tempVal hasPrefix:@"$"]) {
                    // remove the dollar sign
                    [tempVal replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];  
                }
                
                [tempVal replaceOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempVal length])];
                
                total_after_tax += [tempVal floatValue];
                
            }
    }
     
    [tempVal release];
    
}

- (void)displayTotal{
    UIView *bottomContainerView =
    [[[UIView alloc]
      initWithFrame:CGRectMake(0, 0, 300, 80)]
     autorelease];
	UILabel *footerLabel =
    [[[UILabel alloc]
      initWithFrame:CGRectMake(0, 0, 300, 40)]
     autorelease];
	footerLabel.text = [NSString stringWithFormat:@"%d Purchased Item%@",[[sharedUserInfo one_receipt] count],([[sharedUserInfo one_receipt] count]) == 1 ? @"" : @"s"];
    
	footerLabel.textColor = [UIColor whiteColor];
	footerLabel.shadowColor = [UIColor blackColor];
	footerLabel.shadowOffset = CGSizeMake(0, 1);
	footerLabel.font = [UIFont boldSystemFontOfSize:18]; 
	footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.textAlignment = UITextAlignmentCenter;
	[bottomContainerView addSubview:footerLabel];
    
    // compute expense
    [self computeExpense];
    
    NSNumberFormatter *numFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numFormatter setNumberStyle: NSNumberFormatterCurrencyStyle ];
    [numFormatter setMinimumFractionDigits:2];
    
	UILabel *footerLabel2 =
    [[[UILabel alloc]
      initWithFrame:CGRectMake(0, 25, 300, 40)]
     autorelease];
    
    footerLabel2.text = [NSString stringWithFormat:@"Total Amount = %@",[numFormatter stringFromNumber:[NSNumber numberWithFloat:total_after_tax]]]; 
    
    if (total_after_tax <= 0)
        footerLabel2.textColor = [UIColor whiteColor];
    else
        footerLabel2.textColor = [UIColor purpleColor];
    
	footerLabel2.shadowColor = [UIColor blackColor];
	footerLabel2.shadowOffset = CGSizeMake(0, 1);
	footerLabel2.font = [UIFont boldSystemFontOfSize:18]; 
	footerLabel2.backgroundColor = [UIColor clearColor];
    footerLabel2.textAlignment = UITextAlignmentCenter;
	[bottomContainerView addSubview:footerLabel2];
    
    UILabel *footerLabel3 =
    [[[UILabel alloc]
      initWithFrame:CGRectMake(0, 50, 300, 40)]
     autorelease];
    
    footerLabel3.text = [NSString stringWithFormat:@"Total Savings = %@",[numFormatter stringFromNumber:[NSNumber numberWithFloat:total_savings]]];  
    
    if (total_savings <= 0)
        footerLabel3.textColor = [UIColor whiteColor];
    else
        footerLabel3.textColor = [UIColor redColor];
    
	footerLabel3.shadowColor = [UIColor blackColor];
	footerLabel3.shadowOffset = CGSizeMake(0, 1);
	footerLabel3.font = [UIFont boldSystemFontOfSize:18]; 
	footerLabel3.backgroundColor = [UIColor clearColor];
    footerLabel3.textAlignment = UITextAlignmentCenter;
	[bottomContainerView addSubview:footerLabel3];
    
    self.tableView.tableFooterView = bottomContainerView;
    
}

- (void)generateItemDetail:(int)itemNum{
    int i = itemNum;

    // clear the item Detail string
    [itemDetail setString:@""];
    
    if ([[[[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:NAME_KEY] isEqualToString:PURCHASE_ITEM_DETAIL_TAG]) {
            
        if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:PURCHASED_ITEM_KEY] isEqualToString:@""] &&
                ([ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:PURCHASED_ITEM_KEY] != NULL)){
                [itemDetail appendFormat:@"%@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:PURCHASED_ITEM_KEY]];
        }
        if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_PRICE_KEY] isEqualToString:@""])
            [itemDetail appendFormat:@"Original Price = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_PRICE_KEY]];
            
        if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_DISCOUNT_RATE_KEY] isEqualToString:@"0%"]){
                
            [itemDetail appendFormat:@"%@ OFF = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_DISCOUNT_RATE_KEY],
                 [ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_DISCOUNT_AMOUNT_KEY]];                
        }
            
        if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_COUPONS_AMOUNT_KEY] isEqualToString:@"0"]){
                
            [itemDetail appendFormat:@"Coupon = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_COUPONS_AMOUNT_KEY]];                
        }
            
        if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY] isEqualToString:@"$0"] && ![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY] isEqualToString:@"$0.00"]){
                
            [itemDetail appendFormat:@"Savings = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY]];  
        }
            
        if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SALE_TAX_PERCENT_KEY] isEqualToString:@"0%"]){
            [itemDetail appendFormat:@"%@ Tax = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SALE_TAX_PERCENT_KEY], [ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SALE_TAX_AMOUNT_KEY]];                 
        }
        
        if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_TOTAL_AFTER_TAX_KEY] isEqualToString:@"$0"]){
                
            [itemDetail appendFormat:@"Cost = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_TOTAL_AFTER_TAX_KEY]];      
        }
    }
    
    //NSLog(@"%@",itemDetail);
}

- (void)generateReceiptDetail{
    
    NSMutableString *tempVal = [[[NSMutableString alloc] init ] autorelease];
    
    total_savings = 0.0;
    total_after_tax = 0.0;
    
    // first clear the array
    [receiptDetail setString:@""];
    
    for (int i=0;i<[[sharedUserInfo one_receipt] count];i++){
        if ([[[[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:NAME_KEY] isEqualToString:PURCHASE_ITEM_DETAIL_TAG]) {
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:PURCHASED_ITEM_KEY] isEqualToString:@""] &&
                ([ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:PURCHASED_ITEM_KEY] != NULL)){
                [receiptDetail appendFormat:@"%d. %@",i+1,[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:PURCHASED_ITEM_KEY]];
            }
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_PRICE_KEY] isEqualToString:@""])
                [receiptDetail appendFormat:@"      %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_PRICE_KEY]];
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_DISCOUNT_RATE_KEY] isEqualToString:@"0%"]){
                
                [receiptDetail appendFormat:@"%@ OFF = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_DISCOUNT_RATE_KEY],
                 [ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_DISCOUNT_AMOUNT_KEY]];                
            }
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_COUPONS_AMOUNT_KEY] isEqualToString:@"0"]){
                
                [receiptDetail appendFormat:@"Coupon = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_COUPONS_AMOUNT_KEY]];                
            }
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY] isEqualToString:@"$0"] && ![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY] isEqualToString:@"$0.00"]){
                
                [receiptDetail appendFormat:@"Savings = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY]];  
                
                [tempVal setString:[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SAVINGS_KEY]];
                if([tempVal hasPrefix:@"$"]) {
                    // remove the dollar sign
                    [tempVal replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];  
                }
                
                [tempVal replaceOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempVal length])];
                
                total_savings += [tempVal floatValue];
                
            }
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SALE_TAX_PERCENT_KEY] isEqualToString:@"0%"]){
                [receiptDetail appendFormat:@"%@ Tax = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SALE_TAX_PERCENT_KEY], [ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_SALE_TAX_AMOUNT_KEY]];                 
            }
            
            if (![[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_TOTAL_AFTER_TAX_KEY] isEqualToString:@"$0"]){
                
                [receiptDetail appendFormat:@"Cost = %@\n",[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_TOTAL_AFTER_TAX_KEY]];      
                
                [tempVal setString:[ [[sharedUserInfo one_receipt] objectAtIndex:i] objectForKey:ITEM_TOTAL_AFTER_TAX_KEY]];
                if([tempVal hasPrefix:@"$"]) {
                    // remove the dollar sign
                    [tempVal replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];  
                }
                
                [tempVal replaceOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempVal length])];
                
                total_after_tax += [tempVal floatValue];
                
            }
            
            [receiptDetail appendFormat:@"%@\n",DISPLAY_ITEM_DIVIDER_LINE];
            
        }
    }

    NSNumberFormatter *numFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numFormatter setNumberStyle: NSNumberFormatterCurrencyStyle ];
    [numFormatter setMinimumFractionDigits:2];
    
    [receiptDetail appendFormat:@"%@\n",DISPLAY_RECEIPT_SUMMARY_LINE];
    [receiptDetail appendFormat:@"There %@ %d purchased item%@.\n",([[sharedUserInfo one_receipt] count]) == 1 ? @"is" : @"are",[[sharedUserInfo one_receipt] count],([[sharedUserInfo one_receipt] count]) == 1 ? @"" : @"s"];
    [receiptDetail appendFormat:@"Total Amount = %@\n",[numFormatter stringFromNumber:[NSNumber numberWithFloat:total_after_tax]]];
    [receiptDetail appendFormat:@"Total Savings = %@\n",[numFormatter stringFromNumber:[NSNumber numberWithFloat:total_savings]]];
    [receiptDetail appendFormat:@"%@\n",DISPLAY_ITEM_DIVIDER_LINE];

    NSDate *myDate = [storeInfo objectForKey:PURCHASED_DATE_KEY];
    NSDateFormatter *df = [[NSDateFormatter new] autorelease];
    [df setDateFormat:DISPLAY_DATE_FORMAT];
    
    // create receipt summary for facebook and twitter and sms
    [receiptSummary setString:[NSString stringWithFormat:@"On %@, I bought %d item%@ from %@ on %@. Total Amount: %@. Savings: %@",[df stringFromDate:myDate],[[sharedUserInfo one_receipt] count],([[sharedUserInfo one_receipt] count]) == 1 ? @"" : @"s",[storeInfo objectForKey:STORE_NAME_KEY],[storeInfo objectForKey:STORE_LOCATION_KEY],[numFormatter stringFromNumber:[NSNumber numberWithFloat:total_after_tax]],[numFormatter stringFromNumber:[NSNumber numberWithFloat:total_savings]]]]; 
    
    //[tempVal release];
    
}

- (IBAction)sendSMS {
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    [self generateReceiptDetail];
    
    if([MFMessageComposeViewController canSendText])
	{
        controller.body = [NSString stringWithFormat:@"%@\n\n%via Money Calculator +\nhttp://ezfunapps.com/get.php",receiptSummary]; 
        
		controller.recipients = [NSArray arrayWithObjects:nil];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
	}	
    
    [controller release];
    
}

- (void) emailNow: (id) sender{
    
    if(![MFMailComposeViewController canSendMail])
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your device are not configured to send email" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return;
    }
 
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    NSDate *myDate = [storeInfo objectForKey:PURCHASED_DATE_KEY];
    NSDateFormatter *df = [[NSDateFormatter new] autorelease];
    [df setDateFormat:DISPLAY_DATE_FORMAT];
    
    [self generateReceiptDetail];

    mailComposer.mailComposeDelegate = self;
    
    [mailComposer setSubject:SHOPPING_RECEIPT_SUBJECT];
    //UIImage *pic = [UIImage imageNamed:@"picture.jpg"];
    //NSData *imageData = UIImageJPEGRepresentation(pic, 1);
    //[picker addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"picture.jpg"];
    
    //    UIImageView *tmpImgView = [imageView.subviews objectAtIndex:0];
    
    
    //    if (tmpImgView.image != nil) {
    if ([sharedUserInfo userPhoto] != nil){
        [mailComposer addAttachmentData:UIImageJPEGRepresentation([sharedUserInfo userPhoto], 1) mimeType:@"image/jpg" fileName:@"picture.jpg"];
    }
    
    if ([sharedUserInfo gotRecordedMemo]){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL success = [fileManager fileExistsAtPath:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]]; 
        
        if (success) {
            [mailComposer addAttachmentData:[NSData dataWithContentsOfFile:[NSString stringWithFormat: @"%@/memo.aif", DOCSFOLDER]] mimeType:@"audio/aif" fileName:@"voicememo.aif"];
        }        
    }
    
    NSString* emailBody = [NSString stringWithFormat:@"Store Name: %@\nStore Location: %@\nPurchase Date: %@\n%@\n%@\n\n%via Money Calculator +\nhttp://ezfunapps.com/get.php",[storeInfo objectForKey:STORE_NAME_KEY],[storeInfo objectForKey:STORE_LOCATION_KEY],[df stringFromDate:myDate],DISPLAY_ITEM_DIVIDER_LINE,receiptDetail];
    
    [mailComposer setMessageBody:emailBody isHTML:NO];
    [self presentModalViewController:mailComposer animated:YES];
    
    [mailComposer release];    
    //[emailBody release];
}


-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    NSMutableString *status = [[NSMutableString alloc] init];
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [status setString:[NSString stringWithFormat:@"Email Cancelled"]];
            break;
        case MFMailComposeResultSaved:
            [status setString:[NSString stringWithFormat:@"Email Saved"]];
            break;
        case MFMailComposeResultSent:
            [status setString:[NSString stringWithFormat:@"Email Sent"]];
            break;
        case MFMailComposeResultFailed:
            [status setString:[NSString stringWithFormat:@"Email Failed"]];
            break;
        default:
            [status setString:[NSString stringWithFormat:@"Email Abort"]];
            break;
    }
    
    IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
    display.type = NotificationDisplayTypeText;
    [display setNotificationText:status];
    [display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
    [display release];
    
    [status release];
    
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction) shareThis: (id) sender
{
    UIActionSheet *option;  
    
    if ([MFMessageComposeViewController canSendText]){  
        
        option = [[UIActionSheet alloc] initWithTitle:@"Share Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"SMS", @"Email", @"Facebook", @"Twitter", nil];
    }
    else{
        option = [[UIActionSheet alloc] initWithTitle:@"Share Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email", @"Facebook", @"Twitter", nil];
    }
    [option showInView:self.view];
    [option release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([actionSheet.title isEqualToString:@"Share Options"] == YES)
	{
        if ([MFMessageComposeViewController canSendText]){  
            
            // shuffle puzzle
            if(buttonIndex == 0)
            {
                [self sendSMS];
            }
            else if(buttonIndex == 1)
            {
                [self emailNow:nil];
            }
            else if(buttonIndex == 2)        
            {
                [self pushFacebookPost];
            }
            else if(buttonIndex == 3)        
            {
                [self pushTwitterPost];
            } 
        }
        else{
            // shuffle puzzle
            if(buttonIndex == 0)
            {
                [self emailNow:nil];
            }
            else if(buttonIndex == 1)        
            {
                [self pushFacebookPost];
            }
            else if(buttonIndex == 2)        
            {
                [self pushTwitterPost];
            }
        }        
    }
    if([actionSheet.title isEqualToString:@"Attach Media To Email / Facebook"] == YES)
	{
		// media option
        switch (buttonIndex) {
            case 0:
                [self pushVoiceRecorder];
                break;
            case 1:
                [self pushPhotoPage];
                break;
            default:
                break;
        }

        
    }
    else if([actionSheet.title isEqualToString:@"Remove Voice Memo"] == YES)
	{
		// media option
        switch (buttonIndex) {
            case 0:
                [self delRec:nil];
                break;
            case 1:
            default:
                break;
        }
        
    }
    else if([actionSheet.title isEqualToString:@"Remove Photo"] == YES)
	{
		// media option
        switch (buttonIndex) {
            case 0:
                [sharedUserInfo setUserPhoto:nil];
                photoIcon.hidden = YES;
                break;
            case 1:
            default:
                break;
        }
        
    }

}

// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the 
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
				 didFinishWithResult:(MessageComposeResult)result {
	
    NSMutableString *status = [[NSMutableString alloc] init];
    
    switch (result)
	{
		case MessageComposeResultCancelled:
            [status setString:[NSString stringWithFormat:@"Texting Cancelled"]];
			break;
		case MessageComposeResultSent:
            [status setString:[NSString stringWithFormat:@"Finished Texting"]];
			break;
		case MessageComposeResultFailed:
            [status setString:[NSString stringWithFormat:@"Texting Failed"]];
			break;
		default:
            [status setString:[NSString stringWithFormat:@"Texting Abort"]];
			break;
	}
    
    IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
    display.type = NotificationDisplayTypeText;
    [display setNotificationText:status];
    [display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
    [display release];
    
    [status release];
    
	[self dismissModalViewControllerAnimated:YES];
}

- (void)pushFacebookPost{
    
    PostOnFacebookVC * postVC;
    [self generateReceiptDetail];
    
    postVC = [[PostOnFacebookVC alloc] initWithNibName:@"PostOnFacebookVC" bundle:nil];
    
    postVC.msgToPost = [NSString stringWithFormat:@"%@",receiptSummary];    
    [self.navigationController pushViewController:postVC animated:YES];
    [postVC release];    
}

- (void)pushTwitterPost{
    PostOnTwitter * postTwitterVC;

    [self generateReceiptDetail];

    postTwitterVC = [[PostOnTwitter alloc] initWithNibName:@"PostOnTwitter" bundle:nil];

    postTwitterVC.msgToPost = [NSString stringWithFormat:@"%@",receiptSummary];
    
    [self.navigationController pushViewController:postTwitterVC animated:YES];
    [postTwitterVC release];    
    
}

- (void)pushPhotoPage{
    PhotoController * photoVC;
    photoVC = [[PhotoController alloc] initWithNibName:@"PhotoController" bundle:nil];
    [self.navigationController pushViewController:photoVC animated:YES];
    [photoVC release];
}

- (void)pushVoiceRecorder{
    voiceRecorder * voiceRecVC;
    voiceRecVC = [[voiceRecorder alloc] initWithNibName:@"voiceRecorder" bundle:nil];
    [self.navigationController pushViewController:voiceRecVC animated:YES];
    [voiceRecVC release];    
}

@end

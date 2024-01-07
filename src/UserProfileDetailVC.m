//
//  UserProfileDetailVC.m
//  pocketCalc
//
//  Created by Albert Tran on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UserProfileDetailVC.h"
#import "ConstantValues.h"
#import "DealHistory.h"
#import "RestaurantHistory.h"
#import "IOUHistory.h"
#import "ShoppingReceiptHistory.h"

@implementation UserProfileDetailVC

@synthesize imageView,tableView,userProfileRecord;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    sharedUserInfo = [UserDatabase shared];
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

	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.rowHeight = 50;
	tableView.backgroundColor = [UIColor clearColor];
	imageView.image = [UIImage imageNamed:@"gradientBackground.png"];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    switch (userProfileRecord) {
        case IOU_RECORDS_PROFILE:
            self.title = @"IOU";
            break;
        case DEAL_RECORDS_PROFILE:
            self.title = @"Deal";
            break;
        case RESTAURANT_RECORDS_PROFILE:
            self.title = @"Restaurant";
            break;
        case SHOPPING_RECEIPT_RECORDS_PROFILE:
            self.title = @"Receipt";
            break;
        default:
            self.title = nil;
            break;
    }
    
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setEditing:NO animated:YES];

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated { 
    [super setEditing:editing animated:animated]; 
    [self.tableView setEditing:editing animated:animated]; 
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (userProfileRecord) {
        case IOU_RECORDS_PROFILE:
            if (DEBUG_MODE_ENABLE)
                NSLog(@"IOU numRow = %d",[[sharedUserInfo iou_records] count]);
            
            return [[sharedUserInfo iou_records] count];
        case DEAL_RECORDS_PROFILE:
            if (DEBUG_MODE_ENABLE)
                NSLog(@"deal numRow = %d",[[sharedUserInfo deal_records] count]);
            
            return [[sharedUserInfo deal_records] count];
        case RESTAURANT_RECORDS_PROFILE:
            if (DEBUG_MODE_ENABLE)
                NSLog(@"restaurant numRow = %d",[[sharedUserInfo restaurant_records] count]);
            
            return [[sharedUserInfo restaurant_records] count]; 
        case SHOPPING_RECEIPT_RECORDS_PROFILE:
            if (DEBUG_MODE_ENABLE)
                NSLog(@"shopping numRow = %d",[[sharedUserInfo shopping_receipt_records] count]);
            
            return [[sharedUserInfo shopping_receipt_records] count];
        default:
            return 0;
	}
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
        
		UIImage *indicatorImage = [UIImage imageNamed:@"profile_indicator.png"];
		cell.accessoryView =
        [[[UIImageView alloc]
          initWithImage:indicatorImage]
         autorelease];
		
		const CGFloat LABEL_HEIGHT = 20;

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
        topLabel.textAlignment = UITextAlignmentCenter;
		[cell.contentView addSubview:topLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		topLabel.tag = TOP_LABEL_TAG;
		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];

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
        bottomLabel.textAlignment = UITextAlignmentCenter;
		[cell.contentView addSubview:bottomLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		bottomLabel.tag = BOTTOM_LABEL_TAG;
		bottomLabel.backgroundColor = [UIColor clearColor];
		bottomLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		bottomLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
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
    
    // Configure the cell...
    NSDateFormatter *df = [[NSDateFormatter new] autorelease];
    [df setDateFormat:DISPLAY_DATE_FORMAT];
    
    switch (userProfileRecord){
        case IOU_RECORDS_PROFILE:
            
            topLabel.text = [NSString stringWithFormat:@"%@", 
             [[[sharedUserInfo iou_records] objectAtIndex:indexPath.row] objectForKey:BORROWER_NAME_KEY]];
            bottomLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[[[sharedUserInfo iou_records] objectAtIndex:indexPath.row] objectForKey:PURCHASED_DATE_KEY]]];
            break;
            
        case DEAL_RECORDS_PROFILE:
            topLabel.text = [NSString stringWithFormat:@"%@",[[[sharedUserInfo deal_records] objectAtIndex:indexPath.row] objectForKey:PURCHASED_ITEM_KEY]]; 
            bottomLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[[[sharedUserInfo deal_records] objectAtIndex:indexPath.row] objectForKey:PURCHASED_DATE_KEY]]];
            break;
        case RESTAURANT_RECORDS_PROFILE:
            topLabel.text = [NSString stringWithFormat:@"%@",[[[sharedUserInfo restaurant_records] objectAtIndex:indexPath.row] objectForKey:RESTAURANT_NAME_KEY]];       
            bottomLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[[[sharedUserInfo restaurant_records] objectAtIndex:indexPath.row] objectForKey:PURCHASED_DATE_KEY]]];
            break;
            
        case SHOPPING_RECEIPT_RECORDS_PROFILE:
            topLabel.text = [NSString stringWithFormat:@"%@",[[[sharedUserInfo shopping_receipt_records] objectAtIndex:indexPath.row] objectForKey:STORE_NAME_KEY]];
            bottomLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[[[sharedUserInfo shopping_receipt_records] objectAtIndex:indexPath.row] objectForKey:PURCHASED_DATE_KEY]]];
                      
            break;
        default:
            topLabel.text = nil;
            break;
    }
    
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
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"]; // topAndBottomRow.png
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"]; //topAndBottomRowSelected.png
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"topRow.png"]; //topRow.png
		selectionBackground = [UIImage imageNamed:@"topRowSelected.png"]; //topRowSelected.png
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"bottomRow.png"]; //bottomRow.png
		selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"]; //bottomRowSelected.png
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"middleRow.png"];//middleRow.png
		selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"]; //middleRowSelected.png
	}
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
    
	return cell;
}

- (void)dealloc
{
	[tableView release];
	[imageView release];
    
	[super dealloc];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView2 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        switch (userProfileRecord) {
            case IOU_RECORDS_PROFILE:
                [[sharedUserInfo iou_records] removeObjectAtIndex:indexPath.row];
                break;
            case DEAL_RECORDS_PROFILE:
                [[sharedUserInfo deal_records] removeObjectAtIndex:indexPath.row];
                break;        
            case RESTAURANT_RECORDS_PROFILE:
                [[sharedUserInfo restaurant_records] removeObjectAtIndex:indexPath.row];
                break; 
            case SHOPPING_RECEIPT_RECORDS_PROFILE:
                [[sharedUserInfo shopping_receipt_records] removeObjectAtIndex:indexPath.row];
                break; 
            default:
                break;
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    DealHistory *dealHistoryVC;
    RestaurantHistory *restaurantHistoryVC;
    IOUHistory * iouHistoryVC;
    ShoppingReceiptHistory *receiptVC;
    
    switch (userProfileRecord) {
        case IOU_RECORDS_PROFILE:
            
            iouHistoryVC = [[IOUHistory alloc] initWithNibName:@"IOUHistory" bundle:nil];
            iouHistoryVC.iou_record = [[sharedUserInfo iou_records] objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:iouHistoryVC animated:YES];
            [iouHistoryVC release];
            break;
            
        case DEAL_RECORDS_PROFILE:
            dealHistoryVC = [[DealHistory alloc] initWithNibName:@"DealHistory" bundle:nil];
            dealHistoryVC.deal_record = [[sharedUserInfo deal_records] objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:dealHistoryVC animated:YES];
            [dealHistoryVC release];
            break;
        case RESTAURANT_RECORDS_PROFILE:
            restaurantHistoryVC = [[RestaurantHistory alloc] initWithNibName:@"RestaurantHistory" bundle:nil];
            restaurantHistoryVC.restaurant_record = [[sharedUserInfo restaurant_records] objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:restaurantHistoryVC animated:YES];
            //[RestaurantHistory release]; 
            [restaurantHistoryVC release];
            break;
        case SHOPPING_RECEIPT_RECORDS_PROFILE:
            receiptVC = [[ShoppingReceiptHistory alloc] initWithNibName:@"ShoppingReceiptHistory" bundle:nil];
            receiptVC.receipt = [[sharedUserInfo shopping_receipt_records] objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:receiptVC animated:YES];
            //[ShoppingReceiptHistory release];  
            [receiptVC release];
            break;
        default:
            break;
    }
}

@end

//
//  UserProfileVC.m
//  pocketCalc
//
//  Created by Albert Tran on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UserProfileVC.h"
#import "ConstantValues.h"

#import "UserProfileDetailVC.h"

@implementation UserProfileVC

@synthesize imageView,tableView;

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
    
    sharedUserInfo = [UserDatabase shared];
    
	//
	// Change the properties of the imageView and tableView (these could be set
	// in interface builder instead).
	//
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.rowHeight = 100;
	tableView.backgroundColor = [UIColor clearColor];
	imageView.image = [UIImage imageNamed:@"gradientBackground.png"];
    
    [self.tableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = USER_PROFILE_TITLE;
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return TOTAL_NUM_USER_PROFILE_RECORD_CNT;
    
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
		UIImage *image = [UIImage imageNamed:@"IOUButton.png"];
        
		//
		// Create the label for the top row of text
		//
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
        
		//
		// Create the label for the top row of text
		//
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
    switch (indexPath.row) {
        case IOU_RECORDS_PROFILE:
            topLabel.text = IOU_TAG;
            bottomLabel.text = [NSString stringWithFormat:@"%d IOU Records", 
                             [[sharedUserInfo iou_records] count]];
            cell.imageView.image = [UIImage imageNamed:@"IOUButton.png"];
            break;
        case DEAL_RECORDS_PROFILE:
            topLabel.text = DEAL_TAG;
            bottomLabel.text = [NSString stringWithFormat:@"%d Deal Records", 
                             [[sharedUserInfo deal_records] count]];
            cell.imageView.image = [UIImage imageNamed:@"LikeItButton.png"];
            break;
        case RESTAURANT_RECORDS_PROFILE:
            topLabel.text = RESTAURANT_TAG;
            bottomLabel.text = [NSString stringWithFormat:@"%d Feedback Records", 
                             [[sharedUserInfo restaurant_records] count]];
            cell.imageView.image = [UIImage imageNamed:@"LikeItButton.png"];
            break;
        case SHOPPING_RECEIPT_RECORDS_PROFILE:
            topLabel.text = SHOPPING_RECEIPT_TAG;
            bottomLabel.text = [NSString stringWithFormat:@"%d Receipt Records", 
                             [[sharedUserInfo shopping_receipt_records] count]];
            cell.imageView.image = [UIImage imageNamed:@"taxButton.png"];
            break;
        default:
            topLabel.text = nil;
            bottomLabel.text = nil;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    UserProfileDetailVC *userProfileDetailVC;
    
    //userProfileDetailVC = [[UserProfileDetailVC alloc] initWithNibName:@"UserProfileDetailVC" bundle:nil PVC:myBoss];
    
    userProfileDetailVC = [[UserProfileDetailVC alloc] initWithNibName:@"UserProfileDetailVC" bundle:nil ];
    
    userProfileDetailVC.userProfileRecord = IOU_RECORDS_PROFILE;
    
    switch (indexPath.row) {
        case IOU_RECORDS_PROFILE:
            userProfileDetailVC.userProfileRecord = IOU_RECORDS_PROFILE;
            break;
        case DEAL_RECORDS_PROFILE:
            userProfileDetailVC.userProfileRecord = DEAL_RECORDS_PROFILE;
            break;
        case RESTAURANT_RECORDS_PROFILE:
            userProfileDetailVC.userProfileRecord = RESTAURANT_RECORDS_PROFILE;
            break;
        case SHOPPING_RECEIPT_RECORDS_PROFILE:
            userProfileDetailVC.userProfileRecord = SHOPPING_RECEIPT_RECORDS_PROFILE;
            break;
        default:
            userProfileDetailVC.userProfileRecord = TOTAL_NUM_USER_PROFILE_RECORD_CNT;
            break;
    }
    
    [self.navigationController pushViewController:userProfileDetailVC animated:YES];
    [userProfileDetailVC release];
    
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

@end

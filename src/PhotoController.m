//
//  PhotoController.m
//  pocketCalc
//
//  Created by Albert Tran on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoController.h"
#import "ConstantValues.h"

@implementation PhotoController

@synthesize choosePhotoBtn,takePhotoBtn,imageView;

-(IBAction)getPhoto:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
	if((UIButton *) sender == choosePhotoBtn) {
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        takenPhoto = NO;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        takenPhoto = YES;
	}
	
    // Get the Core Graphics Reference to the Image
    //CGImageRef cgImage = [imageView.image CGImage];
    
    
	[self presentModalViewController:picker animated:YES]; 
    
    [picker release];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    
    // Unable to save the image  
    if (error)
    {   
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Photo not saved. Please try again" 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (takenPhoto){
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    }
    
    if (imageView.image == nil)
        NSLog(@"image is empty");
    else
        [sharedUserInfo setUserPhoto:imageView.image];
    
    //[sharedUserInfo setUserPhoto:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    
    //imageView.image = [sharedUserInfo userPhoto];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //photo.image = nil;
    [picker dismissModalViewControllerAnimated:YES];
    //[self emailNow:nil];
}

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

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        
    if ([sharedUserInfo userPhoto] != nil){
        imageView.image = [sharedUserInfo userPhoto];
    }
    else{
        imageView.image = nil;
    }

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gradientBackground.png"]]];  
    
    // if don't have camera available
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        choosePhotoBtn.hidden = NO;
        takePhotoBtn.hidden = NO;
        
    }
    else{
        takePhotoBtn.hidden = YES;
        choosePhotoBtn.center = CGPointMake(160.0, choosePhotoBtn.center.y);
    }
}

- (void)viewDidLoad
{
    // start the user database
    sharedUserInfo = [UserDatabase shared];
    
    self.title = @"Photo";
    
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

- (void) dealloc{
    [takePhotoBtn release];
    [choosePhotoBtn release];
    [imageView release];
    [super dealloc];
}
@end

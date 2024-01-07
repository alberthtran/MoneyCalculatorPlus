//
//  pocketCalcAppDelegate.m
//  pocketCalc
//
//  Created by Albert Tran on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "pocketCalcAppDelegate.h"

#import "pocketCalcViewController.h"

@implementation pocketCalcAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Rate Now"])
	{
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"rated"];
		NSString *reviewURL2 = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=481958167&onlyLatestVersion=false&type=Purple+Software";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL2]]; 
	}
    else if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"More Apps"])
	{
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"moreApps"];
        NSString *reviewURL2 = @"itms://search.itunes.apple.com/WebObjects/MZContentLink.woa/wa/link?path=ezfunapps";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL2]]; 
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    // start the user database
    sharedUserInfo = [UserDatabase shared];
    
    // Get the reference of the Calculator Instance and initialize the Tip Calc
    calc_obj = [Calculator calcInstance];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"rated"] == NULL) 
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"rated"];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"moreApps"] == NULL) 
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"moreApps"];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"moreAppCounter"] == NULL) 
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"moreAppCounter"];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"rateCounter"] == NULL) 
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"rateCounter"];
    // Override point for customization after application launch.
    navCntlr = [[UINavigationController alloc] initWithRootViewController:self.viewController];  
    
    [self.window addSubview:navCntlr.view];
    
    //self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    // save the data into plist
    [sharedUserInfo saveUserDataToPlist];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"rated"] == 0) {
        int count = [[NSUserDefaults standardUserDefaults] integerForKey:@"rateCounter"];
        if (count >= 4) {
            
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"rateCounter"];
            UIAlertView *ll = [[UIAlertView alloc] initWithTitle:@"Rate Money Calculator +" message:@"User ratings/reviews help us improve our apps. Please take a moment to rate Money Calculator +. Thank you." delegate:self cancelButtonTitle:@"Maybe Later" otherButtonTitles:@"Rate Now", nil];
            [ll show];
            [ll release];
        }
        else
        {
            count += 1;
            [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"rateCounter"];
        }
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"moreApps"] == 0) {
        int appcount = [[NSUserDefaults standardUserDefaults] integerForKey:@"moreAppCounter"];
        if (appcount >= 4) {
            
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"moreAppCounter"];
            UIAlertView *ll = [[UIAlertView alloc] initWithTitle:@"More EZ Fun Apps" message:@"Please take a moment to check out our other apps. Thank you." delegate:self cancelButtonTitle:@"Maybe Later" otherButtonTitles:@"More Apps", nil];
            [ll show];
            [ll release];
        }
        else
        {
            appcount += 1;
            [[NSUserDefaults standardUserDefaults] setInteger:appcount forKey:@"moreAppCounter"];
        }
        
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    // save the data into plist
    [sharedUserInfo saveUserDataToPlist];
    
    // release memory from the singleton objects
    [calc_obj dealloc];
    [sharedUserInfo dealloc];
    
}

- (void)dealloc
{
    [navCntlr release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end

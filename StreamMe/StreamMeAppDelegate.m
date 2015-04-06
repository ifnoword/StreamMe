//
//  StreamMeAppDelegate.m
//  StreamMe
//
//  Created by MEI C on 3/30/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import "StreamMeAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@implementation StreamMeAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyBgtnP3YYFRVqo9KknTtrlB-aHh2NcGlFo"];
    
    [Parse setApplicationId:@"s2HX5ukFVJ15PAnuR3yIFWfOJmqi1vS4kDsfkYUv"
                  clientKey:@"NJOhhkKr4Yz1a9way195EJw6H0cWfqcIXLrClzad"];
    //[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    if (![PFUser currentUser]) {
    
    UIViewController *rootViewController = [[[[self window] rootViewController] storyboard] instantiateViewControllerWithIdentifier:@"HomeView"];
    [[self window] setRootViewController:rootViewController];
    }
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"userInfoList"]){
        NSArray *userInfoList = [[NSArray alloc]init];
        [[NSUserDefaults standardUserDefaults] setObject:userInfoList forKey:@"userInfoList"];
    }
    
    /*check UserDefault about Login info
    jump to map view if already login*/
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

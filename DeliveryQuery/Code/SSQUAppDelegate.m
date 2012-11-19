//
//  SSQUAppDelegate.m
//  QueryUtilities
//
//  Created by 佳 刘 on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SSQUAppDelegate.h"

#import "SSQUViewController.h"
#import <RestKit/RestKit.h>
#import "SSQUMoreViewController.h"
#import "MobWinBannerView.h"

@interface SSQUAppDelegate()
@property (nonatomic, retain) MobWinBannerView *advBannerView;
@end
@implementation SSQUAppDelegate

@synthesize window = _window;
//@synthesize viewController = _viewController;
@synthesize rootViewController = _rootViewController;
@synthesize advBannerView = _advBannerView;
@synthesize navigationController = _navigationController;
@synthesize db = _db;

- (void)dealloc
{
    [self.advBannerView stopRequest];
    [self.advBannerView removeFromSuperview];
    self.advBannerView = nil;
    [_window release];
    self.navigationController = nil;
    self.rootViewController = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    SSQUViewController* mainViewController = [[SSQUViewController alloc] initWithNibName:@"SSQUViewController" bundle:nil] ;
    mainViewController.navigationItem.title = @"查快递";
    
    _navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    self.navigationController.view.frame = CGRectMake(self.navigationController.view.frame.origin.x, self.navigationController.view.frame.origin.y, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height - 25);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    UIButton * infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];

    UIBarButtonItem * infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    [infoButton addTarget:self action:@selector(infoBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    mainViewController.navigationItem.rightBarButtonItem = infoButtonItem ;
    
    [infoButtonItem release];
    [mainViewController release];
    
    _advBannerView = [[MobWinBannerView alloc] initMobWinBannerSizeIdentifier:MobWINBannerSizeIdentifier320x25];
    
    _rootViewController = [[UIViewController alloc] init];
    UIView * rootView = [[UIView alloc] initWithFrame:self.window.frame];
    _rootViewController.view = rootView;
    [rootView release];
    
    [self.rootViewController.view addSubview:self.navigationController.view];
    
	self.advBannerView.rootViewController = self.rootViewController;
	[self.advBannerView setAdUnitID:@"F2730496033B03EA0115BF9B992675B5"];
//    NSLog(@"advframe %f %f %f %f",self.advBannerView.frame.origin.x,self.advBannerView.frame.origin.y,self.advBannerView.frame.size.width,self.advBannerView.frame.size.height);
    self.advBannerView.frame = CGRectMake(self.rootViewController.view.frame.origin.x, self.rootViewController.view.frame.size.height-45, self.advBannerView.frame.size.width, 25);
//    NSLog(@"advframe %f %f %f %f",self.advBannerView.frame.origin.x,self.advBannerView.frame.origin.y,self.advBannerView.frame.size.width,self.advBannerView.frame.size.height);
//	[self.viewController.view addSubview:self.advBannerView];
    [self.rootViewController.view addSubview:self.advBannerView];
    self.advBannerView.adGpsMode = NO;
    [self.advBannerView startRequest];
    
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];

    [self initDB];
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

- (void)infoBtnPress{
    SSQUMoreViewController *moreViewController = [[SSQUMoreViewController alloc] initWithNibName:@"SSQUMoreViewController" bundle:nil];
    SET_GRAY_BG(moreViewController);
    moreViewController.navigationItem.title = @"更多";
    [self.navigationController pushViewController:moreViewController animated:YES];
    [moreViewController release];
}

- (void)initDB {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"mydb.sqlite"];
    
    NSLog(@"db path:%@",writableDBPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:writableDBPath]) {
        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:DBNAME ofType:@"sqlite" ] toPath:writableDBPath error:nil];
    }
    
    
    self.db = [FMDatabase databaseWithPath:writableDBPath];
}

@end

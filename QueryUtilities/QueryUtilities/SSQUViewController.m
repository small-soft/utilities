//
//  SSQUViewController.m
//  QueryUtilities
//
//  Created by 佳 刘 on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SSQUViewController.h"
#import "SSMenuItemView.h"
#import "SSMenuView.h"
#import "SSQUWeatherViewController.h"
@interface SSQUViewController()<SSMenuViewDelegate>
@property (nonatomic,retain) IBOutlet SSMenuView * menuView;
@property (nonatomic,retain) NSArray *menuTitle;
@end

@implementation SSQUViewController
@synthesize menuView = _menuView;
@synthesize menuTitle = _menuTitle;

-(NSArray *)menuTitle{
    if(nil==_menuTitle){
        _menuTitle = [[NSArray alloc] initWithObjects:@"天气",@"归属地",@"汇率", nil];
    }
        
    return _menuTitle;
}


#pragma mark - SSMenuViewDelegate Methods
-(void)menuView:(SSMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index{
    NSString * menuTileForIndex = [self.menuTitle objectAtIndex:index];
    if ([menuTileForIndex isEqualToString:@"天气"]) {
        SSQUWeatherViewController * weatherViewController = [[SSQUWeatherViewController alloc] initWithNibName:@"SSQUWeatherViewController" bundle:nil];
        weatherViewController.navigationItem.title = @"天气";
        [self.navigationController pushViewController:weatherViewController animated:YES];
        [weatherViewController release];
    }
}

-(NSUInteger)menuViewNumberOfItems:(SSMenuView*)menuView{
    return self.menuTitle.count;
}

-(SSMenuItemView*)menuView:(SSMenuView *)menuView ItemViewForRowAtIndex:(NSUInteger)index{
    SSMenuItemView * menuItemView = [[[SSMenuItemView alloc] init] autorelease];
    menuItemView.label.text = [self.menuTitle objectAtIndex:index];
    menuItemView.imageView.backgroundColor = [UIColor blueColor];
    return menuItemView;
}

#pragma mark - Life cycle

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

-(void)dealloc{
    self.menuView = nil;
    self.menuTitle = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.menuView.menuDelegate = self;
    self.menuView.topPadding = 10;
    [self.menuView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


@end

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
#import "SSQUExchangeRateViewController.h"
#import "SSQUTranslateViewController.h"
#import "SSQUMoreViewController.h"
#import "SSQUFontChangeViewController.h"
#import "SSQULocaleViewController.h"
@interface SSQUViewController()<SSMenuViewDelegate>
@property (nonatomic,retain) IBOutlet SSMenuView * menuView;
@property (nonatomic,retain) NSArray *menuTitle;
@end

@implementation SSQUViewController
@synthesize menuView = _menuView;
@synthesize menuTitle = _menuTitle;

-(NSArray *)menuTitle{
    if(nil==_menuTitle){
        _menuTitle = [[NSArray alloc] initWithObjects:@"汉译英",@"英译汉",@"简转繁",@"繁转简",@"手机归属地",@"ip归属地",@"天气",@"汇率",@"更多", nil];
    }
        
    return _menuTitle;
}


#pragma mark - SSMenuViewDelegate Methods
-(void)menuView:(SSMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index{
    NSString * menuTileForIndex = [self.menuTitle objectAtIndex:index];
    if ([menuTileForIndex isEqualToString:@"汉译英"]) {
        SSQUTranslateViewController * translateViewController = [[SSQUTranslateViewController alloc] initWithNibName:@"SSQUTranslateViewController" bundle:nil];
        translateViewController.navigationItem.title = @"翻译";
        translateViewController.selectIndex = 0;
        [self.navigationController pushViewController:translateViewController animated:YES];
        [translateViewController release];
    }else if ([menuTileForIndex isEqualToString:@"英译汉"]){
        SSQUTranslateViewController * translateViewController = [[SSQUTranslateViewController alloc] initWithNibName:@"SSQUTranslateViewController" bundle:nil];
        translateViewController.navigationItem.title = @"翻译";
        translateViewController.selectIndex = 1;
        [self.navigationController pushViewController:translateViewController animated:YES];
        [translateViewController release];
    }else if ([menuTileForIndex isEqualToString:@"简转繁"]){
        SSQUFontChangeViewController * fontChangeViewController = [[SSQUFontChangeViewController alloc] initWithNibName:@"SSQUFontChangeViewController" bundle:nil];
        fontChangeViewController.navigationItem.title = @"字体转换";
        fontChangeViewController.selectIndex = 0;
        [self.navigationController pushViewController:fontChangeViewController animated:YES];
        [fontChangeViewController release];
    }else if ([menuTileForIndex isEqualToString:@"繁转简"]){
        SSQUFontChangeViewController * fontChangeViewController = [[SSQUFontChangeViewController alloc] initWithNibName:@"SSQUFontChangeViewController" bundle:nil];
        fontChangeViewController.navigationItem.title = @"字体转换";
        fontChangeViewController.selectIndex = 1;
        [self.navigationController pushViewController:fontChangeViewController animated:YES];
        [fontChangeViewController release];
    }else if ([menuTileForIndex isEqualToString:@"手机归属地"]){
        SSQULocaleViewController * localeViewController = [[SSQULocaleViewController alloc] initWithNibName:@"SSQULocaleViewController" bundle:nil];
        localeViewController.navigationItem.title = @"归属地";
        localeViewController.selectIndex = 0;
        [self.navigationController pushViewController:localeViewController animated:YES];
        [localeViewController release];
    }else if ([menuTileForIndex isEqualToString:@"ip归属地"]){
        SSQULocaleViewController * localeViewController = [[SSQULocaleViewController alloc] initWithNibName:@"SSQULocaleViewController" bundle:nil];
        localeViewController.navigationItem.title = @"归属地";
        localeViewController.selectIndex = 1;
        [self.navigationController pushViewController:localeViewController animated:YES];
        [localeViewController release];
    }else if ([menuTileForIndex isEqualToString:@"天气"]) {
        SSQUWeatherViewController * weatherViewController = [[SSQUWeatherViewController alloc] initWithNibName:@"SSQUWeatherViewController" bundle:nil];
        weatherViewController.navigationItem.title = @"天气";
        [self.navigationController pushViewController:weatherViewController animated:YES];
        [weatherViewController release];
    }else if ([menuTileForIndex isEqualToString:@"汇率"]){
        SSQUExchangeRateViewController *exchangeRateViewController = [[SSQUExchangeRateViewController alloc] initWithNibName:@"SSQUExchangeRateViewController" bundle:nil];
        exchangeRateViewController.navigationItem.title = @"汇率";
        [self.navigationController pushViewController:exchangeRateViewController animated:YES];
        [exchangeRateViewController release];
    }else if ([menuTileForIndex isEqualToString:@"更多"]){
        SSQUMoreViewController *moreViewController = [[SSQUMoreViewController alloc] initWithNibName:@"SSQUMoreViewController" bundle:nil];
        moreViewController.navigationItem.title = @"更多";
        [self.navigationController pushViewController:moreViewController animated:YES];
        [moreViewController release];
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
    self.menuView.yPadding = 10;
    self.menuView.columnCount = 3;
    [self.menuView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


@end

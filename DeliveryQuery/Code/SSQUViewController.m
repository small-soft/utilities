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
#import "SSQUIDViewController.h"
#import "SSDQAllDeliveryCompanyListViewController.h"
#import "SSDQDeliveryQueryViewController.h"
#import "SSDQMyDeliveryViewController.h"

@interface SSQUViewController()<SSMenuViewDelegate>
@property (nonatomic,retain) IBOutlet SSMenuView * menuView;
@property (nonatomic,retain) NSArray *menuTitle;
@property (nonatomic,retain) NSArray *menuImage;
@end

@implementation SSQUViewController
@synthesize menuView = _menuView;
@synthesize menuTitle = _menuTitle;
@synthesize menuImage = _menuImage;

-(NSArray *)menuTitle{
    if(nil==_menuTitle){
        self.menuTitle = [[NSArray alloc] initWithObjects:@"快递追踪",@"我的快递",@"快递查询",@"常用快递",@"快递公司大全",@"寄快递", nil];
    }
        
    return _menuTitle;
}

-(NSArray *)menuImage{
    if(nil==_menuImage){
        self.menuImage = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"han"],[UIImage imageNamed:@"en"],[UIImage imageNamed:@"jian"],[UIImage imageNamed:@"fan"],[UIImage imageNamed:@"phone"],[UIImage imageNamed:@"ip"],[UIImage imageNamed:@"tianqi"],[UIImage imageNamed:@"huilv"],[UIImage imageNamed:@"id"], nil];
    }
    
    return _menuImage;
}

#pragma mark - SSMenuViewDelegate Methods
-(void)menuView:(SSMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index{
    NSString * menuTileForIndex = [self.menuTitle objectAtIndex:index];
    if ([menuTileForIndex isEqualToString:@"快递追踪"]) {
//        SSQUTranslateViewController * translateViewController = [[SSQUTranslateViewController alloc] init];
//        translateViewController.navigationItem.title = @"翻译";
//        translateViewController.selectIndex = 0;
//        SET_GRAY_BG(translateViewController);
//        [self.navigationController pushViewController:translateViewController animated:YES];
//        [translateViewController release];

        SSDQAllDeliveryCompanyListViewController * translateViewController = [[SSDQAllDeliveryCompanyListViewController alloc] init];
        translateViewController.navigationItem.title = @"快递追踪";
//        translateViewController.selectIndex = 0;
        SET_GRAY_BG(translateViewController);
        SET_AD_FRAME(translateViewController.view);
        [self.navigationController pushViewController:translateViewController animated:YES];
        [translateViewController release];
    }else if ([menuTileForIndex isEqualToString:@"我的快递"]){
        SSDQMyDeliveryViewController * translateViewController = [[SSDQMyDeliveryViewController alloc] init];
        translateViewController.navigationItem.title = @"我的快递";
//        translateViewController.selectIndex = 1;
        SET_GRAY_BG(translateViewController);
        [self.navigationController pushViewController:translateViewController animated:YES];
        [translateViewController release];
    }else if ([menuTileForIndex isEqualToString:@"快递查询"]){
        SSDQDeliveryQueryViewController * fontChangeViewController = [[SSDQDeliveryQueryViewController alloc] initWithNibName:@"SSDQDeliveryQueryViewController" bundle:nil];
        fontChangeViewController.navigationItem.title = @"快递查询";
//        fontChangeViewController.selectIndex = 0;
        SET_GRAY_BG(fontChangeViewController);
        [self.navigationController pushViewController:fontChangeViewController animated:YES];
        [fontChangeViewController release];
    }else if ([menuTileForIndex isEqualToString:@"常用快递"]){
        SSDQAllDeliveryCompanyListViewController * translateViewController = [[SSDQAllDeliveryCompanyListViewController alloc] init];
        translateViewController.navigationItem.title = @"常用快递";
        translateViewController.contentMode = DeliverCompanyListContentModeFavOnly;
        //        translateViewController.selectIndex = 0;
        SET_GRAY_BG(translateViewController);
        [self.navigationController pushViewController:translateViewController animated:YES];

    }else if ([menuTileForIndex isEqualToString:@"快递公司大全"]){
        SSDQAllDeliveryCompanyListViewController * translateViewController = [[SSDQAllDeliveryCompanyListViewController alloc] init];
        translateViewController.navigationItem.title = @"快递公司大全";
        SET_GRAY_BG(translateViewController);
        [self.navigationController pushViewController:translateViewController animated:YES];
        [translateViewController release];
    }else if ([menuTileForIndex isEqualToString:@"寄快递"]){
        SSQULocaleViewController * localeViewController = [[SSQULocaleViewController alloc] init];
        localeViewController.navigationItem.title = @"寄快递";
        localeViewController.selectIndex = 1;
        SET_GRAY_BG(localeViewController);
        [self.navigationController pushViewController:localeViewController animated:YES];
        [localeViewController release];
    }
}

-(NSUInteger)menuViewNumberOfItems:(SSMenuView*)menuView{
    return self.menuTitle.count;
}

-(SSMenuItemView*)menuView:(SSMenuView *)menuView ItemViewForRowAtIndex:(NSUInteger)index{
    SSMenuItemView * menuItemView = [[[SSMenuItemView alloc] init] autorelease];
    menuItemView.label.text = [self.menuTitle objectAtIndex:index];
    menuItemView.imageView.image = [self.menuImage objectAtIndex:index];
    menuItemView.maskImageView.frame = menuItemView.imageView.frame;
    menuItemView.maskImageView.image = [UIImage imageNamed:@"gray_mengban"];
    return menuItemView;
}

#pragma mark - Life cycle

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

-(void)dealloc{
    [self.menuView release];
    [self.menuTitle release];
    [self.menuImage release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.menuView.menuDelegate = self;
    self.menuView.topPadding = 11;
    self.menuView.yPadding = 22;
    self.menuView.columnCount = 3;
    SET_GRAY_BG(self);
    [self.menuView reloadData];
}

- (void)viewDidUnload
{
    self.menuView = nil;
    self.menuTitle = nil;
    self.menuImage = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


@end

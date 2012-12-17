//
//  SSTabBarViewController.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-6.
//
//

#import "SSTabBarViewController.h"
//#import "AMLogiticsViewController.h"
//#import "AMFavoritesViewController.h"
//#import "AMIMViewController.h"
//#import "AMAppCenterViewController.h"
//#import "LoginToken.h"
//#import "UIHelp.h"
//#import "AMIMHomeViewController.h"
//#import "NoticationItem.h"
//#import "CallBackTool.h"
//#import "AMIMUserDefault.h"
//#import "AMIMDefaultStorageHelper.h"
//#import "LoginToken.h"
#import "SSTabBarItem.h"
//#import "AliNavigationViewController.h"
//#import "AESCrypto.h"
//#import "AliSearchViewController.h"
#import "SSToastView.h"
//#import "AMHomeDressViewController.h"
//#import "AMHomeFurnitureViewController.h"
//#import "AMHomeIndustryViewController.h"
//#import "AMHomeMaterialsViewController.h"
//#import "AMHomeProductViewController.h"
//#import "AMIndustrySelectHomeViewController.h"
//#import "AMBeginerNavigateViewControl.h"
//#import "UserDataUtils.h"
//#import "MessageCenterListViewController.h"
//#import "AMMessageCenterListViewController.h"
//#import "AMMessageCenterHelp.h"
#define SELECTED_VIEW_CONTROLLER_TAG 98456345
#define ITEMID_KEYWORD_NAME @"name"
#define ITEMID_KEYWORD_TITLE @"title"
#define ITEMID_KEYWORD_IMAGE @"image"
#define ITEMID_KEYWORD_FOCUSIMAGE @"focusImage"
#define ITEMID_KEYWORD_VIEWCONTROLLER @"viewController"
#define ITEMID_KEYWORD_VIEW @"view"

#define ITEMNAME_HOME @"home"
#define ITEMNAME_WW @"ww"
#define ITEMNAME_FAV @"fav"
#define ITEMNAME_SEARCH @"search"
#define ITEMNAME_APPCENTER @"appCenter"
#define ITEMNAME_LOGIN @"login"

#define TABBAR_IDX_HOME    0
#define TABBAR_IDX_SEARCH  1
#define TABBAR_IDX_FAV     2
#define TABBAR_IDX_APPCTR  3
#define TABBAR_IDX_WW      4

#define ALERT_IF_LOGIN_WANGWANG_TAG     99
#define ALERT_FORCEQUIT_WANGWANG_TAG    100
#define ALERT_NETWORKERROR_WANGWANG_TAG 101
#define ALERT_NETWORK_ERROR_TAG         102

@interface SSTabBarViewController() {
    BOOL isTimeout;
    BOOL loginHere;
    BOOL isLogining;
    
    BOOL isEnterWwAfterWwLogin;
}

-(void)hideTabBar:(id)sender;
-(void)unHideTabBar:(id)sender;

@property(nonatomic) NSUInteger lastSelectedIndex;

@property(nonatomic,retain)NSArray * tabBarItemsSource;
@property(nonatomic,retain)NSArray * tabBarHomeItemsSource;

@property (nonatomic)BOOL tabBatHidden;
@end


@implementation SSTabBarViewController

@synthesize aliTabBar = _aliTabBar;
@synthesize contentView = _contentView;
@synthesize tabBarItemArray = _tabBarItemArray;
@synthesize tabBarItemsSource = _tabBarItemsSource;
@synthesize tabBarHomeItemsSource = _tabBarHomeItemsSource;
@synthesize lastSelectedIndex = _lastSelectedIndex;
@synthesize tabBatHidden = _tabBatHidden;

-(void)setTabBatHidden:(BOOL)tabBatHidden
{
    if (_tabBatHidden != tabBatHidden) {
        
        //[UIView setAnimationDuration:2.0];
        //[UIView beginAnimations:@"scale" context:nil];
        
        if (tabBatHidden) {
            self.aliTabBar.alpha = 0.0f;
            self.contentView.frame =CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
        }
        else {
            self.aliTabBar.alpha = 1.0f;
            self.contentView.frame =CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-self.aliTabBar.frame.size.height + 5);
        }
        
        //[UIView commitAnimations];
        _tabBatHidden = tabBatHidden;
    }
}

-(void)initTabBarItemArray
{
    [self.tabBarItemArray removeAllObjects];
    for (NSDictionary*data in self.tabBarItemsSource) {
        NSString*name = [data objectForKey:ITEMID_KEYWORD_NAME];
        
        if ([name isEqualToString:ITEMNAME_HOME]||[name isEqualToString:ITEMNAME_SEARCH]||[name isEqualToString:ITEMNAME_FAV]||[name isEqualToString:ITEMNAME_APPCENTER]||[name isEqualToString:ITEMNAME_WW]) {
            [self.tabBarItemArray addObject:data];
        }
    }
}

-(NSMutableArray*)tabBarItemArray
{
    if (!_tabBarItemArray) {
        _tabBarItemArray = [[NSMutableArray alloc]init];
    }
    return  _tabBarItemArray;
}

- (void) replaceTabItem:(NSString *)sourceName withName:(NSString *)newName{
    NSMutableDictionary * newData;
    for (NSMutableDictionary * data in self.tabBarItemsSource) {
        NSString*keyword = [data objectForKey:ITEMID_KEYWORD_NAME];
        if ([keyword isEqualToString:newName]) {
            newData = data;
            break;
        }
    }
    
    NSUInteger count = [self.tabBarItemArray count];
    for (NSUInteger i=0; i<count; i++) {
        NSMutableDictionary*data = [self.tabBarItemArray objectAtIndex:i];
        NSString*keyword = [data objectForKey:ITEMID_KEYWORD_NAME];
        if ([keyword isEqualToString:sourceName]) {
            [self.tabBarItemArray replaceObjectAtIndex:i withObject:newData];
            break;
        }
    }
}

- (void) setHome
{
    int newIdx = 0;
//    newIdx = [UserDataUtils getSelectNumber] - 1;
    if (newIdx < 0 || newIdx >= [_tabBarHomeItemsSource count]) {
        return ;
    }
    
    NSMutableDictionary * newData = [_tabBarHomeItemsSource objectAtIndex:newIdx];
    [_tabBarItemArray replaceObjectAtIndex:0 withObject:newData];
    
    self.aliTabBar.reload = YES;
    self.aliTabBar.reloadItemContent = YES;
    [self.aliTabBar setNewSelectedItem : 0];
    
    // reload = YES 后需要把旺旺的图标刷新一次
    [self tabBarItemViewUnHighlighted:self.aliTabBar atIndex:TABBAR_IDX_WW];
}

-(NSArray*)tabBarItemsSource
{
    if (!_tabBarItemsSource) {
//        UIViewController *viewCtrSearch = [[AliSearchViewController alloc] initWithNibName:@"AliSearchViewController" bundle:nil];
//        UIViewController *viewCtrIm = [[AMIMHomeViewController alloc] init];
//        UIViewController *viewCtrFav = [[AMFavoritesViewController alloc] initWithNibName:@"AMFavoritesViewController_iPhone" bundle:nil] ;
//        UIViewController *viewCtrApp = [[AMAppCenterViewController alloc] initWithNibName:@"AMAppCenterViewController" bundle:nil] ;
//        UIViewController *viewCtrLogin = [[AMIMViewController alloc] initWithNibName:@"AMIMViewController_iPhone" bundle:nil] ;
//        AliNavigationViewController *search = [[AliNavigationViewController alloc]initWithRootViewController:viewCtrSearch] ;
//        AliNavigationViewController *im = [[AliNavigationViewController alloc]initWithRootViewController:viewCtrIm] ;
//        AliNavigationViewController *favorites = [[AliNavigationViewController alloc]initWithRootViewController:viewCtrFav] ;
//        AliNavigationViewController *app = [[AliNavigationViewController alloc]initWithRootViewController:viewCtrApp] ;
//        AliNavigationViewController *login = [[AliNavigationViewController alloc]initWithRootViewController:viewCtrLogin] ;
        
        /* for iOS 4.3 */
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
        {
//            search.delegate = self;
//            im.delegate = self;
//            favorites.delegate = self;
//            app.delegate = self;
//            login.delegate = self;
        }
        
        int homeIdx = 0;
//        int homeIdx = [UserDataUtils getSelectNumber] - 1;
//        if (homeIdx < 0 || homeIdx > 4) {
//            homeIdx = 0;
//        }
        
//        _tabBarItemsSource = [[NSArray arrayWithObjects:
//                               [self.tabBarHomeItemsSource objectAtIndex:homeIdx],
//                               [NSDictionary dictionaryWithObjectsAndKeys:ITEMNAME_SEARCH,ITEMID_KEYWORD_NAME,@"搜索", ITEMID_KEYWORD_TITLE,@"icon_toolbar_search_n.png", ITEMID_KEYWORD_IMAGE,  @"icon_toolbar_search_p.png",ITEMID_KEYWORD_FOCUSIMAGE, search, ITEMID_KEYWORD_VIEWCONTROLLER,[AliTabItemView createView],ITEMID_KEYWORD_VIEW , nil],
//                               [NSDictionary dictionaryWithObjectsAndKeys:ITEMNAME_FAV,ITEMID_KEYWORD_NAME,@"收藏夹", ITEMID_KEYWORD_TITLE,@"icon_toolbar_fav.png", ITEMID_KEYWORD_IMAGE,  @"icon_toolbar_fav_p",ITEMID_KEYWORD_FOCUSIMAGE, favorites, ITEMID_KEYWORD_VIEWCONTROLLER,[AliTabItemView createView],ITEMID_KEYWORD_VIEW , nil],
//                               [NSDictionary dictionaryWithObjectsAndKeys:ITEMNAME_APPCENTER,ITEMID_KEYWORD_NAME,@"工具", ITEMID_KEYWORD_TITLE,@"icon_toolbar_tool.png", ITEMID_KEYWORD_IMAGE,  @"icon_toolbar_tool_p",ITEMID_KEYWORD_FOCUSIMAGE, app, ITEMID_KEYWORD_VIEWCONTROLLER, [AliTabItemView createView],ITEMID_KEYWORD_VIEW ,nil],
//                               [NSDictionary dictionaryWithObjectsAndKeys:ITEMNAME_WW,ITEMID_KEYWORD_NAME,@"旺旺", ITEMID_KEYWORD_TITLE,@"icon_toolbar_ww_dis.png", ITEMID_KEYWORD_IMAGE,  @"icon_toolbar_ww",ITEMID_KEYWORD_FOCUSIMAGE, im, ITEMID_KEYWORD_VIEWCONTROLLER,[AliTabItemView createView],ITEMID_KEYWORD_VIEW , nil],
//                               [NSDictionary dictionaryWithObjectsAndKeys:ITEMNAME_LOGIN,ITEMID_KEYWORD_NAME,@"登录", ITEMID_KEYWORD_TITLE, login, ITEMID_KEYWORD_VIEWCONTROLLER,nil],
//                               nil] retain];
        
        //        [viewCtrSearch release];
        //        [viewCtrFav release];
        //        [viewCtrApp release];
        //        [viewCtrLogin release];
        //        [viewCtrIm release];
        
//        [search release];
//        [im release];
//        [favorites release];
//        [app release];
//        [login release];
    }
    
    return _tabBarItemsSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTabBarItemArray];
    self.aliTabBar.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entryFavEvent:) name:@"enter" object:nil];
    
    self.view.backgroundColor = RGB(0xf5, 0xf5, 0xf5);
    loginHere = NO;
    isLogining = NO;
    self.aliTabBar.alpha = 1.0f;
    self.contentView.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-self.aliTabBar.frame.size.height + 5);
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) onMsgRecv {
    [self updateItemBadge];
}

-(void) onMsgRead {
    [self updateItemBadge];
}

-(void) updateItemBadge {
//    AMAppDelegate * appDelegate = (AMAppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    NSUInteger appcenterUnReadMsg = [appDelegate getUnReadMsgWithSource:AMSource_Trade] + [appDelegate getUnReadMsgWithSource:AMSource_ALI56] + [appDelegate getUnReadMsgWithSource:AMSource_PM] + [appDelegate getUnReadMsgWithSource:AMSource_EQ];
//    NSUInteger favUnReadMsg = [appDelegate getUnReadMsgWithSource:AMSource_JiaGe]+[appDelegate getUnReadMsgWithSource:AMSource_Favorite];
    
    
//    [self setItemBadge:TABBAR_IDX_APPCTR:appcenterUnReadMsg];
//    [self setItemBadge:TABBAR_IDX_FAV:favUnReadMsg];
}

// if badgeNum <= 0, Badge will not show
-(void) setItemBadge:(NSUInteger)index:(NSInteger)badgeNum{
    if (index >= [self.tabBarItemArray count]) {
        return ;
    }
    
    NSDictionary* data = [self.tabBarItemArray objectAtIndex:index];
    SSTabBarItem *itemView = [data objectForKey:ITEMID_KEYWORD_VIEW];
    
    if (badgeNum > 0) {
        //        if (badgeNum > 99) {
        //            itemView.badgeText = @"N";
        //        } else {
        //            itemView.badgeText = [NSString stringWithFormat:@"%d", badgeNum];
        //        }
        itemView.showBadge = YES;
    } else {
        itemView.showBadge = NO;
        //        itemView.badgeText = @"";
    }
}

-(void)hideTabBar:(id)sender{
    self.tabBatHidden = YES;
}

-(void)unHideTabBar:(id)sender{
    self.tabBatHidden = NO;
}

-(void)cancelLoginEvent:(id)sender{
    
    if (self.aliTabBar.selectedItem >= self.tabBarItemArray.count) {
        return ;
    }
    
    NSDictionary*data = [self.tabBarItemArray objectAtIndex:self.aliTabBar.selectedItem];
    NSString*keyword = [data objectForKey:ITEMID_KEYWORD_NAME];
    
    if([keyword isEqualToString:ITEMNAME_FAV]||[keyword isEqualToString:ITEMNAME_WW]){
        [self.aliTabBar setNewSelectedItem:(NSInteger)self.lastSelectedIndex];
        self.tabBatHidden = NO;
    }
}

-(void)loginSucessEvent:(id)sender{
    if (self.aliTabBar.selectedItem >= self.tabBarItemArray.count) {
        return ;
    }
    
    NSDictionary*data = [self.tabBarItemArray objectAtIndex:self.aliTabBar.selectedItem];
    NSString*keyword = [data objectForKey:ITEMID_KEYWORD_NAME];
    
    if([keyword isEqualToString:ITEMNAME_FAV]||[keyword isEqualToString:ITEMNAME_WW]){
        self.aliTabBar.reloadItemContent = YES;
        [self.aliTabBar setNewSelectedItem:self.aliTabBar.selectedItem];
        self.tabBatHidden = NO;
    }
}

-(void)entryHomeEvent:(id)sender{
    [self entryTabBarItem:ITEMNAME_HOME];
}

-(void)entryTabBarItem:(NSString*)name{
    NSUInteger count = [self.tabBarItemArray count];
    // 先看tabBar中有没有
    for (NSUInteger i=0; i<count; i++) {
        NSDictionary*data = [self.tabBarItemArray objectAtIndex:i];
        NSString*keyword = [data objectForKey:ITEMID_KEYWORD_NAME];
        if ([keyword isEqualToString:name]) {
            self.lastSelectedIndex = self.aliTabBar.selectedItem;
            [self.aliTabBar setNewSelectedItem:i];
            return;
        }
    }
    return ;
}

-(void)entryFavEvent:(id)sender{
    [self entryTabBarItem:ITEMNAME_FAV];
}

-(void)entrySearchEvent:(id)sender{
    [self entryTabBarItem:ITEMNAME_SEARCH];
}

-(UIImage*)tabBarBackgroundImage:(SSTabBar *)tabBar {
    return [UIImage imageNamed:@"bg_home_tab.png"];
}

- (NSUInteger)tabBarItemCount:(SSTabBar*)tabBar {
    return [self.tabBarItemArray count];
}

-(void) popContentViewToRoot{
    NSUInteger count = [self.tabBarItemArray count];
    for (NSUInteger i=0; i < count; i++) {
        NSMutableDictionary * data = [self.tabBarItemArray objectAtIndex:i];
        UINavigationController * viewCtr = [data objectForKey:ITEMID_KEYWORD_VIEWCONTROLLER];
        
        [viewCtr popToRootViewControllerAnimated:NO];
        viewCtr.navigationBar.hidden = NO;
    }
}

-(void)tabBarItemViewDidSelected:(SSTabBar*)tabBar atIndex:(NSUInteger)itemIndex {
    // 移除itemview上的数字
    //[self setItemBadge:itemIndex:0];
    
    // Remove the current view controller's view
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    NSDictionary * data = [self.tabBarItemArray objectAtIndex:itemIndex];
    NSString *itemName = [data objectForKey:ITEMID_KEYWORD_NAME];
    UIViewController* viewController;
    
        
    // Set the view controller's frame to account for the tab bar
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.contentView.frame.size.height);
    
    // Se the tag so we can find it later
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    
    if ([viewController.view isDescendantOfView:self.contentView]) {
        [self.contentView bringSubviewToFront:viewController.view];
    } else {
        [self.contentView addSubview:viewController.view];
    }
    
    if([itemName isEqualToString:ITEMNAME_HOME]){
        int newIdx = 0;
//        newIdx = [UserDataUtils getSelectNumber] - 1;
        if (newIdx < 0 || newIdx >= [_tabBarHomeItemsSource count]) {
            
        }
        else {
            switch (newIdx) {
                case 0:
//                    [AMLogUtils appendLog:APP_HOME_BAR_ONE_ONE];
                    break;
                case 1:
//                    [AMLogUtils appendLog:APP_HOME_BAR_ONE_TWO];
                    break;
                case 2:
//                    [AMLogUtils appendLog:APP_HOME_BAR_ONE_THREE];
                    break;
                case 3:
//                    [AMLogUtils appendLog:APP_HOME_BAR_ONE_FOUR];
                    break;
                case 4:
//                    [AMLogUtils appendLog:APP_HOME_BAR_ONE_FIVE];
                    break;
                default:
                    break;
            }
        }
        
    }else if([itemName isEqualToString:ITEMNAME_WW]){
//        [AMLogUtils appendLog:APP_HOME_BAR_TWO];
    }else if ([itemName isEqualToString:ITEMNAME_FAV]) {
//        [AMLogUtils appendLog:APP_HOME_BAR_THREE];
    }else if ([itemName isEqualToString:ITEMNAME_APPCENTER]){
//        [AMLogUtils appendLog:APP_HOME_BAR_TWELVE];
    }else if ([itemName isEqualToString:ITEMNAME_SEARCH]){
//        [AMLogUtils appendLog:APP_HOME_BAR_ELEVEN];
    }
    
    self.lastSelectedIndex = self.aliTabBar.selectedItem;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
    {
        [viewController viewWillAppear:NO];
    }
}

-(BOOL)tabBarItemViewShouldDidSelected:(SSTabBar*)tabBar atIndex:(NSUInteger)itemIndex {
    int count = self.tabBarItemArray.count;
    if (itemIndex >= count || self.aliTabBar.selectedItem >= count) {
        return NO;
    }
    
    NSDictionary *itemData = [self.tabBarItemArray objectAtIndex:itemIndex];
    NSString *name = [itemData objectForKey:ITEMID_KEYWORD_NAME];
    return YES;
}

- (UIControl*) tabBarItemView:(SSTabBar*)tabBar atIndex:(NSUInteger)itemIndex {
    // Get the right data
    NSDictionary* data = [self.tabBarItemArray objectAtIndex:itemIndex];
    // Return the image for this tab bar item
    SSTabBarItem *control = [data objectForKey:ITEMID_KEYWORD_VIEW];
    control.itemIcon.image = [UIImage imageNamed:[data objectForKey:ITEMID_KEYWORD_IMAGE]];
    control.itemTitle.text = [data objectForKey:ITEMID_KEYWORD_TITLE];
    control.itemHighlighted=NO;
    
    if (!control.itemTitle.text) {
        control.itemIcon.frame = CGRectMake((control.frame.size.width - control.itemIcon.frame.size.width)/2, (control.frame.size.height - control.itemIcon.frame.size.height)/2, control.itemIcon.frame.size.width, control.itemIcon.frame.size.height);
    }
    
    return control;
}

-(void)tabBarItemViewHighlighted:(SSTabBar*)tabBar atIndex:(NSUInteger)itemIndex {
    if (itemIndex >= self.tabBarItemArray.count) {
        return ;
    }
    
    NSDictionary* data = [self.tabBarItemArray objectAtIndex:itemIndex];
    // Return the image for this tab bar item
    SSTabBarItem *control = [data objectForKey:ITEMID_KEYWORD_VIEW];
    control.itemIcon.image = [UIImage imageNamed:[data objectForKey:ITEMID_KEYWORD_FOCUSIMAGE]];
    control.itemHighlighted=YES;
}

-(void)tabBarItemViewUnHighlighted:(SSTabBar *)tabBar atIndex:(NSUInteger)itemIndex {
    if (itemIndex >= self.tabBarItemArray.count) {
        return ;
    }
    
    NSDictionary* data = [self.tabBarItemArray objectAtIndex:itemIndex];
    // Return the image for this tab bar item
    SSTabBarItem *control = [data objectForKey:ITEMID_KEYWORD_VIEW];
    if (itemIndex == TABBAR_IDX_WW) {
        control.itemIcon.image = [UIImage imageNamed:[data objectForKey:ITEMID_KEYWORD_FOCUSIMAGE]];
    } else {
        control.itemIcon.image = [UIImage imageNamed:[data objectForKey:ITEMID_KEYWORD_IMAGE]];
    }
    
    control.itemHighlighted=NO;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [viewController viewWillAppear:NO];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
    {
        //        [viewController viewWillAppear:animated];
        //[viewController viewWillDisappear:animated];
    }
}  

- (void)navigationController:(UINavigationController *)navigationController   
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated { 
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
    {
        [viewController viewDidAppear:animated];  
        
    }
}  

@end

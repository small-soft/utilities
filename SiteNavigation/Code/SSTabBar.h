//
//  SSTabBar.h
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-6.
//
//

#import <UIKit/UIKit.h>

@class SSTabBar;

@protocol CustomTabBarDelegate

- (NSUInteger)tabBarItemCount:(SSTabBar*)tabBar;
- (UIControl*)tabBarItemView:(SSTabBar*)tabBar atIndex:(NSUInteger)itemIndex;
@optional
- (UIImage*) tabBarSelectedItemImage:(SSTabBar*)tabBar;
- (UIImage*) tabBarBackgroundImage:(SSTabBar*)tabBar;
-(void)tabBarItemViewHighlighted:(SSTabBar*)tabBar atIndex:(NSUInteger)itemIndex;
-(void)tabBarItemViewUnHighlighted:(SSTabBar*)tabBar atIndex:(NSUInteger)itemIndex;
-(void)tabBarItemViewDidSelected:(SSTabBar*)tabBar atIndex:(NSUInteger)itemIndex;
-(BOOL)tabBarItemViewShouldDidSelected:(SSTabBar*)tabBar atIndex:(NSUInteger)itemIndex;
@end

@interface SSTabBar : UIView
-(void)setNewSelectedItem:(NSInteger)itemIdx;

@property (nonatomic,assign) NSObject <CustomTabBarDelegate> *delegate;
@property(nonatomic) NSInteger selectedItem;
@property(nonatomic) BOOL reload;
@property(nonatomic) BOOL reloadItemContent;

@end


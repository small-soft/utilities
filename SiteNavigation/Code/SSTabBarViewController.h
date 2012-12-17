//
//  SSTabBarViewController.h
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-6.
//
//

#import <UIKit/UIKit.h>
#import "SSTabBar.h"


@interface SSTabBarViewController : UIViewController <CustomTabBarDelegate,UIAlertViewDelegate,UITabBarControllerDelegate,UINavigationControllerDelegate>
{
}

@property (retain, nonatomic) IBOutlet SSTabBar *aliTabBar;

@property(nonatomic,retain) NSMutableArray *tabBarItemArray;
@property (retain, nonatomic) IBOutlet UIView *contentView;

-(void)entryTabBarItem:(NSString*)name;
-(void)entryMsgCenter;

-(void)updateWwNewMsgCnt:(NSInteger)cnt;

@end


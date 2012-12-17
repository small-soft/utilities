//
//  SSTabBarItem.h
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-6.
//
//

#import <Foundation/Foundation.h>
#import "SSLabel.h"
@interface SSTabBarItem : UIControl

@property (retain, nonatomic) IBOutlet UIImageView *itemIcon;
@property (retain, nonatomic) IBOutlet SSLabel *itemTitle;

@property (nonatomic) BOOL itemHighlighted;
@property (nonatomic) BOOL showBadge;
//@property (retain, nonatomic) NSString * badgeText;

+(id)createView;
@end


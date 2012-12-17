//
//  SSSNHostSitesCell.h
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-10.
//
//

#import <UIKit/UIKit.h>
#import "SSLinkLabel.h"
#import "SSSNSites.h"

@interface SSSNHostSitesCell : UITableViewCell <SSLinkLabelDelegate>

@property(nonatomic,retain) UIViewController *parentViewController;
@property(nonatomic,retain) SSSNSmallCat *data;

-(void)setupView;

+(CGFloat)cellHeight;
+(CGFloat)cellWidth;
+(NSString*)cellIdentifer;
+(id)createCell;

@end

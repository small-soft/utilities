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
#import "SSButton.h"

@interface SSSNHistoryCell : UITableViewCell <SSLinkLabelDelegate>

@property(nonatomic,retain) UIViewController *parentViewController;
@property(nonatomic,retain) SSFav *data;
@property(nonatomic,retain) IBOutlet SSButton *delBtn;

-(void)setupView;

+(CGFloat)cellHeight;
+(CGFloat)cellWidth;
+(NSString*)cellIdentifer;
+(id)createCell;

-(void)cellData:(SSFav*)data;

@end

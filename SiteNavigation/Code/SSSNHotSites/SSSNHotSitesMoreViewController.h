//
//  SSSNHotSitesMoreViewController.h
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-16.
//
//

#import <UIKit/UIKit.h>
#import "SSViewController.h"

#import "SSSNSites.h"

@interface SSSNHotSitesMoreViewController : SSViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) SSSNSmallCat *data;

@end

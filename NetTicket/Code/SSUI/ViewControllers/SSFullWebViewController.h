//
//  SSFullWebViewController.h
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-7.
//
//

#import <UIKit/UIKit.h>
#import "SSWebViewController.h"

@interface SSFullWebViewController : SSWebViewController<UITextFieldDelegate,UISearchBarDelegate>

@property(nonatomic,retain) NSString *keyWord;

@end

//
//  SSWebViewController.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-28.
//
//

#import <UIKit/UIKit.h>
#import "SSViewController.h"

@interface SSWebViewController : SSViewController<UIWebViewDelegate>

@property(nonatomic,retain) NSURL *url;
@property (nonatomic,retain) IBOutlet UIWebView *webView;

- (IBAction)gotoHome;
- (IBAction)gogoLast;
- (IBAction)gotoNext;
- (IBAction)gotoRefresh:(id)sender;
- (void)loadURL;
@end

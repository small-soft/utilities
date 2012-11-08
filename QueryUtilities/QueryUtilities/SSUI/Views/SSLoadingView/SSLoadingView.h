//
//  SSQULoadingView.h
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-28.
//
//

#import <UIKit/UIKit.h>

@interface SSLoadingView : UIView
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;
-(void)showLoadingView;
-(void)hideLoadingView;
@end

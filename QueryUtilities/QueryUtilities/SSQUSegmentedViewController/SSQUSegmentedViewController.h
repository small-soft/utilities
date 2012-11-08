//
//  SSQUSegmentedViewController.h
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-3.
//
//

#import <UIKit/UIKit.h>
#import "SSViewController.h"
#import <RestKit/RestKit.h>
@interface SSQUSegmentedViewController : SSViewController<RKRequestDelegate>

@property (nonatomic, assign) NSUInteger selectIndex;

@property (nonatomic, retain) RKRequest * request;

@property (nonatomic, copy) NSString * sendRequestButtonTitle;

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UITextField * inputTextField;
@property (nonatomic, retain) IBOutlet UILabel * outputLabel;
@property (nonatomic, retain) IBOutlet UIButton * sendrequestButton;
@property (nonatomic, retain) IBOutlet UIButton * outputCopyButton;
-(void)loadObjectsFromRemote;
@end

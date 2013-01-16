//
//  SSNTViewController.h
//  NetTicket
//
//  Created by 刘 佳 on 12-12-29.
//  Copyright (c) 2012年 Small-Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSViewController.h"

@interface SSNTViewController : SSViewController<UIScrollViewDelegate,UIPageViewControllerDelegate>

@property(nonatomic,retain) NSString *type;

@end

//
//  SSNTTicketView.h
//  NetTicket
//
//  Created by 刘 佳 on 13-1-5.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSNTTicket.h"

@interface SSNTTicketView : UIControl

@property(nonatomic,retain) SSNTTicket *ticket;
@property(nonatomic,assign) UIViewController *delegate;
@property(nonatomic) SEL editCallBack;

-(void)setFrame:(CGRect)frame data:(SSNTTicket*)ticket;

@end

//
//  SSNTTicketEditableView.h
//  NetTicket
//
//  Created by 刘 佳 on 13-1-5.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSNTTicket.h"

@interface SSNTTicketEditableView : UIView

@property(nonatomic,retain) SSNTTicket *ticket;
@property(nonatomic,assign) UIViewController *delegate;
@property(nonatomic) SEL returnCallBack;

- (id)initWithFrame:(CGRect)frame ticket:(SSNTTicket*)ticket;

- (void)setData:(SSNTTicket*)ticket;
- (void)saveUpdate;
@end

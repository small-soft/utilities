//
//  SSNTNoDataView.m
//  NetTicket
//
//  Created by 神逸 on 13-1-16.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import "SSNTNoDataView.h"
#import "UIView+UIViewUtil.h"
#import <QuartzCore/QuartzCore.h>
#import "SSSystemUtils.h"

@interface SSNTNoDataView()
@property(nonatomic,retain)UIView *bg;
@property(nonatomic,retain)UIImageView *image;

@end

@implementation SSNTNoDataView
@synthesize addButton = _addButton;
@synthesize messageLabel = _messageLabel;
@synthesize bg = _bg;
@synthesize image = _image;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory Management
-(void)dealloc {
    self.addButton = nil;
    self.messageLabel = nil;
    self.bg = nil;
    self.image = nil;
    [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    
    [self initMask];
    [self initBg];
    [self initImage];
    [self initMessageLabel];
    [self initAddButton];
}

-(void)initMask {
    self.backgroundColor = [UIColor clearColor];
    UIView *mask = [[UIView alloc]initWithFrame:self.frame];
    mask.backgroundColor = [UIColor blackColor];
    //    mask.alpha = .8;
    [self addSubview:mask];
}

-(void)initBg {
    UIControl *bg = [[[UIControl alloc]initWithFrame:CGRectMake(2, 2, 320 - 2*2, [self height] - 30)]autorelease];
    bg.backgroundColor = [UIColor lightTextColor];
    bg.alpha = .4;
    bg.layer.borderWidth = 1;
    bg.layer.cornerRadius = 12;
    bg.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.bg = bg;
    [self addSubview: self.bg];
}

-(void)initImage {
    UIImageView *image = [[[UIImageView alloc]initWithFrame:CGRectMake(([self.bg width] - 128)/2 + [self.bg x], 60, 128, 128)]autorelease];
    image.image = [UIImage imageNamed:@"maidou.gif"];
    self.image = image;
    [self addSubview:self.image];
}

-(void)initMessageLabel {
    UILabel *message = [[[UILabel alloc]initWithFrame:CGRectMake(0, [self.image endY] + 10, [self width], 30)]autorelease];
    message.backgroundColor = [UIColor clearColor];
    message.text = @"还没有创建网票哦";
    message.font = [UIFont boldSystemFontOfSize:20];
    message.textColor = [UIColor whiteColor];
    message.textAlignment = UITextAlignmentCenter;
    self.messageLabel = message;
    [self addSubview:self.messageLabel];
}

-(void)initAddButton {
    self.addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.addButton.frame = CGRectMake(20, [self.messageLabel endY] + 10, [self width] - 20 * 2, 44);
    [self.addButton setTitle:@"添加网票" forState:UIControlStateNormal];
    [SSSystemUtils setGrayBtn:self.addButton];

    [self addSubview:self.addButton];
}

@end

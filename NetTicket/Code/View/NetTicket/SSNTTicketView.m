//
//  SSNTTicketView.m
//  NetTicket
//
//  Created by 刘 佳 on 13-1-5.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import "SSNTTicketView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+UIViewUtil.h"
#import "NSDate+DateUtil.h"

@interface SSNTTicketView()

@property(nonatomic,retain) UIView *bg;
@property(nonatomic,retain) UIControl *mask;
@property(nonatomic,retain) UIImageView *image;
@property(nonatomic,retain) UILabel *validDes;
@property(nonatomic,retain) UILabel *validStart;
@property(nonatomic,retain) UILabel *validSep;
@property(nonatomic,retain) UILabel *validEnd;
@property(nonatomic,retain) UILabel *codeDes;
@property(nonatomic,retain) UILabel *code;
@property(nonatomic,retain) UILabel *desDes;
@property(nonatomic,retain) UILabel *des;
@end

@implementation SSNTTicketView
@synthesize bg = _bg;
@synthesize mask = _mask;
@synthesize image = _image;
@synthesize validDes = _validDes;
@synthesize validStart = _validStart;
@synthesize validSep = _validSep;
@synthesize validEnd = _validEnd;
@synthesize codeDes = _codeDes;
@synthesize code = _code;
@synthesize desDes = _desDes;
@synthesize des = _des;
@synthesize ticket = _ticket;
@synthesize delegate = _delegate;
@synthesize editCallBack = _editCallBack;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory Management
-(void)dealloc {
    self.bg = nil;
    self.mask = nil;
    self.image = nil;
    self.validDes = nil;
    self.validStart = nil;
    self.validSep = nil;
    self.validEnd = nil;
    self.codeDes = nil;
    self.code = nil;
    self.desDes = nil;
    self.des = nil;
    
    self.delegate = nil;
    self.editCallBack = nil;
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
    
    [self initBg];
    [self initImage];
    [self initValid];
    [self initCode];
    [self initDes];
    
    [self initMask];
}

-(void)initBg {
    UIView *bg = [[[UIView alloc]initWithFrame:CGRectMake(10, 5, 300, [self height] - 20)]autorelease];
    bg.backgroundColor = [UIColor lightTextColor];
    bg.alpha = .4;
    bg.layer.borderWidth = 1;
    bg.layer.cornerRadius = 12;
    bg.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.bg = bg;
    [self addSubview: self.bg];
}

-(void)initImage {
    UIImageView *image = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ecodeExample"]]autorelease];
    image.backgroundColor = [UIColor clearColor];
    image.frame = CGRectMake(48, 20, 215, 215);
    image.layer.borderWidth = 1;
    //        image.layer.cornerRadius = 12;
    image.layer.borderColor = [[UIColor grayColor] CGColor];
    self.image = image;
    [self addSubview:self.image];
}

-(void)initValid {
    UILabel *validDes = [[[UILabel alloc]initWithFrame:CGRectMake([self.bg x]+15, [self.image endY]+15, 68, 17)]autorelease];
    validDes.backgroundColor = [UIColor clearColor];
    validDes.text = @"有效期：";
    validDes.textColor = [UIColor whiteColor];
    self.validDes = validDes;
    [self addSubview:self.validDes];
    
    UILabel *validStart = [[[UILabel alloc]initWithFrame:CGRectMake([validDes endX] + 5, [validDes y] - 7, 170, 15)]autorelease];
    validStart.backgroundColor = [UIColor clearColor];
    validStart.text = @"2012.12.12 12:12:12";
    validStart.font = [UIFont systemFontOfSize:15];
    validStart.textColor = [UIColor whiteColor];
    self.validStart = validStart;
    [self addSubview:self.validStart];
    
    UILabel *validSep = [[[UILabel alloc]initWithFrame:CGRectMake([validStart endX] + 5, [validDes y], 30, 17)]autorelease];
    validSep.backgroundColor = [UIColor clearColor];
    validSep.text = @"~";
    validSep.font = [UIFont systemFontOfSize:17];
    validSep.textColor = [UIColor whiteColor];
    self.validSep = validSep;
    [self addSubview:self.validSep];
    
    UILabel *validEnd = [[[UILabel alloc]initWithFrame:CGRectMake([validStart x], [validStart endY]+5 , 170, 15)]autorelease];
    validEnd.backgroundColor = [UIColor clearColor];
    validEnd.text = @"2012.12.12 12:12:12";
    validEnd.font = [UIFont systemFontOfSize:15];
    validEnd.textColor = [UIColor whiteColor];
    self.validEnd = validEnd;
    [self addSubview:self.validEnd];
}

-(void)initCode {
    UILabel *codeDes = [[[UILabel alloc]initWithFrame:CGRectMake([self.validDes x], [self.validDes endY]+20, 68, 17)]autorelease];
    codeDes.backgroundColor = [UIColor clearColor];
    codeDes.text = @"编码：";
    codeDes.textColor = [UIColor whiteColor];
    self.codeDes = codeDes;
    [self addSubview:self.codeDes];
    
    UILabel *code = [[[UILabel alloc]initWithFrame:CGRectMake([codeDes endX] + 5, [codeDes y], [self.bg width]-[codeDes endX] - 5, 17)]autorelease];
    code.backgroundColor = [UIColor clearColor];
    code.text = @"2322XSDEEFLSKJDLKJF223432FLSKJDLF";
    code.textColor = [UIColor whiteColor];
    code.font = [UIFont systemFontOfSize:15];
    self.code = code;
    [self addSubview:self.code];
}

-(void)initDes {
    UILabel *desDes = [[[UILabel alloc]initWithFrame:CGRectMake([self.validDes x], [self.codeDes endY]+15, 68, 17)]autorelease];
    desDes.backgroundColor = [UIColor clearColor];
    desDes.text = @"备注：";
    desDes.textColor = [UIColor whiteColor];
    self.desDes = desDes;
    [self addSubview:self.desDes];
    
    UILabel *des = [[[UILabel alloc]initWithFrame:CGRectMake([desDes endX] + 5, [self.codeDes endY] + 10, [self.bg width]-[self.codeDes endX] - 5, 35)]autorelease];
    des.backgroundColor = [UIColor clearColor];
    des.text = @"电影票，附送两倍可乐和一份薯条，地址在西直门588号，西直大厦502";
    des.numberOfLines = 2;
    des.textColor = [UIColor whiteColor];
    des.font = [UIFont systemFontOfSize:15];
    self.des = des;
    [self addSubview:self.des];
}

-(void)initMask {
    UIControl *mask = [[[UIControl alloc]initWithFrame:self.bg.frame]autorelease];
    
    mask.backgroundColor = [UIColor clearColor];
    self.mask = mask;
    
    [self addSubview: self.mask];
}

-(void)setFrame:(CGRect)frame data:(SSNTTicket *)ticket {
    self.frame = frame;
    self.ticket = ticket;
    self.mask.tag = self.tag;
    
    [self.mask addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.ticket.code.length > 0) {
        self.code.text = self.ticket.code;
    }else {
        self.code.text = @"暂无";
    }
    
    if (self.ticket.comment.length > 0) {
        self.des.text = self.ticket.comment;
    }else {
        self.des.text = @"暂无";
    }
    
    if (self.ticket.validStart) {
//        self.validStart.text = [NSString stringWithFormat:@"%@ (星期%d)",[self.ticket.validStart getDateStringForTodayYesterdayWithFormate:@"yyyy年MM月dd日 HH:mm"],[self.ticket.validStart week]];
        self.validStart.text = [self.ticket.validStart formate:@"yyyy年MM月dd日 HH:mm"];
    }else {
        self.validStart.text = @"无限制";
    }
    
    if (self.ticket.validEnd) {
//        self.validEnd.text = [NSString stringWithFormat:@"%@ (星期%d)",[self.ticket.validEnd getDateStringForTodayYesterdayWithFormate:@"yyyy年MM月dd日 HH:mm"],[self.ticket.validEnd week]];
        self.validEnd.text = [self.ticket.validEnd formate:@"yyyy年MM月dd日 HH:mm"];
    }else {
        self.validEnd.text = @"无限制";
    }
    
}

-(void)edit:(UIControl*)sender {
    [self.delegate performSelector:self.editCallBack withObject:sender];
}
@end

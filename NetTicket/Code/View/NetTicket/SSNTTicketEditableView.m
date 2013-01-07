//
//  SSNTTicketEditableView.m
//  NetTicket
//
//  Created by 刘 佳 on 13-1-5.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import "SSNTTicketEditableView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+UIViewUtil.h"
#import "SSNTTicketService.h"
#import "NSDate+DateUtil.h"

@interface SSNTTicketEditableView() <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) UITableView *contentTable;
@property(nonatomic,retain) UITextField *code;
@property(nonatomic,retain) UIDatePicker *datePicker;
@property(nonatomic) NSInteger dateEditRowNo;

@end

@implementation SSNTTicketEditableView
@synthesize imageView = _imageView;
@synthesize contentTable = _contentTable;
@synthesize code = _code;
@synthesize ticket = _ticket;
@synthesize delegate = _delegate;
@synthesize returnCallBack = _returnCallBack;
@synthesize datePicker = _datePicker;
@synthesize dateEditRowNo = _dateEditRowNo;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory Management
-(void)dealloc {
    self.imageView = nil;
    self.contentTable = nil;
    self.code = nil;
    self.delegate = nil;
    self.returnCallBack = nil;
    self.datePicker = nil;
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
        
        if (self.ticket == nil) {
            self.ticket = [[[SSNTTicket alloc]init]autorelease];
        }
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame ticket:(SSNTTicket *)ticket {
    self = [self initWithFrame:frame];
    self.ticket = ticket;
    
    if (self.ticket == nil) {
        self.ticket = [[[SSNTTicket alloc]init]autorelease];
    }
    
    return self;
}

-(void)setupView {
    
    [self initMask];
    [self initBg];
    [self initImage];
    [self initCodeField];
    [self initTable];
    [self initDatePicker];
    
}

-(void)initMask {
    self.backgroundColor = [UIColor clearColor];
    UIView *mask = [[UIView alloc]initWithFrame:self.frame];
    mask.backgroundColor = [UIColor blackColor];
    //    mask.alpha = .8;
    [self addSubview:mask];
}

-(void)initBg {
    UIView *bg = [[[UIView alloc]initWithFrame:CGRectMake(2, 2, 320 - 2*2, [self height] - 20)]autorelease];
    bg.backgroundColor = [UIColor lightTextColor];
    bg.alpha = .4;
    bg.layer.borderWidth = 1;
    bg.layer.cornerRadius = 12;
    bg.layer.borderColor = [[UIColor grayColor] CGColor];
    [self addSubview: bg];
}

-(void)initImage {
    UIImageView *image = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ecodeExample"]]autorelease];
    image.backgroundColor = [UIColor clearColor];
    image.frame = CGRectMake(10, 10, 57, 57);
    image.layer.borderWidth = 1;
    //        image.layer.cornerRadius = 12;
    image.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.imageView = image;
    [self addSubview:self.imageView];
}

-(void)initCodeField {
    UITextField *codeField = [[[UITextField alloc]initWithFrame:CGRectMake([self.imageView endX]+5,[self.imageView endY] - 20, self.width - [self.imageView endX] - 15, 20)]autorelease];
    self.code = codeField;
    self.code.textColor = [UIColor whiteColor];
    self.code.font = [UIFont systemFontOfSize:15];
    self.code.borderStyle = UITextBorderStyleNone;
    self.code.placeholder = @"点击输入编码";
    self.code.delegate = self;
    self.code.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.code];
}

-(void)initTable {
    UITableView *tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, [self.imageView endY], [self width], [self height] - [self.imageView endY]) style:UITableViewStyleGrouped]autorelease];
    self.contentTable = tableView;
    self.contentTable.backgroundColor = [UIColor clearColor];
    self.contentTable.backgroundView = nil;
    self.contentTable.delegate = self;
    self.contentTable.dataSource = self;
    self.contentTable.scrollEnabled = NO;
    
    [self addSubview:self.contentTable];
}

-(void)initDatePicker {
    self.datePicker = [[[UIDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216 - 88, SCREEN_WIDTH, 216)]autorelease];
    self.datePicker.hidden = YES;
    
    [self.datePicker addTarget:self action:@selector(dateValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.datePicker];
}

-(void)setData:(SSNTTicket *)ticket {
    self.ticket = ticket;
    if (self.ticket == nil) {
        self.ticket = [[[SSNTTicket alloc]init]autorelease];
    }
    
    self.code.text = ticket.code;
    [self.code reloadInputViews];
    
    self.datePicker.hidden = YES;
    
    [self.contentTable reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return self.ticket.id == 0 ? 2:3;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SSNTETC"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SSNTETC"]autorelease];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.detailTextLabel.text = @"有效期开始";
                    
                    if (self.ticket.validStart) {
//                        cell.textLabel.text = [NSString stringWithFormat:@"%@ (星期%d)",[self.ticket.validStart getDateStringForTodayYesterdayWithFormate:@"yyyy年MM月dd日 HH:mm"],[self.ticket.validStart week]];
                        
                        cell.textLabel.text = [self.ticket.validStart formate:@"yyyy年MM月dd日 HH:mm"];
                    }else {
                        cell.textLabel.text = @"无限制";
                    }
                }
                    break;
                case 1:
                {
                    if (self.ticket.validEnd) {
//                        cell.textLabel.text = [NSString stringWithFormat:@"%@ (星期%d)",[self.ticket.validEnd getDateStringForTodayYesterdayWithFormate:@"yyyy年MM月dd日 HH:mm"],[self.ticket.validEnd week]];
                        cell.textLabel.text = [self.ticket.validEnd formate:@"yyyy年MM月dd日 HH:mm"];
                    }else {
                        cell.textLabel.text = @"无限制";
                    }
                    
                    cell.detailTextLabel.text = @"有效期截止";
                }
                    break;
                case 2:
                {
//                    cell.detailTextLabel.text = @"备注";
                    cell.textLabel.text = @"暂无备注";
                    if (self.ticket.comment.length > 0) {
                        cell.textLabel.text = self.ticket.comment;
                    }
                    cell.textLabel.numberOfLines = 2;
                }
                    break;
                    
                default:
                    break;
                    
            }
            
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.backgroundColor = [UIColor whiteColor];
//            cell.layer.borderColor = [[UIColor whiteColor] CGColor];
//            cell.textLabel.textColor = [UIColor whiteColor];
        }
            break;
            
        case 1:{
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"确定";
                    cell.backgroundColor = [UIColor blueColor];
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"取消";
                    cell.backgroundColor = [UIColor grayColor];
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"删除";
                    cell.backgroundColor = [UIColor redColor];
                }
                    break;
                default:
                    break;
            }
            
            cell.textLabel.textAlignment = UITextAlignmentCenter;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    self.dateEditRowNo = 0;
                    [self showDatePicker];
                }
                    break;
                case 1:
                {
                    self.dateEditRowNo = 1;
                    [self showDatePicker];
                }
                    break;
                case 2:
                {
                }
                    break;
                    
                default:
                    break;
                    
            }
        }
            break;
            
        case 1:{
            switch (indexPath.row) {
                case 0:
                {
                    [self saveUpdate];
                }
                    break;
                case 1:
                {
                }
                    break;
                case 2:
                {
                    [self delete];
                }
                    break;
                default:
                    break;
            }
            
            [self callBack];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) {
        return 66;
    }
    
    return 44;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    self.ticket.code = textField.text;
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self hideDatePicker];
    return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark DB
-(void)saveUpdate {
    // 如果id=0，则为新增
    if (self.ticket.id == 0) {
        NSLog(@"add ticket id is :%d",[SSNTTicketService addTicket:self.ticket]);
    }else {
        NSLog(@"update ticket id is :%d",[SSNTTicketService update:self.ticket]);
    }
}

-(void)delete {
    NSLog(@"delete ticket id is :%d",[SSNTTicketService delete:self.ticket.id]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private
-(void)callBack {
    self.hidden = YES;
    [self.delegate performSelector:self.returnCallBack];
}

-(void)showDatePicker {
    if (self.dateEditRowNo == 0) {
        if (self.ticket.validEnd) {
            self.datePicker.maximumDate = self.ticket.validEnd;
        }
        
        self.datePicker.minimumDate = nil;
        
        if (self.ticket.validStart) {
            self.datePicker.date = self.ticket.validStart;
        }
        
    }else {
        if (self.ticket.validStart) {
            self.datePicker.minimumDate = self.ticket.validStart;
        }
        
        self.datePicker.maximumDate = nil;
        
        if (self.ticket.validEnd) {
            self.datePicker.date = self.ticket.validEnd;
        }
    }
    
    [self.code resignFirstResponder];
    self.datePicker.hidden = NO;
}

-(void)hideDatePicker {
    self.datePicker.hidden = YES;
}

-(void)dateValueChanged:(id)sender {
    if (self.dateEditRowNo == 0) {
        self.ticket.validStart = self.datePicker.date;
    }else {
        self.ticket.validEnd = self.datePicker.date;
    }
    
    
    [self.contentTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}
@end

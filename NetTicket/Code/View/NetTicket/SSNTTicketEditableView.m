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
#import "SSTextFieldCell.h"
#import "ZBarReaderViewController.h"
#import "QRCodeGenerator.h"
#import "SSNativeFileService.h"
#import "UIImage+fixOrientation.h"

#define TEXTVIEW_PLACEHOLDER @"点击设置备注"

@interface SSNTTicketEditableView() <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,ZBarReaderDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) UITableView *contentTable;
@property(nonatomic,retain) UITextField *code;
@property(nonatomic,retain) UIDatePicker *datePicker;
@property(nonatomic,retain) UIToolbar *datePickerTollbar;
@property(nonatomic,retain) UITextView *comment;
@property(nonatomic) NSInteger dateEditRowNo;
@property(nonatomic,retain) ZBarReaderViewController *reader;
@property(nonatomic,retain) UILabel *type;

@end

@implementation SSNTTicketEditableView
@synthesize imageView = _imageView;
@synthesize contentTable = _contentTable;
@synthesize code = _code;
@synthesize ticket = _ticket;
@synthesize delegate = _delegate;
@synthesize returnCallBack = _returnCallBack;
@synthesize cancelCallBack = _cancelCallBack;
@synthesize datePicker = _datePicker;
@synthesize datePickerTollbar = _datePickerTollbar;
@synthesize comment = _comment;
@synthesize dateEditRowNo = _dateEditRowNo;
@synthesize reader = _reader;
@synthesize type = _type;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory Management
-(void)dealloc {
    self.imageView = nil;
    self.contentTable = nil;
    self.code = nil;
    self.delegate = nil;
    self.returnCallBack = nil;
    self.cancelCallBack = nil;
    self.datePicker = nil;
    self.datePickerTollbar = nil;
    self.comment = nil;
    self.reader = nil;
    self.type = nil;
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
    [self initTypeLabel];
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
    UIControl *bg = [[[UIControl alloc]initWithFrame:CGRectMake(2, 2, 320 - 2*2, [self height] - 30)]autorelease];
    bg.backgroundColor = [UIColor lightTextColor];
    bg.alpha = .4;
    bg.layer.borderWidth = 1;
    bg.layer.cornerRadius = 12;
    bg.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [bg addTarget:self action:@selector(hideAll) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview: bg];
}

-(void)initImage {
    UIImageView *image = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ecodeExample"]]autorelease];
    
    image.backgroundColor = [UIColor whiteColor];
    image.frame = CGRectMake(10, 10, 57, 57);
    image.layer.borderWidth = 1;
    //        image.layer.cornerRadius = 12;
    image.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.imageView = image;
    [self addSubview:self.imageView];
    
    UIControl *imageMask = [[[UIControl alloc]initWithFrame:self.imageView.frame]autorelease];
    imageMask.backgroundColor = [UIColor clearColor];
    [imageMask addTarget:self action:@selector(imageGenerateSelector) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:imageMask];
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

-(void)initTypeLabel {
    UILabel *typeLabel = [[[UILabel alloc]initWithFrame:CGRectMake([self.imageView endX]+5,[self.imageView y], self.width - [self.imageView endX] - 15, 20)]autorelease];
    self.type = typeLabel;
    self.type.text = @"点击选择类型";
    self.type.backgroundColor = [UIColor clearColor];
    self.type.textColor = [UIColor lightGrayColor];
    [self addSubview:self.type];
    
    UIControl *typeMask = [[[UIControl alloc]initWithFrame:self.type.frame]autorelease];
    typeMask.backgroundColor = [UIColor clearColor];
    [typeMask addTarget:self action:@selector(selectType) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:typeMask];
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
    self.datePicker = [[[UIDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216 - 88 + 30, SCREEN_WIDTH, 216)]autorelease];
    self.datePicker.hidden = YES;
    
    [self.datePicker addTarget:self action:@selector(dateValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.datePicker];
    
    // init toolbar
    self.datePickerTollbar = [[[UIToolbar alloc]initWithFrame:CGRectMake(0,[self.datePicker y] - 44,SCREEN_HEIGHT,44)]autorelease];
    UIBarButtonItem *clearItem = [[[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearDate)]autorelease];
    UIBarButtonItem *hideItem = [[[UIBarButtonItem alloc] initWithTitle:@"隐藏" style:UIBarButtonItemStyleBordered target:self action:@selector(hideDatePicker)]autorelease];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexibleSpace.width = SCREEN_WIDTH - 110;
    
    NSArray *items = [NSArray arrayWithObjects:clearItem,flexibleSpace,hideItem, nil];
    
    self.datePickerTollbar.items = items;
    self.datePickerTollbar.hidden = YES;
    [self addSubview:self.datePickerTollbar];
}

-(void)setData:(SSNTTicket *)ticket withType:(NSString*)type {
    
    self.ticket = ticket;
    if (self.ticket == nil) {
        self.ticket = [[[SSNTTicket alloc]init]autorelease];
        self.ticket.type = type;
    }
    
    self.code.text = ticket.code;
    [self.code reloadInputViews];
    UIImage *image = [SSNTTicketService getTicketImageById:self.ticket.id];
    if (image) {
        self.imageView.image = image;
    }else {
        self.imageView.image = [UIImage imageNamed:@"ecodeExample"];
    }
    
    if (self.ticket.type.length > 0) {
        self.type.text = self.ticket.type;
        self.type.textColor = [UIColor whiteColor];
    }else {
        self.type.text = @"点击选择类型";
        self.type.textColor = [UIColor lightGrayColor];
    }
    
    [self hideAll];
        
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
            return self.ticket.id == 0 ? 1:2;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SSNTETC"];
    
    switch (indexPath.section) {
        case 0:
        {
            if (cell == nil) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SSNTETC"]autorelease];
                cell.backgroundColor = [UIColor whiteColor];
            }
            switch (indexPath.row) {
                case 0:
                {
                    cell.detailTextLabel.text = @"有效期开始";
                    
                    if (self.ticket.validStart) {
//                        cell.textLabel.text = [NSString stringWithFormat:@"%@ (星期%d)",[self.ticket.validStart getDateStringForTodayYesterdayWithFormate:@"yyyy年MM月dd日 HH:mm"],[self.ticket.validStart week]];
                        
                        cell.textLabel.text = [self.ticket.validStart formate:@"yyyy年MM月dd日 HH:mm"];
                    }else {
                        cell.textLabel.text = @"无限制 点击设置";
                    }
                }
                    break;
                case 1:
                {
                    if (self.ticket.validEnd) {
//                        cell.textLabel.text = [NSString stringWithFormat:@"%@ (星期%d)",[self.ticket.validEnd getDateStringForTodayYesterdayWithFormate:@"yyyy年MM月dd日 HH:mm"],[self.ticket.validEnd week]];
                        cell.textLabel.text = [self.ticket.validEnd formate:@"yyyy年MM月dd日 HH:mm"];
                    }else {
                        cell.textLabel.text = @"无限制 点击设置";
                    }
                    
                    cell.detailTextLabel.text = @"有效期截止";
                }
                    break;
                case 2:
                {
                    SSTextFieldCell *textCell = [SSTextFieldCell createCell];
                    
                    textCell.textView.text = @"点击设置备注";
                    textCell.textView.textColor = [UIColor lightGrayColor];
                    textCell.textView.font = [UIFont systemFontOfSize:15];
                    textCell.backgroundColor = [UIColor whiteColor];
                    if (self.ticket.comment.length > 0) {
                        textCell.textView.text = self.ticket.comment;
                        textCell.textView.textColor = [UIColor blackColor];
                    }
                    
                    textCell.textView.delegate = self;
                    self.comment = textCell.textView;
                    
                    return textCell;
                }
                    break;
                    
                default:
                    break;
                    
            }
            
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.backgroundColor = [UIColor whiteColor];

        }
            break;
            
        case 1:{
            if (cell == nil) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SSNTETC"]autorelease];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"取消";
                    cell.backgroundColor = [UIColor grayColor];
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"删除";
                    cell.backgroundColor = [UIColor redColor];
                }
                    break;
                default:
                    break;
            }
            
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.detailTextLabel.text = @"";

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
                    [self cancel];
                }
                    break;
                case 1:
                {
                    NSString *msg = [NSString stringWithFormat:@"确定要删除 [%@]%@吗",self.ticket.type,self.ticket.code];
                    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"删除" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]autorelease];
                    [alert show];
                    
                    return;
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

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.ticket.code = textField.text;
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self hideDatePicker];
    return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TextField delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self hideDatePicker];
    if ([textView.text isEqualToString:TEXTVIEW_PLACEHOLDER]) {
        textView.text = @"";
    }
    
    textView.textColor = [UIColor blackColor];
    [self onEditMove];
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    
    self.ticket.comment = textView.text;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    [self endEditMove];
    
    self.ticket.comment = textView.text;
    if(textView.text.length <= 0){
        textView.text = TEXTVIEW_PLACEHOLDER;
        textView.textColor = [UIColor lightGrayColor];
    }
    
    return YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark DB
-(void)saveUpdate {
    // 如果id=0，则为新增
    if (self.ticket.id == 0) {
        self.ticket.id = [SSNTTicketService addTicket:self.ticket];
        NSLog(@"add ticket id is :%d",self.ticket.id);
    }else {
        NSLog(@"update ticket id is :%d",[SSNTTicketService update:self.ticket]);
    }
    
    [SSNativeFileService writeImage:self.imageView.image to:[SSNTTicketService getImagePathById:self.ticket.id]];
    
    [self hideAll];
}

-(void)delete {
    NSLog(@"delete ticket id is :%d",[SSNTTicketService delete:self.ticket.id]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Alert
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
        {
            [self delete];
            [self callBack];
        }
            break;
            
        default:
            break;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private
-(void)callBack {
    self.hidden = YES;
    if (self.returnCallBack && self.delegate) {
        [self.delegate performSelector:self.returnCallBack];
    }
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

    [self hideAll];
    
    [self onEditMove];
    self.datePicker.hidden = NO;
    self.datePickerTollbar.hidden = NO;

}

-(void)hideDatePicker {
    [self endEditMove];
    self.datePicker.hidden = YES;
    self.datePickerTollbar.hidden = YES;
}

-(void)dateValueChanged:(id)sender {
    [self setDateAndReload:self.datePicker.date];
}

-(void)cancel {
    if (self.cancelCallBack && self.delegate) {
        [self.delegate performSelector:self.cancelCallBack];
    }
}

-(void)hideAll {
    [self hideDatePicker];
    [self.code resignFirstResponder];
    [self.comment resignFirstResponder];
}

-(void)clearDate {
    [self setDateAndReload:nil];
}

-(void)setDateAndReload:(NSDate*)date {
    if (self.dateEditRowNo == 0) {
        self.ticket.validStart = date;
    }else {
        self.ticket.validEnd = date;
    }
    
    [self.contentTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)onEditMove {
    [self setOriginY:-30];
}

-(void)endEditMove {
    [self setOriginY:0];
}

-(void)selectType {
    UIActionSheet *typePicker = [[[UIActionSheet alloc]initWithTitle:@"选择类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"其他" otherButtonTitles:@"电影票",@"优惠券",@"机票/车票",@"会员卡" ,nil]autorelease];
    
    typePicker.tag = 1;
    [typePicker showInView:self.delegate.view];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Scan
-(void) startScan
{
    
    if (self.reader == nil) {
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        //    [reader.cameraOverlayView setHeight:[reader.cameraOverlayView height]-50];
        // 使用自定义的toolbar，也可以使用默认的
        reader.showsZBarControls = NO;
        
        UIToolbar *readerToolbar = [[[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 25 - 44, SCREEN_WIDTH, 44)]autorelease];
        readerToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *clearItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelScan)]autorelease];
        UIBarButtonItem *hideItem = [[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(hideDatePicker)]autorelease];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *camera = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(scan)];
        //    flexibleSpace.width = (SCREEN_WIDTH - 110)/2;
        
        NSArray *items = [NSArray arrayWithObjects:clearItem,flexibleSpace,camera,flexibleSpace,hideItem, nil];
        readerToolbar.items = items;
        
        [reader.view addSubview:readerToolbar];
        
        reader.readerDelegate = self;
        ZBarImageScanner *scanner = reader.scanner;
        [scanner setSymbology: ZBAR_I25
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        self.reader = reader;
        [reader release];
    }
    
    
    [self.delegate presentModalViewController: self.reader
                            animated: YES];
    
}

- (void) imagePickerController: (UIImagePickerController*) picker didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
        
    self.imageView.image = [UIImage rotateImage:image];
    
//    float rotateAngle = M_PI;
//    
//    CGAffineTransform transform =CGAffineTransformMakeRotation(rotateAngle);
//    
//    self.imageView.transform = transform;
    
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    
    for(symbol in results)
    {
        break;
    }
    
    if(!symbol || !image)
    {
        if (!symbol) {
            [self closeCamera];
        }
//        [SSNativeFileService writeImage:image to:[SSNTTicketService getImagePathById:self.ticket.id]];
        return;
    }
    
    NSLog(@"symbol.data = %@", symbol.data);
    
    self.code.text = symbol.data;
    self.ticket.code = self.code.text;
    
    [self generateImageFromCode];
    
    [self closeCamera];
    
//    [SSNativeFileService writeImage:image to:[SSNTTicketService getImagePathById:self.ticket.id]];
}

-(void)cancelScan {
    [self closeCamera];
}

-(void)scan {
    [self.reader takePicture];
    [self performSelector:@selector(closeCamera) withObject:nil afterDelay:0.2];
}

-(void)closeCamera {
    [self.delegate dismissModalViewControllerAnimated:YES];
}

-(void)pickFromAlbum{
    UIImagePickerController *pc = [[[UIImagePickerController alloc]init]autorelease];
    pc.delegate = self;
    pc.allowsEditing = NO;
    //pc.allowsImageEditing = NO;
    pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.delegate presentModalViewController:pc animated:YES];
}

-(void)imageGenerateSelector {
    
    UIActionSheet *sheet = [[[UIActionSheet alloc]initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"扫描/拍摄" otherButtonTitles:@"从相册选取",@"通过二维码生成", nil]autorelease];
    
    sheet.tag = 0;
    if (self.ticket.code.length <= 0) {
        sheet = [[[UIActionSheet alloc]initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"扫描/拍摄" otherButtonTitles:@"从相册选取", nil]autorelease];
    }
    
    [sheet showInView:self.delegate.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        return;
    }
    
    if (actionSheet.tag == 0) {
        switch (buttonIndex) {
            case 0:
            {
                [self startScan];
            }
                break;
            case 1:
            {
                [self pickFromAlbum];
            }
                break;
            case 2:
            {
                [self generateImageFromCode];
            }
                break;
            default:
                break;
        }

    }else if (actionSheet.tag == 1) {
    
        self.ticket.type = [actionSheet buttonTitleAtIndex:buttonIndex];
        self.type.text = self.ticket.type;
        self.type.textColor = [UIColor whiteColor];
    }
    
        
}

-(void)generateImageFromCode {
    self.imageView.image = [QRCodeGenerator qrImageForString:self.ticket.code imageSize:215*2];
}
@end

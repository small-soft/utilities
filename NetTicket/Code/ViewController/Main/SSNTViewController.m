//
//  SSNTViewController.m
//  NetTicket
//
//  Created by 刘 佳 on 12-12-29.
//  Copyright (c) 2012年 Small-Soft. All rights reserved.
//

#import "SSNTViewController.h"
#import "UIView+UIViewUtil.h"
#import <QuartzCore/QuartzCore.h>
#import "SSNTNetTicketViewController.h"
#import "SSNTTicketView.h"
#import "SSNTTicketEditableView.h"
#import "SSNTTicketService.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SSToastView.h"
#import "SSNTNoDataView.h"

@interface SSNTViewController () <UIScrollViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>

@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UIPageControl *pageControl;

@property(nonatomic,retain) NSArray *data;
@property(nonatomic,retain) NSMutableArray *dataView;

@property(nonatomic) int pageNo;

@property(nonatomic,retain) SSNTTicketEditableView *ticketEditableView;
@property(nonatomic,retain) SSNTNoDataView *noDataView;

@property(nonatomic,retain) UILabel *statusTitleLabel;
@end

@implementation SSNTViewController
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize ticketEditableView = _ticketEditableView;
@synthesize data = _data;
@synthesize dataView = _dataView;
@synthesize pageNo = _pageNo;
@synthesize type = _type;
@synthesize statusTitleLabel = _statusTitleLabel;
@synthesize noDataView = _noDataView;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory Management
-(void)dealloc {
    self.scrollView = nil;
    self.pageControl = nil;
    self.ticketEditableView = nil;
    self.dataView = nil;
    self.data = nil;
    self.type = nil;
    self.statusTitleLabel = nil;
    self.noDataView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Initialization
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initRightBarButton];
    [self initNoDataView];
    [self initTicketEditableView];
    [self initStatusPicker];
}

-(void)viewWillAppear:(BOOL)animated {
    [self reload];
    
    [super viewWillAppear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initScrollView {
    _scrollView.contentSize = CGSizeMake(320*self.data.count, [_scrollView height]);
}

-(void)initPageControl {
    [_pageControl setOriginY:[_scrollView height] - 10];
    
    _pageControl.numberOfPages = self.data.count;
    _pageControl.currentPage = self.pageNo;
    
    [self.scrollView setContentOffset:CGPointMake(_pageControl.currentPage * SCREEN_WIDTH, 0) animated:NO];
}

-(void)initRightBarButton {
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    UIBarButtonItem * addButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    [addButton addTarget:self action:@selector(addBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = addButtonItem;
}

-(void)initDataFromDB {
    self.data = [SSNTTicketService getTicketByType:self.type];
}

-(void)initDataView {
    if (self.data.count <= 0) {
        return;
    }
    
    if (self.dataView == nil) {
        self.dataView = [NSMutableArray arrayWithCapacity:3];
        
        for (int i=0; i<3; i++) {
            SSNTTicketView *ticketView = [[[SSNTTicketView alloc]initWithFrame:CGRectMake(320., 0., SCREEN_WIDTH, [_scrollView height])]autorelease];
            
            ticketView.hidden = YES;
            [self.dataView addObject:ticketView];
            [_scrollView addSubview:ticketView];
        }
        
    }
    
    for (int i = 0; i<3; i++) {
        SSNTTicketView *ticketView = [self.dataView objectAtIndex:i];
        ticketView.hidden = YES;
    }
    
    int j = 0;
    for (int i = self.pageControl.currentPage - 1; i < self.pageControl.currentPage + 2; i++) {
        // 边界控制
        if (i < 0) {
            continue;
        }
        if (i >= self.data.count) {
            break;
        }
        
        SSNTTicketView *ticketView = [self.dataView objectAtIndex:j];
        [ticketView setFrame:CGRectMake((i)*320., 0., 320, [_scrollView height]) data:[self.data objectAtIndex:i]];
        ticketView.tag = i;
        ticketView.delegate = self;
        ticketView.editCallBack = @selector(editTicket:);
        ticketView.hidden = NO;
        
        j++;
    }
}

-(void)initNoDataView {
    if (self.noDataView == nil) {
        self.noDataView = [[[SSNTNoDataView alloc]initWithFrame:self.view.frame]autorelease];
        [self.noDataView.addButton addTarget:self action:@selector(addBtnPress) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.noDataView];
    }
    
    self.noDataView.hidden = YES;
}

-(void)initTicketEditableView {
    if (self.ticketEditableView == nil) {
        self.ticketEditableView = [[SSNTTicketEditableView alloc]initWithFrame:self.view.frame];
        self.ticketEditableView.delegate = self;
        self.ticketEditableView.returnCallBack = @selector(editReturn);
        self.ticketEditableView.cancelCallBack = @selector(cancelEdit:);
        
        [self.view addSubview:self.ticketEditableView];
    }
    
    self.ticketEditableView.hidden = YES;
}

-(void)initStatusPicker {
    UIControl *titleMask = [[[UIControl alloc]initWithFrame:CGRectMake(0, 0, 200, 44)]autorelease];
    titleMask.backgroundColor = [UIColor clearColor];
    [titleMask addTarget:self action:@selector(showStatusPicker) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *title = [[UILabel alloc]initWithFrame:titleMask.frame];
    title.text = @"全部(点击筛选)";
    title.font = [UIFont boldSystemFontOfSize:20];
    title.textAlignment = UITextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    
    self.statusTitleLabel = title;
    [titleMask addSubview:title];
    self.navigationItem.titleView = titleMask;
//    [self.navigationItem.titleView addSubview:titleMask];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"offset : %f",scrollView.contentOffset.x);

//    if ((_pageControl.currentPage - 1) < 0) {
//        return;
//    }
    
    CGFloat preOffset = SCREEN_WIDTH * (_pageControl.currentPage - 1);
    CGFloat nextOffset = SCREEN_WIDTH * (_pageControl.currentPage + 1);
    
    NSLog(@"now offset : %f",scrollView.contentOffset.x);
    NSLog(@"pre offset : %f",preOffset);
    NSLog(@"next offset : %f",nextOffset);
    
    if (scrollView.contentOffset.x < nextOffset && scrollView.contentOffset.x > preOffset) {
        return;
    }
    
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    _pageControl.currentPage = index;
    [self initDataView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Method
-(void)addBtnPress {
    self.pageNo = 0;
    
    NSString *type = @"";
    if (![self.type isEqualToString:@"已过期"]) {
        type = self.type;
    }
    [self.ticketEditableView setData:nil withType:type];
    [self showTicketEditableView];
}

-(void)showTicketEditableView {
    self.ticketEditableView.hidden = NO;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"确定"style:UIBarButtonItemStylePlain target:self action:@selector(endEdit:)]autorelease];

}

-(void)hideTicketEditableView {
    self.ticketEditableView.hidden = YES;
    [self initRightBarButton];
}

-(void)showNoDataView {
    if (self.type.length <= 0) {
        self.noDataView.messageLabel.text = @"还没有网票哦";
        [self.noDataView.addButton setTitle:@"赶紧体验一下吧" forState:UIControlStateNormal];
    }else if ([self.type isEqualToString:@"其他"] || [self.type isEqualToString:@"已过期"]) {
        self.noDataView.messageLabel.text = @"没有找到相应数据哦";
        [self.noDataView.addButton setTitle:@"创建一个" forState:UIControlStateNormal];
    }else {
        self.noDataView.messageLabel.text = [NSString stringWithFormat:@"没有找到[%@]哦",self.type];
        [self.noDataView.addButton setTitle:@"赶紧创建一个吧" forState:UIControlStateNormal];
    }
    self.noDataView.hidden = NO;
}

-(void)hideNoDataView {
    self.noDataView.hidden = YES;
}

-(void)editReturn {
    [self reload];
    [self initRightBarButton];
}

-(void)reload {
    [self.loadingView showLoadingView];
    [self initDataFromDB];
    
    if (self.data.count > 0) {
        [self hideNoDataView];
        [self initScrollView];
        [self initPageControl];
        [self initDataView];
        
    }else {
        [self showNoDataView];
    }
    [self.loadingView hideLoadingView];
    
//    [self initRightBarButton];
}

-(void)editTicket:(UIControl*)sender {    
    [self.ticketEditableView setData:[self.data objectAtIndex:self.pageControl.currentPage] withType:nil];
    self.pageNo = self.pageControl.currentPage;
    [self showTicketEditableView];
}

-(void)endEdit:(id)sender {
    [self.ticketEditableView saveUpdate];
    [self hideTicketEditableView];
    [self reload];
}

-(void)cancelEdit:(id)sender {
    [self initRightBarButton];
//    _pageControl.currentPage = self.pageNo;
}

-(void)showStatusPicker {
    UIActionSheet *statusPicker = [[[UIActionSheet alloc]initWithTitle:@"筛选" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"全部" otherButtonTitles:@"电影票",@"优惠券",@"机票/车票",@"会员卡",@"其他",@"已过期" ,nil]autorelease];
    
    [statusPicker showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];

    // click cancel or same status with now
    if (actionSheet.cancelButtonIndex == buttonIndex || [self.statusTitleLabel.text isEqualToString:[self genStatusTitle:title]]) {
        return;
    }
    
    [self setStatusTitle:title];
    
    // 如果点击全部，清空状态
    if (actionSheet.destructiveButtonIndex == buttonIndex) {
        title = nil;
    }
    
    self.type = title;
    [self reload];
}

-(void)setStatusTitle :(NSString*)title {
    self.statusTitleLabel.text = [self genStatusTitle:title];
}

-(NSString*)genStatusTitle:(NSString*)title {
    if (title.length <= 0) {
        return @"全部(点击筛选)";
    }else {
        return [NSString stringWithFormat:@"%@(点击筛选)",title];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Mail&Message Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
        {
            [[SSToastView MakeToastWithType:TOAST_STYLE_SUCC info:@"已经保存为草稿^_^!"]show];
        }
			break;
		case MFMailComposeResultSent:
        {
            [[SSToastView MakeToastWithType:TOAST_STYLE_SUCC info:@"发送成功^_^!"]show];
        }
			break;
		case MFMailComposeResultFailed:
			break;
		default:
			break;
	}
    [self dismissModalViewControllerAnimated:YES];
    //	[self setFrame4Ad];
    //    [self reSet4BellowIOS5OnCloseModal];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultSent:
        {
            [[SSToastView MakeToastWithType:TOAST_STYLE_SUCC info:@"发送成功^_^！"] show];
        }
            break;
            
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
//    [self setFrame4Ad];
}
@end

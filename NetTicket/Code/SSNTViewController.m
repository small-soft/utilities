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

@interface SSNTViewController () <UIScrollViewDelegate>

@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UIPageControl *pageControl;

@property(nonatomic,retain) NSArray *data;
@property(nonatomic,retain) NSMutableArray *dataView;

@property(nonatomic,retain) SSNTTicketEditableView *ticketEditableView;
@end

@implementation SSNTViewController
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize ticketEditableView = _ticketEditableView;
@synthesize data = _data;
@synthesize dataView = _dataView;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory Management
-(void)dealloc {
    self.scrollView = nil;
    self.pageControl = nil;
    self.ticketEditableView = nil;
    self.dataView = nil;
    self.data = nil;
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
    [self initTicketEditableView];
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
    _pageControl.currentPage = 0;
}

-(void)initRightBarButton {
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    UIBarButtonItem * addButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    [addButton addTarget:self action:@selector(addBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = addButtonItem;
}

-(void)initDataFromDB {
    self.data = [SSNTTicketService getTicketByType:nil];
}

-(void)initDataView {
    if (self.data.count <= 0) {
        return;
    }
    
    if (self.dataView == nil) {
        self.dataView = [NSMutableArray arrayWithCapacity:self.dataView.count];
    }
    
    // remove all
//    for (int i = 0; i<self.dataView.count; i++) {
//        SSNTTicketView *ticketView = [self.dataView objectAtIndex:i];
//        
//        [ticketView removeFromSuperview];
//    }
    
    for (int i = 0; i < self.data.count; i++) {
        SSNTTicketView *ticketView = nil;
        if (self.dataView.count > i) {
            ticketView = [self.dataView objectAtIndex:i];
            [ticketView setFrame:CGRectMake((i)*320., 0., 320, [_scrollView height]) data:[self.data objectAtIndex:i]];
        }else{
            ticketView = [[[SSNTTicketView alloc]initWithFrame:CGRectMake(320., 0., SCREEN_WIDTH, [_scrollView height])]autorelease];
            
            SSNTTicketView *view = ticketView;
            [view setFrame:CGRectMake((i)*320., 0., 320, [_scrollView height]) data:[self.data objectAtIndex:i]];
            ticketView.tag = i;
            view.delegate = self;
            view.editCallBack = @selector(editTicket:);
            
            [self.dataView addObject:ticketView];
            [_scrollView addSubview:ticketView];
        }
        
        
        
    }
}

-(void)initTicketEditableView {
    if (self.ticketEditableView == nil) {
        self.ticketEditableView = [[SSNTTicketEditableView alloc]initWithFrame:self.view.frame];
        self.ticketEditableView.delegate = self;
        self.ticketEditableView.returnCallBack = @selector(reload);
        
        [self.view addSubview:self.ticketEditableView];
    }
    
    self.ticketEditableView.hidden = YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    _pageControl.currentPage = index;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Method
-(void)addBtnPress {
    [self.ticketEditableView setData:nil];
    [self showTicketEditableView];
}

-(void)showTicketEditableView {
    self.ticketEditableView.hidden = NO;
}

-(void)hideTicketEditableView {
    self.ticketEditableView.hidden = YES;
}

-(void)reload {
    [self initDataFromDB];
    
    if (self.data.count > 0) {
        [self initDataView];
        [self initScrollView];
        [self initPageControl];
    }else {
        [self.ticketEditableView setData:nil];
        [self showTicketEditableView];
    }
}

-(void)editTicket:(UIControl*)sender {    
    [self.ticketEditableView setData:[self.data objectAtIndex:sender.tag]];
    
    [self showTicketEditableView];
}
@end

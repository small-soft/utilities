//
//  SSDQSendDeliveryViewController.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-25.
//
//

#import "SSDQSendDeliveryViewController.h"
#import "SSDQDeliveryCompanyListCell.h"
#import "SSDQDeliveryCompany.h"
#import "SSDQCompanyDetailViewController.h"
#import "UIView+UIViewUtil.h"

@interface SSDQSendDeliveryViewController ()

@property(nonatomic,retain) IBOutlet UITableView *contentTable;
@property(nonatomic,retain) NSDictionary *data;

@end

@implementation SSDQSendDeliveryViewController
@synthesize contentTable = _contentTable;
@synthesize data = _data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData {
    SSDQDeliveryCompany *yuantong = [[SSDQDeliveryCompany alloc]init];
    yuantong.code = @"yuantong";
    yuantong.name = @"圆通速递";
    yuantong.phone = @"021-69777888";
    
    SSDQDeliveryCompany *yunda = [[SSDQDeliveryCompany alloc]init];
    yunda.code = @"yunda";
    yunda.name = @"韵达快运";
    yunda.phone = @"400-821-6789";
    
    SSDQDeliveryCompany *shentong = [[SSDQDeliveryCompany alloc]init];
    shentong.code = @"shentong";
    shentong.name = @"申通快递";
    shentong.phone = @"400-889-5543";
    
    SSDQDeliveryCompany *zhongtong = [[SSDQDeliveryCompany alloc]init];
    zhongtong.code = @"zhongtong";
    zhongtong.name = @"中通速递";
    zhongtong.phone = @"021-39777777";
    
    SSDQDeliveryCompany *zhaijisong = [[SSDQDeliveryCompany alloc]init];
    zhaijisong.code = @"zhaijisong";
    zhaijisong.name = @"宅急送";
    zhaijisong.phone = @"400-6789-000";
    
    SSDQDeliveryCompany *shunfeng = [[SSDQDeliveryCompany alloc]init];
    shunfeng.code = @"shunfeng";
    shunfeng.name = @"顺丰速递";
    shunfeng.phone = @"400-811-1111";
    
    SSDQDeliveryCompany *ems = [[SSDQDeliveryCompany alloc]init];
    ems.code = @"ems";
    ems.name = @"EMS";
    ems.phone = @"11183";
    
    SSDQDeliveryCompany *youzhengguonei = [[SSDQDeliveryCompany alloc]init];
    youzhengguonei.code = @"youzhengguonei";
    youzhengguonei.name = @"中国邮政";
    youzhengguonei.phone = @"11185";
    
    SSDQDeliveryCompany *ztky = [[SSDQDeliveryCompany alloc]init];
    ztky.code = @"ztky";
    ztky.name = @"中铁快运(铁路)";
    ztky.phone = @"95572";
    
    SSDQDeliveryCompany *youzhengguoji = [[SSDQDeliveryCompany alloc]init];
    youzhengguoji.code = @"youzhengguoji";
    youzhengguoji.name = @"邮政国际";
    youzhengguoji.phone = @"11185";
    
    SSDQDeliveryCompany *tiantian = [[SSDQDeliveryCompany alloc]init];
    tiantian.code = @"tiantian";
    tiantian.name = @"天天快递";
    tiantian.phone = @"400-820-8198";
    
    SSDQDeliveryCompany *fedex = [[SSDQDeliveryCompany alloc]init];
    fedex.code = @"fedex";
    fedex.name = @"Fedex";
    fedex.phone = @"400-886-1888";
    
    SSDQDeliveryCompany *emsen = [[SSDQDeliveryCompany alloc]init];
    emsen.code = @"emsen";
    emsen.name = @"EMS国际";
    emsen.phone = @"11183";
    
    SSDQDeliveryCompany *shunfengen = [[SSDQDeliveryCompany alloc]init];
    shunfengen.code = @"shunfengen";
    shunfengen.name = @"顺风国际";
    shunfengen.phone = @"400-811-1111";
    
    SSDQDeliveryCompany *ups = [[SSDQDeliveryCompany alloc]init];
    ups.code = @"ups";
    ups.name = @"UPS";
    ups.phone = @"800-275-8777";
    
    NSArray *cheaps = [NSArray arrayWithObjects: shentong,yuantong,yunda,zhongtong,tiantian,nil];
    
    NSArray *quicks = [NSArray arrayWithObjects:shunfeng,zhaijisong, nil];
    
    NSArray *areas = [NSArray arrayWithObjects:ems,youzhengguonei,ztky, nil];
    
    NSArray *mails = [NSArray arrayWithObjects:youzhengguonei, nil];
    
    NSArray *inter = [NSArray arrayWithObjects:youzhengguoji,fedex,emsen,shunfengen,ups, nil];
    
    NSArray *big = [NSArray arrayWithObjects:ztky, nil];
    
    self.data = [NSDictionary dictionaryWithObjectsAndKeys:cheaps,@"性价比高",quicks,@"快速|安全|价格稍高",areas,@"网点广|偏远地区|稍慢",mails,@"信件|挂号信",inter,@"国际快递|跨国",big,@"大件|重件", nil];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *keys = [self.data allKeys];
    return [keys objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *keys = [self.data allKeys];
    return [[self.data objectForKey:[keys objectAtIndex:section]] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSDQDeliveryCompanyListCell *cell = [tableView dequeueReusableCellWithIdentifier:[SSDQDeliveryCompanyListCell cellIdentifer]];
    if (cell == nil) {
        cell = [SSDQDeliveryCompanyListCell createCell:nil];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSArray *keys = [self.data allKeys];
    NSArray *companys =  [self.data objectForKey:[keys objectAtIndex:indexPath.section]];
    
    cell.company = [companys objectAtIndex:indexPath.row];
    [cell setupView];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SSDQDeliveryCompanyListCell cellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.data allKeys] count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *keys = [self.data allKeys];
    NSArray *companys =  [self.data objectForKey:[keys objectAtIndex:indexPath.section]];
    SSDQCompanyDetailViewController *detail = [[[SSDQCompanyDetailViewController alloc]init]autorelease];
    
    detail.company = [companys objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detail animated:YES];
}

@end

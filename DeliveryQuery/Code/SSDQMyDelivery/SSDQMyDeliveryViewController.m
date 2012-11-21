//
//  SSDQMyDeliveryViewController.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-18.
//
//

#import "SSDQMyDeliveryViewController.h"
#import "FMDatabase.h"
#import "SSQUAppDelegate.h"
#import "SSDQDeliveryQueryResultViewController.h"
#import "SSDQDeliveryQueryResult.h"
#import "SSDQMyDeliveryCell.h"

@interface SSDQMyDeliveryViewController ()

@property(nonatomic,retain) IBOutlet UITableView *contentTable;
@property(nonatomic,retain) NSMutableArray *data;

@end

@implementation SSDQMyDeliveryViewController
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadDB];
    
    [super viewWillAppear:animated];
}

-(void)loadDB{
    self.data = [[NSMutableArray alloc]init];
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSMutableString *sql = [NSMutableString stringWithString: @"SELECT * from DeliveryQueryHistoryMain"];
        
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {

            SSDQDeliveryResult *result = [[[SSDQDeliveryResult alloc]init]autorelease];
            result.id = [rs intForColumn:@"id"];
            result.expTextName = [rs stringForColumn:@"companyName"];
            result.expSpellName = [rs stringForColumn:@"companyCode"];
            result.mailNo = [rs stringForColumn:@"deliveryNumber"];
            result.status = [rs intForColumn:@"status"];
            result.latestContext = [rs stringForColumn:@"latestContext"];
            result.sendTime = [rs stringForColumn:@"sendTime"];
            result.signTime = [rs stringForColumn:@"signTime"];
            result.companyPhone = [rs stringForColumn:@"companyPhone"];
            
            [self.data addObject:result];
        }
    }
    
    
    [db close];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSDQMyDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:[SSDQMyDeliveryCell cellIdentifer]];
    
    if (cell == nil) {
        cell = [SSDQMyDeliveryCell createCell:nil];
    }
    
    cell.result = [self.data objectAtIndex:indexPath.row];
    [cell setupView];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSDQDeliveryQueryResultViewController *dqr = [[[SSDQDeliveryQueryResultViewController alloc]init]autorelease];
    dqr.title = @"快递详情";
    
    SSDQDeliveryResult *result = [self.data objectAtIndex:indexPath.row];
    
    dqr.companyCode = result.expSpellName;
    dqr.deliveryNumber = result.mailNo;
    
    [self.navigationController pushViewController:dqr animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SSDQMyDeliveryCell cellHeight];
}
@end

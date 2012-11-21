//
//  SSDQAllDeliveryCompanyListViewController.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-10.
//
//

#import "SSDQAllDeliveryCompanyListViewController.h"
#import "FMDatabase.h"
#import "SSDQDeliveryCompany.h"
#import "SSDQDeliveryCompanyListCell.h"
#import "SSDQDeliveryQueryViewController.h"
#import "SSQUAppDelegate.h"

@interface SSDQAllDeliveryCompanyListViewController ()

#pragma mark -
#pragma mark ib
@property(nonatomic,retain) IBOutlet UITableView *contentTable;

#pragma mark -
#pragma mark attr
@property(nonatomic,retain) NSMutableArray *data;

@end

@implementation SSDQAllDeliveryCompanyListViewController
@synthesize contentTable = _contentTable;
@synthesize data = _data;
@synthesize displayMode = _displayMode;
@synthesize contentMode = _contentMode;

-(void)dealloc{
    self.contentTable = nil;
    self.data = nil;
    [super dealloc];
}
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"常用" style:UIBarButtonItemStylePlain target:self action:@selector(switchContent)];
    
    [self loadDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadDB{
    self.data = [[NSMutableArray alloc]init];
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSMutableString *sql = [NSMutableString stringWithString: @"SELECT * from DeliveryCompany"];
        if (self.contentMode == DeliverCompanyListContentModeFavOnly) {
            [sql appendString:@" where isFavorite = 1"];
        }
        
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            SSDQDeliveryCompany *company = [[[SSDQDeliveryCompany alloc]init]autorelease];
            company.name = [[rs stringForColumn:@"name"] copy];
            company.code = [[rs stringForColumn:@"code"] copy];
            company.isFavorite = [rs intForColumn:@"isFavorite"] > 0;
            company.site = [[rs stringForColumn:@"site"] copy];
            company.phone = [[rs stringForColumn:@"phone"] copy];
            
            [self.data addObject:company];
        }
    }
    
    
    [db close];
}

#pragma mark -
#pragma mark table delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSDQDeliveryCompanyListCell *cell = [tableView dequeueReusableCellWithIdentifier:[SSDQDeliveryCompanyListCell cellIdentifer]];
    if (cell == nil) {
        cell = [SSDQDeliveryCompanyListCell createCell:nil];
        if (cell.backgroundView == nil) {
            cell.backgroundView = [[[UIView alloc]init]autorelease];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.backgroundView.backgroundColor = [UIColor whiteColor];
    cell.backgroundView.alpha = 1;
    if (indexPath.row%2 == 0) {
        
        cell.backgroundView.backgroundColor = [UIColor grayColor];
        cell.backgroundView.alpha = 0.1;
    }
    
    cell.company = [self.data objectAtIndex:indexPath.row];
    [cell setupView];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.displayMode) {
        case 0:
            
            break;
        case 1:{
            NSInteger i = [[self.navigationController viewControllers] count] -2;
            SSDQDeliveryQueryViewController *qv = [[self.navigationController viewControllers] objectAtIndex:i];
            qv.company = [self.data objectAtIndex:indexPath.row];
            
            [self.navigationController popToViewController:qv animated:YES];
        }
            
            break;
        default:
            break;
    }
}

-(void)switchContent {
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"常用"]) {
        self.contentMode = DeliverCompanyListContentModeFavOnly;
        self.navigationItem.rightBarButtonItem.title = @"全部";
    }else{
        self.contentMode = DeliverCompanyListContentModeAll;
        self.navigationItem.rightBarButtonItem.title = @"常用";
    }
    
    [self loadDB];
    [self.contentTable reloadData];
}
@end

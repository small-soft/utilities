//
//  SSDQDeliveryQueryResultViewController.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-15.
//
//

#import "SSDQDeliveryQueryResultViewController.h"
#import "FMDatabase.h"
#import "SSDQDeliveryQueryResult.h"
#import "SSQUAppDelegate.h"

@interface SSDQDeliveryQueryResultViewController ()

@property(nonatomic,retain) IBOutlet UILabel *manInfo;
@end

@implementation SSDQDeliveryQueryResultViewController
@synthesize manInfo = _manInfo;
@synthesize result = _result;
@synthesize companyCode = _companyCode;
@synthesize deliveryNumber = _deliveryNumber;

-(void)dealloc{
    self.manInfo = nil;
    self.result = nil;
    self.companyCode = nil;
    self.deliveryNumber = nil;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadDB];
    
    self.manInfo.text = self.result.expTextName;
}

-(void)viewDidUnload {
    [_manInfo release];
    [_result release];
    [_companyCode release];
    [_deliveryNumber release];
    
    [super viewDidUnload];
}

-(void)loadDB{
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSMutableString *sql = [NSMutableString stringWithString: @"SELECT * from DeliveryQueryHistoryMain"];
        
        if (self.companyCode.length == 0 || self.deliveryNumber.length == 0) {
            return;
        }
        
        [sql appendFormat:@" where companyCode = '%@' and deliveryNumber = '%@'",self.companyCode,self.deliveryNumber];
        
        NSLog(@"execute sql:%@",sql);
        
        FMResultSet *rs = [db executeQuery:sql];
        
        if ([rs next]) {
            SSDQDeliveryResult *result = [[[SSDQDeliveryResult alloc]init]autorelease];
            result.id = [rs intForColumn:@"id"];
            result.expTextName = [[rs stringForColumn:@"companyName"] copy];
            result.expSpellName = [[rs stringForColumn:@"companyCode"] copy];
            result.mailNo = [[rs stringForColumn:@"deliveryNumber"] copy];
            result.status = [NSNumber numberWithInt:[rs intForColumn:@"status"]];
            
            FMResultSet *items = [db executeQuery:[NSString stringWithFormat:@"SELECT * from DeliveryQueryHistoryItems where mainId = %d",result.id]];
            
            result.data = [NSMutableArray arrayWithCapacity:[items columnCount]];
            while ([items next]) {
                SSDQDeliveryItem *item = [[[SSDQDeliveryItem alloc]init]autorelease];
                item.time = [[items stringForColumn:@"time"] copy];
                item.context = [[items stringForColumn:@"context"] copy];
                
                [result.data addObject:item];
            }
            
            self.result = result;
            
        }
    }
    
    
    [db close];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1234"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"1234"]autorelease];
    }
    
    SSDQDeliveryItem *item = (SSDQDeliveryItem*)[self.result.data objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.time;
    cell.detailTextLabel.text = item.context;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.result == nil || self.result.data == nil) {
        return 0;
    }
    
    return [self.result.data count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

@end

//
//  SSSNFavoritesViewController.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-7.
//
//

#import "SSSNFavoritesViewController.h"
#import "FMDatabase.h"
#import "SSQUAppDelegate.h"
#import "SSSNSites.h"
#import "SSFullWebViewController.h"
#import "NSDate+DateUtil.h"

@interface SSSNFavoritesViewController ()

@property(nonatomic,retain) NSMutableArray *data;
@property(nonatomic,retain) IBOutlet UITableView *contentTable;

@end

@implementation SSSNFavoritesViewController
@synthesize data = _data;
@synthesize contentTable = _contentTable;

-(void)dealloc {
    self.data = nil;
    self.contentTable = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的收藏";
        self.tabBarItem.image = [UIImage imageNamed:@"heart"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadDB];
    [self.contentTable reloadData];
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDB{
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSMutableString *sql = [NSMutableString stringWithString: @"SELECT * from SNFav"];
        
        //        if (self.hasUpdate) {
        //            [sql appendString: @" where hasUpdate=1 "];
        //        }else if (self.statusArray && [self.statusArray count] >0) {
        //            [sql appendString: @" where 1=1 "];
        //
        //            for (int i=0; i<[self.statusArray count]; i++) {
        //                NSString *andOr = @"or";
        //                if (i == 0) {
        //                    andOr = @"and";
        //                }
        //
        //                SSDQDeliveryResultStatus s = [(NSNumber*)[self.statusArray objectAtIndex:i] intValue];
        //                [sql appendFormat:@" %@ status = %d",andOr,s];
        //            }
        //        }
        
        [sql appendString:@" order by id desc"];
        NSLog(@"execute sql:%@",sql);
        
        FMResultSet *rs = [db executeQuery:sql];
        
        self.data = [NSMutableArray arrayWithCapacity:8];
        
        while ([rs next]) {
            
            SSFav *fav = [[[SSFav alloc]init]autorelease];
            fav.id = [rs intForColumn:@"id"];
            fav.title = [rs stringForColumn:@"title"];
            fav.catName = [rs stringForColumn:@"catName"];
            fav.cat = [rs intForColumn:@"cat"];
            fav.date = [NSDate dateWithTimeIntervalSince1970:[rs doubleForColumn:@"date"]];
            fav.url = [rs stringForColumn:@"url"];
            
            [self.data addObject:fav];
        }
        
    }
    
    if (self.data == nil || self.data.count <= 0) {
        [self.loadingView hasToolBar];
        [self.loadingView showNoDataView];
    }else{
        [self.loadingView hideNoDataView];
    }
    
    [db close];
}

#pragma mark -
#pragma mark table view
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SSSNFC"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SSSNFC"]autorelease];
    }
    
    SSFav *fav = [self.data objectAtIndex:indexPath.row];
    cell.textLabel.text = fav.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)%@",[fav.date getDateStringForTodayYesterday],fav.url];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SSFav *fav = [self.data objectAtIndex:indexPath.row];
    
    SSFullWebViewController *controller = [[[SSFullWebViewController alloc]init]autorelease];
    controller.url = [NSURL URLWithString:fav.url];
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

@end

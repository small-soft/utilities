//
//  SSSNFavoritesViewController.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-7.
//
//

#import "SSSNHistoryViewController.h"
#import "FMDatabase.h"
#import "SSQUAppDelegate.h"
#import "SSSNSites.h"
#import "SSFullWebViewController.h"
#import "NSDate+DateUtil.h"
#import "SSSNHistoryCell.h"

@interface SSSNHistoryViewController ()

@property(nonatomic,retain) IBOutlet UITableView *contentTable;
@property(nonatomic,retain) NSMutableDictionary *groupData;
@property(nonatomic,retain) NSArray *sectionArray;
@property(nonatomic,retain) NSMutableArray *changeIndexArray;
@property(nonatomic,retain) NSString *keyword;
@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;

@end

@implementation SSSNHistoryViewController
@synthesize contentTable = _contentTable;
@synthesize groupData = _groupData;
@synthesize sectionArray = _sectionArray;
@synthesize changeIndexArray = _changeIndexArray;
@synthesize mainTableName = _mainTableName;
@synthesize keyword = _keyword;
@synthesize searchBar = _searchBar;

-(void)dealloc {
    self.contentTable = nil;
    self.groupData = nil;
    self.changeIndexArray = nil;
    self.sectionArray = nil;
    self.mainTableName = nil;
    self.keyword = nil;
    self.searchBar = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"访问历史";
        self.mainTableName = @"SNHistory";
        self.tabBarItem.image = [UIImage imageNamed:@"clock"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initGroupData];
    SET_GRAY_BG(self);
    
    self.sectionArray = [NSArray arrayWithObjects:@"今天",@"昨天",@"一周内",@"一个月内",@"早些时候", nil];
    self.changeIndexArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES], nil];
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
        NSMutableString *sql = [NSMutableString stringWithFormat: @"SELECT * from %@",self.mainTableName];
        
        if (self.keyword.length > 0) {
            [sql appendFormat:@" where title like '%%%@%%' or url like '%%%@%%'",self.keyword,self.keyword];
        }
        
        [sql appendString:@" order by id desc LIMIT 500"];
        NSLog(@"execute sql:%@",sql);
        
        FMResultSet *rs = [db executeQuery:sql];
                
        NSMutableArray *today = [NSMutableArray arrayWithCapacity:20];
        NSMutableArray *yestoday = [NSMutableArray arrayWithCapacity:20];
        NSMutableArray *inWeek = [NSMutableArray arrayWithCapacity:20];
        NSMutableArray *inMonth = [NSMutableArray arrayWithCapacity:20];
        NSMutableArray *farAway = [NSMutableArray arrayWithCapacity:20];
        
        while ([rs next]) {
            
            SSFav *fav = [[[SSFav alloc]init]autorelease];
            fav.id = [rs intForColumn:@"id"];
            fav.title = [rs stringForColumn:@"title"];
//            fav.catName = [rs stringForColumn:@"catName"];
//            fav.cat = [rs intForColumn:@"cat"];
            fav.date = [NSDate dateWithTimeIntervalSince1970:[rs doubleForColumn:@"date"]];
            fav.url = [rs stringForColumn:@"url"];
            
            switch ([fav.date compareWith:[NSDate date]]) {
                case NSDateUtilCompareResultSameDay:
                {
                    [today addObject:fav];
                }
                    
                    break;
                case NSDateUtilCompareResultBeforeDay:
                {
                    [yestoday addObject:fav];
                }
                    
                    break;
                case NSDateUtilCompareResultInWeek:
                {
                    [inWeek addObject:fav];
                }
                    
                    break;
                    
                case NSDateUtilCompareResultInMonth:
                {
                    [inMonth addObject:fav];
                }
                    
                    break;
                default:
                {
                    [farAway addObject:fav];
                }
                    break;
            }
            
        }
        
        [self.groupData setObject:today forKey:[self.sectionArray objectAtIndex:0]];
        [self.groupData setObject:yestoday forKey:[self.sectionArray objectAtIndex:1]];
        [self.groupData setObject:inWeek forKey:[self.sectionArray objectAtIndex:2]];
        [self.groupData setObject:inMonth forKey:[self.sectionArray objectAtIndex:3]];
        [self.groupData setObject:farAway forKey:[self.sectionArray objectAtIndex:4]];
    }
    
    
    [db close];
}

#pragma mark -
#pragma mark table view
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSArray *array = [self dataAtSection:indexPath.section];
    NSNumber *n = [self.changeIndexArray objectAtIndex:indexPath.section];
    BOOL isDisplay = [n boolValue];
    
    if (!isDisplay) {
        UITableViewCell *opCell = [tableView dequeueReusableCellWithIdentifier:@"SSSNHSOPC"];
        
        if (opCell == nil) {
            opCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SSSNHSOPC"];
        }
        
        
        opCell.textLabel.text = @"点击展开";
        opCell.detailTextLabel.text = [NSString stringWithFormat:@"%d条记录",array.count];
        return opCell;
    }
    
    SSSNHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:[SSSNHistoryCell cellIdentifer]];
    
    if (cell == nil) {
        cell = [SSSNHistoryCell createCell];
    }
    
    SSFav *fav = [[self dataAtSection:indexPath.section] objectAtIndex:indexPath.row];
//    cell.textLabel.text = fav.title;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)%@",[fav.date getDateStringForTodayYesterday],fav.url];
//    cell.acce ssoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    [cell cellData:fav];
    cell.delBtn.params = [NSMutableArray arrayWithObject:indexPath];
    [cell.delBtn addTarget:self action:@selector(deleteRow:) forControlEvents:UIControlEventTouchUpInside];
    
//    cell.accessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *n = [self.changeIndexArray objectAtIndex:indexPath.section];
    BOOL isDisplay = [n boolValue];
    
    if (!isDisplay)  {
        [self changeDisplayWithTag:indexPath.section];
        return;
    }
    
    SSFav *fav = [self getByIndexPath:indexPath];
    
    SSFullWebViewController *controller = [[[SSFullWebViewController alloc]init]autorelease];
    controller.url = [NSURL URLWithString:fav.url];
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSNumber *n = [self.changeIndexArray objectAtIndex:section];
    BOOL isDisplay = [n boolValue];
    
    if (!isDisplay) {
        return 1;
    }
    
    NSArray *array = [self.groupData objectForKey:[self.sectionArray objectAtIndex:section]];
    
    return array.count;
}

-(void)initGroupData{
    self.groupData = [NSMutableDictionary dictionaryWithCapacity:5];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupData.count;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self.sectionArray objectAtIndex:section];
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
//    
////    
//    
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *array = [self dataAtSection:section];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 34)];
    
    UIControl *mask = [[UIControl alloc]initWithFrame:view.frame];
    mask.backgroundColor = [UIColor clearColor];
    
    mask.tag = section;
    [mask addTarget:self action:@selector(changeDisplady:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 9, 320, 17)];
    label.text = [NSString stringWithFormat:@"%@(%d)",[self.sectionArray objectAtIndex:section],array.count];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGB(0x33, 0x66, 0x66);
    label.font = [UIFont boldSystemFontOfSize:17];
    
    [view addSubview:label];
    [view addSubview:mask];
    
    return view;
}

-(void)changeDisplady:(UIControl*)sender{
    [self changeDisplayWithTag:sender.tag];
    
}

-(void)changeDisplayWithTag:(int)tag{
    NSArray *array = [self dataAtSection:tag];
    if (array == nil || array.count <= 0) {
        return;
    }
    
    NSNumber *n = [self.changeIndexArray objectAtIndex:tag];
    BOOL isDisplay = [n boolValue];
    
    [self.changeIndexArray replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:!isDisplay]];
    
    [self.contentTable reloadData];
}

-(NSMutableArray*)dataAtSection:(NSInteger)section{
    
    return [self.groupData objectForKey:[self.sectionArray objectAtIndex:section]];;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)deleteRow:(SSButton*)sender{
    NSIndexPath *indexPath = [sender.params objectAtIndex:0];
    
    NSNumber *n = [self.changeIndexArray objectAtIndex:indexPath.section];
    BOOL isDisplay = [n boolValue];
    
    if (!isDisplay)  {
        [self changeDisplayWithTag:indexPath.section];
        return;
    }
    
    NSMutableArray *favs = [self dataAtSection:indexPath.section];
    
    SSFav *fav = [favs objectAtIndex:indexPath.row];
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat: @"delete from %@ where id = %d",self.mainTableName,fav.id];
        
        NSLog(@"exeSql:%@,deleteResult:%d",sql ,[db executeUpdate:sql]);
    }
    
    [db close];
    
    [favs removeObjectAtIndex:indexPath.row];
    [self.contentTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.contentTable performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

-(SSFav*)getByIndexPath:(NSIndexPath*)indexPath{
    NSMutableArray *favs = [self dataAtSection:indexPath.section];
    
    SSFav *fav = [favs objectAtIndex:indexPath.row];
    
    return fav;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.keyboardToolBar HiddenKeyBoard];
    
    self.keyword = searchBar.text;
    [self reload];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.keyword = searchBar.text;
    [self reload];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.keyboardToolBar HiddenKeyBoard];
    self.searchBar.text = @"";
    self.keyword = nil;
    [self reload];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    self.keyboardToolBar.type = SSKeyboardToolBarTypeURL;
    [self.keyboardToolBar showBar:searchBar];
    
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.keyword = searchBar.text;
    
    [self reload];
}

-(void)reload{
    [self loadDB];
    [self.contentTable reloadData];
}
@end

//
//  SSSNHotSitesViewController.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-7.
//
//

#import "SSSNHotSitesViewController.h"
#import "SSFullWebViewController.h"
#import "UIView+UIViewUtil.h"
#import "SSKeyboardToolBar.h"
#import "SSSNHostSitesCell.h"
#import "FMDatabase.h"
#import "SSQUAppDelegate.h"
#import "SSSNSites.h"

@interface SSSNHotSitesViewController ()

@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;
@property(nonatomic,retain) IBOutlet UITextField *urlTextField;

@property(nonatomic,retain) IBOutlet UITableView *contentTable;

@property(nonatomic,retain) NSMutableArray *data;
@property(nonatomic,retain) NSMutableArray *bigCats;

@property(nonatomic,retain) NSArray *sectionArray;
@property(nonatomic,retain) NSMutableArray *changeIndexArray;
@end

@implementation SSSNHotSitesViewController

@synthesize searchBar = _searchBar;
@synthesize urlTextField = _urlTextField;
@synthesize contentTable = _contentTable;
@synthesize data = _data;
@synthesize sectionArray = _sectionArray;
@synthesize changeIndexArray = _changeIndexArray;

-(void)dealloc {
    self.searchBar = nil;
    self.urlTextField = nil;
    self.contentTable = nil;
    self.data = nil;
    self.sectionArray = nil;
    self.changeIndexArray = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"热站导航";
        self.tabBarItem.image = [UIImage imageNamed:@"fire_02"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initKeyboardTool];
    SET_GRAY_BG(self);
    [self loadDB];
    [self initChangeIndexArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma search
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self changeInputWidth:YES];
    self.keyboardToolBar.type = SSKeyboardToolBarTypeSearch;
    [self.keyboardToolBar showBar:searchBar];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self changeInputWidth:NO];
    self.keyboardToolBar.type = SSKeyboardToolBarTypeURL;
    [self.keyboardToolBar showBar:textField];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.keyboardToolBar HiddenKeyBoard];
    
    SSFullWebViewController *controller = [[[SSFullWebViewController alloc]init]autorelease];
    
    NSString *urlStr = [self.keyboardToolBar getSearchString];
    
    controller.url = [NSURL URLWithString:urlStr];
    controller.navigationController.navigationBarHidden = NO;
    controller.keyWord = self.searchBar.text;
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.urlTextField resignFirstResponder];
    [self.keyboardToolBar HiddenKeyBoard];
    
    SSFullWebViewController *controller = [[[SSFullWebViewController alloc]init]autorelease];
    controller.url = [NSURL URLWithString:self.urlTextField.text];
    controller.navigationController.navigationBarHidden = NO;
    controller.keyWord = @"";
    
    [self.navigationController pushViewController:controller animated:YES];
    
    return YES;
}

-(void)changeInputWidth:(BOOL)isSearchOnChage{
//    [UIView beginAnimations:@ "changeFieldAnimation" context:nil];
//    [UIView setAnimationDuration:.5 ];
    
    if (isSearchOnChage) {
        [self.urlTextField setWidth:93];
        self.searchBar.frame = CGRectMake(103, 0, 217, 44);
    }else{
        [self.urlTextField setWidth:217];
        [self.searchBar setOriginX:227];
        [self.searchBar setWidth:93];
        
        
    }
    
//    [UIView commitAnimations];
}

-(void)initKeyboardTool{
    self.keyboardToolBar.urlTextField = self.urlTextField;
    self.keyboardToolBar.searchBar = self.searchBar;
}

#pragma mark -
#pragma mark table
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *smallCats = [self getCatsWithSection:indexPath.section];
    NSNumber *n = [self.changeIndexArray objectAtIndex:indexPath.section];
    BOOL isDisplay = [n boolValue];
    
    if (!isDisplay) {
        UITableViewCell *opCell = [tableView dequeueReusableCellWithIdentifier:@"SSSNHSOPC"];
        
        if (opCell == nil) {
            opCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SSSNHSOPC"];
        }

        
        opCell.textLabel.text = @"点击展开";
        opCell.detailTextLabel.text = [NSString stringWithFormat:@"%d个分类",smallCats.count];
        return opCell;
    }
    
    SSSNHostSitesCell *cell = [tableView dequeueReusableCellWithIdentifier:[SSSNHostSitesCell cellIdentifer]];
    
    SSSNSmallCat *smallCat = [smallCats objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [SSSNHostSitesCell createCell];
        cell.parentViewController = self;
    }
    
    cell.data = smallCat;
    [cell setupView];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSNumber *n = [self.changeIndexArray objectAtIndex:section];
    BOOL isDisplay = [n boolValue];
    
    if (!isDisplay) {
        return 1;
    }
    
    NSArray *smallCats = [self getCatsWithSection:section];
    
    return smallCats.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *n = [self.changeIndexArray objectAtIndex:indexPath.section];
    BOOL isDisplay = [n boolValue];
    
    if (!isDisplay)  {
        return 44;
    }
    
    return [SSSNHostSitesCell cellHeight];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.bigCats.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SSSNBigCat *bigCat =  [self.bigCats objectAtIndex:section];
    
    return bigCat.title;
}

#pragma mark -
#pragma mark db

-(void)loadDB{
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSMutableString *sql = [NSMutableString stringWithString: @"SELECT * from SNBigCat"];
        
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
        
        [sql appendString:@" order by id asc"];
        NSLog(@"execute sql:%@",sql);
        
        FMResultSet *rs = [db executeQuery:sql];
        
        self.bigCats = [NSMutableArray arrayWithCapacity:8];
        self.data = [NSMutableArray arrayWithCapacity:8];
        
        while ([rs next]) {
            
            SSSNBigCat *bigCat = [[[SSSNBigCat alloc]init]autorelease];
            bigCat.id = [rs intForColumn:@"id"];
            bigCat.title = [rs stringForColumn:@"title"];
            
            NSString *catSql = [NSMutableString stringWithFormat: @"SELECT * from SNSmallCat where cat = %d",bigCat.id];
            
            FMResultSet *catRs = [db executeQuery:catSql];
            
            
            NSMutableArray *smallCats = [NSMutableArray arrayWithCapacity:catRs.columnCount];
            
            while ([catRs next]) {
                SSSNSmallCat *smallCat = [[[SSSNSmallCat alloc]init]autorelease];
                smallCat.id = [catRs intForColumn:@"id"];
                smallCat.title = [catRs stringForColumn:@"title"];
                smallCat.cat = [catRs intForColumn:@"cat"];
                
                NSString *sitesSql = [NSMutableString stringWithFormat: @"SELECT * from SNSites where cat = %d",smallCat.id];
                
                FMResultSet *siteRs = [db executeQuery:sitesSql];
                
                NSMutableArray *sites = [NSMutableArray arrayWithCapacity:siteRs.columnCount];
                
                while ([siteRs next]) {
                    SSSNSites *site = [[[SSSNSites alloc]init]autorelease];
                    site.id = [siteRs intForColumn:@"id"];
                    site.title = [siteRs stringForColumn:@"title"];
                    site.cat = [siteRs intForColumn:@"cat"];
                    site.url = [siteRs stringForColumn:@"url"];
                    site.faver = [siteRs intForColumn:@"faver"];
                    
                    [sites addObject:site];
                }

                smallCat.sites = sites;
                [smallCats addObject:smallCat];
            }
            
            [self.data addObject:smallCats];
            [self.bigCats addObject:bigCat];
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

-(NSArray*)getCatsWithSection:(NSInteger)section{
    return [self.data objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 34)];
    
    UIControl *mask = [[UIControl alloc]initWithFrame:view.frame];
    mask.backgroundColor = [UIColor clearColor];
    
    mask.tag = section;
    [mask addTarget:self action:@selector(changeDisplady:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 9, 320, 17)];
    
    SSSNBigCat *bigCat =  [self.bigCats objectAtIndex:section];
    label.text = bigCat.title;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGB(0x33, 0x66, 0x66);
    label.font = [UIFont boldSystemFontOfSize:17];
    
    [view addSubview:label];
    [view addSubview:mask];
    
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *n = [self.changeIndexArray objectAtIndex:indexPath.section];
    BOOL isDisplay = [n boolValue];
    
    if (!isDisplay)  {
        [self changeDisplayWithTag:indexPath.section];
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)changeDisplady:(UIControl*)sender{
    [self changeDisplayWithTag:sender.tag];
    
}

-(void)changeDisplayWithTag:(int)tag{
    NSArray *array = [self getCatsWithSection:tag];
    
    if (array == nil || array.count <= 0) {
        return;
    }
    
    NSNumber *n = [self.changeIndexArray objectAtIndex:tag];
    BOOL isDisplay = [n boolValue];
    
    [self.changeIndexArray replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:!isDisplay]];
    
    [self.contentTable reloadData];
}

-(void)initChangeIndexArray{
    self.changeIndexArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],nil];
}
@end

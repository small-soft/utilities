//
//  SSSNHotSitesMoreViewController.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-16.
//
//

#import "SSSNHotSitesMoreViewController.h"
#import "SSSNHistoryCell.h"
#import "SSFullWebViewController.h"

@interface SSSNHotSitesMoreViewController ()

@property(nonatomic,retain) IBOutlet UITableView *contentTable;
-(IBAction)goBack:(id)sender;
@end

@implementation SSSNHotSitesMoreViewController
@synthesize contentTable = _contentTable;

-(void)dealloc {
    self.contentTable = nil;
    
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
    SET_GRAY_BG(self);
    self.contentTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:GRAY_BG]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark table delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SSSNHMC"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SSSNHistoryCell"];
    }
    
    SSSNSites *site = [self.data.sites objectAtIndex:indexPath.row];
    
    cell.textLabel.text = site.title;
    cell.detailTextLabel.text = site.url;
    
    //    cell.accessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.sites.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.data.title;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (IOS_VERSION <5.0) {
        return [tableView tableHeaderView];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 34)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20 + 33, 9, 320, 17)];
    label.text = self.data.title;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = RGB(0x33, 0x66, 0x66);
    label.font = [UIFont boldSystemFontOfSize:17];
    
    [view addSubview:label];
    
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed: [NSString stringWithFormat:@"siteCat%d",self.data.id]]];
    
    icon.frame = CGRectMake(20, 0, 33, 33);
    
    [view addSubview:icon];
    
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    SSSNSites *site = [self.data.sites objectAtIndex:indexPath.row];
    
    SSFullWebViewController *controller = [[[SSFullWebViewController alloc]init]autorelease];
    controller.url = [NSURL URLWithString:site.url];
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)goBack:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

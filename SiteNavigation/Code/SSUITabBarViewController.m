//
//  SSUITabBarViewController.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-6.
//
//

#import "SSUITabBarViewController.h"
#import "SSDQAllDeliveryCompanyListViewController.h"
#import "SSDQMyDeliveryViewController.h"

@interface SSUITabBarViewController ()

@property (nonatomic,retain) IBOutlet UITabBar *tabBar;

@end

@implementation SSUITabBarViewController

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
    UITabBarItem *item0 = [[UITabBarItem alloc]initWithTitle:@"" image:[UIImage imageNamed:@"fire_02"] tag:0];
    self.toolbarItems = [NSArray arrayWithObjects:item0, nil];
    
    self.tabBarItem = item0;
    
    SSDQAllDeliveryCompanyListViewController *controller0 = [[[SSDQAllDeliveryCompanyListViewController alloc]init]autorelease];
    SSDQMyDeliveryViewController *controller1= [[[SSDQMyDeliveryViewController alloc]init]autorelease];
    [self setViewControllers:[NSArray arrayWithObjects:controller0,controller1,nil]];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    SSViewController *controller = nil;
    
    switch (item.tag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            controller = [[[SSDQAllDeliveryCompanyListViewController alloc]init]autorelease];
        }
            break;
            
        case 2:
        {
            controller = [[[SSDQMyDeliveryViewController alloc]init]autorelease];
        }
            break;
        default:
            break;
    }
    
//    [self.navigationController pushViewController:controller animated:YES];
    
}

@end

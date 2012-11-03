//
//  SSQULocaleViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-1.
//
//

#import "SSQULocaleViewController.h"

@interface SSQULocaleViewController ()

@end

@implementation SSQULocaleViewController

-(void)dealloc{
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
    self.sendRequestButtonTitle = @"查询";
    [self.segmentedControl setTitle:@"手机号" forSegmentAtIndex:0];
    [self.segmentedControl setTitle:@"IP" forSegmentAtIndex:1];
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadObjectsFromRemote{
    
    if (self.segmentedControl.selectedSegmentIndex==0) {
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.liqwei.com/location/?mobile=%@",self.inputTextField.text]]];
    }else if(self.segmentedControl.selectedSegmentIndex == 1){
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.liqwei.com/location/?ip=%@",self.inputTextField.text] ]];
    }
    
    self.request.delegate = self;
    [self.loadingView showLoadingView];
    [self.request send];
    
}

@end

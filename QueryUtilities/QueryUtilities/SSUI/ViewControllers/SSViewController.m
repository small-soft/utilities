//
//  SSViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-29.
//
//

#import "SSViewController.h"
#import "SSLoadingView.h"
@interface SSViewController ()

@end

@implementation SSViewController
@synthesize loadingView = _loadingView;

-(SSLoadingView *)loadingView{
    if (nil==_loadingView) {
        _loadingView = [[SSLoadingView alloc] init];
        _loadingView.frame = self.view.frame;
        [self.view addSubview:_loadingView];
        _loadingView.hidden = YES;
    }
    return _loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    self.loadingView = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.loadingView = nil;
}

@end

//
//  SSViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-29.
//
//

#import "SSViewController.h"
#import "SSLoadingView.h"
#import "MobWinBannerView.h"
@interface SSViewController ()
//@property (nonatomic, retain) MobWinBannerView *advBannerView;
@end

@implementation SSViewController
@synthesize loadingView = _loadingView;
//@synthesize advBannerView = _advBannerView;

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
//    [self.advBannerView stopRequest];
//    [self.advBannerView removeFromSuperview];
//    self.advBannerView = nil;

    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    _advBannerView = [[MobWinBannerView alloc] initMobWinBannerSizeIdentifier:MobWINBannerSizeIdentifier320x50];
//	self.advBannerView.rootViewController = self;
//	[self.advBannerView setAdUnitID:@"A495798C12C030F28E7711F3613DFC1B"];
//    NSLog(@"advframe %f %f %f %f",self.advBannerView.frame.origin.x,self.advBannerView.frame.origin.y,self.advBannerView.frame.size.width,self.advBannerView.frame.size.height);
//    self.advBannerView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height-self.advBannerView.frame.size.height, self.advBannerView.frame.size.width, self.advBannerView.frame.size.height);
//    NSLog(@"advframe %f %f %f %f",self.advBannerView.frame.origin.x,self.advBannerView.frame.origin.y,self.advBannerView.frame.size.width,self.advBannerView.frame.size.height);
//	[self.view addSubview:self.advBannerView];
//    self.advBannerView.adGpsMode = NO;
//    [self.advBannerView startRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.loadingView = nil;
//    [self.advBannerView stopRequest];
//    [self.advBannerView removeFromSuperview];
//    self.advBannerView = nil;
}

@end

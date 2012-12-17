//
//  SSWebViewController.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-28.
//
//

#import "SSWebViewController.h"
#import "SSToastView.h"

@interface SSWebViewController ()
@end

@implementation SSWebViewController
@synthesize url = _url;
@synthesize webView =_webView;

-(void)viewDidUnload {
    self.webView = nil;
    self.url = nil;
    
    [super viewDidUnload];
}

-(void)dealloc {
    self.webView = nil;
    self.url = nil;
    
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
    self.backTitle = @"返回";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    [self.loadingView showLoadingView];
}

-(void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gogoLast {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}
- (IBAction)gotoNext {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}
- (IBAction)gotoHome {
    NSMutableURLRequest *request = [[ NSMutableURLRequest alloc ] initWithURL: self.url];
    [self.webView loadRequest: request ];
    [ request release ];
}
- (IBAction)gotoRefresh:(id)sender {
    [self.webView reload];
    
}

-(void)loadURL {
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingView hideLoadingView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.loadingView hideLoadingView];
    [SSToastView MakeToastWithType:TOAST_STYLE_FAIL info:@"访问失败，请查看网络连接是否正常"];
}

-(void)setUrl:(NSURL *)url {
    if (_url!= url){
        [_url release];
        
        if ([url.absoluteString rangeOfString:@"://"].length <=0) {
            _url = [[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",url.absoluteString]]retain];
        }else{
            _url = [url retain];
        }
    }

}

@end

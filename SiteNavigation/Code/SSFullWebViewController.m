//
//  SSFullWebViewController.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-7.
//
//

#import "SSFullWebViewController.h"
#import "UIView+UIViewUtil.h"
#import "FMDatabase.h"
#import "SSQUAppDelegate.h"
#import "SSToastView.h"
#import "NSDate+DateUtil.h"

@interface SSFullWebViewController ()

@property(nonatomic,retain) IBOutlet UITextField *urlTextField;
@property(nonatomic,retain) IBOutlet UISearchBar *searchBar;
@property(nonatomic) BOOL isSetUrlText;
@property(nonatomic) BOOL isSaveHistory;
@property(nonatomic,retain) NSString *webViewTitle;

@end

@implementation SSFullWebViewController

@synthesize urlTextField = _urlTextField;
@synthesize searchBar = _searchBar;
@synthesize keyWord = _keyWord;
@synthesize isSetUrlText = _isSetUrlText;
@synthesize webViewTitle = _webViewTitle;
@synthesize isSaveHistory = _isSaveHistory;

-(void)dealloc{
    self.urlTextField = nil;
    self.searchBar = nil;
    self.keyWord = nil;
    self.webViewTitle = nil;
    
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
    [self initKeyboardTool];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [self.loadingView hasToolBar];
    self.searchBar.text = self.keyWord;
    if (self.keyWord.length > 0) {
        [self changeInputWidth:YES];
    }
    
    self.urlTextField.text = self.url.absoluteString;
    [super viewWillAppear:YES];
}

-(void)gotoHome {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        self.urlTextField.text = request.URL.absoluteString;
        self.url = request.URL;
        self.title = nil;
        self.isSaveHistory = NO;
    }else if (navigationType != UIWebViewNavigationTypeOther && !self.isSetUrlText) {
        self.urlTextField.text = request.URL.absoluteString;
        self.url = request.URL;
        self.isSetUrlText = YES;
    }
    
//    if (self.title.length <=0) {
    
    
        
//    }
//    
//    if ([self isMainUrl:request]) {
//        self.title = [self getTitle:webView];
//        self.urlTextField.text = self.title;
//    }
//    [self saveHistory:webView.request];
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [super webViewDidFinishLoad:webView];
    
    
    
    if ([self isMainUrl:webView.request]) {
        self.title = [self getTitle:webView];
        if (self.title.length <= 0) {
            self.title = self.url.absoluteString;
        }
        
        self.urlTextField.text = self.title;
    }
    
    if (!self.isSaveHistory) {
        NSLog(@"request:%@",webView.request);
        
        [self saveHistory:webView.request];
        self.isSaveHistory = YES;
        
        [self.loadingView hideLoadingView];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self changeInputWidth:NO];
    
    self.urlTextField.text = self.url.absoluteString;
    
    self.keyboardToolBar.type = SSKeyboardToolBarTypeURL;
    [self.keyboardToolBar showBar:textField];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self changeInputWidth:YES];
    
    self.keyboardToolBar.type = SSKeyboardToolBarTypeSearch;
    [self.keyboardToolBar showBar:searchBar];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.urlTextField resignFirstResponder];
    [self.keyboardToolBar HiddenKeyBoard];
    
    [self someSet];
    
    self.url = [NSURL URLWithString:self.urlTextField.text];
    [self loadURL];
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.keyboardToolBar HiddenKeyBoard];
    
    [self someSet];
    
    self.url = [NSURL URLWithString:[self.keyboardToolBar getSearchString]];
    self.keyWord = self.searchBar.text;
    [self loadURL];
}

-(void)initKeyboardTool{
    self.keyboardToolBar.urlTextField = self.urlTextField;
    self.keyboardToolBar.searchBar = self.searchBar;
}

-(void)gogoLast {
    [self someSet];
    [super gogoLast];
}

-(void)gotoNext{
    [self someSet];
    [super gotoNext];
}

-(void)gotoRefresh:(id)sender{
    [self someSet];
    [super gotoRefresh:sender];
}

-(NSString*)getTitle:(UIWebView*)webView{
//    NSString *lJs = @"document.documentElement.innerHTML";
    NSString *lJs2 = @"document.title";
    NSString *lHtml1 = [webView stringByEvaluatingJavaScriptFromString:lJs2];
//    NSString *lHtml2 = [webView stringByEvaluatingJavaScriptFromString:lJs];
    NSLog(@"title:%@",lHtml1);
//    NSLog(@"html:%@",lHtml2);
    
    return lHtml1;
}

-(void)someSet{
    self.isSetUrlText = NO;
    self.title = nil;
}

-(IBAction)fav:(id)sender{
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat: @"SELECT * from SNFav where url = '%@'",self.url.absoluteString];
        
        FMResultSet *rs = [db executeQuery:sql];
        
        if ([rs next] > 0) {
            [[SSToastView MakeToastWithType:TOAST_STYLE_SUCC info:@"已收藏"] show];
            return;
        }
        
        NSString *sqlInsert = [NSString stringWithFormat: @"INSERT INTO SNFav(title,url,date) values('%@','%@',%f)",self.title,self.url.absoluteString,[[NSDate date] timeIntervalSince1970]];
                
        NSLog(@"sql:%@",sqlInsert);
        
        [NSDate timeIntervalSinceReferenceDate];
        
        NSLog(@"inertResult:%d",[db executeUpdate:sqlInsert]);
        [[SSToastView MakeToastWithType:TOAST_STYLE_SUCC info:@"已收藏"] show];
    }
    
  
    
    [db close];

}

-(void)saveHistory:(NSURLRequest*)request{
    
    FMDatabase *db = GETDB;
    if ([db open]) {
        
        NSString *sqlInsert = [NSString stringWithFormat: @"INSERT INTO SNHistory(title,url,date) values('%@','%@',%f)",self.title,self.url.absoluteString,[[NSDate date] timeIntervalSince1970]];
        
        NSLog(@"sql:%@",sqlInsert);
        
        [NSDate timeIntervalSinceReferenceDate];
        
        NSLog(@"inertResult:%d",[db executeUpdate:sqlInsert]);
    }
    
    [db close];
}

-(BOOL)isMainUrl:(NSURLRequest*)request{
    return [request.URL isEqual:request.mainDocumentURL];
}
@end

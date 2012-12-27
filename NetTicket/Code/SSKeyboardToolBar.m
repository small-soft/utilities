//
//  SSKeyboardToolBar.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-7.
//
//

#import "SSKeyboardToolBar.h"
#import "NSString+NSStringUtil.h"

@interface SSKeyboardToolBar()

@property(nonatomic,retain) UIBarButtonItem *dComItem;
@property(nonatomic,retain) UIBarButtonItem *dCnItem;
@property(nonatomic,retain) UIBarButtonItem *httpItem;
@property(nonatomic,retain) UIBarButtonItem *httpsItem;

@property(nonatomic,retain) UIBarButtonItem *baiduItem;
@property(nonatomic,retain) UIBarButtonItem *googleItem;
@property(nonatomic,retain) UIBarButtonItem *sosoItem;
@property(nonatomic,retain) UIBarButtonItem *youdaoItem;
@property(nonatomic,retain) UIBarButtonItem *bingItem;

@property(nonatomic,retain) NSArray *urlBarToolItems;
@property(nonatomic,retain) NSArray *searchBarToolItems;
@property(nonatomic,retain) NSArray *defaultBarToolItems;

@end

@implementation SSKeyboardToolBar

@synthesize view = _view;
@synthesize mask = _mask;
@synthesize btnItems = _btnItems;
@synthesize urlTextField = _urlTextField;
@synthesize searchBar = _searchBar;

@synthesize type = _type;
@synthesize dCnItem = _dCnItem;
@synthesize dComItem = _dComItem;
@synthesize httpItem = _httpItem;
@synthesize httpsItem = _httpsItem;
@synthesize baiduItem = _baiduItem;
@synthesize googleItem = _googleItem;
@synthesize sosoItem = _sosoItem;
@synthesize youdaoItem = _youdaoItem;
@synthesize bingItem = _bingItem;

@synthesize urlBarToolItems = _urlBarToolItems;
@synthesize searchBarToolItems = _searchBarToolItems;
@synthesize defaultBarToolItems = _defaultBarToolItems;

@synthesize currentTextField = _currentTextField;
@synthesize allowShowPreAndNext = _allowShowPreAndNext;
@synthesize hiddenButtonItem = _hiddenButtonItem;
@synthesize isInNavigationController = _isInNavigationController;
@synthesize nextButtonItem = _nextButtonItem;
@synthesize prevButtonItem = _prevButtonItem;
@synthesize spaceButtonItem = _spaceButtonItem;

//@synthesize textFields = _textFields;

//初始化控件和变量

-(id)init{
    
    if((self = [super init])) {
        
        self.dCnItem = [[UIBarButtonItem alloc] initWithTitle:@".cn" style:UIBarButtonItemStyleBordered target:self action:@selector(dCnClick)];
        self.dComItem = [[UIBarButtonItem alloc] initWithTitle:@".com" style:UIBarButtonItemStyleBordered target:self action:@selector(dComClick)];
        self.httpItem = [[UIBarButtonItem alloc] initWithTitle:@"http://" style:UIBarButtonItemStyleBordered target:self action:@selector(dHttpClick)];
        self.httpsItem = [[UIBarButtonItem alloc] initWithTitle:@"https://" style:UIBarButtonItemStyleBordered target:self action:@selector(dHttpsClick)];
        self.baiduItem = [[UIBarButtonItem alloc] initWithTitle:@"百度" style:UIBarButtonItemStyleBordered target:self action:@selector(baiduClick)];
        self.googleItem = [[UIBarButtonItem alloc] initWithTitle:@"谷歌" style:UIBarButtonItemStyleBordered target:self action:@selector(googleClick)];
        self.sosoItem = [[UIBarButtonItem alloc] initWithTitle:@"搜搜" style:UIBarButtonItemStyleBordered target:self action:@selector(sosoClick)];
        self.youdaoItem = [[UIBarButtonItem alloc] initWithTitle:@"有道" style:UIBarButtonItemStyleBordered target:self action:@selector(youdaoClick)];
        self.bingItem = [[UIBarButtonItem alloc] initWithTitle:@"必应" style:UIBarButtonItemStyleBordered target:self action:@selector(bingClick)];
        
        self.hiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"隐藏键盘" style:UIBarButtonItemStyleBordered target:self action:@selector(HiddenKeyBoard)];
        
        self.spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.prevButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一项" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowPrevious)];
        
        self.nextButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一项" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowNext)];
        
        
        self.defaultBarToolItems = [NSArray arrayWithObjects:self.spaceButtonItem,self.hiddenButtonItem, nil];
        self.urlBarToolItems = [NSArray arrayWithObjects:self.httpItem,self.httpsItem,self.dComItem,self.dCnItem,self.spaceButtonItem,self.hiddenButtonItem, nil];
        self.searchBarToolItems = [NSArray arrayWithObjects:self.baiduItem,self.googleItem,self.sosoItem,self.bingItem,self.spaceButtonItem,self.hiddenButtonItem, nil];
        
        
        self.mask = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.mask.backgroundColor = [UIColor lightGrayColor];
        self.mask.alpha = 0.5;
        self.mask.hidden = YES;
        [self.mask addTarget:self action:@selector(HiddenKeyBoard) forControlEvents:UIControlEventTouchUpInside];
        
        self.view = [[UIToolbar alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT,320,44)];
        
        self.view.barStyle = UIBarStyleBlackTranslucent;
        
//        view.items = self.btnItems;
        
        self.allowShowPreAndNext = YES;
        
//        self.textFields = nil;
        
       self.isInNavigationController = YES;
        
        self.currentTextField = nil;
        
    }
    
    return self;
    
}

-(void)setItems{
    switch (self.type) {
        case SSKeyboardToolBarTypeDefault:
        {
            self.view.items = self.defaultBarToolItems;
        }
            break;
        case SSKeyboardToolBarTypeSearch:
        {
            self.view.items = self.searchBarToolItems;
//            self.baiduItem.enabled = NO;
        }
            break;
        case SSKeyboardToolBarTypeURL:
        {
            self.view.items = self.urlBarToolItems;
        }
            break;
        default:
            break;
    }
}

//设置是否在导航视图中

-(void)setIsInNavigationController:(BOOL)isbool{
    
    _isInNavigationController = isbool;
    
}

//显示上一项

//-(void)showPrevious{
//    
//    if (textFields==nil) {
//        
//        return;
//        
//    }
//    
//    NSInteger num = -1;
//    
//    for (NSInteger i=0; i<[textFields count]; i++) {
//        
//        if ([textFields objectAtIndex:i]==currentTextField) {
//            
//            num = i;
//            
//            break;
//            
//        }
//        
//    }
//    
//    if (num>0){
//        
//        [[textFields objectAtIndex:num] resignFirstResponder];
//        
//        [[textFields objectAtIndex:num-1 ] becomeFirstResponder];
//        
//        [self showBar:[textFields objectAtIndex:num-1]];
//        
//    }
//    
//}
//
////显示下一项
//
//-(void)showNext{
//    
//    if (textFields==nil) {
//        
//        return;
//        
//    }
//    
//    NSInteger num = -1;
//    
//    for (NSInteger i=0; i<[textFields count]; i++) {
//        
//        if ([textFields objectAtIndex:i]==currentTextField) {
//            
//            num = i;
//            
//            break;
//            
//        }
//        
//    }
//    
//    if (num<[textFields count]-1){
//        
//        [[textFields objectAtIndex:num] resignFirstResponder];
//        
//        [[textFields objectAtIndex:num+1] becomeFirstResponder];
//        
//        [self showBar:[textFields objectAtIndex:num+1]];
//        
//    }
//    
//}

//显示工具条

-(void)showBar:(UIView *)textField{
    
    self.currentTextField = textField;
    self.mask.hidden = NO;
    
    [self setItems];
    
//    if (textFields==nil) {
//        
//        prevButtonItem.enabled = NO;
//        
//        nextButtonItem.enabled = NO;
//        
//    }
//    
//    else {
//        
//        NSInteger num = -1;
//        
//        for (NSInteger i=0; i<[textFields count]; i++) {
//            
//            if ([textFields objectAtIndex:i]==currentTextField) {
//                
//                num = i;
//                
//                break;
//                
//            }
//            
//        }
//        
//        if (num>0) {
//            
//            prevButtonItem.enabled = YES;
//            
//        }
//        
//        else {
//            
//            prevButtonItem.enabled = NO;
//            
//        }
//        
//        if (num<[textFields count]-1) {
//            
//            nextButtonItem.enabled = YES;
//            
//        }
//        
//        else {
//            
//            nextButtonItem.enabled = NO;
//            
//        }
//        
//    }
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3];
    
    if (self.isInNavigationController) {
        
        self.view.frame = CGRectMake(0, 201-40 + SCREEN_HEIGHT - 480, 320, 44);
        
    }
    
    else {
        
        self.view.frame = CGRectMake(0, 201 + SCREEN_HEIGHT - 480, 320, 44);
        
    }
    
    [UIView commitAnimations];
    
}

////设置输入框数组
//
//-(void)setTextFieldsArray:(NSArray *)array{
//    
//    textFields = array;
//    
//}
//
////设置是否显示上一项和下一项按钮
//
//-(void)setAllowShowPreAndNext:(BOOL)isShow{
//    
//    allowShowPreAndNext = isShow;
//    
//}

//隐藏键盘和工具条

-(void)HiddenKeyBoard{
    
    if (self.currentTextField!=nil) {
        
        [self.currentTextField  resignFirstResponder];
        
    }
    
    self.mask.hidden = YES;
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = CGRectMake(0, SCREEN_HEIGHT, 320, 44);
    
    [UIView commitAnimations];
    
}

- (void)dealloc {
    
    self.view = nil;
    self.btnItems = nil;
    self.searchBar = nil;
    self.urlTextField = nil;
    self.mask = nil;
    
    self.dComItem = nil;
    self.dCnItem = nil;
    self.httpItem = nil;
    self.baiduItem = nil;
    self.googleItem = nil;
    self.sosoItem = nil;
    self.youdaoItem = nil;
    self.bingItem = nil;
    
    self.defaultBarToolItems = nil;
    self.searchBarToolItems = nil;
    self.urlBarToolItems = nil;
    
//    self.textFields = nil;
//    
//    [prevButtonItem release];
//    
//    [nextButtonItem release];
    
    [self.hiddenButtonItem release];
    
    [self.currentTextField release];
    
    [self.spaceButtonItem release];
    
    [super dealloc];
    
}

-(void)dCnClick{
    
    self.urlTextField.text = [NSString stringWithFormat:@"%@.cn",self.urlTextField.text];
}

-(void)dComClick{
    self.urlTextField.text = [NSString stringWithFormat:@"%@.com",self.urlTextField.text];

}

-(void)dHttpClick{
    self.urlTextField.text = [NSString stringWithFormat:@"http://%@",self.urlTextField.text];

}

-(void)dHttpsClick{
    self.urlTextField.text = [NSString stringWithFormat:@"https://%@",self.urlTextField.text];
    
}

-(void)baiduClick{
//    self.searchUrl = [NSString stringWithFormat:@"http://m.baidu.com/s?word=%@&tn=iphone",self.searchBar.text];
    
    [self onClick:self.baiduItem];
}
-(void)bingClick{
//    self.searchUrl = [NSString stringWithFormat:@"http://m.cn.bing.com/search?q=%@",self.searchBar.text];
    [self onClick:self.bingItem];
}
-(void)sosoClick{
//    self.searchUrl = [NSString stringWithFormat:@"http://wap.soso.com/sweb/search.jsp?key=%@",self.searchBar.text];
    [self onClick:self.sosoItem];
}
-(void)googleClick{
//    self.searchUrl = [NSString stringWithFormat:@"http://www.google.com.hk/search?q=%@",self.searchBar.text];
    [self onClick:self.googleItem];
}

-(void)onClick:(UIBarButtonItem*)disabledItem{
    for (UITabBarItem *item in self.searchBarToolItems) {
        item.enabled = YES;
    }
    disabledItem.enabled = NO;
}

-(NSString *)getSearchString{
//    return @"http://m.baidu.com";
    
    NSString *url = [NSString stringWithFormat:@"http://m.baidu.com/s?word=%@&tn=iphone",self.searchBar.text];
    
    if (!self.googleItem.isEnabled){
        url = [NSString stringWithFormat:@"http://www.google.com.hk/search?q=%@",self.searchBar.text];
    }else if (!self.bingItem.isEnabled){
        url = [NSString stringWithFormat:@"http://m.cn.bing.com/search?q=%@",self.searchBar.text];
    }else if(!self.sosoItem.isEnabled){
        url = [NSString stringWithFormat:@"http://wap.soso.com/sweb/search.jsp?key=%@",self.searchBar.text];
    }
    
    return  [NSString escapeURL:url];
}
@end

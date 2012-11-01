//
//  SSQULocaleViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-1.
//
//

#import "SSQULocaleViewController.h"
#import <RestKit/RestKit.h>
@interface SSQULocaleViewController ()<RKRequestDelegate>

@property (nonatomic, retain) IBOutlet UISegmentedControl *searchTypeSegemtedControl;
@property (nonatomic, retain) RKRequest * request;
@property (nonatomic, retain) IBOutlet UITextField * inputField;
@property (nonatomic, retain) IBOutlet UILabel * resultLabel;
@property (nonatomic, retain) IBOutlet UIButton * searchButton;
@property (nonatomic, copy) NSString * cacheInputStringForMoblieToIP;
@property (nonatomic, copy) NSString * cacheResultStringForMoblieToIP;
@property (nonatomic, copy) NSString * cacheInputStringForIPToMoblie;
@property (nonatomic, copy) NSString * cacheResultStringForIPToMoblie;
@end

@implementation SSQULocaleViewController
@synthesize selectIndex = _selectIndex;
@synthesize request = _request;
@synthesize inputField = _inputField;
@synthesize resultLabel = _resultLabel;
@synthesize searchButton = _searchButton;
@synthesize cacheInputStringForMoblieToIP = _cacheInputStringForMoblieToIP;
@synthesize cacheResultStringForMoblieToIP = _cacheResultStringForMoblieToIP;
@synthesize cacheInputStringForIPToMoblie = _cacheInputStringForIPToMoblie;
@synthesize cacheResultStringForIPToMoblie = _cacheResultStringForIPToMoblie;
-(void)dealloc{
    self.searchTypeSegemtedControl = nil;
    [self.request cancel];
    self.request = nil;
    self.inputField = nil;
    self.resultLabel = nil;
    self.searchButton = nil;
    self.cacheInputStringForMoblieToIP = nil;
    self.cacheResultStringForMoblieToIP = nil;
    self.cacheInputStringForIPToMoblie = nil;
    self.cacheResultStringForIPToMoblie = nil;
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
	// Do any additional setup after loading the view.
    self.searchTypeSegemtedControl.selectedSegmentIndex = self.selectIndex;
    [self.searchTypeSegemtedControl addTarget:self action:@selector(segemtControlIndexChange:) forControlEvents:UIControlEventValueChanged];
    [self.searchButton addTarget:self action:@selector(searchButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputField addTarget:self action:@selector(inputFieldEditViewDidEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)segemtControlIndexChange:(id)sender{
    UISegmentedControl *segemtControl = (UISegmentedControl*)sender;
    if (segemtControl.selectedSegmentIndex==0) {
        self.cacheInputStringForIPToMoblie = self.inputField.text;
        self.cacheResultStringForIPToMoblie = self.resultLabel.text;
        self.inputField.text = self.cacheInputStringForMoblieToIP;
        self.resultLabel.text = self.cacheResultStringForMoblieToIP;
    }else if(segemtControl.selectedSegmentIndex==1){
        self.cacheInputStringForMoblieToIP = self.inputField.text;
        self.cacheResultStringForMoblieToIP = self.resultLabel.text;
        self.inputField.text = self.cacheInputStringForIPToMoblie;
        self.resultLabel.text = self.cacheResultStringForIPToMoblie;
    }
    
}

-(IBAction)searchButtonPress:(id)sender{
    [self.inputField resignFirstResponder];
    [self loadObjectsFromRemote];
}

-(IBAction)inputFieldEditViewDidEnd:(id)sender{
    [self.inputField resignFirstResponder];
}
-(void)loadObjectsFromRemote{
    
    if (self.searchTypeSegemtedControl.selectedSegmentIndex==0) {
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.liqwei.com/location/?mobile=%@",self.inputField.text]]];
    }else if(self.searchTypeSegemtedControl.selectedSegmentIndex == 1){
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.liqwei.com/location/?ip=%@",self.inputField.text] ]];
    }
    
    self.request.delegate = self;
    [self.loadingView showLoadingView];
    [self.request send];
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"success :%@",[response bodyAsString]);
    NSString * resultString =[[NSString alloc] initWithData:[response body] encoding: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSRange errorRange =[resultString rangeOfString:@"Microsoft VBScript 运行时错误"];
    if (errorRange.length!=0||[resultString isEqualToString:@""])
    {
        self.resultLabel.text = @"抱歉！查无结果";
    }else{
        self.resultLabel.text = resultString;
    }
    
    [resultString release];
    
    self.resultLabel.numberOfLines = 0;
    CGSize constraint = CGSizeMake(260, 20000.0f);
    CGSize labelSize = [self.resultLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    self.resultLabel.frame = CGRectMake(self.resultLabel.frame.origin.x, self.resultLabel.frame.origin.y, labelSize.width, labelSize.height);
    [self.loadingView hideLoadingView];
    
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"failed :%@", error);
    [self.loadingView hideLoadingView];
}

@end

//
//  SSQUFontChangeViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-1.
//
//

#import "SSQUFontChangeViewController.h"
#import <RestKit/RestKit.h>
@interface SSQUFontChangeViewController ()<RKRequestDelegate>
@property (nonatomic, retain) IBOutlet UISegmentedControl *translateTypeSegemtedControl;
@property (nonatomic, retain) RKRequest * request;
@property (nonatomic, retain) IBOutlet UITextField * inputField;
@property (nonatomic, retain) IBOutlet UILabel * resultLabel;
@property (nonatomic, retain) IBOutlet UIButton * translateButton;
@property (nonatomic, copy) NSString * cacheInputStringForChToBig;
@property (nonatomic, copy) NSString * cacheResultStringForChToBig;
@property (nonatomic, copy) NSString * cacheInputStringForBigToCh;
@property (nonatomic, copy) NSString * cacheResultStringForBigToCh;
@end

@implementation SSQUFontChangeViewController

@synthesize selectIndex = _selectIndex;
@synthesize request = _request;
@synthesize inputField = _inputField;
@synthesize resultLabel = _resultLabel;
@synthesize translateButton = _translateButton;
@synthesize cacheInputStringForChToBig = _cacheInputStringForChToBig;
@synthesize cacheResultStringForChToBig = _cacheResultStringForChToBig;
@synthesize cacheInputStringForBigToCh = _cacheInputStringForBigToCh;
@synthesize cacheResultStringForBigToCh = _cacheResultStringForBigToCh;
-(void)dealloc{
    self.translateTypeSegemtedControl = nil;
    [self.request cancel];
    self.request = nil;
    self.inputField = nil;
    self.resultLabel = nil;
    self.translateButton = nil;
    self.cacheInputStringForChToBig = nil;
    self.cacheResultStringForChToBig = nil;
    self.cacheInputStringForBigToCh = nil;
    self.cacheResultStringForBigToCh = nil;
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
    self.translateTypeSegemtedControl.selectedSegmentIndex = self.selectIndex;
    [self.translateTypeSegemtedControl addTarget:self action:@selector(segemtControlIndexChange:) forControlEvents:UIControlEventValueChanged];
    [self.translateButton addTarget:self action:@selector(translateButtonPress:) forControlEvents:UIControlEventTouchUpInside];
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
        self.cacheInputStringForBigToCh = self.inputField.text;
        self.cacheResultStringForBigToCh = self.resultLabel.text;
        self.inputField.text = self.cacheInputStringForChToBig;
        self.resultLabel.text = self.cacheResultStringForChToBig;
    }else if(segemtControl.selectedSegmentIndex==1){
        self.cacheInputStringForChToBig = self.inputField.text;
        self.cacheResultStringForChToBig = self.resultLabel.text;
        self.inputField.text = self.cacheInputStringForBigToCh;
        self.resultLabel.text = self.cacheResultStringForBigToCh;
    }
    
}

-(IBAction)translateButtonPress:(id)sender{
    [self.inputField resignFirstResponder];
    [self loadObjectsFromRemote];
}

-(IBAction)inputFieldEditViewDidEnd:(id)sender{
    [self.inputField resignFirstResponder];
}
-(void)loadObjectsFromRemote{
    
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    if (self.translateTypeSegemtedControl.selectedSegmentIndex==0) {
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://api.liqwei.com/chinese/?language=gb|big&content=%@",self.inputField.text] stringByAddingPercentEscapesUsingEncoding:encode]]];
    }else if(self.translateTypeSegemtedControl.selectedSegmentIndex == 1){
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://api.liqwei.com/chinese/?language=big|gb&content=%@",self.inputField.text] stringByAddingPercentEscapesUsingEncoding:encode]]];
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

//
//  SSQUSegmentedViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-3.
//
//

#import "SSQUSegmentedViewController.h"

@interface SSQUSegmentedViewController ()

@property (nonatomic, copy) NSString * cacheInputStringTabOne;
@property (nonatomic, copy) NSString * cacheOutputStringTabOne;
@property (nonatomic, copy) NSString * cacheInputStringTabTwo;
@property (nonatomic, copy) NSString * cacheOutputStringTabTwo;
@end

@implementation SSQUSegmentedViewController
@synthesize selectIndex = _selectIndex;
@synthesize segmentedControl = _segmentedControl;
@synthesize request = _request;
@synthesize inputTextField = _inputTextField;
@synthesize outputLabel = _outputLabel;
@synthesize sendrequestButton = _sendrequestButton;
@synthesize cacheInputStringTabOne = _cacheInputStringTabOne;
@synthesize cacheInputStringTabTwo = _cacheInputStringTabTwo;
@synthesize cacheOutputStringTabOne = _cacheOutputStringTabOne;
@synthesize cacheOutputStringTabTwo = _cacheOutputStringTabTwo;
@synthesize outputCopyButton = _outputCopyButton;
@synthesize sendRequestButtonTitle = _sendRequestButtonTitle;
-(void)dealloc{
    [self.request cancel];
    self.request = nil;
    self.segmentedControl = nil;
    self.inputTextField = nil;
    self.outputLabel = nil;
    self.sendrequestButton = nil;
    self.cacheInputStringTabOne = nil;
    self.cacheInputStringTabTwo = nil;
    self.cacheOutputStringTabOne = nil;
    self.cacheOutputStringTabTwo = nil;
    self.outputCopyButton = nil;
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

-(id)init{
    self = [self initWithNibName:@"SSQUSegmentedViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.segmentedControl.selectedSegmentIndex = self.selectIndex;
    if (self.sendRequestButtonTitle==nil) {
        self.sendRequestButtonTitle = @"查询";
    }
    [self.sendrequestButton setTitle:self.sendRequestButtonTitle forState:UIControlStateNormal];
    [self.segmentedControl addTarget:self action:@selector(segemtControlIndexChange)  forControlEvents:UIControlEventValueChanged];
    [self.sendrequestButton addTarget:self action:@selector(sendRequestButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.inputTextField addTarget:self action:@selector(inputTextFieldEditViewDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.outputCopyButton addTarget:self action:@selector(outputCopyButtonPressed) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)segemtControlIndexChange{

    if (self.segmentedControl.selectedSegmentIndex==0) {
        self.cacheInputStringTabTwo = self.inputTextField.text;
        self.cacheOutputStringTabTwo = self.outputLabel.text;
        self.inputTextField.text = self.cacheInputStringTabOne;
        self.outputLabel.text = self.cacheOutputStringTabOne;
    }else if (self.segmentedControl.selectedSegmentIndex==1){
        self.cacheInputStringTabOne = self.inputTextField.text;
        self.cacheOutputStringTabOne = self.outputLabel.text;
        self.inputTextField.text = self.cacheInputStringTabTwo;
        self.outputLabel.text = self.cacheOutputStringTabTwo;
    }

}

-(void)sendRequestButtonPressed{
    [self.inputTextField resignFirstResponder];
    if ([self.inputTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]!=nil) {
        [self loadObjectsFromRemote];
    }

}

-(void)inputTextFieldEditViewDidEndOnExit{
    [self.inputTextField resignFirstResponder];
}

-(void)outputCopyButtonPressed{
    if ([self.outputLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]!=nil) {
        UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.outputLabel.text;
    }

}
-(void)loadObjectsFromRemote{
    if (self.request!=nil) {
        self.request.delegate = self;
        [self.loadingView showLoadingView];
        [self.request send];
    }

}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"success :%@",[response bodyAsString]);
    NSString * resultString =[[NSString alloc] initWithData:[response body] encoding: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSRange errorRange =[resultString rangeOfString:@"Microsoft VBScript 运行时错误"];
    if (errorRange.length!=0||[resultString isEqualToString:@""])
    {
        self.outputLabel.text = @"抱歉！查无结果";
    }else{
        self.outputLabel.text = resultString;
    }
    [resultString release];
    self.outputLabel.numberOfLines = 0;
    CGSize constraint = CGSizeMake(260, 20000.0f);
    CGSize labelSize = [self.outputLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    self.outputLabel.frame = CGRectMake(self.outputLabel.frame.origin.x, self.outputLabel.frame.origin.y, labelSize.width, labelSize.height);
    [self.loadingView hideLoadingView];
    
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"failed :%@", error);
    self.outputLabel.text = @"网络好像有点问题，请检查您的网络^_^";
    self.outputLabel.numberOfLines = 0;
    CGSize constraint = CGSizeMake(260, 20000.0f);
    CGSize labelSize = [self.outputLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    self.outputLabel.frame = CGRectMake(self.outputLabel.frame.origin.x, self.outputLabel.frame.origin.y, labelSize.width, labelSize.height);
    [self.loadingView hideLoadingView];

}

@end

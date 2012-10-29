//
//  SSQUTranslateViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-29.
//
//

#import "SSQUTranslateViewController.h"
#import <RestKit/RestKit.h>
@interface SSQUTranslateViewController ()<RKRequestDelegate>
@property (nonatomic, retain) IBOutlet UISegmentedControl *translateTypeSegemtedControl;
@property (nonatomic, retain) RKRequest * request;
@property (nonatomic, retain) IBOutlet UITextField * inputField;
@property (nonatomic, retain) IBOutlet UILabel * resultLabel;
@property (nonatomic, retain) IBOutlet UIButton * translateButton;
@property (nonatomic, copy) NSString * cacheInputStringForChToEn;
@property (nonatomic, copy) NSString * cacheResultStringForChToEn;
@property (nonatomic, copy) NSString * cacheInputStringForEnToCh;
@property (nonatomic, copy) NSString * cacheResultStringForEnToCh;
@end

@implementation SSQUTranslateViewController
@synthesize selectIndex = _selectIndex;
@synthesize request = _request;
@synthesize inputField = _inputField;
@synthesize resultLabel = _resultLabel;
@synthesize translateButton = _translateButton;
@synthesize cacheInputStringForChToEn = _cacheInputStringForChToEn;
@synthesize cacheResultStringForChToEn = _cacheResultStringForChToEn;
@synthesize cacheInputStringForEnToCh = _cacheInputStringForEnToCh;
@synthesize cacheResultStringForEnToCh = _cacheResultStringForEnToCh;
-(void)dealloc{
    self.translateTypeSegemtedControl = nil;
    [self.request cancel];
    self.request = nil;
    self.inputField = nil;
    self.resultLabel = nil;
    self.translateButton = nil;
    self.cacheInputStringForChToEn = nil;
    self.cacheResultStringForChToEn = nil;
    self.cacheInputStringForEnToCh = nil;
    self.cacheResultStringForEnToCh = nil;
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
        self.cacheInputStringForEnToCh = self.inputField.text;
        self.cacheResultStringForEnToCh = self.resultLabel.text;
        self.inputField.text = self.cacheInputStringForChToEn;
        self.resultLabel.text = self.cacheResultStringForChToEn;
    }else if(segemtControl.selectedSegmentIndex==1){
        self.cacheInputStringForChToEn = self.inputField.text;
        self.cacheResultStringForChToEn = self.resultLabel.text;
        self.inputField.text = self.cacheInputStringForEnToCh;
        self.resultLabel.text = self.cacheResultStringForEnToCh;
    }
    
}

-(IBAction)translateButtonPress:(id)sender{
    [self loadObjectsFromRemote];
}

-(IBAction)inputFieldEditViewDidEnd:(id)sender{
    [self.inputField resignFirstResponder];
}
-(void)loadObjectsFromRemote{
    
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    if (self.translateTypeSegemtedControl.selectedSegmentIndex==0) {
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://api.liqwei.com/translate/?language=zh-CN|en&content=%@",self.inputField.text] stringByAddingPercentEscapesUsingEncoding:encode]]];
    }else if(self.translateTypeSegemtedControl.selectedSegmentIndex == 1){
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://api.liqwei.com/translate/?language=en|zh-CN&content=%@",self.inputField.text] stringByAddingPercentEscapesUsingEncoding:encode]]];
    }

    self.request.delegate = self;
    [self.loadingView showLoadingView];
    [self.request send];
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"success :%@",[response bodyAsString]);

    self.resultLabel.text = [response bodyAsString];
    self.resultLabel.numberOfLines = 0;
    CGSize constraint = CGSizeMake(300, 20000.0f);
    CGSize labelSize = [self.resultLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    self.resultLabel.frame = CGRectMake(self.resultLabel.frame.origin.x, self.resultLabel.frame.origin.y, labelSize.width, labelSize.height);
    [self.loadingView hideLoadingView];
    
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"failed :%@", error);
    [self.loadingView hideLoadingView];
}

@end

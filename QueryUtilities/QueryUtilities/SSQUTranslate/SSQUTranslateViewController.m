//
//  SSQUTranslateViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-29.
//
//

#import "SSQUTranslateViewController.h"

@interface SSQUTranslateViewController ()

@end

@implementation SSQUTranslateViewController

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
    self.sendRequestButtonTitle = @"翻译";
    [self.segmentedControl setTitle:@"汉译英" forSegmentAtIndex:0];
    [self.segmentedControl setTitle:@"英译汉" forSegmentAtIndex:1];
    self.inputTextField.placeholder = @"请输入要翻译的原文";
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadObjectsFromRemote{
    
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    if (self.segmentedControl.selectedSegmentIndex==0) {
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://api.liqwei.com/translate/?language=zh-CN|en&content=%@",self.inputTextField.text] stringByAddingPercentEscapesUsingEncoding:encode]]];
    }else if(self.segmentedControl.selectedSegmentIndex == 1){
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://api.liqwei.com/translate/?language=en|zh-CN&content=%@",self.inputTextField.text] stringByAddingPercentEscapesUsingEncoding:encode]]];
    }

    [super loadObjectsFromRemote];
    
}

@end
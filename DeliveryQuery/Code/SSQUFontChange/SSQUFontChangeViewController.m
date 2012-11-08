//
//  SSQUFontChangeViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-1.
//
//

#import "SSQUFontChangeViewController.h"

@interface SSQUFontChangeViewController ()

@end

@implementation SSQUFontChangeViewController

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
    self.sendRequestButtonTitle = @"转换";
    [self.segmentedControl setTitle:@"简转繁" forSegmentAtIndex:0];
    [self.segmentedControl setTitle:@"繁转简" forSegmentAtIndex:1];
    self.inputTextField.placeholder = @"请输入要转换的原文";

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
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://api.liqwei.com/chinese/?language=gb|big&content=%@",self.inputTextField.text] stringByAddingPercentEscapesUsingEncoding:encode]]];
    }else if(self.segmentedControl.selectedSegmentIndex == 1){
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://api.liqwei.com/chinese/?language=big|gb&content=%@",self.inputTextField.text] stringByAddingPercentEscapesUsingEncoding:encode]]];
    }
    
    [super loadObjectsFromRemote];
    
}


@end

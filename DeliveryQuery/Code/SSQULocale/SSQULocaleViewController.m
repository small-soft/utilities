//
//  SSQULocaleViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-1.
//
//

#import "SSQULocaleViewController.h"
#import "SSMapping4RestKitUtils.h"
#import "SSQUSmartResult.h"
@interface SSQULocaleViewController ()

@end

@implementation SSQULocaleViewController

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
    self.sendRequestButtonTitle = @"查询";
    [self.segmentedControl setTitle:@"手机号" forSegmentAtIndex:0];
    [self.segmentedControl setTitle:@"IP" forSegmentAtIndex:1];
    self.inputTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadObjectsFromRemote{
    
    if (self.segmentedControl.selectedSegmentIndex==0) {
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youdao.com/smartresult-xml/search.s?type=mobile&q=%@",self.inputTextField.text]]];
    }else if(self.segmentedControl.selectedSegmentIndex == 1){
        self.request = [RKRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youdao.com/smartresult-xml/search.s?type=ip&q=%@",self.inputTextField.text] ]];
    }
    
    [super loadObjectsFromRemote];
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"success :%@",[response bodyAsString]);
    
    SSQUSmartResult * result = [SSMapping4RestKitUtils performMappingWithMapping:[SSQUSmartResult sharedObjectMapping] forXmlString:[response bodyAsString] usingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];

    if (result==nil)
    {
        self.outputLabel.text = @"抱歉！查无结果";
    }else{
        self.outputLabel.text = result.product.location;
    }
    self.outputLabel.numberOfLines = 0;
    CGSize constraint = CGSizeMake(260, 20000.0f);
    CGSize labelSize = [self.outputLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];

    self.outputLabel.frame = CGRectMake(self.outputLabel.frame.origin.x, self.outputLabel.frame.origin.y, labelSize.width, labelSize.height);
    [self.loadingView hideLoadingView];
    
}


@end





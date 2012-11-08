//
//  SSQUIDViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-4.
//
//

#import "SSQUIDViewController.h"
#import "SSMapping4RestKitUtils.h"
#import "SSQUSmartResult.h"
@interface SSQUIDViewController ()

@end

@implementation SSQUIDViewController

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
    self.segmentedControl.hidden = YES;
    self.inputTextField.frame = CGRectMake(self.inputTextField.frame.origin.x, self.inputTextField.frame.origin.y-20, self.inputTextField.frame.size.width, self.inputTextField.frame.size.height);
    self.inputTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    self.inputTextField.placeholder = @"请输入身份证号码";
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadObjectsFromRemote{
    
    self.request = [RKRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.youdao.com/smartresult-xml/search.s?type=id&q=%@",self.inputTextField.text]]];
        
    [super loadObjectsFromRemote];
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"success :%@",[response bodyAsString]);
    
    SSQUSmartResult * result = [SSMapping4RestKitUtils performMappingWithMapping:[SSQUSmartResult sharedObjectMapping] forXmlString:[response bodyAsString] usingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    
    if (result==nil)
    {
        self.outputLabel.text = @"抱歉！查无结果";
    }else{
        if ([result.product.gender isEqualToString:@"m"]) {
            self.outputLabel.text = [NSString stringWithFormat:@"性别:男 生日:%@ 地区:%@",result.product.birthday,result.product.location];
        }else{
            self.outputLabel.text = result.product.location;
            self.outputLabel.text = [NSString stringWithFormat:@"性别:女 生日:%@ 地区:%@",result.product.birthday,result.product.location];
        }
        
    }
    self.outputLabel.numberOfLines = 0;
    CGSize constraint = CGSizeMake(260, 20000.0f);
    CGSize labelSize = [self.outputLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    self.outputLabel.frame = CGRectMake(self.outputLabel.frame.origin.x, self.outputLabel.frame.origin.y, labelSize.width, labelSize.height);
    [self.loadingView hideLoadingView];
    
}

@end

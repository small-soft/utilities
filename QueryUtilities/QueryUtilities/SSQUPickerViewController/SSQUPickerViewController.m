//
//  SSQUPickerViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-4.
//
//

#import "SSQUPickerViewController.h"

@interface SSQUPickerViewController ()

@end

@implementation SSQUPickerViewController
@synthesize request = _request;
@synthesize pickerView = _pickerView;
@synthesize selectButton = _selectButton;
@synthesize resultLabel = _resultLabel;

-(void)dealloc{
    [self.request cancel];
    self.request = nil;
    self.selectButton = nil;
    self.pickerView = nil;
    self.resultLabel = nil;
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
    self = [self initWithNibName:@"SSQUPickerViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 设置按钮
    UIImage *buttonImageNormal = [UIImage imageNamed:@"gray_btn_small"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [self.selectButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"gray_btn_small_p"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [self.selectButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    
    [self.selectButton addTarget:self action:@selector(selectButtonPressDown) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadObjectsFromRemote{
    
    self.request.delegate = self;
    [self.loadingView showLoadingView];
    [self.request send];
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"success :%@",[response bodyAsString]);

    self.resultLabel.numberOfLines = 0;
    CGSize constraint = CGSizeMake(280, 20000.0f);
    CGSize labelSize = [self.resultLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    self.resultLabel.frame = CGRectMake(self.resultLabel.frame.origin.x, self.resultLabel.frame.origin.y, labelSize.width, labelSize.height);
    [self.loadingView hideLoadingView];
    
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"failed :%@", error);
    self.resultLabel.text = @"网络好像有点问题，请检查您的网络^_^";
    self.resultLabel.numberOfLines = 0;
    CGSize constraint = CGSizeMake(280, 20000.0f);
    CGSize labelSize = [self.resultLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    self.resultLabel.frame = CGRectMake(self.resultLabel.frame.origin.x, self.resultLabel.frame.origin.y, labelSize.width, labelSize.height);
    [self.loadingView hideLoadingView];
}


-(void)selectButtonPressDown{
    [self loadObjectsFromRemote];
}
@end

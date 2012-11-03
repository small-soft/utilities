//
//  SSQUExchangeRateViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-28.
//
//

#import "SSQUExchangeRateViewController.h"
#import "SSLoadingView.h"
#import <RestKit/RestKit.h>
@interface SSQUExchangeRateViewController ()<RKRequestDelegate>
@property (nonatomic, retain) IBOutlet UIButton * selectButton;
@property (nonatomic, retain) IBOutlet UILabel * resultLabel;
@property (nonatomic, retain) NSArray * countries;
@property (nonatomic, retain) RKRequest * request;
@property (nonatomic, retain) NSMutableDictionary * currentCountryDic;
@end

@implementation SSQUExchangeRateViewController
@synthesize countryPickerView = _countryPickerView ;
@synthesize selectButton = _selectButton;
@synthesize resultLabel = _resultLabel;
@synthesize countries = _countries;
@synthesize currentCountryDic = _currentCountryDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _countries = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MoneyUnit.plist" ofType:nil]];
        _currentCountryDic = [[NSMutableDictionary alloc] init];
        [self.currentCountryDic setValue:[self.countries objectAtIndex:0] forKey:@"first_country_code"];
        [self.currentCountryDic setValue:[self.countries objectAtIndex:1] forKey:@"second_country_code"];

    }
    return self;
}

-(void)dealloc{
    self.countryPickerView = nil;
    self.selectButton = nil;
    self.resultLabel = nil;
    self.countries = nil;
    [self.request cancel];
    self.request = nil;
    self.currentCountryDic=nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.countryPickerView selectRow:1 inComponent:1 animated:YES];
    [self.selectButton addTarget:self action:@selector(selectButtonPressDown:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.countries.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.countries objectAtIndex:row] objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (0==component) {
        [self.currentCountryDic setValue:[self.countries objectAtIndex:row] forKey:@"first_country_code"];
    }
    if (1==component) {
        [self.currentCountryDic setValue:[self.countries objectAtIndex:row] forKey:@"second_country_code"];
    }
}

-(void)loadObjectsFromRemote{
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    self.request = [RKRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://api.liqwei.com/currency/?exchange=%@|%@&count=100",[[self.currentCountryDic objectForKey:@"first_country_code"] objectForKey:@"code"],[[self.currentCountryDic objectForKey:@"second_country_code"] objectForKey:@"code"]] stringByAddingPercentEscapesUsingEncoding:encode]]];
    self.request.delegate = self;
    [self.loadingView showLoadingView];
    [self.request send];
    
}

-(IBAction)selectButtonPressDown:(id)sender{
    [self loadObjectsFromRemote];
}


-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"success :%@",[response bodyAsString]);

    NSString * firstCountryName = [[self.currentCountryDic objectForKey:@"first_country_code"] objectForKey:@"name"];
    NSString * secondCountryName = [[self.currentCountryDic objectForKey:@"second_country_code"] objectForKey:@"name"];
    self.resultLabel.text = [NSString stringWithFormat:@"100 %@ = %@ %@\n%@对%@汇率:%@",firstCountryName,[response bodyAsString],secondCountryName,firstCountryName,secondCountryName,[response bodyAsString]];
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
@end

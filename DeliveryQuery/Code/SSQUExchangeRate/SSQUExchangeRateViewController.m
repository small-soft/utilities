//
//  SSQUExchangeRateViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-28.
//
//

#import "SSQUExchangeRateViewController.h"

@interface SSQUExchangeRateViewController ()<RKRequestDelegate>

@property (nonatomic, retain) NSArray * countries;

@property (nonatomic, retain) NSMutableDictionary * currentCountryDic;
@end

@implementation SSQUExchangeRateViewController

@synthesize countries = _countries;
@synthesize currentCountryDic = _currentCountryDic;

-(id)init{
    self = [super init];
    if (self) {
        _countries = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MoneyUnit.plist" ofType:nil]];
        _currentCountryDic = [[NSMutableDictionary alloc] init];
        [self.currentCountryDic setValue:[self.countries objectAtIndex:0] forKey:@"first_country_code"];
        [self.currentCountryDic setValue:[self.countries objectAtIndex:1] forKey:@"second_country_code"];
    }
    return self;
}

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

    self.countries = nil;
    self.currentCountryDic=nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.pickerView selectRow:1 inComponent:1 animated:YES];

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
    [super loadObjectsFromRemote];
    
}


-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"success :%@",[response bodyAsString]);

    NSString * firstCountryName = [[self.currentCountryDic objectForKey:@"first_country_code"] objectForKey:@"name"];
    NSString * secondCountryName = [[self.currentCountryDic objectForKey:@"second_country_code"] objectForKey:@"name"];
    self.resultLabel.text = [NSString stringWithFormat:@"100 %@ = %@ %@\n%@对%@汇率:%@",firstCountryName,[response bodyAsString],secondCountryName,firstCountryName,secondCountryName,[response bodyAsString]];
    
    [super request:request didLoadResponse:response];
    
}

@end

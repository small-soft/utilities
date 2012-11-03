//
//  SSQUWeatherViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-27.
//
//

#import "SSQUWeatherViewController.h"
#import <RestKit/RestKit.h>
#import "SSQULocation.h"

@interface SSQUWeatherViewController ()<RKRequestDelegate>
@property (nonatomic, retain) RKRequest * request;
@property (nonatomic, retain) NSArray *provinces;
@property (nonatomic, retain) NSArray *cities;
@property (nonatomic, retain) SSQULocation *currentLocation;
@property (nonatomic, retain) IBOutlet UIButton * selectButton;
@property (nonatomic, retain) IBOutlet UILabel *resultLabel;

@end

@implementation SSQUWeatherViewController
@synthesize request = _request;
@synthesize provinces = _provinces;
@synthesize cities = _cities;
@synthesize currentLocation = _currentLocation;
@synthesize locationPicker = _locationPicker;
@synthesize selectButton = _selectButton;
@synthesize resultLabel = _resultLabel;

-(void)dealloc{
    [self.request cancel];
    self.request = nil;
    self.provinces = nil;
    self.cities = nil;
    self.currentLocation = nil;
    self.selectButton = nil;
    self.locationPicker =nil;
    self.resultLabel = nil;

    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvincesAndCities.plist" ofType:nil]];
        _cities = [[[self.provinces objectAtIndex:0] objectForKey:@"Cities"] retain];
        
        _currentLocation = [[SSQULocation alloc] init];
        _currentLocation.state = [[self.provinces objectAtIndex:0] objectForKey:@"State"];
        _currentLocation.city = [[self.cities objectAtIndex:0] objectForKey:@"city"];
        _currentLocation.latitude = [[[self.cities objectAtIndex:0] objectForKey:@"lat"] doubleValue];
        _currentLocation.longitude = [[[self.cities objectAtIndex:0] objectForKey:@"lon"] doubleValue];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.selectButton addTarget:self action:@selector(selectButtonPressDown:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadObjectsFromRemote{
//    RKClient * client = [[RKClient alloc] initWithBaseURLString:@"http://api.liqwei.com"];
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    self.request = [RKRequest requestWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"http://api.liqwei.com/weather?city=%@",self.currentLocation.city] stringByAddingPercentEscapesUsingEncoding:encode]]];
    self.request.delegate = self;
    //    [client get:beijing delegate:self];
    [self.loadingView showLoadingView];
    [self.request send];
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"success :%@",[response bodyAsString]);
    NSArray *tempResultArray = [[response bodyAsString] componentsSeparatedByString:@"<br/>"];
    NSMutableString * tempResult = [[NSMutableString alloc] init];
    for (NSString * tempResultLine in tempResultArray) {
        [tempResult appendFormat:@"%@\n",tempResultLine];
    }
    self.resultLabel.text = tempResult;
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

//-(NSString *)EncodeGB2312Str:(NSString *)encodeStr{
//    CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");
//    NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding
//(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingGB_18030_2000);
//    NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000) autorelease];
//    [preprocessedString release];
//    return newStr;
//}

#pragma mark - PickerView lifecycle
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.provinces count];

        case 1:
            return [self.cities count];

        default:
            return 0;

    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[self.provinces objectAtIndex:row] objectForKey:@"State"];

        case 1:
            return [[self.cities objectAtIndex:row] objectForKey:@"city"];
       
        default:
            return nil;

    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"Cities"];
            [self.locationPicker selectRow:0 inComponent:1 animated:NO];
            [self.locationPicker reloadComponent:1];
            
            self.currentLocation.state = [[self.provinces objectAtIndex:row] objectForKey:@"State"];
            self.currentLocation.city = [[self.cities objectAtIndex:0] objectForKey:@"city"];
            self.currentLocation.latitude = [[[self.cities objectAtIndex:0] objectForKey:@"lat"] doubleValue];
            self.currentLocation.longitude = [[[self.cities objectAtIndex:0] objectForKey:@"lon"] doubleValue];
            break;
        case 1:
            self.currentLocation.city = [[self.cities objectAtIndex:row] objectForKey:@"city"];
            self.currentLocation.latitude = [[[self.cities objectAtIndex:row] objectForKey:@"lat"] doubleValue];
            self.currentLocation.longitude = [[[self.cities objectAtIndex:row] objectForKey:@"lon"] doubleValue];
            break;
        default:
            break;
    }
}

-(IBAction)selectButtonPressDown:(id)sender{
    [self loadObjectsFromRemote];
}
@end

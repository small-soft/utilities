//
//  SSQUWeatherViewController.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-10-27.
//
//

#import "SSQUWeatherViewController.h"
#import <RestKit/RestKit.h>
@interface SSQUWeatherViewController ()<RKRequestDelegate>

@end

@implementation SSQUWeatherViewController

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
    [self loadObjectsFromRemote];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadObjectsFromRemote{
//    RKClient * client = [[RKClient alloc] initWithBaseURLString:@"http://api.liqwei.com"];
    
    NSString * beijing = [NSString stringWithFormat:@"http://api.liqwei.com/weather?city=%@",[self EncodeGB2312Str:@"北京"]];
    
//    [client get:beijing delegate:self];
    
    RKRequest *request = [[[RKRequest alloc] initWithURL:[NSURL URLWithString:beijing]] autorelease];
//    [client configureRequest:request];
    request.delegate = self;
    [request send];
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response{
    NSLog(@"success :%@",[response bodyAsString]);
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"failed :%@", error);
}

-(NSString *)EncodeGB2312Str:(NSString *)encodeStr{
    CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");
    NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingGB_18030_2000);
    NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000) autorelease];
    [preprocessedString release];
    return newStr;
}

@end

//
//  NSString+NSStringUtil.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-7.
//
//

#import "NSString+NSStringUtil.h"

@implementation NSString (NSStringUtil)

-(NSString *)append:(NSString *)str {
    return [NSString stringWithFormat:@"%@%@",self,str];
}

-(NSString *)preFix:(NSString *)str{
    return [NSString stringWithFormat:@"%@%@",str,self];
}

+(NSString *)escapeURL:(NSString *)str{
    NSString *encodedValue = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return encodedValue;
}
@end

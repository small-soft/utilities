//
//  NSString+NSStringUtil.h
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-7.
//
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringUtil)

-(NSString*)append:(NSString*)str;
-(NSString*)preFix:(NSString*)str;
+(NSString*)escapeURL:(NSString*)str;

@end

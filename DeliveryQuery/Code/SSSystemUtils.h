//
//  SSSystemUtils.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-20.
//
//

#import <Foundation/Foundation.h>

@interface SSSystemUtils : NSObject

/*
 *xiejin
 *打电话
 */
+ (void) makeCallWithNumber:(NSString *) phoneNumber;

//+ (void) makeCallWithNumber2:(NSString *)phoneNumber;

+ (void) openBrowserWithUrl:(NSString *) url;


/*
 *xiejin
 *获取app内部资源文件路径，filename为文件名，可以带子路径
 */
+ (NSString *) getAppFilePath:(NSString *) fileName;

@end

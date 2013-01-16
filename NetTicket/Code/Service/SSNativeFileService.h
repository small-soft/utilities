//
//  SSNativeFileService.h
//  NetTicket
//
//  Created by 神逸 on 13-1-9.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSNativeFileService : NSObject

+(NSString*)getNativePathWithRelativePath:(NSString*)relativePath;
+(void)writeTo:(NSString*) toPath from:(NSString*)fromPath;
+(void)writeImage:(UIImage*)image to:(NSString*) toPath;

@end

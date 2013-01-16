//
//  SSNativeFileService.m
//  NetTicket
//
//  Created by 神逸 on 13-1-9.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import "SSNativeFileService.h"

@implementation SSNativeFileService

+(void)writeTo:(NSString *)toPath from:(NSString *)fromPath {
    NSString *writableDBPath = [SSNativeFileService getNativePathWithRelativePath:toPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:writableDBPath]) {
        [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:writableDBPath error:nil];
    }
    

}

+(void)writeImage:(UIImage *)image to:(NSString *)toPath {
    NSError *error = [[[NSError alloc]init]autorelease];
    
//    NSLog(@"from path : %@",UIImagePNGRepresentation(image));
    
    NSLog(@"write image result is %d", [UIImagePNGRepresentation(image) writeToFile:toPath options:NSDataWritingAtomic error:&error]);
    
//    NSLog(@"to path: %@",toPath);
    
    if (error != nil) {
//        NSLog(@"hit error : %@",error);
    }
}

+(NSString*)getNativePathWithRelativePath:(NSString*)relativePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:relativePath];
    
    return writableDBPath;
    
}
@end

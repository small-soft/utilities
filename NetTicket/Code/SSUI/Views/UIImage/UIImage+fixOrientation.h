//
//  UIImage+fixOrientation.h
//  NetTicket
//
//  Created by 神逸 on 13-1-9.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (fixOrientation)
- (UIImage *)fixOrientation;
+(UIImage *)rotateImage:(UIImage *)aImage;
@end

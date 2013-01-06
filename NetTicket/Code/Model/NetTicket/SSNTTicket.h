//
//  SSNTTicket.h
//  NetTicket
//
//  Created by 刘 佳 on 13-1-4.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSNTTicket : NSObject

@property(nonatomic)NSInteger id;
@property(nonatomic,retain)NSString *code;
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSDate *validStart;
@property(nonatomic,retain)NSDate *validEnd;
@property(nonatomic,retain)NSString *comment;

@end

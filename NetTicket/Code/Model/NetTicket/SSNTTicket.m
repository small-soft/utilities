//
//  SSNTTicket.m
//  NetTicket
//
//  Created by 刘 佳 on 13-1-4.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import "SSNTTicket.h"

@implementation SSNTTicket

@synthesize validStart = _validStart;
@synthesize code = _code;
@synthesize comment = _comment;
@synthesize id = _id;
@synthesize type = _type;
@synthesize validEnd = _validEnd;

-(void)dealloc {
    self.validEnd = nil;
    self.comment = nil;
    self.code = nil;
    self.type = nil;
    self.validStart = nil;
    
    [super dealloc];
}

@end

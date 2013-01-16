//
//  SSNTTicketService.h
//  NetTicket
//
//  Created by 刘 佳 on 13-1-4.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSNTTicket.h"

@interface SSNTTicketService : NSObject

+(NSArray*)getTicketByType:(NSString *)type;
+(NSInteger)addTicket:(SSNTTicket*)ticket;
+(NSInteger)update:(SSNTTicket*)ticket;
+(NSInteger)delete:(int)ticketId;
+(UIImage*)getTicketImageById:(int)id;
+(NSString*)getImagePathById:(int)id;
@end

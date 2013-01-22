//
//  SSNTTicketService.m
//  NetTicket
//
//  Created by 刘 佳 on 13-1-4.
//  Copyright (c) 2013年 Small-Soft. All rights reserved.
//

#import "SSNTTicketService.h"
#import "FMDatabase.h"
#import "SSQUAppDelegate.h"
#import "SSNativeFileService.h"

@implementation SSNTTicketService

#pragma mark -
#pragma mark QUERY
+(NSArray *)getTicketByType:(NSString *)type{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    
    FMDatabase *db = GETDB;
    if ([db open]) {
        NSMutableString *sql = [NSMutableString stringWithString: @"SELECT * from NTTicket"];
        
        if (type.length > 0) {
            if ([type isEqualToString:@"已过期"]) {
                [sql appendFormat:@" where validEnd <= %f AND  validEnd > 0",[[NSDate date] timeIntervalSince1970]];
            }else {
                [sql appendFormat:@" where type = '%@' AND (validEnd = 0 OR validEnd > %f)",type,[[NSDate date] timeIntervalSince1970]];
            }
        }else {
            [sql appendFormat:@" where (validEnd = 0 OR validEnd > %f)",[[NSDate date] timeIntervalSince1970]];
        }
        
        [sql appendString:@" order by id desc"];
        NSLog(@"execute sql:%@",sql);
        
        FMResultSet *rs = [db executeQuery:sql];
        
        while ([rs next]) {
            
            SSNTTicket *ticket = [[[SSNTTicket alloc]init]autorelease];
            ticket.id = [rs intForColumn:@"id"];
            
            NSTimeInterval validStart = [rs doubleForColumn:@"validStart"];
            if (validStart > 0) {
                ticket.validStart = [NSDate dateWithTimeIntervalSince1970:validStart];
            }
            
            NSTimeInterval validEnd = [rs doubleForColumn:@"validEnd"];
            if (validEnd > 0) {
                ticket.validEnd = [NSDate dateWithTimeIntervalSince1970:validEnd];
            }
            
            ticket.type = [rs stringForColumn:@"type"];
            ticket.comment = [rs stringForColumn:@"comment"];
            ticket.code = [rs stringForColumn:@"code"];
            
            [array addObject:ticket];
        }
        
    }
    
    [db close];
    
    return array;
}

#pragma mark -
#pragma mark INSERT
+(NSInteger)addTicket:(SSNTTicket *)ticket {
    NSInteger result = 0;
    
    if (ticket == nil) {
        return result;
    }
    
    FMDatabase *db = GETDB;
    if ([db open]) {
        
        if (ticket.comment.length <= 0) {
            ticket.comment = @"";
        }
        
        if (ticket.type.length <= 0) {
            ticket.type = @"其他";
        }
        
        if (ticket.code.length <= 0) {
            ticket.code = @"";
        }
        
        NSString *sqlInsert = [NSString stringWithFormat: @"INSERT INTO NTTicket(validStart,validEnd,type,Comment,Code) values(%f,%f,'%@','%@','%@')",[ticket.validStart timeIntervalSince1970],[ticket.validEnd timeIntervalSince1970],ticket.type,ticket.comment,ticket.code];
        
        NSLog(@"sql:%@",sqlInsert);
        
        if ([db executeUpdate:sqlInsert]) {
            result = [db lastInsertRowId];
        }

    }
    
    [db close];
        
    return result;
}

+(NSInteger)update:(SSNTTicket *)ticket {
    NSInteger result = 0;
    
    if (ticket == nil) {
        return result;
    }
    
    FMDatabase *db = GETDB;
    if ([db open]) {
        
        if (ticket.comment.length <= 0) {
            ticket.comment = @"";
        }
        
        if (ticket.type.length <= 0) {
            ticket.type = @"未分类";
        }
        
        if (ticket.code.length <= 0) {
            ticket.code = @"";
        }
        
        NSString *sql= [NSString stringWithFormat: @"UPDATE NTTicket set validStart = %f ,validEnd = %f,type = '%@',comment = '%@',code = '%@' where id = %d",[ticket.validStart timeIntervalSince1970],[ticket.validEnd timeIntervalSince1970],ticket.type,ticket.comment,ticket.code,ticket.id];
        
        NSLog(@"sql:%@",sql);
        
        if ([db executeUpdate:sql]) {
            result = ticket.id;
        }
        
    }
    
    [db close];
    
    return result;
}

+(NSInteger)delete:(int)ticketId {
    NSInteger result = 0;
    
    if (ticketId <= 0) {
        return result;
    }
    
    FMDatabase *db = GETDB;
    if ([db open]) {
        
        NSString *sql= [NSString stringWithFormat: @"DELETE FROM NTTicket where id = %d",ticketId];
        
        NSLog(@"sql:%@",sql);
        
        if ([db executeUpdate:sql]) {
            result = ticketId;
        }
        
    }
    
    [db close];
    
    return result;
}

+(UIImage *)getTicketImageById:(int)id {
    
    return [UIImage imageWithContentsOfFile:[SSNTTicketService getImagePathById:id]];
}

+(NSString *)getImagePathById:(int)id {
    NSString *ticketImagePath = [SSNativeFileService getNativePathWithRelativePath:[NSString stringWithFormat:@"image/ticket/"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath: ticketImagePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:ticketImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%d.png",ticketImagePath,id];
//    NSLog(@"image path is %@",path);
    
    return path;
}
@end

//
//  SSDQDeliveryQueryResult.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-13.
//
//

#import "SSDQDeliveryQueryResult.h"

@implementation SSDQDeliveryItem
@synthesize context = _context;
@synthesize time = _time;
+ (RKObjectMapping *)sharedObjectMapping {
//        static RKObjectMapping* sharedObjectMapping;
    //
//        @synchronized (self) {
//        if (!sharedObjectMapping) {
    RKObjectMapping * sharedObjectMapping;
    sharedObjectMapping = [RKObjectMapping mappingForClass:[SSDQDeliveryItem class]] ;
    
    [sharedObjectMapping mapKeyPath:@"context" toAttribute:@"context"];
    [sharedObjectMapping mapKeyPath:@"time" toAttribute:@"time"];
    
//        }
//    }
    return sharedObjectMapping;
}
- (void)dealloc
{
    self.time = nil;
    self.context = nil;
    [super dealloc];
}

@end


@implementation SSDQDeliveryResult

@synthesize data = _data;
@synthesize errCode = _errCode;
@synthesize expSpellName = _expSpellName;
@synthesize expTextName = _expTextName;
@synthesize status = _status;
@synthesize mailNo = _mailNo;
@synthesize id;
@synthesize comment = _comment;

+ (RKObjectMapping *)sharedObjectMapping {
//    static RKObjectMapping* sharedObjectMapping;
    //
//    @synchronized (self) {
    RKObjectMapping * sharedObjectMapping;
//        if (!sharedObjectMapping) {
    sharedObjectMapping = [RKObjectMapping mappingForClass:[SSDQDeliveryResult class]] ;
    
    [sharedObjectMapping mapKeyPath:@"errCode" toAttribute:@"errCode"];
    [sharedObjectMapping mapKeyPath:@"expSpellName" toAttribute:@"expSpellName"];
    [sharedObjectMapping mapKeyPath:@"expTextName" toAttribute:@"expTextName"];
    [sharedObjectMapping mapKeyPath:@"status" toAttribute:@"status"];
    [sharedObjectMapping mapKeyPath:@"mailNo" toAttribute:@"mailNo"];
    
    [sharedObjectMapping mapRelationship:@"data" withMapping:[SSDQDeliveryItem sharedObjectMapping]];
//    sharedObjectMapping.rootKeyPath =@"response";
//            }
//        }
    
    return sharedObjectMapping;
}
- (void)dealloc
{
    self.comment = nil;
    self.data = nil;
    self.errCode = nil;
    self.status =nil;
    self.expSpellName = nil;
    self.expTextName = nil;
    self.mailNo = nil;
    [super dealloc];
}

@end


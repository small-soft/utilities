//
//  SSDQDeliveryQueryResult.m
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-13.
//
//

#define COMMON_ERROR_DESCRIPTION @"系统错误，请稍后再试！"

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

@interface SSDQDeliveryResult()
@property (nonatomic,retain) NSArray *statusDescriptions;
@property (nonatomic,retain) NSArray *errorDescriptions;
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
@synthesize message = _message;
@synthesize statusDescriptions = _statusDescriptions;
@synthesize errorDescriptions = _errorDescriptions;
@synthesize latestContext = _latestContext;
@synthesize sendTime = _sendTime;
@synthesize signTime = _signTime;
@synthesize companyPhone = _companyPhone;

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
    [sharedObjectMapping mapKeyPath:@"message" toAttribute:@"message"];
    
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
//    self.errCode = nil;
//    self.status =nil;
    self.expSpellName = nil;
    self.expTextName = nil;
    self.mailNo = nil;
    self.message = nil;
    self.errorDescriptions = nil;
    self.statusDescriptions = nil;
    self.companyPhone = nil;
    self.sendTime = nil;
    self.latestContext = nil;
    self.signTime = nil;
    [super dealloc];
}

-(NSString *)getErrorDescription {
    
    if (_errorDescriptions == nil) {
        //错误代码，0无错误，1单号不存在，2验证码错误，3链接查询服务器失败，4程序内部错误，5程序执行错误，6快递单号格式错误，7快递公司错误，10未知错误
//        self.errorDescriptions = [NSArray arrayWithObjects:@"成功",@"单号不存在",@"验证码错误",@"链接查询服务器失败",@"程序内部错误",@"程序执行错误",@"快递单号格式错误",@"快递公司错误",@"未知错误", nil];
        
        self.errorDescriptions = [NSArray arrayWithObjects:@"成功",@"快递单号不存在",COMMON_ERROR_DESCRIPTION,COMMON_ERROR_DESCRIPTION,COMMON_ERROR_DESCRIPTION,COMMON_ERROR_DESCRIPTION,@"快递单号不存在",@"快递公司错误",@"未知错误", nil];
    }
    
    if (self.errCode >= [self.errorDescriptions count]) {
        return @"快递单号不存在";
    }
    
    return [self.errorDescriptions objectAtIndex:self.errCode];
    
}

-(NSString *)getStatusDescription {
    if (_statusDescriptions == nil) {
        //0表示查询失败，1正常，2派送中，3已签收，4退回
        self.statusDescriptions = [NSArray arrayWithObjects:@"查询失败",@"正常",@"派送中",@"已签收",@"退回", nil];
    }
    
    return [self.statusDescriptions objectAtIndex:self.status];
}

@end


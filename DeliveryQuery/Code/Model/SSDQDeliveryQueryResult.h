//
//  SSDQDeliveryQueryResult.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-13.
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

typedef NS_ENUM(NSInteger, SSDQDeliveryResultStatus)
{
    //0表示查询失败，1正常，2派送中，3已签收，4退回
    SSDQDeliveryResultStatusFailed = 0,
    SSDQDeliveryResultStatusSuccess,
    SSDQDeliveryResultStatusSending,
    SSDQDeliveryResultStatusSigned,
    SSDQDeliveryResultStatusSendBack,
    
};


//错误代码，0无错误，1单号不存在，2验证码错误，3链接查询服务器失败，4程序内部错误，5程序执行错误，6快递单号格式错误，7快递公司错误，10未知错误
typedef NS_ENUM(NSInteger, SSDQDeliveryResultErrorCode) {
    SSDQDeliveryResultErrorCodeNoError = 0,
    SSDQDeliveryResultErrorCodeNumberNotExist,
    SSDQDeliveryResultErrorCodeCheckCodeError,
    SSDQDeliveryResultErrorCodeConectServerError,
    SSDQDeliveryResultErrorCodeSystemError,
    SSDQDeliveryResultErrorCodeSystemExecuteError,
    SSDQDeliveryResultErrorCodeNumberFormateError,
    SSDQDeliveryResultErrorCodeCompanyError,
    SSDQDeliveryResultErrorCodeUnknown,  // This separator style is only supported for grouped style table views currently
};

@interface SSDQDeliveryItem : NSObject
@property (nonatomic,copy) NSString * time;
@property (nonatomic,copy) NSString * context;
+ (RKObjectMapping *)sharedObjectMapping;
@end


@interface SSDQDeliveryResult : NSObject
@property (nonatomic, retain) NSMutableArray* data;
@property (nonatomic) SSDQDeliveryResultStatus status;
@property (nonatomic) SSDQDeliveryResultErrorCode errCode;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, copy) NSString *expTextName;
@property (nonatomic, copy) NSString *expSpellName;
@property (nonatomic, copy) NSString *mailNo;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic) NSInteger id;
@property (nonatomic,retain) NSString *sendTime;
@property (nonatomic,retain) NSString *signTime;
@property (nonatomic,retain) NSString *latestContext;
@property (nonatomic,retain) NSString *companyPhone;
+ (RKObjectMapping *)sharedObjectMapping;

-(NSString*) getStatusDescription;
-(NSString*) getErrorDescription;
@end

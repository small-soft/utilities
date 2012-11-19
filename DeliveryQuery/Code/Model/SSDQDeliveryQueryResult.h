//
//  SSDQDeliveryQueryResult.h
//  DeliveryQuery
//
//  Created by 刘 佳 on 12-11-13.
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
@interface SSDQDeliveryItem : NSObject
@property (nonatomic,copy) NSString * time;
@property (nonatomic,copy) NSString * context;
+ (RKObjectMapping *)sharedObjectMapping;
@end


@interface SSDQDeliveryResult : NSObject
@property (nonatomic, retain) NSMutableArray* data;
@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, copy) NSString *errCode;
@property (nonatomic, copy) NSString *expTextName;
@property (nonatomic, copy) NSString *expSpellName;
@property (nonatomic, copy) NSString *mailNo;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic) NSInteger id;
+ (RKObjectMapping *)sharedObjectMapping;
@end

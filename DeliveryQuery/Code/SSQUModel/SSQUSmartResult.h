//
//  SSQUSmartResult.h
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-4.
//
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
@interface SSQUProduct : NSObject
@property (nonatomic,retain) NSString * type;
@property (nonatomic,retain) NSString * phonenum;
@property (nonatomic,retain) NSString * location;
@property (nonatomic,retain) NSString * ip;
@property (nonatomic,retain) NSString * gender;
@property (nonatomic,retain) NSString * birthday;
+ (RKObjectMapping *)sharedObjectMapping;
@end

@interface SSQUSmartResult : NSObject
@property (nonatomic, retain) SSQUProduct* product;
+ (RKObjectMapping *)sharedObjectMapping;
@end

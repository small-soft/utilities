//
//  SSQUSmartResult.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-4.
//
//

#import "SSQUSmartResult.h"

@implementation SSQUProduct
@synthesize type = _type;
@synthesize phonenum = _phonenum;
@synthesize location = _location;
@synthesize ip = _ip;
@synthesize birthday = _birthday;
@synthesize gender = _gender;
+ (RKObjectMapping *)sharedObjectMapping {
    //    static RKObjectMapping* sharedObjectMapping;
    //
    //    @synchronized (self) {
    //        if (!sharedObjectMapping) {
    RKObjectMapping * sharedObjectMapping;
    sharedObjectMapping = [RKObjectMapping mappingForClass:[SSQUProduct class]] ;
    
    [sharedObjectMapping mapKeyPath:@"type" toAttribute:@"type"];
    [sharedObjectMapping mapKeyPath:@"phonenum" toAttribute:@"phonenum"];
    [sharedObjectMapping mapKeyPath:@"location" toAttribute:@"location"];
    [sharedObjectMapping mapKeyPath:@"ip" toAttribute:@"ip"];
    [sharedObjectMapping mapKeyPath:@"birthday" toAttribute:@"birthday"];
    [sharedObjectMapping mapKeyPath:@"gender" toAttribute:@"gender"];
    //        }
    //    }
    
    return sharedObjectMapping;
}
- (void)dealloc
{
    self.type = nil;
    self.phonenum = nil;
    self.location = nil;
    self.ip = nil;
    self.birthday = nil;
    self.gender = nil;
    [super dealloc];
}

@end

@implementation SSQUSmartResult

@synthesize product = _product;

+ (RKObjectMapping *)sharedObjectMapping {
    //    static RKObjectMapping* sharedObjectMapping;
    //
    //    @synchronized (self) {
    RKObjectMapping * sharedObjectMapping;
    //        if (!sharedObjectMapping) {
    sharedObjectMapping = [RKObjectMapping mappingForClass:[SSQUSmartResult class]] ;
    
    [sharedObjectMapping mapRelationship:@"product" withMapping:[SSQUProduct sharedObjectMapping]];
    sharedObjectMapping.rootKeyPath =@"smartresult";
    //        }
    //    }
    
    return sharedObjectMapping;
}
- (void)dealloc
{
    self.product = nil;
    [super dealloc];
}

@end

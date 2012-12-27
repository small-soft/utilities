//
//  SSSNSites.h
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-11.
//
//

typedef NS_ENUM(NSInteger, SSSNFaver)
{
    //0：系统,1：用户
    SSSNFaverSystem = 0,
    SSSNFaverCustom,
};

#import <Foundation/Foundation.h>

@interface SSSNBigCat : NSObject<NSCopying>

@property(nonatomic)NSInteger id;
@property(nonatomic,retain)NSString *title;

@end

@interface SSSNSmallCat : NSObject

@property(nonatomic)NSInteger id;
@property(nonatomic,retain)NSString *title;
@property(nonatomic)NSInteger cat;
@property(nonatomic,retain)NSArray *sites;

@end

@interface SSSNSites : NSObject

@property(nonatomic)NSInteger id;
@property(nonatomic,retain)NSString *title;
@property(nonatomic)NSInteger cat;
@property(nonatomic,retain)NSString *url;
@property(nonatomic)SSSNFaver faver;//收藏者

@end

@interface SSFav : NSObject

@property(nonatomic)NSInteger id;
@property(nonatomic,retain)NSString *title;
@property(nonatomic)NSInteger cat;
@property(nonatomic,retain)NSString *catName;
@property(nonatomic,retain)NSString *url;
@property(nonatomic,retain)NSDate *date;

@end

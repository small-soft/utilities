//
//  SSSNSites.m
//  SiteNavigation
//
//  Created by 刘 佳 on 12-12-11.
//
//

#import "SSSNSites.h"

@implementation SSSNBigCat

@synthesize id = _id;
@synthesize title = _title;

-(void)dealloc{
    self.title = nil;
    
    [super dealloc];
}

- (SSSNBigCat *) initWithId:(NSInteger)id title:(NSString*)title {
    if (self = [super init]) {
        self.id = id;
        self.title = title;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    SSSNBigCat *cat = [[[self class] allocWithZone:zone] initWithId:self.id title:self.title];
    
    return cat;
}

@end

@implementation SSSNSmallCat

@synthesize id = _id;
@synthesize title = _title;
@synthesize cat = _cat;
@synthesize sites = _sites;

-(void)dealloc{
    self.title = nil;
    self.sites = nil;
    
    [super dealloc];
}

@end

@implementation SSSNSites

@synthesize id = _id;
@synthesize title = _title;
@synthesize cat = _cat;
@synthesize faver = _faver;
@synthesize url = _url;

-(void)dealloc{
    self.title = nil;
    self.url = nil;
    
    [super dealloc];
}

@end

@implementation SSFav

@synthesize id = _id;
@synthesize title = _title;
@synthesize cat = _cat;
@synthesize url = _url;
@synthesize catName = _catName;
@synthesize date = _date;

-(void)dealloc{
    self.title = nil;
    self.url = nil;
    self.date = nil;
    self.catName = nil;
    
    [super dealloc];
}

@end

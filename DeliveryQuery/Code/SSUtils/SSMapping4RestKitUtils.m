//
//  SSMapping4RestKitUtils.m
//  QueryUtilities
//
//  Created by 于 佳 on 12-11-3.
//
//

#import "SSMapping4RestKitUtils.h"

@implementation SSMapping4RestKitUtils
+(id)performMappingWithMapping:(RKObjectMappingDefinition*)configuredObjectMapping forXmlString:(NSString*)xmlString{
    RKObjectMappingProvider * mappingProvider = [RKObjectMappingProvider mappingProvider];
    NSString *rootKeyPath = configuredObjectMapping.rootKeyPath ? configuredObjectMapping.rootKeyPath : @"smartresult";
    [mappingProvider setMapping:configuredObjectMapping forKeyPath:rootKeyPath];
    NSError * error = nil;
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeXML];
    id parsedData = [parser objectFromString:xmlString error:&error];
    if (parsedData == nil && error) {
        return nil;
    }
    RKObjectMapper * mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:mappingProvider];
    RKObjectMappingResult * result = [mapper performMapping];
    if (result) {
        return [result asObject];
    }
    return nil;
}

+(id)performMappingWithMapping:(RKObjectMappingDefinition*)configuredObjectMapping forXmlString:(NSString*)xmlString usingEncoding:(NSStringEncoding)encoding{
    RKObjectMappingProvider * mappingProvider = [RKObjectMappingProvider mappingProvider];
    NSString *rootKeyPath = configuredObjectMapping.rootKeyPath ? configuredObjectMapping.rootKeyPath : @"";
    [mappingProvider setMapping:configuredObjectMapping forKeyPath:rootKeyPath];
    NSError * error = nil;
    id<RKParser> parser = [[RKParserRegistry sharedRegistry] parserForMIMEType:RKMIMETypeXML];
    id parsedData = [parser objectFromString:xmlString error:&error usingEncoding:encoding];
    if (parsedData == nil && error) {
        return nil;
    }
    RKObjectMapper * mapper = [RKObjectMapper mapperWithObject:parsedData mappingProvider:mappingProvider];
    RKObjectMappingResult * result = [mapper performMapping];
    if (result) {
        return [result asObject];
    }
    return nil;
}
@end

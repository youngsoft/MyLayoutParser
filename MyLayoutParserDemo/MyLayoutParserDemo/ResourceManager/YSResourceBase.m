//
//  YSResourceBase.m
//  jimustockFoundation
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSResourceBase.h"

extern CGFloat _jmbScaleFactor;


NSString *const kYSResourceObject = @"kYSResourceObject";
NSString *const kYSResourceRequestedSchema = @"kYSResourceRequestedSchema";
NSString *const kYSResourceResponsiveSchema= @"kYSResourceResponsiveSchema";

NSString *const YSResourceSchemaDidChangeNotification = @"YSResourceSchemaDidChangeNotification";


@implementation YSResourceBase

-(id)initWithBundle:(NSBundle*)bundle type:(NSString*)type;
{
    self = [super init];
    if (self != nil)
    {
        _bundle = bundle;
        _type = type;
        
        [self switchToSchemaInner:@""];
    }
    
    return self;
}

-(BOOL)switchToSchemaInner:(NSString*)schemaName
{
    //切换方案时，新的方案是否存在，如果存在则用新的方案，如果不存在则用当前方案
    NSString *fileName = nil;
    if ([schemaName isEqualToString:@""])
        fileName = _type;
    else
        fileName = [NSString stringWithFormat:@"%@_%@",schemaName, _type];
    
    
    //加载默认的方案
    NSString *defaultPlistPath = [_bundle pathForResource:_type ofType:@"plist"];
    NSAssert(defaultPlistPath != nil, @"Must have default schema");
    if (_dict == nil)
    {
        _dict = [[NSDictionary alloc] initWithContentsOfFile:defaultPlistPath];
        _schemaDict = _dict;
    }
    
    NSString *plistPath = nil;
    if ([schemaName isEqualToString:@""])
        plistPath = defaultPlistPath;
    else
        plistPath = [_bundle pathForResource:fileName ofType:@"plist"];
    
    BOOL bOK = (plistPath != nil && ![self.schema isEqualToString:schemaName]);
    
    if (plistPath == nil)
        plistPath = defaultPlistPath;
    
    
    
    //personalDict 个性化差异化
    NSString *personalFileName = nil;
    if ([schemaName isEqualToString:@""]) {
        personalFileName = [NSString stringWithFormat:@"%@_%@",kBBAEPersonalResourcePrefix, _type];
    }
    else
        personalFileName = [NSString stringWithFormat:@"%@_%@_%@",kBBAEPersonalResourcePrefix, schemaName, _type];
    
    NSString *personalPlistPath = [_bundle pathForResource:personalFileName ofType:@"plist"];
    if (personalPlistPath != nil) {
        _personalDict = [NSDictionary dictionaryWithContentsOfFile:personalPlistPath];
    }
    
    
    
    
    //清除缓存。
    if (_cache == nil)
    {
        _cache = [[NSCache alloc] init];
        [_cache setCountLimit:20];
    }
    
    //如果方案真实有变化
    if (bOK)
    {
        self.schema = schemaName;
        [_cache removeAllObjects];
        
        if (![schemaName isEqualToString:@""])
            _schemaDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        else
        {
            _schemaDict = _dict;
        }
    }
    
    return bOK;
}

-(BOOL)switchToSchema:(NSString*)schemaName
{
    BOOL ok = [self switchToSchemaInner:schemaName];
    if (ok)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:YSResourceSchemaDidChangeNotification object:nil userInfo:@{kYSResourceObject:self, kYSResourceRequestedSchema:schemaName, kYSResourceResponsiveSchema:self.schema}];
    }
    
    return ok;
    
}

-(BOOL)switchToDefaultSchema
{
    return [self switchToSchema:@""];
}

-(id)findResDescById:(NSString*)resId
{
    id desc = nil;
    
    //按/分割目录。
   NSArray *pathIds = [resId componentsSeparatedByString:@"/"];
    if (_personalDict != nil) {
        NSDictionary *tempDict = _personalDict;
        for (int i = 0; i < pathIds.count - 1; i++) {
            tempDict = [tempDict objectForKey:pathIds[i]];
        }
        desc = [tempDict objectForKey:[pathIds lastObject]];
    }
    if (desc != nil) {
        return desc;
    }
    
    
    
   if (_schemaDict != nil)
   {
       NSDictionary *tempDict = _schemaDict;
       for (int i = 0; i < pathIds.count - 1; i++)
       {
           tempDict = [tempDict objectForKey:pathIds[i]];
       }
       
       desc = [tempDict objectForKey:[pathIds lastObject] ];
   }
    
    if (desc != nil)
        return desc;
    
    NSDictionary *tempDict = _dict;
    for (int i = 0; i < pathIds.count - 1; i++)
    {
        tempDict = [tempDict objectForKey:pathIds[i]];
    }
    
    return [tempDict objectForKey:[pathIds lastObject] ];    
}

-(NSNumber*)scaledNumberFrom:(id)val
{
    if ([val isKindOfClass:[NSNumber class]])
        return val;
    else
    {
        NSString *strNumber = (NSString*)val;
        if ([strNumber hasPrefix:@"@"])
        {
            CGFloat scaledVal = [strNumber substringFromIndex:1].floatValue * _jmbScaleFactor;
            return [NSNumber numberWithFloat:scaledVal];
        }
        else
        {
            return [NSNumber numberWithFloat:strNumber.floatValue];
        }
    }
}





@end

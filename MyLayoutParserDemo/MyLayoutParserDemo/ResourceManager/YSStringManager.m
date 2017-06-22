//
//  YSStringManager.m
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSStringManager.h"

@implementation YSStringManager


-(id)initWithBundle:(NSBundle *)bundle
{
    self = [super initWithBundle:bundle type:@"string"];
    if (self != nil)
    {
        //第一次不需要进行通知。
        NSString *lanschema =  [[NSLocale preferredLanguages] objectAtIndex:0];
       [self switchToSchemaInner:lanschema];
    }
    
    return self;
}


-(NSString*)stringWith:(NSString*)stringId
{
    NSString *strVal = [self.cache objectForKey:stringId];
    if (strVal != nil)
        return strVal;
    
    strVal = [self findResDescById:stringId];
    if (strVal == nil)
        return stringId;
    
    //这里要替换掉其中的换行符    
    strVal = [strVal stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
    [self.cache setObject:strVal forKey:stringId];

    return strVal;
    
}

-(NSString*)stringFormatWith:(NSString *)stringId,...
{
    NSString *fmt = [self stringWith:stringId];
    va_list args;
    va_start(args, stringId);
    
    NSString *str = [[NSString alloc] initWithFormat:fmt arguments:args];
    va_end(args);
    
    return str;
}


-(NSArray*)stringArrayWith:(NSString*)stringArrayId
{
    NSArray *arr =  [self findResDescById:stringArrayId];
    if (arr == nil)
        NSAssert(0, @"Invalid stringarray value:%@",stringArrayId);
        
    return arr;
}



@end

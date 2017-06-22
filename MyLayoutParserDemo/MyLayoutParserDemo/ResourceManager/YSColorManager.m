//
//  YSColorManager.m
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSColorManager.h"


@implementation YSColorManager

-(id)initWithBundle:(NSBundle*)bundle
{
    return [super initWithBundle:bundle type:@"color"];
}


-(UIColor*)colorWith:(NSString*)colorId
{
    UIColor *color = [self.cache objectForKey:colorId];
    if (color != nil)
        return color;
    
    NSString *strVal = [self findResDescById:colorId];
    
    if (strVal == nil)
        NSAssert(0, @"Invalid color value:%@",colorId);
    
    if ([strVal hasPrefix:@"@"])
    {
        color = [self colorWith:[strVal substringFromIndex:1]];
    }
    else
    {
        color = [YSColorManager colorWithHex:strVal];
    }
    
    if (color != nil)
    {
        [self.cache setObject:color forKey:colorId];
    }
    
    return color;
    
}

+(UIColor*)colorWithHex:(NSString*)hex
{
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    unsigned int val = 0;
    [scanner scanHexInt:&val];
    
    unsigned char blue  = val & 0xFF;
    unsigned char green = (val >> 8) & 0xFF;
    unsigned char red = (val >> 16) & 0xFF;
    unsigned char alpha = hex.length == 6 ? 0xFF : (val >> 24) & 0xFF;
    
    return [[UIColor alloc ] initWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
}


@end

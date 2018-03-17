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
    
    if (strVal == nil){
//        NSAssert(0, @"Invalid color value:%@",colorId);
        strVal = colorId;
    }
    
    if ([strVal hasPrefix:@"@"] || [strVal hasPrefix:@"#"])
    {
        color = [self colorWith:[strVal substringFromIndex:1]];
    }
    else if ([strVal hasPrefix:@"0x"]){
        color = [self colorWith:[strVal substringFromIndex:2]];
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
    hex = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([hex length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([hex hasPrefix:@"0X"])
        hex = [hex substringFromIndex:2];
    if ([hex hasPrefix:@"#"])
        hex = [hex substringFromIndex:1];
    if ([hex length] != 6)
        return [UIColor clearColor];
    
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

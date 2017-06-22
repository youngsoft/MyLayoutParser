//
//  YSDimeManager.m
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSDimeManager.h"

extern CGFloat _jmbScaleFactor;
extern CGFloat _jmbXScaleFactor;
extern CGFloat _jmbYScaleFactor;


@implementation YSDimeManager

-(id)initWithBundle:(NSBundle *)bundle
{
    return [super initWithBundle:bundle type:@"dime"];
}


-(CGFloat)dimeWith:(NSString*)dimeId
{
    
    NSNumber *number = [self.cache objectForKey:dimeId];
    if (number != nil)
        return number.floatValue;
    
     id val = [self findResDescById:dimeId];
    if (val == nil)
    {
        NSAssert(0, @"Invalid dime value:%@",dimeId);
    }
    
    number = [self scaledNumberFrom:val];
    if (number != nil)
    {
        [self.cache setObject:number forKey:dimeId];
    }
    
    return number.floatValue;
}

+(CGFloat)scaledDime:(CGFloat)dime
{
    return _jmbScaleFactor * dime;
}

+(CGFloat)scaledXDime:(CGFloat)dime
{
    return _jmbXScaleFactor * dime;
}

+(CGFloat)scaledYDime:(CGFloat)dime
{
    return _jmbYScaleFactor * dime;
}


+(CGSize)scaledSize:(CGSize)size
{
    return CGSizeMake(size.width * _jmbXScaleFactor, size.height * _jmbYScaleFactor);
}

+(CGPoint)scaledPoint:(CGPoint)point
{
    return CGPointMake(point.x * _jmbXScaleFactor, point.y * _jmbYScaleFactor);
}

+(CGRect)scaledRect:(CGRect)rect
{
    return CGRectMake(rect.origin.x * _jmbXScaleFactor, rect.origin.y * _jmbYScaleFactor, rect.size.width * _jmbXScaleFactor, rect.size.height * _jmbYScaleFactor);
}


@end

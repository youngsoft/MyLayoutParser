//
//  YSFontManager.m
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSFontManager.h"

@implementation YSFontManager



-(id)initWithBundle:(NSBundle *)bundle
{
    self = [super initWithBundle:bundle type:@"font"];
    if (self != nil)
    {
        _scaleFactor = 1;
    }
    
    return self;
}

-(void)setScaleFactor:(CGFloat)scaleFactor
{
    if (_scaleFactor == scaleFactor || scaleFactor <= 0)
        return;
    
    _scaleFactor = scaleFactor;
    [self.cache removeAllObjects];
    
}

-(UIFont*)fontWith:(NSString*)fontId
{
    UIFont *font = [self.cache objectForKey:fontId];
    if (font != nil)
        return font;
    
    id desc = [self findResDescById:fontId];
    if ([desc isKindOfClass:[NSString class]])
    {
        font = [self fontWith:[((NSString*)desc) substringFromIndex:1]];
    }
    else
    {
        
        NSDictionary *fontDict = desc;
        if (fontDict != nil)
        {
            NSString *name = [fontDict objectForKey:@"name"];
            NSNumber *size = [self scaledNumberFrom:[fontDict objectForKey:@"size"]];
            if (name == nil || [name isEqualToString:@"system"])
            {
                NSNumber *blod = [fontDict objectForKey:@"blod"];
                NSNumber *italic = [fontDict objectForKey:@"italic"];
                NSNumber *weight = [fontDict objectForKey:@"weight"];
                
                if (italic != nil && italic.boolValue)
                {
                    font = [UIFont italicSystemFontOfSize:size.floatValue * self.scaleFactor];
                }
                else if (blod != nil && blod.boolValue)
                {
                    font = [UIFont boldSystemFontOfSize:size.floatValue * self.scaleFactor];
                }
                else if (weight != nil)
                    font = [UIFont systemFontOfSize:size.floatValue * self.scaleFactor weight:weight.floatValue];
                else
                    font = [UIFont systemFontOfSize:size.floatValue * self.scaleFactor];
                
            }
            else
            {
                font = [UIFont fontWithName:name size:size.floatValue * self.scaleFactor];
                if (font == nil) {
                    font = [UIFont systemFontOfSize:size.floatValue * self.scaleFactor];
                }
            }
        }
        else
        {
            NSAssert(0, @"Invalid font value:%@",fontId);
        }
    }
    
    if (font != nil)
    {
        [self.cache setObject:font forKey:fontId];
    }
    
    return font;

}

-(UIFont*)noScaleFontWith:(NSString*)fontId
{
    UIFont *font = nil;
    
    id desc = [self findResDescById:fontId];
    if ([desc isKindOfClass:[NSString class]])
    {
        font = [self noScaleFontWith:[((NSString*)desc) substringFromIndex:1]];
    }
    else
    {
        
        NSDictionary *fontDict = desc;
        if (fontDict != nil)
        {
            NSString *name = [fontDict objectForKey:@"name"];
            NSNumber *size = [self scaledNumberFrom:[fontDict objectForKey:@"size"]];
            if (name == nil || [name isEqualToString:@"system"])
            {
                NSNumber *blod = [fontDict objectForKey:@"blod"];
                NSNumber *italic = [fontDict objectForKey:@"italic"];
                NSNumber *weight = [fontDict objectForKey:@"weight"];
                
                if (italic != nil && italic.boolValue)
                {
                    font = [UIFont italicSystemFontOfSize:size.floatValue];
                }
                else if (blod != nil && blod.boolValue)
                {
                    font = [UIFont boldSystemFontOfSize:size.floatValue];
                }
                else if (weight != nil)
                    font = [UIFont systemFontOfSize:size.floatValue weight:weight.floatValue];
                else
                    font = [UIFont systemFontOfSize:size.floatValue];
                
            }
            else
            {
                font = [UIFont fontWithName:name size:size.floatValue];
                if (font == nil) {
                    font = [UIFont systemFontOfSize:size.floatValue];
                }
            }
        }
        else
        {
            NSAssert(0, @"Invalid font value:%@",fontId);
        }
    }
    
    return font;

}



@end

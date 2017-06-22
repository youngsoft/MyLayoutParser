//
//  YSStyleManager.m
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSStyleManager.h"
#import "YSFontManager.h"
#import "YSColorManager.h"
#import "YSImageManager.h"
#import "YSResourceManager.h"

#if TARGET_OS_IOS
@implementation UIView(YSStyleEx)

-(void)setJmbStyle:(NSDictionary*)style
{
    [self setValuesForKeysWithDictionary:style];
    
}

@end
#endif


@implementation YSStyleManager
{
    __weak YSResourceManager *_manager;
}

-(id)initWithResourceManager:(YSResourceManager*)manager;
{
    self = [super initWithBundle:manager.bundle type:@"style"];
    if (self != nil)
    {
        _manager = manager;
    }
    
    return self;
}



-(NSDictionary*)styleWith:(NSString*)styleId
{
    NSDictionary *style = [self.cache objectForKey:styleId];
    if (style != nil)
        return style;
    
    //解析对应的字体,颜色,样式
    NSDictionary *dict = [self findResDescById:styleId];
    if (dict == nil)
        NSAssert(0, @"Invalid Style value: %@",styleId);
    
    NSMutableDictionary *styleDict = [dict mutableCopy];
    for (NSString *key in styleDict.allKeys) {
        NSString *value=styleDict[key];
        NSRange range;
        if ([value isKindOfClass:[NSString class]]) {
            if ((range=[value rangeOfString:@"@font/"]).length) {
                
                NSString *fontId=[value substringFromIndex:range.length];
                UIFont *font=[_manager.fontManager fontWith:fontId];
                [styleDict setValue:font forKey:key];
            }else if ((range=[value rangeOfString:@"@color/"]).length){
                
                NSString *colorId=[value substringFromIndex:range.length];
                
                NSString *trueColorId = nil;
                //先查#后面是否有值。
                range = [colorId rangeOfString:@"#"];
                CGFloat alpha = -1;
                if (range.length != 0)
                {
                    trueColorId = [colorId substringToIndex:range.location];
                    alpha = atof([[colorId substringFromIndex:range.location + 1] UTF8String]);
                }
                
                //查找是否有.
                NSString *method = nil;
                range = [colorId rangeOfString:@":"];
                if (range.length != 0)
                {
                    if (trueColorId == nil)
                        trueColorId = [colorId substringToIndex:range.location];
                    method = [colorId substringFromIndex:range.location + 1];
                }
                
                if (trueColorId == nil)
                    trueColorId = colorId;
                
                UIColor *color=[_manager.colorManager colorWith:trueColorId];
                if (alpha != -1)
                    color = [color colorWithAlphaComponent:alpha];
                
                if (method != nil)
                {
                    color = [color valueForKeyPath:@"method"];
                }
                
                //针对颜色做特殊处理。一个是符号后面带.是属性 #后面是透明度。
                
                
                [styleDict setValue:color forKey:key];
            }else if ((range=[value rangeOfString:@"@style/"]).length){
                NSString *styleId=[value substringFromIndex:range.length];
                NSDictionary *dict=[self styleWith:styleId];
                [styleDict removeObjectForKey:key];
                [styleDict setValuesForKeysWithDictionary:dict];
            }else if ((range=[value rangeOfString:@"@image/"]).length){
                
                NSString *imageName=[value substringFromIndex:range.length];
                UIImage *image=[_manager.imageManager imageNamed:imageName];
                [styleDict setValue:image forKey:key];
            }
            else if ((range=[value rangeOfString:@"@string/"]).length){
                
                NSString *stringId=[value substringFromIndex:range.length];
                NSString *str = [_manager.stringManager stringWith:stringId];
                [styleDict setValue:str forKey:key];
            }
            else if ((range=[value rangeOfString:@"@dime/"]).length){
                
                NSString *dimeId=[value substringFromIndex:range.length];
                CGFloat dime = [_manager.dimeManager dimeWith:dimeId];
                [styleDict setValue:@(dime) forKey:key];
            }

        }
    }
    
    if (styleDict != nil)
        [self.cache setObject:styleDict forKey:styleId];
    
    return styleDict;
}


@end

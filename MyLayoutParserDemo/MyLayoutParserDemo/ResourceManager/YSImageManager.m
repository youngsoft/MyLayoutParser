//
//  YSImageManager.m
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSImageManager.h"


@implementation YSImageManager



-(id)initWithBundle:(NSBundle *)bundle;
{
    return [super initWithBundle:bundle type:@"image"];
}

-(BOOL)switchToSchemaInner:(NSString*)schemaName
{
    BOOL bOk = ![self.schema isEqualToString:schemaName];
    
    self.schema = schemaName;
    
    if (self.cache == nil)
    {
        self.cache = [[NSCache alloc] init];
        [self.cache setCountLimit:20];
    }
    
    return bOk;
    
}



-(UIImage*)imageNamed:(NSString*)imageName
{
    //如果方案不为空则默认查询指定的方案的图片。
    NSString *schemaImageName  = nil;
    if (![self.schema isEqualToString:@""])
        schemaImageName = [NSString stringWithFormat:@"%@_%@", self.schema, imageName];
    else
        schemaImageName = imageName;
    
    
    NSString *personalImageName = [NSString stringWithFormat:@"%@_%@",kBBAEPersonalResourcePrefix, schemaImageName];
    
    
    UIImage *image = nil;
    if (self.bundle == [NSBundle mainBundle])
    {
        image = [UIImage imageNamed:personalImageName];
        if (image == nil) {
            
            image = [UIImage imageNamed:schemaImageName];
            if (image == nil && ![schemaImageName isEqualToString:imageName])
            {
                image = [UIImage imageNamed:imageName];
            }
        }
        
        
    }
    else
    {
        image =  [UIImage imageNamed:[[self.bundle.bundlePath lastPathComponent] stringByAppendingPathComponent:personalImageName]];
        if (image == nil) {
            image =  [UIImage imageNamed:[[self.bundle.bundlePath lastPathComponent] stringByAppendingPathComponent:schemaImageName]];
        }
        
    }
    
    
    return image;
}



#if TARGET_OS_IOS

-(UIImage*)imageNoCached:(NSString*)imageName
{
    UIImage *image = nil;
    NSString *path = [self.cache objectForKey:imageName];
    if (path != nil)
    {
        NSString *strRealPath = [path substringFromIndex:2];
        CGFloat scale =  path.floatValue;
        NSData *data = [NSData dataWithContentsOfFile:strRealPath];
        
        if (data != nil)
        {
            image = [UIImage imageWithData:data scale:scale];
        }
        
        return image;
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *schemaImageName  = nil;
    if (![self.schema isEqualToString:@""])
        schemaImageName = [NSString stringWithFormat:@"%@_%@",self.schema, imageName];
    else
        schemaImageName = imageName;
    
    NSString *personalImageName = [NSString stringWithFormat:@"%@_%@",kBBAEPersonalResourcePrefix, schemaImageName];
    
    
    if (scale == 3.0)
    {
        path = [self.bundle pathForResource:[NSString stringWithFormat:@"%@@3x",personalImageName] ofType:@"png"];
        if (path == nil) {
            path = [self.bundle pathForResource:[NSString stringWithFormat:@"%@@3x",schemaImageName] ofType:@"png"];
        }
        if (path == nil)
        {
            scale = 2.0;
            path = [self.bundle pathForResource:[NSString stringWithFormat:@"%@@2x",personalImageName] ofType:@"png"];
            if (path == nil) {
                path = [self.bundle pathForResource:[NSString stringWithFormat:@"%@@2x",schemaImageName] ofType:@"png"];
            }
        }
        
        if (path == nil)
        {
            scale = 1.0;
            path = [self.bundle pathForResource:personalImageName ofType:@"png"];
            if (path == nil) {
                path = [self.bundle pathForResource:schemaImageName ofType:@"png"];
            }
        }
        
        if (path == nil && ![schemaImageName isEqualToString:imageName])
        {
            scale = 3.0;
            path = [self.bundle pathForResource:[NSString stringWithFormat:@"%@@3x",imageName] ofType:@"png"];
        }
        
        if (path == nil && ![schemaImageName isEqualToString:imageName])
        {
            scale = 2.0;
            path = [self.bundle pathForResource:[NSString stringWithFormat:@"%@@2x",imageName] ofType:@"png"];
        }
        
        if (path == nil  && ![schemaImageName isEqualToString:imageName])
        {
            scale = 1.0;
            path = [self.bundle pathForResource:imageName ofType:@"png"];
        }
        
    }
    else if (scale == 2.0)
    {
        path = [self.bundle pathForResource:[NSString stringWithFormat:@"%@@2x",personalImageName] ofType:@"png"];
        if (path == nil) {
            path = [self.bundle pathForResource:[NSString stringWithFormat:@"%@@2x",schemaImageName] ofType:@"png"];
        }
        
        if (path == nil)
        {
            scale = 3.0;
            path = [self.bundle pathForResource:[NSString stringWithFormat:@"%@@3x",personalImageName] ofType:@"png"];
            if (path == nil) {
                path = [self.bundle pathForResource:[NSString stringWithFormat:@"%@@3x",schemaImageName] ofType:@"png"];
            }
            
        }
        
        if (path == nil)
        {
            scale = 1.0;
            path = [self.bundle pathForResource:personalImageName ofType:@"png"];
            if (path == nil) {
                path = [self.bundle pathForResource:schemaImageName ofType:@"png"];
            }
        }
        
        if (path == nil && ![schemaImageName isEqualToString:imageName])
        {
            scale = 2.0;
            path = [self.bundle pathForResource:[NSString stringWithFormat:@"%@@2x",imageName] ofType:@"png"];
        }
        
        if (path == nil && ![schemaImageName isEqualToString:imageName])
        {
            scale = 3.0;
            path = [self.bundle pathForResource:[NSString stringWithFormat:@"%@@3x",imageName] ofType:@"png"];
        }

        if (path == nil && ![schemaImageName isEqualToString:imageName])
        {
            scale = 1.0;
            path = [self.bundle pathForResource:imageName ofType:@"png"];
        }
        
    }
    else
    {
        path = [self.bundle pathForResource:personalImageName ofType:@"png"];
        if (path == nil) {
            path = [self.bundle pathForResource:schemaImageName ofType:@"png"];
            if (path == nil && ![schemaImageName isEqualToString:imageName])
                path = [self.bundle pathForResource:imageName ofType:@"png"];
        }
        
    }
    
    if (path != nil)
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data != nil)
        {
            image = [UIImage imageWithData:data scale:scale];
        }
    }
    
    if (path != nil)
    {
        NSString *strPathAndScale = [NSString stringWithFormat:@"%d#%@",(int)scale,path];
        [self.cache setObject:strPathAndScale forKey:imageName];
    }
    
    return image;
}

#endif

@end

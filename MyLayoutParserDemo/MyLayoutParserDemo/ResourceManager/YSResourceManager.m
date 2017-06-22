//
//  YSResourceManager.m
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSResourceManager.h"

CGFloat _jmbScaleFactor = 1.0;
CGFloat _jmbXScaleFactor = 1.0;
CGFloat _jmbYScaleFactor = 1.0;


@implementation YSResourceManager
{
    YSImageManager *_imageManager;
    YSFontManager  *_fontManager;
    YSColorManager *_colorManager;
    YSDimeManager  *_dimeManager;
    YSStringManager *_stringManager;
    YSStyleManager *_styleManager;
    YSRawManager *_rawManager;
    NSBundle  *_bundle;
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
    }
    
    return self;
}


-(YSColorManager*)colorManager
{
    if (_colorManager == nil)
    {
        _colorManager = [[YSColorManager alloc] initWithBundle:_bundle];
    }
    
    return _colorManager;
}

-(YSImageManager*)imageManager
{
    if (_imageManager == nil)
    {
        _imageManager = [[YSImageManager alloc] initWithBundle:_bundle];
    }
    
    return _imageManager;
}

-(YSFontManager*)fontManager
{
    if (_fontManager == nil)
    {
        _fontManager = [[YSFontManager alloc] initWithBundle:_bundle];
    }
    
    return _fontManager;
}

-(YSDimeManager*)dimeManager
{
    if (_dimeManager == nil)
    {
        _dimeManager = [[YSDimeManager alloc] initWithBundle:_bundle];
    }
    
    return _dimeManager;
}

-(YSStringManager*)stringManager
{
    if (_stringManager == nil)
    {
        _stringManager = [[YSStringManager alloc] initWithBundle:_bundle];
    }
    
    return _stringManager;
}

-(YSStyleManager*)styleManager
{
    if (_styleManager == nil)
    {
        _styleManager = [[YSStyleManager alloc] initWithResourceManager:self];
    }
    
    return _styleManager;
}

-(YSRawManager *)rawManager
{
    if (_rawManager == nil)
    {
        _rawManager = [[YSRawManager alloc] initWithBundle:_bundle];
    }
    
    return _rawManager;
}

-(id)findResById:(NSString*)resId
{
    NSRange range;
    if ((range=[resId rangeOfString:@"@font/"]).length) {
        
        NSString *fontId=[resId substringFromIndex:range.length];
        return [self.fontManager fontWith:fontId];
        
    }else if ((range=[resId rangeOfString:@"@color/"]).length){
        
        NSString *colorId=[resId substringFromIndex:range.length];
        return [self.colorManager colorWith:colorId];
        
    }else if ((range=[resId rangeOfString:@"@style/"]).length){
        NSString *styleId=[resId substringFromIndex:range.length];
        return [self.styleManager styleWith:styleId];
       
    }else if ((range=[resId rangeOfString:@"@image/"]).length){
        
        NSString *imageName=[resId substringFromIndex:range.length];
        
        return [self.imageManager imageNamed:imageName];
    }
    else if ((range=[resId rangeOfString:@"@string/"]).length){
        
        NSString *stringId=[resId substringFromIndex:range.length];
        return [self.stringManager stringWith:stringId];
    }
    else if ((range=[resId rangeOfString:@"@dime/"]).length){
        
        NSString *dimeId=[resId substringFromIndex:range.length];
        return @([self.dimeManager dimeWith:dimeId]);
    }
    else if ((range=[resId rangeOfString:@"@raw/"]).length){
        
        NSString *rawId=[resId substringFromIndex:range.length];
        return [self.rawManager dataWith:rawId];
    }
    else
        return nil;
}



-(NSBundle*)bundle
{
    return _bundle;
}

//解决不同的资源方案的问题。解决装载不同bundle下的问题。
+(YSResourceManager*)loadFromBundle:(NSBundle*)bundle
{
    if (bundle == nil)
        return nil;
    
    
    YSResourceManager *mgr = [[YSResourceManager alloc] init];
    mgr.bundle = bundle;
    return mgr;
}

+(YSResourceManager*)loadFromBundleName:(NSString*)bundleName
{
    NSString *strBundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    if (strBundlePath == nil)
        NSAssert(0, @"Invalid bundle name");
    if (strBundlePath != nil)
    {
        NSBundle *bundle = [NSBundle bundleWithPath:strBundlePath];
        return [self loadFromBundle:bundle];
    }
    
    return nil;
}


//主bundle中的资源。
+(YSResourceManager*)loadFromMainBundle
{
    static YSResourceManager *gMgr = nil;
    
    if (gMgr == nil)
    {
        gMgr = [[YSResourceManager alloc] init];
        gMgr.bundle = [NSBundle mainBundle];
    }
    
    return gMgr;
}


#if TARGET_OS_IOS
+(void)setResourceTemplateSize:(CGSize)size idiom:(UIUserInterfaceIdiom)idiom
{
    
    __WATCHOS_PROHIBITED
    
    //获取当前的
    UIUserInterfaceIdiom curInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom;
    if (curInterfaceIdiom == idiom)  //如果不是一种设备则不需要进行比例转化。比如iphone的应用程序在ipad上跑就不需要进行比例缩放
    {
        CGRect rect = [[UIScreen mainScreen] bounds];
        
        BOOL isPortrait = size.height > size.width;

        
        CGFloat curWidth = isPortrait ? MIN(rect.size.width, rect.size.height) : MAX(rect.size.width, rect.size.height);
        CGFloat curHeight = isPortrait ? MAX(rect.size.width, rect.size.height) : MIN(rect.size.width, rect.size.height);
        
      //  CGSize curSize = CGSizeMake(curWidth, curHeight);
       // _jmbScaleFactor = sqrtf((curSize.width * curSize.width + curSize.height * curSize.height) / (size.width * size.width + size.height * size.height));
        
        _jmbXScaleFactor = curWidth / size.width;
        _jmbYScaleFactor = curHeight / size.height;
        
        if (isPortrait)
            _jmbScaleFactor = _jmbXScaleFactor;
        else
            _jmbScaleFactor = _jmbYScaleFactor;
        
    }
    
 }

#endif



@end

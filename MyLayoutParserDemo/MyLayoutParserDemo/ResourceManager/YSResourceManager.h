//
//  YSResourceManager.h
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YSColorManager.h"
#import "YSImageManager.h"
#import "YSDimeManager.h"
#import "YSStringManager.h"
#import "YSFontManager.h"
#import "YSStyleManager.h"
#import "YSRawManager.h"


/**
 *  资源管理器类，管理所有的静态资源
 *
 */
@interface YSResourceManager : NSObject

@property(nonatomic, strong,readonly) YSImageManager *imageManager;
@property(nonatomic, strong,readonly) YSFontManager  *fontManager;
@property(nonatomic, strong,readonly) YSColorManager *colorManager;
@property(nonatomic, strong,readonly) YSDimeManager  *dimeManager;
@property(nonatomic, strong,readonly) YSStringManager *stringManager;
@property(nonatomic, strong,readonly) YSStyleManager *styleManager;
@property(nonatomic, strong,readonly) YSRawManager *rawManager;

/**
 *  根据资源标识得到资源对象
 *
 *  @param resId 资源标识这里的资源标识必须要以@image/ @font/ @color/ @dime/ @string/ @style/ @raw/开头
 *
 *  @return 根据不同的资源标识符得到不同的对象,@raw得到的是NSData类型的数据
 */
-(id)findResById:(NSString*)resId;


//归属的bundle
@property(nonatomic,strong) NSBundle *bundle;


//解决不同的资源方案的问题。
+(YSResourceManager*)loadFromBundle:(NSBundle*)bundle;
+(YSResourceManager*)loadFromBundleName:(NSString*)bundleName;  //bundleName必须在主bundle中存在


//主bundle中的资源。
+(YSResourceManager*)loadFromMainBundle;


/**
 *  设置资源的屏幕标准SIZE，尤其是对font,dime,image这三类资源，因为UI所提供的值总是在一定的标准下完成的，因此需要为系统设置一个SIZE的标准
 *  然后会在不同的屏幕尺寸下对应的那些资源中带有@开头的值会进行相对应的缩放。
 *
 *  @param size        UI设计时屏幕尺寸,这里不是屏幕的像素尺寸
 *  @param idiom       UI设计的设备类型
 */
#if TARGET_OS_IOS
+(void)setResourceTemplateSize:(CGSize)size idiom:(UIUserInterfaceIdiom)idiom;

#endif
@end


//主bundle中的资源宏

#define YSIMAGE(resid) [[YSResourceManager loadFromMainBundle].imageManager imageNamed:resid]
#define YSIMAGENOCACHED(resid) [[YSResourceManager loadFromMainBundle].imageManager imageNoCached:resid]

#define YSFONT(resid)  [[YSResourceManager loadFromMainBundle].fontManager fontWith:resid]
#define YSFONTNOSCALE(resid)  [[YSResourceManager loadFromMainBundle].fontManager noScaleFontWith:resid]


#define YSCOLOR(resid) [[YSResourceManager loadFromMainBundle].colorManager colorWith:resid]

#define YSDIME(resid)    [[YSResourceManager loadFromMainBundle].dimeManager dimeWith:resid]

#define YSX(dime)      [YSDimeManager scaledXDime:dime]
#define YSY(dime)      [YSDimeManager scaledYDime:dime]
#define YSSIZE(size)   [YSDimeManager scaledSize:size]
#define YSPOINT(point) [YSDimeManager scaledPoint:point]
#define YSRECT(rect)   [YSDimeManager scaledRect:rect]
#define YSSCALE(dime)  [YSDimeManager scaledDime:dime];


#define YSSTRING(resid)  [[YSResourceManager loadFromMainBundle].stringManager stringWith:resid]
#define YSSTRINGARRAY(resid)  [[YSResourceManager loadFromMainBundle].stringManager stringArrayWith:resid]
#define YSSTRINGFORMAT(resid, ...) [[YSResourceManager loadFromMainBundle].stringManager stringFormatWith:resid, ##__VA_ARGS__]

#define YSSTYLE(resid) [[YSResourceManager loadFromMainBundle].styleManager styleWith:resid]

#define YSDATA(resid)  [[YSResourceManager loadFromMainBundle].rawManager dataWith:resid]

#define YSSTREAM(resid)  [[YSResourceManager loadFromMainBundle].rawManager streamWith:resid]

#define YSPATH(resid) [[YSResourceManager loadFromMainBundle].rawManager pathWith:resid]


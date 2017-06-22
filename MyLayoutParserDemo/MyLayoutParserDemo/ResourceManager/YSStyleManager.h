//
//  YSStyleManager.h
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//
#import "YSResourceBase.h"

@class YSResourceManager;

/*样式管理器，管理视图中的样式，要求样式中的key必须为视图中具备的属性*/
@interface YSStyleManager : YSResourceBase

-(id)initWithResourceManager:(YSResourceManager*)manager;

/*
  各种资源的引用方式:
  Image :   @image\xxxx
  Font :    @font\xxxx
  Color:    @color\xxxx
  String:   @string\xxxx
  Dime      @dime\xxxxx
  Style:    @style\xxxx
 */

//根据样式ID得到样式,样式支持嵌套，系统会优先处理嵌入的样式
-(NSDictionary*)styleWith:(NSString*)styleId;

@end




#if TARGET_OS_IOS

//为视图设置样式
@interface UIView(YSStyleEx)

//为视图设置样式。
-(void)setJmbStyle:(NSDictionary*)style;


@end


#endif


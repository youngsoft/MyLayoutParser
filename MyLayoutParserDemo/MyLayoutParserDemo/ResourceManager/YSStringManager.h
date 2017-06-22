//
//  YSStringManager.h
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSResourceBase.h"

/**
 字符串资源管理类，主要用于国际化语言,switchSchema时请用不同的国家语言标识
 */
@interface YSStringManager : YSResourceBase

-(id)initWithBundle:(NSBundle *)bundle;

//根据字符串Id取字符串,如果字符串不存在则返回Id
-(NSString*)stringWith:(NSString*)stringId;

//如果没有找到则以stringId作为格式化的字符
-(NSString*)stringFormatWith:(NSString *)stringId,...;

//得到字符串数组
-(NSArray*)stringArrayWith:(NSString*)stringArrayId;

@end

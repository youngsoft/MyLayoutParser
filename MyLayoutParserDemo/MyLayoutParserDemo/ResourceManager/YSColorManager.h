//
//  YSColorManager.h
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSResourceBase.h"

/*颜色管理器类，管理color.plist中的颜色*/
@interface YSColorManager : YSResourceBase

-(id)initWithBundle:(NSBundle*)bundle;


//根据颜色标识取颜色值,要求color.plist中的value必须是字符串型的用RRGGBB 或者AARRGGBB。 AA,RR,GG,BB必须是16进制表示
-(UIColor*)colorWith:(NSString*)colorId;



/**
 根据数字建立颜色

 @param hex 数字表示的颜色格式必须是：RRGGBB或者AARRGGBB AA,RR,GG,BB必须是16进制表示.
 @return 颜色
 */
+(UIColor*)colorWithHex:(NSString*)hex;


@end

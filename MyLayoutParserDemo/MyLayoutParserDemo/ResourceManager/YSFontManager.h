//
//  YSFontManager.h
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSResourceBase.h"

/*字体资源管理器，管理font下的字体资源*/
@interface YSFontManager : YSResourceBase

-(id)initWithBundle:(NSBundle *)bundle;

@property(nonatomic, assign) CGFloat scaleFactor;  //缩放因子。默认是1

//根据Font文件夹中的PList中的字体定义取字体,如果字体的尺寸中前面带了@则表示是根据屏幕的大小进行缩放
-(UIFont*)fontWith:(NSString*)fontId;

//这里取的字体不会受到缩放因子的影响,而且也不会被缓存
-(UIFont*)noScaleFontWith:(NSString*)fontId;

@end

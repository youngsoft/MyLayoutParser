//
//  YSDimeManager.h
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSResourceBase.h"

/*尺寸管理器，管理dime中的尺寸资源值*/
@interface YSDimeManager : YSResourceBase


-(id)initWithBundle:(NSBundle *)bundle;


//根据尺寸ID取尺寸,如果尺寸值前面带@则标示的是会根据屏幕大小变动的值，而不带则表示是固定的
-(CGFloat)dimeWith:(NSString*)dimeId;

// 据屏幕尺寸等比例缩放
+(CGFloat)scaledDime:(CGFloat)dime;
// 宽度缩放
+(CGFloat)scaledXDime:(CGFloat)dime;
// 高度缩放
+(CGFloat)scaledYDime:(CGFloat)dime;
// 大小缩放
+(CGSize)scaledSize:(CGSize)size;
// 缩放后的位置
+(CGPoint)scaledPoint:(CGPoint)point;
// 位置和大小的缩放
+(CGRect)scaledRect:(CGRect)rect;

@end

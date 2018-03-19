//
//  FormulaStringCalcUtility.h
//  MyLayoutParserDemo
//
//  Created by 梁慧聪 on 2018/3/19.
//  Copyright © 2018年 youngsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormulaStringCalcUtility : NSObject
+ (NSString *)calcComplexFormulaString:(NSString *)formula;
//所有括号里面的公式，优先求解
+ (NSString *)firstCalcComplexFormulaString:(NSString *)formula;
@end

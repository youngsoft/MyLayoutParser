//
//  FormulaStringCalcUtility.m
//  MyLayoutParserDemo
//
//  Created by 梁慧聪 on 2018/3/19.
//  Copyright © 2018年 youngsoft. All rights reserved.
//

#import "FormulaStringCalcUtility.h"

@implementation FormulaStringCalcUtility

// 字符串加
+ (NSString *)addV1:(NSString *)v1 v2:(NSString *)v2 {
    CGFloat result = [v1 floatValue] + [v2 floatValue];
    return [NSString stringWithFormat:@"%.2f", result];
}

// 字符串减
+ (NSString *)subV1:(NSString *)v1 v2:(NSString *)v2 {
    CGFloat result = [v1 floatValue] - [v2 floatValue];
    return [NSString stringWithFormat:@"%.2f", result];
}

// 字符串乘
+ (NSString *)mulV1:(NSString *)v1 v2:(NSString *)v2 {
    CGFloat result = [v1 floatValue] * [v2 floatValue];
    return [NSString stringWithFormat:@"%.2f", result];
}

// 字符串除
+ (NSString *)divV1:(NSString *)v1 v2:(NSString *)v2 {
    CGFloat result = [v1 floatValue] / [v2 floatValue];
    return [NSString stringWithFormat:@"%.2f", result];
}

// 简单只包含 + - 的计算
+ (NSString *)calcSimpleFormula:(NSString *)formula {
    
    NSString *result = @"0";
    char symbol = '+';
    
    int len = formula.length;
    int numStartPoint = 0;
    for (int i = 0; i < len; i++) {
        char c = [formula characterAtIndex:i];
        if (c == '+' || c == '-') {
            NSString *num = [formula substringWithRange:NSMakeRange(numStartPoint, i - numStartPoint)];
            switch (symbol) {
                case '+':
                    result = [self addV1:result v2:num];
                    break;
                case '-':
                    result = [self subV1:result v2:num];
                    break;
                default:
                    break;
            }
            symbol = c;
            numStartPoint = i + 1;
        }
    }
    if (numStartPoint < len) {
        NSString *num = [formula substringWithRange:NSMakeRange(numStartPoint, len - numStartPoint)];
        switch (symbol) {
            case '+':
                result = [self addV1:result v2:num];
                break;
            case '-':
                result = [self subV1:result v2:num];
                break;
            default:
                break;
        }
    }
    return result;
}

// 获取字符串中的后置数字
+ (NSString *)lastNumberWithString:(NSString *)str {
    int numStartPoint = 0;
    for (int i = str.length - 1; i >= 0; i--) {
        char c = [str characterAtIndex:i];
        if ((c < '0' || c > '9') && c != '.') {
            numStartPoint = i + 1;
            break;
        }
    }
    return [str substringFromIndex:numStartPoint];
}

// 获取字符串中的前置数字
+ (NSString *)firstNumberWithString:(NSString *)str {
    int numEndPoint = str.length;
    for (int i = 0; i < str.length; i++) {
        char c = [str characterAtIndex:i];
        if ((c < '0' || c > '9') && c != '.') {
            numEndPoint = i;
            break;
        }
    }
    return [str substringToIndex:numEndPoint];
}

// 包含 * / 的计算
+ (NSString *)calcNormalFormula:(NSString *)formula {
    NSRange mulRange = [formula rangeOfString:@"*" options:NSLiteralSearch];
    NSRange divRange = [formula rangeOfString:@"/" options:NSLiteralSearch];
    // 只包含加减的运算
    if (mulRange.length == 0 && divRange.length == 0) {
        return [self calcSimpleFormula:formula];
    }
    // 进行乘除运算
    int index = mulRange.length > 0 ? mulRange.location : divRange.location;
    // 计算左边表达式
    NSString *left = [formula substringWithRange:NSMakeRange(0, index)];
    NSString *num1 = [self lastNumberWithString:left];
    left = [left substringWithRange:NSMakeRange(0, left.length - num1.length)];
    // 计算右边表达式
    NSString *right = [formula substringFromIndex:index + 1];
    NSString *num2 = [self firstNumberWithString:right];
    right = [right substringFromIndex:num2.length];
    // 计算一次乘除结果
    NSString *tempResult = @"0";
    if (index == mulRange.location) {
        tempResult = [self mulV1:num1 v2:num2];
    } else {
        tempResult = [self divV1:num1 v2:num2];
    }
    // 代入计算得到新的公式
    NSString *newFormula = [NSString stringWithFormat:@"%@%@%@", left, tempResult, right];
    return [self calcNormalFormula:newFormula];
}

// 复杂计算公式计算,接口主方法
+ (NSString *)calcComplexFormulaString:(NSString *)formula {
    // 左括号
    NSRange lRange = [formula rangeOfString:@"(" options:NSBackwardsSearch];
    // 没有括号进行二步运算(含有乘除加减)
    if (lRange.length == 0) {
        return [self calcNormalFormula:formula];
    }
    // 右括号
    NSRange rRange = [formula rangeOfString:@")" options:NSLiteralSearch range:NSMakeRange(lRange.location, formula.length-lRange.location)];
    // 获取括号左右边的表达式
    NSString *left = [formula substringWithRange:NSMakeRange(0, lRange.location)];
    NSString *right = [formula substringFromIndex:rRange.location + 1];
    // 括号内的表达式
    NSString *middle = [formula substringWithRange:NSMakeRange(lRange.location+1, rRange.location-lRange.location-1)];
    // 代入计算新的公式
    NSString *newFormula = [NSString stringWithFormat:@"%@%@%@", left, [self calcNormalFormula:middle], right];
    return [self calcComplexFormulaString:newFormula];
}

//所有括号里面的公式，优先求解
+ (NSString *)firstCalcComplexFormulaString:(NSString *)formula {
    // 左括号
    NSRange lRange = [formula rangeOfString:@"(" options:NSBackwardsSearch];
    // 没有括号进行二步运算(含有乘除加减)
    if (lRange.length == 0) {
        return formula;
    }
    // 右括号
    NSRange rRange = [formula rangeOfString:@")" options:NSLiteralSearch range:NSMakeRange(lRange.location, formula.length-lRange.location)];
    // 获取括号左右边的表达式
    NSString *left = [formula substringWithRange:NSMakeRange(0, lRange.location)];
    NSString *right = [formula substringFromIndex:rRange.location + 1];
    // 括号内的表达式
    NSString *middle = [formula substringWithRange:NSMakeRange(lRange.location+1, rRange.location-lRange.location-1)];
    // 代入计算新的公式
    NSString *newFormula = [NSString stringWithFormat:@"%@%@%@", left, [self calcNormalFormula:middle], right];
    return [self firstCalcComplexFormulaString:newFormula];
}
@end

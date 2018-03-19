//
//  ParserManager.h
//  MyLayoutParserDemo
//
//  Created by 梁慧聪 on 2017/6/20.
//  Copyright © 2017年 youngsoft. All rights reserved.
//  一个 xml 对应一个解析器

#import <Foundation/Foundation.h>
#import "NSXMLParser+MyLayout.h"
/*
 XCode LLVM XXX - Preprocessing中Debug会添加 DEBUG=1 标志
 */
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"[%s(%d)]: %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

@interface ParserManager : NSObject
- (NSXMLParser *)parserFilePath:(NSString *)path withBlock:(XMLParserBlock)block superView:(UIView *)superView;
- (UIView *)parserFindViewById:(NSString *)viewId;
@end

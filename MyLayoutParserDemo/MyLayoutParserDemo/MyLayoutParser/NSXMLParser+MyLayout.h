//
//  NSXMLParser+MyLayout.h
//  MyLayoutParserDemo
//
//  Created by 梁慧聪 on 2017/6/20.
//  Copyright © 2017年 youngsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^XMLParserBlock)(NSMutableDictionary * xmlDictionary, NSString * jsonString, NSError * error);
@interface NSXMLParser (MyLayout)
@property (nonatomic, strong) NSURL *xmlUrl;
@property (nonatomic, copy) NSString *jsonString;
@property (nonatomic, strong) NSMutableDictionary *xmlDictionary;

@property (nonatomic, copy) XMLParserBlock xmlParserBlock;

- (BOOL)checkIsProcessing;
- (void)configProcess:(BOOL)yesOrNo;

- (BOOL)checkJustProcessStartElement;
- (void)configJustProcessStartElement:(BOOL)yesOrNo;
@end

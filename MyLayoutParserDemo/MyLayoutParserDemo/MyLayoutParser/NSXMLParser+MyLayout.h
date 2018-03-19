//
//  NSXMLParser+MyLayout.h
//  MyLayoutParserDemo
//
//  Created by 梁慧聪 on 2017/6/20.
//  Copyright © 2017年 youngsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ParserManager;
typedef void(^XMLParserBlock)(ParserManager * parser,NSMutableDictionary * xmlDictionary, NSString * jsonString, UIView * view,NSError * error);
@interface NSXMLParser (MyLayout)
@property (nonatomic, strong) NSURL *xmlUrl;
@property (nonatomic, copy) NSString *jsonString;
@property (nonatomic, strong) NSMutableDictionary *xmlDictionary;

@property (nonatomic, copy) XMLParserBlock xmlParserBlock;

@property (nonatomic, strong) UIView *xmlView;
@property (nonatomic, weak) UIView *superView;

- (BOOL)checkIsProcessing;
- (void)configProcess:(BOOL)yesOrNo;

- (BOOL)checkJustProcessStartElement;
- (void)configJustProcessStartElement:(BOOL)yesOrNo;
@end

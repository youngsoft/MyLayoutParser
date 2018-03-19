//
//  ParserManager.m
//  MyLayoutParserDemo
//
//  Created by 梁慧聪 on 2017/6/20.
//  Copyright © 2017年 youngsoft. All rights reserved.
//

#import "ParserManager.h"
#import "YSResourceManager.h"
#import "MyLayout.h"
#import "NSString+Property.h"
#import "UIView+FALayout.h"
#import <objc/runtime.h>
#import "FormulaStringCalcUtility.h"
const NSArray *___NSLayoutAttributeArr;
// 创建初始化函数。等于用宏创建一个getter函数
#define NSLayoutAttributeGet (___NSLayoutAttributeArr == nil ? ___NSLayoutAttributeArr = [[NSArray alloc] initWithObjects:\
@"NotAnAttribute",\
@"left",\
@"right",\
@"top",\
@"bottom",\
@"leading",\
@"trailing",\
@"width",\
@"height",\
@"centerX",\
@"centerY",\
@"baseline",\
@"firstBaseline",\
@"marginLeft",\
@"marginRight",\
@"marginTop",\
@"marginBottom",\
@"leadingMargin",\
@"trailingMargin",\
@"centerXWithinMargins",\
@"centerYWithinMargins", nil] : ___NSLayoutAttributeArr)

// 枚举 to 字串
#define NSLayoutAttributeString(type) ([NSLayoutAttributeGet objectAtIndex:type])
// 字串 to 枚举
#define NSLayoutAttributeEnum(string) ([NSLayoutAttributeGet indexOfObject:string])


@interface ParserManager()<NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableArray * formats;
@property (nonatomic, strong) NSMutableDictionary * views;
@end
@implementation ParserManager
- (NSXMLParser *)parserFilePath:(NSString *)path withBlock:(XMLParserBlock)block{
    return [self parserFilePath:path withBlock:block superView:nil];
}
- (NSXMLParser *)parserFilePath:(NSString *)path withBlock:(XMLParserBlock)block superView:(UIView *)superView{
    NSURL * url = [NSURL fileURLWithPath:path];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    xmlParser.superView = superView;
    xmlParser.xmlUrl = url;
    xmlParser.delegate = self;
    xmlParser.xmlParserBlock = block;
    return xmlParser;
}
#pragma mark xmlparser
//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    /*
     * 开始解析XML文档时 设定一些解析状态
     *     设置isProcessing为true，表示XML正在被解析
     *     设置justProcessStartElement为true，表示刚刚没有处理过 startElement事件
     */
    [parser configProcess:YES];
    [parser configJustProcessStartElement:YES];
    //清空字符
    parser.jsonString = @"";
    [self.formats removeAllObjects];
    [self.views removeAllObjects];
}
//step 5：解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [parser configProcess:NO];
    //转化为字典
    NSError * error = nil;
    parser.xmlDictionary = [NSJSONSerialization JSONObjectWithData:[parser.jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if (!error) {
        [self drawView:parser error:error];
    }
}
//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    /*
     * 是否刚刚处理完一个startElement事件
     *     如果是 则表示这个元素是父元素的第一个元素 。
     *     如果不是 则表示刚刚处理完一个endElement事件，即这个元素不是父元素的第一个元素
     */
    BOOL justProcessStartElement = [parser checkJustProcessStartElement];
    if(!justProcessStartElement){//节点解析完毕
        parser.jsonString = [parser.jsonString stringByAppendingString:@","];
        [parser configJustProcessStartElement:YES];
    }
    parser.jsonString = [parser.jsonString stringByAppendingString:@"{"];
    parser.jsonString = [parser.jsonString stringByAppendingFormat:@"\"elementName\":\"%@\"",elementName];
    parser.jsonString = [parser.jsonString stringByAppendingString:@","];
    //将解析出来的元素属性添加到JSON字符串中
    
    parser.jsonString = [parser.jsonString stringByAppendingString:@"\"attrs\":{"];
    NSString * attribute = @"";
    if ([attributeDict isKindOfClass:[NSDictionary class]]) {
        __block NSMutableArray * attriMut = [NSMutableArray array];
        [attributeDict enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL * _Nonnull stop) {
            NSString * keyStr = [[key componentsSeparatedByString:@":"] lastObject];
            [attriMut addObject:[NSString stringWithFormat:@"\"%@\":\"%@\"",keyStr,obj]];
        }];
        attribute = [attriMut componentsJoinedByString:@","];
        parser.jsonString = [parser.jsonString stringByAppendingString:attribute];
    }
    parser.jsonString = [parser.jsonString stringByAppendingString:@"}"];
    parser.jsonString = [parser.jsonString stringByAppendingString:@","];
    //将解析出来的元素的子元素列表添加到JSON字符串中
    parser.jsonString = [parser.jsonString stringByAppendingString:@"\"childElements\":["];
}
//step 4 ：解析完当前节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [parser configJustProcessStartElement:NO];
    parser.jsonString = [parser.jsonString stringByAppendingString:@"]}"];
    
}
//error
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if (parser.xmlParserBlock) {
        parser.xmlParserBlock(self,parser.xmlDictionary, parser.jsonString,parser.xmlView ,parseError);
    }
}
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    if (parser.xmlParserBlock) {
        parser.xmlParserBlock(self,parser.xmlDictionary, parser.jsonString,parser.xmlView, validationError);
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{}
//step 6：获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{}

- (void)drawView:(NSXMLParser *)parser error:(NSError *)error{
    parser.xmlView = [NSClassFromString(parser.xmlDictionary[@"elementName"]) new];
    [self configId:parser.xmlView dict:parser.xmlDictionary[@"attrs"]];
    
    [self recurPrintPath:parser.xmlDictionary parent:parser.xmlView from:0 superView:parser.superView];
    
    if (parser.xmlParserBlock) {
        parser.xmlParserBlock(self,parser.xmlDictionary, parser.jsonString,parser.xmlView, error);
    }
}
- (void)configId:(UIView *)view dict:(NSDictionary *)dict{
    NSString * layout_id = [NSString stringWithFormat:@"view_%ld_%ld", (long)[[NSDate date] timeIntervalSince1970]*1000,self.views.count];
    if (dict && dict[@"id"]) {
        layout_id = dict[@"id"];
    }
    view.layout_id = layout_id;
    [self.views setObject:view forKey:view.layout_id];
}

- (void)recurPrintPath:(NSDictionary *)dict parent:(UIView *)parant from:(int)from superView:(UIView *)superView{
    for (NSString * key in dict.allKeys) {
        if ([dict[key] isKindOfClass:[NSDictionary class]]) {//字典是面向属性的最后一关
            if (from!=0) {
                //这里面的都是子节点
                UIView * view = [NSClassFromString(dict[@"elementName"]) new];
                [self configId:view dict:dict[@"attrs"]];
                if (from==2) {
                    [parant addSubview:view];
                }
                parant = view;
            }
            
            if(!parant.superview && superView){
                superView.layout_id = @"parent";
                [self.views setObject:superView forKey:superView.layout_id];
                [superView addSubview:parant];
            }
            
            [self recurPrintPath:dict[key] parent:parant from:1 superView:superView];
            
        }else if ([dict[key] isKindOfClass:[NSArray class]]){
            for (NSDictionary * sub in dict[key]) {
                [self recurPrintPath:sub parent:parant from:2 superView:superView];
            }
        }else{
            if (![key isEqualToString:@"elementName"]) {
//                [self configProperty:key value:dict[key] view:parant];
            }
        }
    }
}

- (NSMutableArray *)formats{
    if (!_formats) {
        _formats = [NSMutableArray array];
    }
    return _formats;
}
- (NSMutableDictionary *)views{
    if (!_views) {
        _views = [NSMutableDictionary dictionary];
    }
    return _views;
}
@end

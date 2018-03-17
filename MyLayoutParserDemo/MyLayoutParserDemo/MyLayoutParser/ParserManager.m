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
        parser.xmlParserBlock(parser.xmlDictionary, parser.jsonString,parser.xmlView ,parseError);
    }
}
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    if (parser.xmlParserBlock) {
        parser.xmlParserBlock(parser.xmlDictionary, parser.jsonString,parser.xmlView, validationError);
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
    
    [FALiveLeftDrawerView formats:self.formats views:self.views];
    
    [self.formats removeAllObjects];
    [self.views removeAllObjects];
    
    if (parser.xmlParserBlock) {
        parser.xmlParserBlock(parser.xmlDictionary, parser.jsonString,parser.xmlView, error);
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
                [self configProperty:key value:dict[key] view:parant];
            }
        }
    }
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
#pragma mark - 属性映射表，这里乱写，要重新找一个方案

- (void)configProperty:(NSString *)property value:(NSString *)value view:(UIView *)view{
    YSResourceManager *mgr = [YSResourceManager loadFromMainBundle];
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([property hasPrefix:@"layout_"]) {
        NSString * format = @"";
        NSString * attri = @"";
        NSString * attri2 = @"";
        NSString * item2 = @"";
        NSString * mul = @"1.0";
        NSString * c = @"0.0";
        NSString * relation = [value rangeOfString:@"="].location==NSNotFound?@"":@"=";
        NSLayoutRelation rel = NSLayoutRelationEqual;
        NSArray * propertys = @[];
        BOOL isMargin = NO;
        if ([property hasPrefix:@"layout_constraint"]) {
            NSString *string = property;
            NSRange startRange = [string rangeOfString:@"layout_constraint"];
            NSRange endRange = [string rangeOfString:@"Of"];
            NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
            NSString *result = [string substringWithRange:range];
            propertys = [result componentsSeparatedByString:@"_To"];
        }else{
            propertys = [property componentsSeparatedByString:@"_"];
            NSString * last = [[[[propertys lastObject] substringToIndex:1] uppercaseString] stringByAppendingString:[[propertys lastObject] substringFromIndex:1]];
            if ([last hasPrefix:@"Margin"]) {
                isMargin = YES;
                NSLayoutAttribute attribute2 = [FALiveLeftDrawerView layoutAttributeEnum:last];
                propertys = @[[FALiveLeftDrawerView layoutAttributeIndex:attribute2-12],last];
            }else{
                propertys = @[last,@""];
            }
        }
        attri = ([FALiveLeftDrawerView layoutAttributeEnum:[propertys firstObject]] != NSNotFound)?[propertys firstObject]:@"";
        if (propertys.count==2) {
            attri2 = ([FALiveLeftDrawerView layoutAttributeEnum:[propertys lastObject]] != NSNotFound)?[propertys lastObject]:@"";
        }else{
            attri2=@"";
        }
        BOOL isPure = [self isPureInt:value];
        if(isPure){
            if (isMargin) {
                item2 = view.superview.layout_id;
            }else{
                item2 = @"";
            }
            mul = @"1.0";
            c = value;
            relation = @"=";
        }else{
            NSArray * values = [value componentsSeparatedByString:@","];
            for (NSString * v in values) {
                if ([v hasPrefix:@"@off/"]) {
                    c = [v substringFromIndex:@"@off/".length];
                }else if ([v hasPrefix:@"@mul/"]){
                    mul = [v substringFromIndex:@"@mul/".length];
                }else{
                    if ([v hasPrefix:@">"]) {
                        relation = [@">" stringByAppendingString:relation];
                        rel = NSLayoutRelationGreaterThanOrEqual;
                    }else if ([v hasPrefix:@"<"]){
                        relation = [@"<" stringByAppendingString:relation];
                        rel = NSLayoutRelationLessThanOrEqual;
                    }
                    if ([relation isEqualToString:@""]) {
                        item2 = v;
                        relation = @"=";
                    }else{
                        item2 = [v substringFromIndex:relation.length];
                    }
                }
            }
            if ([attri2 isEqualToString:@""]) {
                attri2 = attri;
            }
        }
        
        
        if ([item2 isEqualToString:@""] && [attri2 isEqualToString:@""]) {
            format = [NSString stringWithFormat:@"%@.%@%@%@",view.layout_id,[[[attri substringToIndex:1] lowercaseString] stringByAppendingString:[attri substringFromIndex:1]],relation,c];
        }else{
            format = [NSString stringWithFormat:@"%@.%@%@%@.%@*%@+%@",view.layout_id,[[[attri substringToIndex:1] lowercaseString] stringByAppendingString:[attri substringFromIndex:1]],relation,item2,[[[attri2 substringToIndex:1] lowercaseString] stringByAppendingString:[attri2 substringFromIndex:1]],mul,c];
        }
        NSLog(@"%@",format);
        [self.formats addObject:format];
        //        [FALiveLeftDrawerView constraintItem:view attr1:[FALiveLeftDrawerView layoutAttributeEnum:attri] rel:rel item2:superView attr2:[FALiveLeftDrawerView layoutAttributeEnum:attri2] mul:[mul doubleValue] constant:[c doubleValue]];
    }
    else{
        NSString * first = [[property substringToIndex:1] uppercaseString];
        NSString * rest = [property substringFromIndex:1];
        NSString * setMethod = [NSString stringWithFormat:@"set%@%@:", first,rest];
        //backgroundColor\textColor
        if ([view respondsToSelector:NSSelectorFromString(setMethod)]) {
            if(value){
                //颜色
                if ([property hasSuffix:@"Color"]) {
                    UIColor * color = [mgr.colorManager colorWith:value];
                    //边框大小颜色
                    if ([property isEqualToString:@"borderColor"]){
                        view.layer.borderColor = color.CGColor;
                    }else{
                        [view setValue:color forKey:property];
                    }
                }
                //字体大小
                else if([self isPureInt:value]){
                    const char * pObjCType = [((NSNumber*)value) objCType];
                    id val = value;
                    if ([property isEqualToString:@"font"] ||
                        [property isEqualToString:@"borderWidth"]){
                        if ([property isEqualToString:@"font"]) {
                            if (strcmp(pObjCType, @encode(int))  == 0) {//int
                                val = [UIFont systemFontOfSize:[value intValue]];
                            }
                            if (strcmp(pObjCType, @encode(float)) == 0) {//float
                                val = [UIFont systemFontOfSize:[value floatValue]];
                            }
                            if (strcmp(pObjCType, @encode(double))  == 0) {//double
                                val = [UIFont systemFontOfSize:[value doubleValue]];
                            }
                            if (strcmp(pObjCType, @encode(BOOL)) == 0) {//bool
                                val = [UIFont systemFontOfSize:[value boolValue]];
                            }
                        }
                        else if ([property isEqualToString:@"borderWidth"]){
                            
                        }
                        [view setValue:val forKey:property];
                    }else {
                        [view setValue:value forKey:property];
                    }
                }else{
                    
                }
            }
        }
    }
}

//- (void)configProperty:(NSString *)property value:(NSString *)value view:(UIView *)view{
//    //YSResourceManager
//    YSResourceManager *mgr = [YSResourceManager loadFromMainBundle];
//
//    if ([property isEqualToString:@"layout_width"]) {
//        if ([value isEqualToString:@"match_parent"]) {
//            view.myLeftMargin = view.myRightMargin = 0;
//        }
//        else if ([value isEqualToString:@"wrap_content"]){
//            view.wrapContentWidth = YES;
//        }
//        else{
//            view.myWidth = [value integerValue];
//        }
//    }
//    else if ([property isEqualToString:@"layout_height"]) {
//        if ([value isEqualToString:@"match_parent"]) {
//            view.myTopMargin = view.myBottomMargin = 0;
//        }
//        else if ([value isEqualToString:@"wrap_content"]){
//            view.wrapContentHeight = YES;
//        }
//        else{
//            view.myHeight = [value integerValue];
//        }
//    }
//    else if ([property isEqualToString:@"background"]) {
//        view.backgroundColor = [mgr.colorManager colorWith:value];
//    }
//    else {
//        NSString * first = [[property substringToIndex:1] uppercaseString];
//        NSString * rest = [property substringFromIndex:1];
//        NSString * setMethod = [NSString stringWithFormat:@"set%@%@:", first,rest];
//
//
//        //backgroundColor\textColor
//        if ([view respondsToSelector:NSSelectorFromString(setMethod)]) {
//            id propertyObj = [view valueForKey:property];
//            if (propertyObj) {
//                if ([propertyObj isKindOfClass:[UIColor class]]) {//如果是颜色
//                    [view setValue:[mgr.colorManager colorWith:value] forKey:property];
//                }
//                //字体大小
//                else if ([propertyObj isKindOfClass:[UIFont class]]){
//                    if([value isKindOfClass:[NSNumber class]]){
//                        const char * pObjCType = [((NSNumber*)value) objCType];
//                        if (strcmp(pObjCType, @encode(int))  == 0) {//int
//                            [view setValue:[UIFont systemFontOfSize:[value intValue]] forKey:property];
//                        }
//                        if (strcmp(pObjCType, @encode(float)) == 0) {//float
//                            [view setValue:[UIFont systemFontOfSize:[value floatValue]] forKey:property];
//                        }
//                        if (strcmp(pObjCType, @encode(double))  == 0) {//double
//                            [view setValue:[UIFont systemFontOfSize:[value doubleValue]] forKey:property];
//                        }
//                        if (strcmp(pObjCType, @encode(BOOL)) == 0) {//bool
//                            [view setValue:[UIFont systemFontOfSize:[value boolValue]] forKey:property];
//                        }
//
//                    }
//                }
//                NSArray * temp = [property componentsSeparatedByString:@"/"];
//                NSString * first = [temp firstObject];
//                NSString * last = [temp firstObject];
//                if (last) {
//                    if ([last isEqualToString:@"@drawable"]) {
//
//                    }
//                }else{
//                    //颜色
//
//                    //大小
//
//                    //图片名字
//                }
//            }
//            
//        }else{
//            //            NSLog(@"%@,没有此属性:%@---%@",NSStringFromCGRect(view.frame),setMethod,value);
//        }
//
//    }
//
//}
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

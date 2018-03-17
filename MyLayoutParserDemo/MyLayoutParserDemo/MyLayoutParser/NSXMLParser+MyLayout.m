//
//  NSXMLParser+MyLayout.m
//  MyLayoutParserDemo
//
//  Created by 梁慧聪 on 2017/6/20.
//  Copyright © 2017年 youngsoft. All rights reserved.
//

#import "NSXMLParser+MyLayout.h"
#import <objc/runtime.h>
@interface NSXMLParser()
@property (nonatomic, strong) NSNumber * isProcessing;//1表示XML正在被解析
@property (nonatomic, strong) NSNumber * justProcessStartElement;//1表示刚刚没有处理过 startElement事件
@end
@implementation NSXMLParser (MyLayout)

-(void)setXmlUrl:(NSURL *)xmlUrl{
    objc_setAssociatedObject(self, @selector(xmlUrl), xmlUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSURL *)xmlUrl{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setJsonString:(NSString *)jsonString{
    objc_setAssociatedObject(self, @selector(jsonString), jsonString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)jsonString{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setIsProcessing:(NSNumber *)isProcessing{
    objc_setAssociatedObject(self, @selector(isProcessing), isProcessing, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSNumber *)isProcessing{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setJustProcessStartElement:(NSNumber *)justProcessStartElement{
    objc_setAssociatedObject(self, @selector(justProcessStartElement), justProcessStartElement, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSNumber *)justProcessStartElement{
    return objc_getAssociatedObject(self, _cmd);
}


-(void)setXmlDictionary:(NSMutableDictionary *)xmlDictionary{
    objc_setAssociatedObject(self, @selector(xmlDictionary), xmlDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSMutableDictionary *)xmlDictionary{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setXmlParserBlock:(XMLParserBlock)xmlParserBlock{
    objc_setAssociatedObject(self, @selector(xmlParserBlock), xmlParserBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(XMLParserBlock)xmlParserBlock{
    return objc_getAssociatedObject(self, _cmd);
}

-(UIView *)xmlView{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setXmlView:(UIView *)xmlView{
    objc_setAssociatedObject(self, @selector(xmlView), xmlView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)superView{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setSuperView:(UIView *)superView{
    objc_setAssociatedObject(self, @selector(superView), superView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)checkIsProcessing{
    return [self.isProcessing boolValue];
}
- (void)configProcess:(BOOL)yesOrNo{
    self.isProcessing = [NSNumber numberWithBool:yesOrNo];
}

- (BOOL)checkJustProcessStartElement{
    return [self.justProcessStartElement boolValue];
}
- (void)configJustProcessStartElement:(BOOL)yesOrNo{
    self.justProcessStartElement = [NSNumber numberWithBool:yesOrNo];
}
@end

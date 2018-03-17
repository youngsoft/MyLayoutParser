//
//  UIView+FALayout.m
//  MyLayoutParserDemo
//
//  Created by 梁慧聪 on 2018/3/17.
//  Copyright © 2018年 youngsoft. All rights reserved.
//

#import "UIView+FALayout.h"
#import <objc/runtime.h>
@implementation UIView (FALayout)
-(void)setLayout_id:(NSString *)layout_id{
    objc_setAssociatedObject(self, @selector(layout_id), layout_id, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)layout_id{
    return objc_getAssociatedObject(self, _cmd);
}
@end

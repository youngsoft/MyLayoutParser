//
//  FALiveLeftDrawerView.h
//  FALiveCommon
//
//  Created by 梁慧聪 on 2018/3/16.
//  Copyright © 2018年 kugou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define ConstraintAdd(ITEM,ATTR1,RELATION,ITEM2,ATTR2,MULTIPLIER,CONSTANT)\
({\
UIView * SUPERVIEW = nil;\
if (!ITEM2 && ((ATTR1 == NSLayoutAttributeWidth) || (ATTR1 == NSLayoutAttributeHeight))) {\
SUPERVIEW = ITEM;\
}else{\
UIView *ITEM2_SUPER = ITEM2;\
while (!SUPERVIEW && ITEM2_SUPER) {\
UIView *ITEM_SUPER = ITEM;\
while (!SUPERVIEW && ITEM_SUPER) {\
if (ITEM2_SUPER == ITEM_SUPER) {\
SUPERVIEW = ITEM2_SUPER;\
}\
ITEM_SUPER = ITEM_SUPER.superview;\
}\
ITEM2_SUPER = ITEM2_SUPER.superview;\
}\
}\
ITEM.translatesAutoresizingMaskIntoConstraints = NO;\
NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:ITEM attribute:ATTR1 relatedBy:RELATION toItem:ITEM2 attribute:ATTR2 multiplier:MULTIPLIER constant:CONSTANT];\
[SUPERVIEW addConstraint:constraint];\
constraint;\
})


@interface FALiveLeftDrawerView : UIView
+ (FALiveLeftDrawerView *)showInView:(UIView *)superView;
+ (NSLayoutAttribute)layoutAttributeEnum:(NSString *)att;
+ (NSLayoutConstraint *)format:(NSString *)format views:(NSDictionary<NSString *, id> *)views;
+ (NSLayoutConstraint *)constraintItem:(UIView *)ITEM attr1:(NSLayoutAttribute)ATTR1 rel:(NSLayoutRelation)RELATION item2:(UIView *)ITEM2 attr2:(NSLayoutAttribute)ATTR2 mul:(CGFloat)MULTIPLIER constant:(CGFloat)CONSTANT;
+ (void)formats:(NSArray *)formats views:(NSDictionary<NSString *, id> *)views;
+ (NSString *)layoutAttributeIndex:(NSUInteger)index;
@end
@interface FALiveLeftDrawerCell : UICollectionViewCell
+ (NSString *)reuseIdentifier;
@end

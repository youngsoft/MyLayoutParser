//
//  FALiveLeftDrawerView.m
//  FALiveCommon
//
//  Created by 梁慧聪 on 2018/3/16.
//  Copyright © 2018年 kugou. All rights reserved.
//

#import "FALiveLeftDrawerView.h"

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

@interface FALiveLeftDrawerView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIButton * btnClose;
@property (nonatomic, strong) UICollectionView * collectView;
@property (nonatomic, strong) NSNumber * cwidth;
@end
@implementation FALiveLeftDrawerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configStyle];
    }
    return self;
}
+ (FALiveLeftDrawerView *)showInView:(UIView *)superView{
    FALiveLeftDrawerView * leftDrawer = [[FALiveLeftDrawerView alloc]initWithFrame:CGRectZero];
    [superView addSubview:leftDrawer];
    [leftDrawer resetFrame];
    return leftDrawer;
}
- (void)configStyle{
    //常量
    self.cwidth = @([[UIApplication sharedApplication] keyWindow].bounds.size.width * (1/3.0));
    //样式
    self.backgroundColor = [UIColor yellowColor];
    self.btnClose.hidden = NO;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.collectView.backgroundColor = [UIColor clearColor];
}
- (void)resetFrame{
    
    ConstraintAdd(self, NSLayoutAttributeLeft, NSLayoutRelationEqual, self.superview, NSLayoutAttributeLeft, 1.0, 0);
    ConstraintAdd(self, NSLayoutAttributeRight, NSLayoutRelationEqual, self.superview, NSLayoutAttributeRight, 1.0, 0);
    ConstraintAdd(self, NSLayoutAttributeTop, NSLayoutRelationEqual, self.superview, NSLayoutAttributeTop, 1.0, 0);
    ConstraintAdd(self, NSLayoutAttributeBottom, NSLayoutRelationEqual, self.superview, NSLayoutAttributeBottom, 1.0, 0);
    
    [FALiveLeftDrawerView formats:@[@"_contentView.left = self.left * 1 + 0",
                                    @"_contentView.width = self.width * 0.3 + 0",
                                    @"_contentView.height = 100",
                                    @"_contentView.bottom = self.bottom",
                                    ] views:NSDictionaryOfVariableBindings(self,_contentView)];
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        [self addSubview:_contentView];
    }
    return _contentView;
}
-(UIButton *)btnClose{
    if (!_btnClose) {
        _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_btnClose];
        _btnClose.backgroundColor = [UIColor blueColor];
        
        [FALiveLeftDrawerView formats:@[@"_btnClose.left = self.left * 1 + 0",
                                        @"_btnClose.right = self.right * 1 + 0",
                                        @"_btnClose.top = self.top * 1 + 0",
                                        @"_btnClose.bottom = self.bottom",
                                        ] views:NSDictionaryOfVariableBindings(self,_btnClose)];
    }
    return _btnClose;
}
- (UICollectionView *)collectView{
    if (!_collectView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.itemSize = CGSizeMake([self.cwidth integerValue], 150);
        [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flow setMinimumLineSpacing:5];
        [flow setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
        
        _collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
        [self.contentView addSubview:_collectView];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        [_collectView registerClass:[FALiveLeftDrawerCell class] forCellWithReuseIdentifier:[FALiveLeftDrawerCell reuseIdentifier]];
    }
    return _collectView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FALiveLeftDrawerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FALiveLeftDrawerCell reuseIdentifier]
                                                                           forIndexPath:indexPath];

    return cell;
}


#pragma mark - 布局整理
+ (NSLayoutConstraint *)format:(NSString *)format views:(NSDictionary<NSString *, id> *)views{
    return ({
        NSLayoutConstraint * constraint = nil;
        if ([format isKindOfClass:[NSString class]]) {
            UIView * itemView = nil;
            NSLayoutAttribute attribute = NSLayoutAttributeNotAnAttribute;
            NSLayoutRelation relation = NSLayoutRelationEqual;
            UIView * item2View = nil;
            NSLayoutAttribute attribute2 = NSLayoutAttributeNotAnAttribute;
            CGFloat multiplier = 1.0;
            CGFloat c = 0;
            
            NSString * relationStr = ([format rangeOfString:@"="].location != NSNotFound)?@"=":@"";
            if ([format rangeOfString:@">"].location != NSNotFound) {
                relationStr = [relationStr stringByAppendingString:@">"];
                relation = NSLayoutRelationGreaterThanOrEqual;
            }else if([format rangeOfString:@"<"].location != NSNotFound){
                relationStr = [relationStr stringByAppendingString:@"<"];
                relation = NSLayoutRelationLessThanOrEqual;
            }
            if (![relationStr isEqualToString:@""]) {
                NSArray * formatArr = [format componentsSeparatedByString:relationStr];
                if (formatArr.count==2) {
                    NSArray * firstFormat = [[formatArr firstObject] componentsSeparatedByString:@"."];
                    NSString * item = [[firstFormat firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    NSString * attri = [[firstFormat lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    itemView = views[item];
                    attribute = NSLayoutAttributeEnum(attri);
                    
                    NSScanner* scan = [NSScanner scannerWithString:[formatArr lastObject]];
                    int val;
                    BOOL isPure = ([scan scanInt:&val] && [scan isAtEnd]);
                    if (isPure) {
                         c = [[formatArr lastObject] doubleValue];
                    }else{
                        NSArray * secFormat = @[[[formatArr lastObject] substringToIndex:[[formatArr lastObject] rangeOfString:@"."].location],[[formatArr lastObject] substringFromIndex:[[formatArr lastObject] rangeOfString:@"."].location+1]];
                        if (secFormat.count==2) {
                            NSString * item2 = [[secFormat firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            item2View = views[item2];
                            secFormat = [[secFormat lastObject] componentsSeparatedByString:@"*"];
                            NSString * attri2 = [[secFormat firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            if (secFormat.count==2) {
                                attri2 = [[secFormat firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                secFormat = [[secFormat lastObject] componentsSeparatedByString:@"+"];
                                if (secFormat.count==2) {
                                    NSString * multip = [[secFormat firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                    multiplier = [multip doubleValue];
                                    NSString * constant = [[secFormat lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                    c = [constant doubleValue];
                                }
                            }
                            attribute2 = NSLayoutAttributeEnum(attri2);
                        }
                    }
                }
            }
            constraint = ConstraintAdd(itemView, attribute, relation, item2View, attribute2, multiplier, c);
        }
        constraint;
    });
}
+ (void)formats:(NSArray *)formats views:(NSDictionary<NSString *, id> *)views{
//    [self formats:formats opts:0 mts:nil views:views];
    if ([formats isKindOfClass:[NSArray class]]&& formats.count>0) {
        [formats enumerateObjectsUsingBlock:^(NSString *  _Nonnull format, NSUInteger idx, BOOL * _Nonnull stop) {
            [FALiveLeftDrawerView format:format views:views];
        }];
    }
}
+ (void)formats:(NSArray *)formats opts:(NSLayoutFormatOptions)opts mts:(nullable NSDictionary<NSString *,id> *)metrics views:(NSDictionary<NSString *, id> *)views{
//    nil
}
+(NSLayoutConstraint *)constraintItem:(UIView *)ITEM attr1:(NSLayoutAttribute)ATTR1 rel:(NSLayoutRelation)RELATION item2:(UIView *)ITEM2 attr2:(NSLayoutAttribute)ATTR2 mul:(CGFloat)MULTIPLIER constant:(CGFloat)CONSTANT{
    return ({
        UIView * SUPERVIEW = nil;
        if (!ITEM2 && ((ATTR1 == NSLayoutAttributeWidth) || (ATTR1 == NSLayoutAttributeHeight))) {
            SUPERVIEW = ITEM;
        }else{
            UIView *ITEM2_SUPER = ITEM2;
            while (!SUPERVIEW && ITEM2_SUPER) {
                UIView *ITEM_SUPER = ITEM;
                while (!SUPERVIEW && ITEM_SUPER) {
                    if (ITEM2_SUPER == ITEM_SUPER) {
                        SUPERVIEW = ITEM2_SUPER;
                    }
                    ITEM_SUPER = ITEM_SUPER.superview;
                }
                ITEM2_SUPER = ITEM2_SUPER.superview;
            }
        }
        ITEM.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:ITEM attribute:ATTR1 relatedBy:RELATION toItem:ITEM2 attribute:ATTR2 multiplier:MULTIPLIER constant:CONSTANT];
        [SUPERVIEW addConstraint:constraint];
        constraint;
    });
}
+ (NSString *)layoutAttributeIndex:(NSUInteger)index{
    return [@[
              @"NotAnAttribute",
              @"Left",
              @"Right",
              @"Top",
              @"Bottom",
              @"Leading",
              @"Trailing",
              @"Width",
              @"Height",
              @"CenterX",
              @"CenterY",
              @"Baseline",
              @"FirstBaseline",
              @"MarginLeft",
              @"MarginRight",
              @"MarginTop",
              @"MarginBottom",
              @"LeadingMargin",
              @"TrailingMargin",
              @"CenterXWithinMargins",
              @"CenterYWithinMargins"
              ]objectAtIndex:index];
}
+ (NSLayoutAttribute)layoutAttributeEnum:(NSString *)att{
//    return NSLayoutAttributeEnum(att);
    return [@[
             @"NotAnAttribute",
             @"Left",
             @"Right",
             @"Top",
             @"Bottom",
             @"Leading",
             @"Trailing",
             @"Width",
             @"Height",
             @"CenterX",
             @"CenterY",
             @"Baseline",
             @"FirstBaseline",
             @"MarginLeft",
             @"MarginRight",
             @"MarginTop",
             @"MarginBottom",
             @"LeadingMargin",
             @"TrailingMargin",
             @"CenterXWithinMargins",
             @"CenterYWithinMargins"
             ]indexOfObject:att];
}
@end
@interface FALiveLeftDrawerCell()
@property (nonatomic, strong) UIImageView * ivSinger;
@property (nonatomic, strong) UILabel * lbName;
@property (nonatomic, strong) UILabel * lbFansCount;
@end
@implementation FALiveLeftDrawerCell
+ (NSString *)reuseIdentifier{
    return @"FALiveLeftDrawerCell";
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configStyle];
    }
    return self;
}
- (void)configStyle{
    self.ivSinger.backgroundColor = [UIColor redColor];
    self.ivSinger.layer.cornerRadius = 5;
    self.lbName.font = [UIFont systemFontOfSize:12];
    self.lbFansCount.font = [UIFont systemFontOfSize:12];
    
    self.lbName.text = @"lbName";
    self.lbFansCount.text = @"lbFansCount";
    [self resetFrame];
}
- (void)resetFrame{
    UIView * contentView = self.contentView;
    //铺满全屏
    [FALiveLeftDrawerView formats:@[
                                    @"_ivSinger.left = contentView.left * 1 + 0",
                                    @"_ivSinger.right = contentView.right * 1 + 0",
                                    @"_ivSinger.top = contentView.top * 1 + 0",
                                    @"_ivSinger.bottom = contentView.bottom",
                                    ]
                            views:NSDictionaryOfVariableBindings(_ivSinger,contentView)];
    ConstraintAdd(self.lbName, NSLayoutAttributeBottom, NSLayoutRelationEqual, self.contentView, NSLayoutAttributeBottom, 1.0, 0);
    ConstraintAdd(self.lbName, NSLayoutAttributeLeft, NSLayoutRelationEqual, self.contentView, NSLayoutAttributeLeft, 1.0,  0);
    ConstraintAdd(self.lbName, NSLayoutAttributeWidth, NSLayoutRelationGreaterThanOrEqual, nil, NSLayoutAttributeNotAnAttribute, 1.0, 0).priority = 1000;
    ConstraintAdd(self.lbFansCount, NSLayoutAttributeBottom, NSLayoutRelationEqual, self.contentView, NSLayoutAttributeBottom, 1.0, 0);
    ConstraintAdd(self.lbFansCount, NSLayoutAttributeRight, NSLayoutRelationEqual, self.contentView, NSLayoutAttributeRight, 1.0, 0);
    ConstraintAdd(self.lbFansCount, NSLayoutAttributeWidth, NSLayoutRelationGreaterThanOrEqual, nil, NSLayoutAttributeNotAnAttribute, 1.0, 0).priority = 750;
    
    ConstraintAdd(self.lbName,NSLayoutAttributeRight,NSLayoutRelationEqual,self.lbFansCount,NSLayoutAttributeLeft,1.0, 0);
//    ConstraintAdd(self.lbName,NSLayoutAttributeWidth,NSLayoutRelationEqual,self.lbFansCount,NSLayoutAttributeWidth,1.0, 0);
    
//    [self.lbName setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
//    [self.lbFansCount setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
}
- (UIImageView *)ivSinger{
    if (!_ivSinger) {
        _ivSinger = [UIImageView new];
        [self.contentView addSubview:_ivSinger];
    }
    return _ivSinger;
}
- (UILabel *)lbFansCount{
    if (!_lbFansCount) {
        _lbFansCount = [[UILabel alloc]init];
        [self.contentView addSubview:_lbFansCount];
    }
    return _lbFansCount;
}
- (UILabel *)lbName{
    if (!_lbName) {
        _lbName = [[UILabel alloc]init];
        [self.contentView addSubview:_lbName];
    }
    return _lbName;
}
@end

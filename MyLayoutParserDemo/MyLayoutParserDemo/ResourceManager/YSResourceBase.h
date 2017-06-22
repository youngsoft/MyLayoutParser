//
//  YSResourceBase.h
//  jimustockFoundation
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 *  YSResourceSchemaDidChangeNotification 对象的key, value就是对应的资源管理器。
 */
UIKIT_EXTERN NSString *const kYSResourceObject;
UIKIT_EXTERN NSString *const kYSResourceRequestedSchema;
UIKIT_EXTERN NSString *const kYSResourceResponsiveSchema;



/**
 * switchToSchema到指定方案的资源时发出的通知，以及switchToDefaultSchema时发出的通知。
 */
UIKIT_EXTERN NSString *const YSResourceSchemaDidChangeNotification;



#define kBBAEPersonalResourcePrefix @"personal"

/**
 *  各种资源的基类
 */
@interface YSResourceBase : NSObject


@property(nonatomic, weak, readonly) NSBundle *bundle;
@property(nonatomic, strong, readonly) NSString *type;
@property(nonatomic, strong) NSString *schema;

@property(nonatomic, strong) NSCache *cache;
@property(nonatomic, strong) NSDictionary *dict;
@property(nonatomic, strong) NSDictionary *schemaDict;

@property(nonatomic, strong) NSDictionary *personalDict;        //个性化，差异化的资源

-(id)initWithBundle:(NSBundle*)bundle type:(NSString*)type;

//方案的名称，如果是默认方案则返回@""串
/**
 *  schemaName对应于资源文件名的前缀比如： <<schemaName>>_color.plist
 *  如果某类资源没有对应的schemaName_xxx.plist则用默认的schema
 *切换到某个特定的方案。切换完毕后会发送YSResourceSchemaDidChangeNotification通知
 */
-(BOOL)switchToSchema:(NSString*)schema;
//恢复到原始方案
-(BOOL)switchToDefaultSchema;

//内部调用。不产生通知，外部不要调用,派生类如果有特殊处理需要重载这个方法
-(BOOL)switchToSchemaInner:(NSString*)schemaName;



/**
 *  根据资源ID查找plist中的资源描述对象
 *
 *  @param resId resId description
 *
 *  @return <#return value description#>
 */
-(id)findResDescById:(NSString*)resId;

-(NSNumber*)scaledNumberFrom:(id)val;


@end

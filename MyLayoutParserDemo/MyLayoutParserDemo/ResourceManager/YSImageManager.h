//
//  YSImageManager.h
//  JimuLoan
//
//  Created by apple on 15/6/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSResourceBase.h"


/*图片资源管理器，管理Image下的图片资源*/
@interface YSImageManager : YSResourceBase

-(id)initWithBundle:(NSBundle *)bundle;

//加载图片放入缓存中，如果用这个函数加载图片资源则图片资源会一直保持在内存中，这个函数一般是图片资源需要常驻内存
/**
 *  图片资源的处理不像其他资源一样有一个plist文件来进行描述，而是直接根据图片资源的名字来进行加载
 *  那么图片资源如何来处理不同的bundle下的不同的schema的呢。
 *  不同的schema的实现是在图片资源名称前面加上schema。但是使用时不需要指定。其他bundle下则直接根据bundle下来处理。
 *  在IOS8中支持将Images.xcassets放入到其他bundle中，并可以通过imageNamed来访问
 *
 *  @param imageName <#imageName description#>
 *
 *  @return <#return value description#>
 */
-(UIImage*)imageNamed:(NSString*)imageName;

#if TARGET_OS_IOS
//加载图片不放入缓存中,如果图片资源只是局部使用请使用这个方法，保证图片不会长时间占用内存
//做NoCached的图片不能放入到Images.xcassets中去只能像老版本一样把图片资源添加到工程中
-(UIImage*)imageNoCached:(NSString*)imageName;

#endif

@end

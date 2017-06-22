//
//  YSRawManager.h
//  jimustockFoundation
//
//  Created by apple on 15/12/23.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSResourceBase.h"

/**原始二进制文件管理器**/
@interface YSRawManager : YSResourceBase

-(id)initWithBundle:(NSBundle*)bundle;


-(NSData*)dataWith:(NSString*)rawId;

-(NSInputStream*)streamWith:(NSString*)rawId;

-(NSString*) pathWith:(NSString*)rawId;

@end

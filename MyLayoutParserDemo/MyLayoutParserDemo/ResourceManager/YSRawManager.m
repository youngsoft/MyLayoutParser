//
//  YSRawManager.m
//  jimustockFoundation
//
//  Created by apple on 15/12/23.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "YSRawManager.h"

@implementation YSRawManager

-(id)initWithBundle:(NSBundle*)bundle
{
    return [super initWithBundle:bundle type:@"raw"];
}

-(BOOL)switchToSchemaInner:(NSString*)schemaName
{
    BOOL bOk = ![self.schema isEqualToString:schemaName];
    
    self.schema = schemaName;
    
    return bOk;
}



-(NSData*)dataWith:(NSString*)rawId
{
    return [NSData dataWithContentsOfFile:[self pathWith:rawId]];
}

-(NSInputStream*)streamWith:(NSString*)rawId
{
    return [NSInputStream inputStreamWithFileAtPath:[self pathWith:rawId]];
}


-(NSString*) pathWith:(NSString*)rawId
{
    NSString *fileName = nil;
    if ([self.schema isEqualToString:@""])
        fileName = rawId;
    else
        fileName = [NSString stringWithFormat:@"%@_%@",self.schema,rawId];
    
    NSString *personalFileName = [NSString stringWithFormat:@"%@_%@",kBBAEPersonalResourcePrefix, fileName];
    
    NSString *filePath = [self.bundle pathForResource:personalFileName ofType:nil];
    if (filePath == nil) {
        filePath = [self.bundle pathForResource:fileName ofType:nil];
        if (filePath == nil && ![self.schema isEqualToString:@""])
        {
            filePath = [self.bundle pathForResource:rawId ofType:nil];
        }
    }
    
    return filePath;
}



@end

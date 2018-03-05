//
//  NSString+Property.m
//  MyLayoutParserDemo
//
//  Created by 梁慧聪 on 2017/10/16.
//  Copyright © 2017年 youngsoft. All rights reserved.
//

#import "NSString+Property.h"
#import <objc/runtime.h>
#include <string.h>
@implementation NSString (Property)

/**
 * Get the data type of a property in a class
 * @designatedClass, designated class name of `Class`
 */
- (NSString *)getPropertyTypeWithClass:(Class)designatedClass {
    const char * propertyName = self.UTF8String;
    
    NSString *property_data_type = nil;
    unsigned int outCount = 0, i = 0;
    objc_property_t *properties = class_copyPropertyList(designatedClass, &outCount);

    for (; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *property_name = property_getName(property);
        if (strcmp(property_name, propertyName) == 0) {
            const char * property_attr = property_getAttributes(property);
            
            //If the property is a type of Objective-C class, then substring the variable of `property_attr` in order to getting its real type
            if (property_attr[1] == '@') {
                char * occurs1 =  strchr(property_attr, '@');
                char * occurs2 =  strrchr(occurs1, '"');
                char dest_str[40]= {0};
                strncpy(dest_str, occurs1, occurs2 - occurs1);
                char * realType = (char *)malloc(sizeof(char) * 50);
                int i = 0, j = 0, len = (int)strlen(dest_str);
                for (; i < len; i++) {
                    if ((dest_str[i] >= 'a' && dest_str[i] <= 'z') || (dest_str[i] >= 'A' && dest_str[i] <= 'Z')) {
                        realType[j++] = dest_str[i];
                    }
                }
                property_data_type = [NSString stringWithFormat:@"%s", realType];
                free(realType);
            } else {
                
                //Otherwise, take the second subscript character for comparing to the @encode()
                char * realType = [self getPropertyRealType:property_attr];
                property_data_type = [NSString stringWithFormat:@"%s", realType];
            }
        }
    }
    
    return property_data_type;
}

/**
 * Get the data type of a property in a class that the encode characters is deponding on the following Link
 * https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
 **/
- (char *)getPropertyRealType:(const char *)property_attr {
    char * type;
    
    char t = property_attr[1];
    
    if (strcmp(&t, @encode(char)) == 0) {
        type = "char";
    } else if (strcmp(&t, @encode(int)) == 0) {
        type = "int";
    } else if (strcmp(&t, @encode(short)) == 0) {
        type = "short";
    } else if (strcmp(&t, @encode(long)) == 0) {
        type = "long";
    } else if (strcmp(&t, @encode(long long)) == 0) {
        type = "long long";
    } else if (strcmp(&t, @encode(unsigned char)) == 0) {
        type = "unsigned char";
    } else if (strcmp(&t, @encode(unsigned int)) == 0) {
        type = "unsigned int";
    } else if (strcmp(&t, @encode(unsigned short)) == 0) {
        type = "unsigned short";
    } else if (strcmp(&t, @encode(unsigned long)) == 0) {
        type = "unsigned long";
    } else if (strcmp(&t, @encode(unsigned long long)) == 0) {
        type = "unsigned long long";
    } else if (strcmp(&t, @encode(float)) == 0) {
        type = "float";
    } else if (strcmp(&t, @encode(double)) == 0) {
        type = "double";
    } else if (strcmp(&t, @encode(_Bool)) == 0 || strcmp(&t, @encode(bool)) == 0) {
        type = "BOOL";
    } else if (strcmp(&t, @encode(void)) == 0) {
        type = "void";
    } else if (strcmp(&t, @encode(char *)) == 0) {
        type = "char *";
    } else if (strcmp(&t, @encode(id)) == 0) {
        type = "id";
    } else if (strcmp(&t, @encode(Class)) == 0) {
        type = "Class";
    } else if (strcmp(&t, @encode(SEL)) == 0) {
        type = "SEL";
    } else {
        type = "";
    }
    return type;
}

@end

//
//  ViewController.m
//  MyLayoutParserDemo
//
//  Created by apple on 2017/6/7.
//  Copyright © 2017年 youngsoft. All rights reserved.
//

#import "ViewController.h"
#import "ParserManager.h"
@interface ViewController ()
@property (nonatomic, strong) ParserManager *parserManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSXMLParser * parser = [self.parserManager parserWithBlock:^(NSMutableDictionary *xmlDictionary, NSString *jsonString, NSError *error) {
        if (error) {
            NSLog(@"xml 解析错误：%@",error);
            return;
        }
        NSLog(@"json:\n%@",jsonString);
        NSLog(@"字典:\n%@",xmlDictionary);
    }];
    [parser parse];
}

- (ParserManager *)parserManager
{
    if (!_parserManager) {
        _parserManager = [[ParserManager alloc] init];
    }
    return _parserManager;
}

@end

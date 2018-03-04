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
    __weak typeof(self) wSelf = self;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"test3" ofType:@"xml"];
    NSXMLParser * parser = [self.parserManager parserFilePath:path withBlock:^(NSMutableDictionary *xmlDictionary, NSString *jsonString,UIView * view, NSError *error) {
        if (error) {
            NSLog(@"xml 解析错误：%@",error);
            return;
        }
        [wSelf.view addSubview:view];
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

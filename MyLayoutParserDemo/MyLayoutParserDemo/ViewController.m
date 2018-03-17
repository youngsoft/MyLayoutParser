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
@property (nonatomic, strong) UIView * viewRed;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [FALiveLeftDrawerView showInView:self.view];
    __weak typeof(self) wSelf = self;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"test4" ofType:@"xml"];
    NSXMLParser * parser = [self.parserManager parserFilePath:path withBlock:^(NSMutableDictionary *xmlDictionary, NSString *jsonString,UIView * view, NSError *error) {
        if (error) {
            NSLog(@"xml 解析错误：%@",error);
            return;
        }
    } superView:self.view];
    [parser parse];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (ParserManager *)parserManager
{
    if (!_parserManager) {
        _parserManager = [[ParserManager alloc] init];
    }
    return _parserManager;
}

@end

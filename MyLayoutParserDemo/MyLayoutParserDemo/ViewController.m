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
    __weak typeof(self) weakSelf = self;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"test5" ofType:@"xml"];
    NSXMLParser * parser = [self.parserManager parserFilePath:path withBlock:^(ParserManager *parser, NSMutableDictionary *xmlDictionary, NSString *jsonString, UIView *view, NSError *error) {
        if (error) {
            return;
        }
        weakSelf.viewRed = [parser parserFindViewById:@"view"];
        
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

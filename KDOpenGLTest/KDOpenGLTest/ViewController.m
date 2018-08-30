//
//  ViewController.m
//  KDOpenGLTest
//
//  Created by csyibei on 2018/8/31.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //iOS面试之道的错误
    dispatch_queue_t q = dispatch_queue_create("111", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1");
    dispatch_sync(q, ^{
        NSLog(@"2");
        dispatch_async(q, ^{
            NSLog(@"3");
        });
        sleep(2);
        NSLog(@"4");
        sleep(2);
    });
    sleep(2);
    NSLog(@"5");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ViewController.m
//  KDOpenGLTest
//
//  Created by csyibei on 2018/8/31.
//  Copyright © 2018 csyibei. All rights reserved.
//

#import "ViewController.h"
#import "KDGLView.h"
#import "KDNewGLView.h"
#import "KDTextureGlView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //iOS面试之道的错误
//    dispatch_queue_t bq = dispatch_queue_create("222", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t q = dispatch_queue_create("111", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(bq, ^{
//        NSLog(@"1");
//        dispatch_sync(q, ^{
//            NSLog(@"2");
//            dispatch_async(q, ^{
//                NSLog(@"3");
//            });
////            sleep(2);
//            NSLog(@"4");
//            sleep(2);
//        });
////        sleep(2);
//        NSLog(@"5");
//    });
    
    
    KDTextureGlView *glv = [[KDTextureGlView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:glv];
    
//    [context presentRenderbuffer:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

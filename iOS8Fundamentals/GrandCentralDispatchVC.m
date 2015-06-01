//
//  GrandCentralDispatchVC.m
//  iOS8Fundamentals
//
//  Created by Pedro Ontiveros on 5/31/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "GrandCentralDispatchVC.h"

//void (^globalWorker1)(id) = ^(id object) {
//    
//    dispatch_async(dispatch_get_main_queue(), ^() {
//        NSObject *obj = (NSObject*)object;
//        if ([obj isKindOfClass:[UILabel class]]) {
//            UILabel *label = (UILabel*)obj;
//            [label setText:@""];
//        }
//    });
//    
//};

@interface GrandCentralDispatchVC ()

@end

@implementation GrandCentralDispatchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Grand Central Dispatch";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startWorker1:(id)sender
{
    NSLog(@"Starting worker 1...");
    
    __block UILabel *label = self.worker1Label;
    
    void (^localWorker1)(void) = ^(void) {
        for (int i = 0; i < 10; i++) {
            sleep(1);
            NSLog(@"worker1 running...%d", (i + 1));
            dispatch_async(dispatch_get_main_queue(), ^() {
                [label setText:[NSString stringWithFormat:@"Iteration number %d", i + 1]];
                [label setNeedsDisplay];
            
            });
        }
        
        NSLog(@"worker1 has finished.");
        dispatch_async(dispatch_get_main_queue(), ^() {
            [label setText:@"worker1 has finished."];
            [label setNeedsDisplay];
        });
    };
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, localWorker1);
}

@end

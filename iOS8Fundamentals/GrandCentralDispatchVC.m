//
//  GrandCentralDispatchVC.m
//  iOS8Fundamentals
//
//  Created by Pedro Ontiveros on 5/31/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "GrandCentralDispatchVC.h"

void (^globalWorker1)(int) = ^(int max) {
    if (max > 0) {
        for (int n = 0; n < max; n++) {
            sleep(1);
            NSLog(@"Running globalWorker1 iteration %d.", n);
        }
    }
    
    NSLog(@"globalWorker1 has finished.");
};

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
    
    self.serialQueue01     = dispatch_queue_create("com.qbxsoft.serialqueue01", DISPATCH_QUEUE_SERIAL);
    self.concurrentQueue02 = dispatch_queue_create("com.qbxsoft.concurrentqueue01", DISPATCH_QUEUE_CONCURRENT);
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

- (IBAction)startWorker2:(id)sender
{
    globalWorker1(4);
    
    dispatch_async(self.serialQueue01, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"worker02 is running...%d", i);
            sleep(1);
        }
        
        NSLog(@"worker02 finished.");
    });

    dispatch_async(self.serialQueue01, ^ {
        for (int i = 0; i < 10; i++) {
            NSLog(@"worker03 is running...%d", i);
            sleep(1);
        }
        
        NSLog(@"worker03 finished.");
    });
    
}

- (IBAction)useBarrierBlock:(id)sender
{
    if ([sender isKindOfClass:[UISwitch class]]) {
        UISwitch *sw = (UISwitch*)sender;
        self.useBarrierBLock = [sw isOn];
    }
}

- (IBAction)startWorker03:(id)sender
{
    [self testBlock];
    
    dispatch_async(self.concurrentQueue02, ^{
        
        for (int i = 0; i < 10; i++) {
            NSLog(@"worker04 is running...%d", i);
            sleep(1);
        }
        
        NSLog(@"worker04 finished.");
    });
    
    if (self.useBarrierBLock) {
        dispatch_barrier_async(self.concurrentQueue02, ^{
            sleep(2);
            NSLog(@"Lazy block is still working.");
        });
    }
    
    dispatch_async(self.concurrentQueue02, ^ {
        for (int i = 0; i < 10; i++) {
            NSLog(@"worker05 is running...%d", i);
            sleep(1);
        }
        
        NSLog(@"worker05 finished.");
    });
}

- (void)testBlock
{
    __block int n = 100; // Pay attention in "__block" keyword.
    
    NSLog(@"Value of n: %d", n);
    
    void (^blockWorker)(void) = ^(void) {
        n = 900; // Here is the effect of "__block" keyword.
        NSLog(@"Value of n: %d", n);
    };
    
    blockWorker(); // Run block.
    
    NSLog(@"Value of n: %d", n); // Value here ?
}

@end

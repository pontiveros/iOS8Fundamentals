//
//  NSThreadVCViewController.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 6/1/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "NSThreadVC.h"

typedef long(^procedure_01)(NSString* arg1);

procedure_01 proc01 = ^long(NSString *arg1) {
    NSLog(@"%@", arg1);
    return arg1.length;
};

procedure_01 proc02 = ^long(NSString* arg1) {

    for (long i = (arg1.length - 1); i >= 0; i--) {
        NSLog(@"%c", [arg1 characterAtIndex:i]);
    }
    return 0;
};

@interface NSThreadVC ()

@end

@implementation NSThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"NSThread Class";
    self.flagWorker1 = NO;
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

- (void)viewWillDisappear:(BOOL)animated
{
    self.flagWorker1 = NO;
    [super viewWillDisappear:animated];
}

- (IBAction)startWorker1:(id)sender
{
    self.flagWorker1 = !self.flagWorker1;
    
    if (self.flagWorker1) {
        [self.btnWorker1 setTitle:@"Stop Worker 1" forState:UIControlStateNormal];
        [NSThread detachNewThreadSelector:@selector(nsWorker1) toTarget:self withObject:nil];
    } else {
        [self.btnWorker1 setTitle:@"Start Worker 1" forState:UIControlStateNormal];
    }
}

- (void)nsWorker1
{
    NSLog(@"Start nsworker1...");
    
    __block int counter = 0;
    __weak NSThreadVC *pSelf = self;
    
    while (self.flagWorker1) {
        sleep(1);
        NSLog(@"nsWorker running...");
        dispatch_async(dispatch_get_main_queue(), ^() {
            [pSelf.labelWorker1 setText:[NSString stringWithFormat:@"Iteration order %d", ++counter]];
        });
    }
    
    NSLog(@"nsWorker1 finished.");
}

#pragma mark - BLOCKS AND MORE

- (IBAction)onTouchBlock01:(id)sender
{
    [self testingBlock1];
}

- (void)testingBlock1
{
    long length = proc02(@"Mensaje de Pedro Ontiveros.");
    NSLog(@"Length: %ld", length);
}

@end

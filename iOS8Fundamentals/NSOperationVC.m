//
//  NSOperationVC.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 8/5/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "NSOperationVC.h"

@interface NSOperationVC ()

@end

@implementation NSOperationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"NSOperationVC";
    self.items = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTouchStart:(id)sender
{
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"This is a simple block.");
    }];
    
    [operation1 start];
    NSLog(@"Start");
}

- (IBAction)onTouchStop:(id)sender
{
    NSLog(@"Stop");
}

- (IBAction)onTouchResume:(id)sender
{
    NSLog(@"Resume");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end

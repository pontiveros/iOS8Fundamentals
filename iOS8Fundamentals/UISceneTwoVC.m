//
//  UISceneTwoVC.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 10/11/15.
//  Copyright © 2015 Pedro Ontiveros. All rights reserved.
//

#import "UISceneTwoVC.h"

@interface UISceneTwoVC ()

@end

@implementation UISceneTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Scene Two";
    [self.view setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:230.0/255.0 blue:220.0/255.0 alpha:1.0]];
    [self.redView setBackgroundColor:[UIColor blueColor]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self.redView addGestureRecognizer:tapGesture];
    
    
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

- (void)onTapGesture:(UITapGestureRecognizer*)sender
{
    NSLog(@"Hey, it's works!");
    
    if (self.redView.backgroundColor == [UIColor blueColor]) {
        [self.redView setBackgroundColor:[UIColor redColor]];
    } else {
        [self.redView setBackgroundColor:[UIColor blueColor]];
    }
}

@end

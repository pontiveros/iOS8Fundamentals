//
//  NetworkingVC.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 6/13/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "NetworkingVC.h"
#import "UIPingVC.h"
#import "WebViewContainer.h"


@interface NetworkingVC ()

@end

@implementation NetworkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Files & Networking";
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

- (IBAction)onTouchPing:(id)sender
{
    UIPingVC *vc = [[UIPingVC alloc] initWithNibName:@"UIPingView" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTouchWKWebView:(id)sender
{
    WebViewContainer *wvc = [[WebViewContainer alloc] initWithNibName:@"WebViewContainer" bundle:nil];
    [self.navigationController pushViewController:wvc animated:YES];
}

@end

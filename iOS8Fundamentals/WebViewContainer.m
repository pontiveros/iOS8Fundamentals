//
//  WebViewContainer.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 9/10/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "WebViewContainer.h"
#import <WebKit/WebKit.h>

@interface WebViewContainer ()

@end

@implementation WebViewContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (NSClassFromString(@"WKWebView")) {
        WKWebView *web = [[WKWebView alloc] initWithFrame:[[self view] bounds]];
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://10.27.219.153/ETE/App_Receipts/index.aspx#/"]]];
        self.webView = web;
    } else {
        self.webView = [[UIWebView alloc] initWithFrame:[[self view] bounds]];
    }
    [self.view addSubview:self.webView];
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

@end

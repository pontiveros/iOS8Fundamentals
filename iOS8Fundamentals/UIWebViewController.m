//
//  UIWebViewController.m
//  iOS8Fundamentals
//
//  Created by Pedro Ontiveros on 5/13/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "UIWebViewController.h"

@interface UIWebViewController ()

@end

@implementation UIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UIWebView";
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blueColor]];

//    [self.webView.scrollView setAlwaysBounceVertical:YES];
//    [self.webView.scrollView setAutoresizesSubviews:YES];
//    [self.webView.scrollView setScrollEnabled:NO];
//    [self.webView.scrollView setPagingEnabled:YES];
//    [self.webView.scrollView setContentOffset:CGPointMake(1, 1000.0) animated:NO];
//    [self.webView.scrollView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
//    [self.webView setAccessibilityNavigationStyle:UIAccessibilityNavigationStyleSeparate];
    
//    self.webView.suppressesIncrementalRendering = YES;
//    self.webView.gapBetweenPages = 20.0;
    self.webView.scalesPageToFit = YES;

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost/getpdf/out/theclanguage.html"]]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://l3-documents.appspot.com/brands/GPRO/prospectus/prospectus.html"]]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost/getcustomer/TheCLanguage.pdf"]]];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"ERROR: %@", [error description]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateCanvas) userInfo:nil repeats:NO];
}

- (void)runInBackground
{
    NSString *script = @"showAlert();";
    [self.webView stringByEvaluatingJavaScriptFromString:script];
}

- (void)updateCanvas
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"console.log('before upadted');"];
    NSString *script = @"document.querySelector('body').style.webkitOverflowScrolling = 'touch';";
    [self.webView stringByEvaluatingJavaScriptFromString:script];
    [self.webView stringByEvaluatingJavaScriptFromString:@"console.log('after upadted');"];
}

@end

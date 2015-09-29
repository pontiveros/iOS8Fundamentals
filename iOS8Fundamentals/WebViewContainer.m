//
//  WebViewContainer.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 9/10/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "WebViewContainer.h"

@interface WebViewContainer ()

@end

@implementation WebViewContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"WKWebView";
    // Do any additional setup after loading the view.
    if (NSClassFromString(@"WKWebView")) {
    
        NSError  *error = nil;
        NSString  *path = [[NSBundle mainBundle] pathForResource: @"ScriptWebView" ofType: @"js"];
        NSString *scriptFromFile = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
        NSString *script = @"function onClickButton() { window.webkit.messageHandlers.Observe.postMessage('Message from web'); console.log('click here... working!');}";
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserScript *scriptCamera = [[WKUserScript alloc] initWithSource:scriptFromFile injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *userController  = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *webConfiguration = [[WKWebViewConfiguration alloc] init];
        
        [userController addUserScript:userScript];
        [userController addUserScript:scriptCamera];
        [userController addScriptMessageHandler:self name:@"Observe"];
        [webConfiguration setUserContentController:userController];
        
//        WKWebView *web = [[WKWebView alloc] initWithFrame:[[self view] bounds] configuration:webConfiguration];
        WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,500,400) configuration:webConfiguration];
        
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost/webkitapp"]]];
        [web setUserInteractionEnabled:YES];
        
        [web setUIDelegate:self];
        self.webView = web;
    } else {
        self.webView = [[UIWebView alloc] initWithFrame:[[self view] bounds]];
    }
    [self.view addSubview:self.webView];
}

- (NSString*)getScriptFrom
{
    return @"function openCamera() {\
                console.log('Message from native, please check out.');\
            }";
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

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"Observe"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:message.body preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
@end

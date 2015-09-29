//
//  WebViewContainer.h
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 9/10/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewContainer : UIViewController<WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>

@property (nonatomic, retain)IBOutlet UIView *webView;

@end

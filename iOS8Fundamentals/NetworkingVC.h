//
//  NetworkingVC.h
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 6/13/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "PickerImageHelper.h"

@interface NetworkingVC : UIViewController<NSURLSessionDelegate, MCAdvertiserAssistantDelegate>

@property (nonatomic, retain)PickerImageHelper *imageHelper;
@property (nonatomic, retain)NSString *stringURL;

@end

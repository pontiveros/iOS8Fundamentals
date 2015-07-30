//
//  UIBarCodeReaderVC.h
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 7/29/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZBarSDK.h"

@interface UIBarCodeReaderVC : UIViewController<AVCaptureMetadataOutputObjectsDelegate, ZBarReaderDelegate>

@property (nonatomic, retain) IBOutlet UILabel *result;

@end

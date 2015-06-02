//
//  NSThreadVCViewController.h
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 6/1/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSThreadVC : UIViewController

@property (nonatomic, retain)IBOutlet UILabel  *labelWorker1;
@property (nonatomic, retain)IBOutlet UIButton *btnWorker1;

@property(nonatomic) BOOL flagWorker1;

@end

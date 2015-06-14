//
//  GrandCentralDispatchVC.h
//  iOS8Fundamentals
//
//  Created by Pedro Ontiveros on 5/31/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrandCentralDispatchVC : UIViewController


@property (nonatomic, retain) IBOutlet UILabel *worker1Label;
@property (strong)dispatch_queue_t serialQueue01;
@property (strong)dispatch_queue_t concurrentQueue02;
@property (assign, atomic) BOOL useBarrierBLock;

@end

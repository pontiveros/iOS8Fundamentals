//
//  UITableVC.h
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 7/22/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>

#define REMOTE_URL @"http://jsonplaceholder.typicode.com/photos"
//#define REMOTE_URL @"http://jsonplaceholder.typicode.com/albums"

@interface UITableVC : UITableViewController

@property (nonatomic, retain)NSMutableArray   *items;
@property (nonatomic, retain)dispatch_queue_t backgroundQueue;

@end

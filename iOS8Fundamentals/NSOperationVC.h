//
//  NSOperationVC.h
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 8/5/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSOperationVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSBlockOperation *_blockOperation;
}

@property (nonatomic, retain)NSMutableArray *items;
@property (nonatomic, retain)IBOutlet UITableView *table;

@end

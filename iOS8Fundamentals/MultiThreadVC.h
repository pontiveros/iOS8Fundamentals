//
//  MultiThreadVC.h
//  iOS8Fundamentals
//
//  Created by Pedro Ontiveros on 5/30/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiThreadVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *items;
}


@end

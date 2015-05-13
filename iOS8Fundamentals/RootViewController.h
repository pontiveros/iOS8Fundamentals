//
//  ViewController.h
//  iOS8Fundamentals
//
//  Created by Pedro Ontiveros on 5/13/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary *items;
}

@end


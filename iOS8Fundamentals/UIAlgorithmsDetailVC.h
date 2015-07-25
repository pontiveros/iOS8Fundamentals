//
//  UIAlgorithmsDetailVC.h
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 7/24/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _UIDETAIL_TYPE {
    UIDETAIL_TYPE_A,
    UIDETAIL_TYPE_B,
} UIDETAIL_TYPE;

typedef enum _SORT_BY {
    SORT_BY_INDEX,
    SORT_BY_ALPHABETICAL,
    SORT_BY_ALPHABETICAL_REVERSE,
}SORT_BY;

@interface UIAlgorithmsDetailVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    IBOutlet UITableView *_tableView;
}

@property(nonatomic, assign) UIDETAIL_TYPE type;
@property(nonatomic, assign) SORT_BY sortBy;
@property(nonatomic, retain) NSArray *items;
@property(nonatomic, retain) NSArray *options;

@end

//
//  UICoreDataVC.h
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 10/4/15.
//  Copyright © 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _UICOREDATA_VIEW_MODE {
    UICOREDATA_MODE_ROOT,
    UICOREDATA_MODE_MOCLIST,
    UICOREDATA_MODE_CUSTOMER,
} UICOREDATA_VIEW_MODE;

@interface UICoreDataVC : UITableViewController

@property (nonatomic, assign)UICOREDATA_VIEW_MODE mode;
@property (nonatomic, retain) NSArray *items;

- (id)initWithViewMode:(UICOREDATA_VIEW_MODE)mode;

@end

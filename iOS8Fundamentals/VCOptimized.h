//
//  VCOptimized.h
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 12/24/15.
//  Copyright © 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CProduct : NSObject

@property (nonatomic, retain) NSString *productName;
@property (nonatomic, retain) NSString *productKind;
@property (nonatomic, retain) NSNumber *stock;
@property (nonatomic, retain) NSNumber *price;

@end

@interface VCOptimized : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *items;

@end

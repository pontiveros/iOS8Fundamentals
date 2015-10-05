//
//  Customer+CoreDataProperties.h
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 10/4/15.
//  Copyright © 2015 Pedro Ontiveros. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "QCustomer.h"

NS_ASSUME_NONNULL_BEGIN

@interface QCustomer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *fullname;
@property (nullable, nonatomic, retain) NSString *identification;
@property (nullable, nonatomic, retain) NSNumber *instance;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) Location *location;

@end

NS_ASSUME_NONNULL_END

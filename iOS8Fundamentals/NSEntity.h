//
//  NSEntity.h
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 7/13/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSEntity : NSObject

@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSNumber *identification;

- (id)init;
- (id)initWithIdentification:(NSNumber*)identification andName:(NSString*)name;
- (NSString*)description;
- (NSComparisonResult)compare:(NSEntity*)entity;

@end

//
//  NSCustomer.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 7/13/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "NSCustomer.h"

@implementation NSCustomer

- (id)init
{
    if (self = [super init]) {
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithIdentification:(NSNumber *)identification andName:(NSString *)name
{
    if (self = [super initWithIdentification:identification andName:name]) {
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    NSCustomer *customer = [[NSCustomer alloc] initWithIdentification:self.identification andName:self.name];
    for (NSString *item in self.items) {
        [customer.items addObject:[item copy]];
    }
    return customer;
}

@end

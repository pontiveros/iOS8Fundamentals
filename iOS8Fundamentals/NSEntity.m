//
//  NSEntity.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 7/13/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "NSEntity.h"

@implementation NSEntity

- (id)init
{
    if (self = [super init]) {
        self.name = @"Unknown";
        self.identification = 000000;
    }
    return self;
}

- (id)initWithIdentification:(NSNumber*)identification andName:(NSString*)name
{
    if (self = [super init]) {
        self.identification = [identification copy];
        self.name           = [name copy];
    }
    
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"Identification: %@ - Name: %@", [self.identification stringValue], self.name];
}

- (NSComparisonResult)compare:(NSEntity*)entity
{
    return [self.name compare:entity.name];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[NSEntity alloc] initWithIdentification:self.identification andName:self.name];
}

@end

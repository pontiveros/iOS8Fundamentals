//
//  QSyncManager.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 9/30/15.
//  Copyright © 2015 Pedro Ontiveros. All rights reserved.
//

#import "QSyncManager.h"
#import "AppDelegate.h"
#import "QCustomer.h"


@implementation QSyncManager

- (id)initWithMode:(SYNC_MODE)mode
{
    if (self = [super init]) {
        self.mode = mode;
    }
    
    return self;
}

- (void)downloadDataFrom:(NSString*)stringURL
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type":[NSString stringWithFormat:@"application/json;"]};
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURLSessionDataTask *uploadTask = [session dataTaskWithRequest:request
                                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                      if (data) {
                                                          [self saveToDatabase:data];
                                                      } else {
                                                          NSLog(@"ERROR: WTF ?");
                                                      }
                                                  }];
    
    [uploadTask resume];
}

- (void)saveToDatabase:(NSData*)data
{
    NSError    *err = nil;
    NSArray *result = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingMutableContainers
                                                        error:&err];
    if (!err) {
        if (self.mode == SYNC_MODE_MOC) {
            [self fillMocList:result];
        } else {
            [self fillCustomer:result];
        }
    } else {
        NSLog(@"ERROR: %@", [err description]);
    }
}

- (void)fillMocList:(NSArray*)dataSet
{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [app managedObjectContext];
    
    for (NSDictionary *item in dataSet) {
        NSManagedObject *newRow = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:context];
        NSNumber *value = [NSNumber numberWithLong:[[item objectForKey:@"id"] longValue]];
        [newRow setValue:value forKey:@"instance"];
        [newRow setValue:[item objectForKey:@"cus"]forKey:@"label"];
        [newRow setValue:[item objectForKey:@"detail"] forKey:@"detail"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
}

- (void)fillCustomer:(NSArray*)dataSet
{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [app managedObjectContext];
    
    for (NSDictionary *item in dataSet) {
        NSManagedObject *newRow = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:context];
        [newRow setValue:@"instance" forKey:[item objectForKey:@"id"]];
        [newRow setValue:@"label" forKey:[item objectForKey:@"cus"]];
        [newRow setValue:@"detail" forKey:[item objectForKey:@"detail"]];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
}

@end

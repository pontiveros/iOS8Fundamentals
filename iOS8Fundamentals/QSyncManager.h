//
//  QSyncManager.h
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 9/30/15.
//  Copyright © 2015 Pedro Ontiveros. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _SYNC_MODE {
    SYNC_MODE_CUSTOMER,
    SYNC_MODE_MOC,
} SYNC_MODE;

@interface QSyncManager : NSObject

@property(nonatomic, assign) SYNC_MODE mode;

- (id)initWithMode:(SYNC_MODE)mode;
- (void)downloadDataFrom:(NSString*)stringURL;

@end

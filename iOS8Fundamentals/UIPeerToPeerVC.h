//
//  UIPeerToPeerVC.h
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 10/28/15.
//  Copyright © 2015 Pedro Ontiveros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface UIPeerToPeerVC : UIViewController<MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>

@property(nonatomic, retain) NSMutableArray *mutableBlockedPeers;
@property(nonatomic, retain) MCPeerID *localPeerID;

@end

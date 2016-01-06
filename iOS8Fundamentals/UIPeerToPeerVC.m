//
//  UIPeerToPeerVC.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 10/28/15.
//  Copyright © 2015 Pedro Ontiveros. All rights reserved.
//

#import "UIPeerToPeerVC.h"
//#include "buril.h"


static NSString * const XXServiceType = @"pedro-service";


@interface UIPeerToPeerVC ()

@end

@implementation UIPeerToPeerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Peer to Peer";
    self.mutableBlockedPeers = [[NSMutableArray alloc] init];
    self.localPeerID         = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];

    MCNearbyServiceAdvertiser *serviceAd = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID discoveryInfo:nil serviceType:XXServiceType];
    serviceAd.delegate = self;
    [serviceAd startAdvertisingPeer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTouchSendMessage:(id)sender {
    NSLog(@"Message form button");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MCSessionDelegate
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"Session + peer + didchangeState");
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Session + didReceivedData + fromPeer");
}

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL))certificateHandler
{
    NSLog(@"didReceiveCertificate");
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"didReceiveStream");
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSLog(@"didStartReceivingResourceWithName");
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    NSLog(@"didFinishReceivingResourceWithName");
}

#pragma mark - MCNearbyServiceAdvertiserDelegate
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"ERROR: %@", [error description]);
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser
 didReceiveInvitationFromPeer:(MCPeerID *)peerID
                  withContext:(NSData *)context
            invitationHandler:(void (^)(BOOL, MCSession * _Nonnull))invitationHandler
{
    NSLog(@"Connectivity is working ...");
    
    NSString *title = [NSString stringWithFormat:@"Received Invitation from %@", self.localPeerID.displayName];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Reject" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Block" style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Block" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        BOOL acceptedInvitation = (buttonIndex == [actionSheet firstOtherButtonIndex]);
//        
//        if (buttonIndex == [actionSheet destructiveButtonIndex]) {
//            [self.mutableBlockedPeers addObject:peerID];
//        }
//        
//        MCSession *session = [[MCSession alloc] initWithPeer:self.localPeerID
//                                            securityIdentity:nil
//                                        encryptionPreference:MCEncryptionNone];
//        session.delegate = self;
//        
//        invitationHandler(acceptedInvitation, (acceptedInvitation ? session : nil));
    }]];
}
@end

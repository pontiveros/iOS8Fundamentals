//
//  UIBarCodeReaderVC.m
//  iOSWorkshop
//
//  Created by Pedro Ontiveros on 7/29/15.
//  Copyright (c) 2015 Pedro Ontiveros. All rights reserved.
//

#import "UIBarCodeReaderVC.h"


@interface UIBarCodeReaderVC ()

@property (nonatomic, retain)AVCaptureSession *session;

@end

@implementation UIBarCodeReaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTouchOpenReader:(id)sender
{

    AVCaptureDevice     *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]; // Type Video
    NSError              *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    dispatch_queue_t      queue = dispatch_queue_create("com.mycompany.dataMatrixQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    if (input) {
        self.session = [[AVCaptureSession alloc] init];
        [self.session beginConfiguration];
        [self.session addInput:input];

        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [self.session addOutput:output];
        
        AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        [output setMetadataObjectsDelegate:self queue:queue];
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        
        [self.view.layer addSublayer:layer];
        [self.session commitConfiguration];
        [self.session startRunning];
    } else {
        NSLog(@"ERROR: %@", [error description]);
    }
}

- (IBAction)onTouchOpenZBarScann:(id)sender
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
//    [scanner setSymbology:ZBAR_I25
//                   config:ZBAR_CFG_ENABLE
//                       to:0];
    
    [self presentViewController:reader animated:YES completion:nil];
}

#pragma mark - AVCaptureDataOutputObjectDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *QRCode = nil;
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            // This will never happen; nobody has ever scanned a QR code... ever
            QRCode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            break;
        }
    }
    
    NSLog(@"QR Code: %@", QRCode);
    UIBarCodeReaderVC *pSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ {
        [pSelf.result setText:QRCode];
    });
    [self.session stopRunning];
}

#pragma mark - 
- (void)imagePickerController:(UIImagePickerController*)reader didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
//    resultText.text = symbol.data;
    UIBarCodeReaderVC *pSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^ {
        [pSelf.result setText:symbol.data];
    });

    NSLog(@"READ: %@", symbol.data);
    
    // EXAMPLE: do something useful with the barcode image
//    resultImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissViewControllerAnimated:YES completion:nil];
}
@end

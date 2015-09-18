//
//  ImageHelper.h
//  DeloitteContainer
//
//  Created by Pedro Ontiveros on 9/11/15.
//  Copyright (c) 2015 Infopulse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum _IMAGEPICKCONTROLLER_TYPE {
    IMAGEPICKCONTROLLER_TYPE_CAMERA,
    IMAGEPICKCONTROLLER_TYPE_GALLERY,
} IMAGEPICKCONTROLLER_TYPE;

@interface PickerImageHelper : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    UIViewController *hostViewController;
}

@property(nonatomic, assign)CGPoint position;
- (id)initWithViewController:(UIViewController*)viewController;
- (id)initWithViewController:(UIViewController *)viewController menuPosition:(CGPoint)point;
- (void)selectImageWithCompletionHandler:(void (^)(UIImage *image, NSError *error))completionHandler;
- (void)dealloc;
@end

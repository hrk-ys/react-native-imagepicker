//
//  RNImagePickerManager.m
//  RNImagePicker
//
//  Created by Hiroki Yoshifuji on 2015/06/08.
//  Copyright (c) 2015年 hiroki.yoshifuji. All rights reserved.
//

#import "RNImagePickerManager.h"
#import <UIKit/UIKit.h>

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"

@interface RNImagePickerManager() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    RCTResponseSenderBlock _callback;
}

@end

@implementation RNImagePickerManager

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(showWithSourceType:(NSString *)key findEvents:(RCTResponseSenderBlock)callback)
{
    _callback = callback;
    dispatch_async(dispatch_get_main_queue(), ^{

        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;

        [[self rootVc] presentViewController:imagePicker animated:YES completion:nil];
    });
}

- (UIViewController*)rootVc
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    return [window rootViewController];
}

- (void)_closeWithImage:(NSString*)imagePath
{
    [[self rootVc] dismissViewControllerAnimated:YES completion:^{
        id error = [NSNull null];
        id success = imagePath ? imagePath : [NSNull null];
        _callback(@[error, success]);
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self _closeWithImage:editingInfo[UIImagePickerControllerReferenceURL]];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL* url = info[UIImagePickerControllerReferenceURL];
    if (info[UIImagePickerControllerEditedImage]) {
        NSString* assetFilePath = url.absoluteString;
        BOOL isPing = [[assetFilePath uppercaseString] hasSuffix:@"PNG"];
        NSString* tmpFilePath = [self writeImgae:info[UIImagePickerControllerEditedImage] isPing:isPing];
        [self _closeWithImage:tmpFilePath];
    } else {
        [self _closeWithImage:url.absoluteString];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self _closeWithImage:nil];
}

- (NSString*) writeImgae:(UIImage*)image isPing:(BOOL)isPing {

    NSData *data = isPing ? UIImagePNGRepresentation(image) : UIImageJPEGRepresentation(image, 0.8f);

    NSTimeInterval now =  [[NSDate date] timeIntervalSince1970];
    NSString* filename = [NSString stringWithFormat:isPing ? @"tmp-%d.png" : @"tmp-%d.jpg", (int)now];

    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirPath = [array objectAtIndex:0];
    NSString *filePath = [cacheDirPath stringByAppendingPathComponent:filename];

    if ([data writeToFile:filePath atomically:YES]) {
        return filePath;
    } else {
        return nil;
    }
}

@end

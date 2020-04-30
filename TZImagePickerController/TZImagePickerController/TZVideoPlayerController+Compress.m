//
//  TZVideoPlayerController+Compress.m
//  TZImagePickerController
//
//  Created by jiaweiding on 2020/4/30.
//  Copyright © 2020 谭真. All rights reserved.
//

#import "TZVideoPlayerController+Compress.h"
#import "TZVideoCompressManager.h"

@implementation TZVideoPlayerController (Compress)

// 新的按钮点击事件，用来处理视频压缩
- (void)newDoneButtonClick {
    NSLog(@"原始文件URL：%@", self.url);
    NSLog(@"原始文件大小：%@", [self getFileSizeWithFilePath:self.url.relativePath]);
    [TZVideoCompressManager compressVideoWithVideoUrl:self.url withBiteRate:[TZImageManager manager].videoCompressBiteRate withFrameRate:[TZImageManager manager].videoCompressFrameRate withVideoWidth:[TZImageManager manager].videoCompressWidth withVideoHeight:[TZImageManager manager].videoCompressHeight compressComplete:^(id  _Nonnull responseObjc) {
        NSString *filePathStr = [responseObjc objectForKey:@"urlStr"];
        NSURL *fileURL = [NSURL fileURLWithPath:filePathStr];
        NSLog(@"压缩后文件URL：%@", fileURL);
        NSLog(@"压缩后文件大小：%@", [self getFileSizeWithFilePath:fileURL.relativePath]);
        [self reSaveVideo:fileURL];
    }];
}

// 重新保存，获取PHAsset并更新model属性
- (void)reSaveVideo:(NSURL *)url {
    [[TZImageManager manager] saveVideoWithUrl:url completion:^(PHAsset *asset, NSError *error) {
        self.model = [[TZImageManager manager] createModelWithAsset:asset];
        [self doneButtonClick];
    }];
}

- (NSString *)getFileSizeWithFilePath:(NSString *)filePath {
    NSFileManager *manager = NSFileManager.defaultManager;
    if ([manager fileExistsAtPath:filePath]) {
        unsigned long long fileSize = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        return [NSString stringWithFormat:@"%.2fM", fileSize / (1024.0 * 1024.0)];
    }
    return @"0M";
}


@end

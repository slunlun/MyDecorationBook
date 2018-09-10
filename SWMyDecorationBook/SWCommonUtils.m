//
//  SWCommonUtils.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/29.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWCommonUtils.h"
#import <MobileCoreServices/MobileCoreServices.h>
#define SCREEN_WIDTH              [UIScreen mainScreen].bounds.size.width

#define SCREEN_HEIGHT             [UIScreen mainScreen].bounds.size.height

//iPhone_X layout

#define Status_H                 [UIApplication sharedApplication].statusBarFrame.size.height

#define NavBar_H                  44

#define Nav_Height                (Status_H + NavBar_H)

@implementation SWCommonUtils
+ (CGFloat)systemNavBarHeight {
    return Nav_Height;
}

+ (NSString*) getMiMeType:(NSString*)filepath
{
    if (filepath == nil) {
        return nil;
    }
    
    NSString *fileExtension = [self getExtension:filepath error:nil];
    if (fileExtension == nil) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtension, NULL);
    CFStringRef mimeType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    NSString *mimeTypeStr = (__bridge_transfer NSString *)mimeType;
    if (mimeTypeStr == nil) {
        if([fileExtension compare:@"java" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            return @"text/x-java-source";
        }
        NSString *extentensionText = @"cpp, c, h, m, log, swift, vb, md, properties,";
        NSRange foundOjb = [extentensionText rangeOfString:fileExtension options:NSCaseInsensitiveSearch];
        if (foundOjb.length > 0) {
            return @"text/plain";
        }
        return @"application/octet-stream";
    }
    return mimeTypeStr;
}

+ (NSString *)getExtension:(NSString *)fullpath error:(NSError **)error
{
    if (fullpath == nil) {
        return  nil;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullpath]) {
        return nil;
    }
   
    return [[fullpath pathExtension] lowercaseString];
    
}

+ (void)saveFile:(NSData *)fileData toDocumentFolder:(NSString *)fileName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileData attributes:nil];
}

+ (NSData *)getFileFromDocumentFolder:(NSString *)fileName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

+ (void)removeFileFromDocumentFolder:(NSString *)fileName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    
    NSAssert(error == nil, @"WTK");
}
@end

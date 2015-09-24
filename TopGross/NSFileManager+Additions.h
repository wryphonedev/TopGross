//
//  NSFileManager+Additions.h
//
//  Created by Isaac Schmidt on 1/16/14.
//  Copyright (c) 2014 Isaac Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

extern const uint64_t kMinimumDiskSpaceThreshold;

@interface NSFileManager (Additions)

+ (NSString *)uniqueName;
+ (NSString *)documentDirectoryPath;
+ (NSString *)cacheDirectoryPath;
+ (NSString *)newUniqueSubdirectoryInDirectoryWithPath:(NSString *)path;
+ (NSString *)pathForUniqueTemporaryFileWithExtension:(NSString*)extension;
+ (NSURL *)urlForUniqueTemporaryFileWithExtension:(NSString*)extension;
+ (NSString *)uniqueSubdirectoryInDocumentsDirectory;
+ (NSString *)uniqueSubdirectoryInTempDirectory;
+ (void)removeFile:(NSURL *)fileURL;
+ (BOOL)replaceFileAtURL:(NSURL *)destinationURL withFileAtURL:(NSURL *)sourceURL;
+ (BOOL)createDirectoryAtPath:(NSString *)path;
+ (BOOL)deleteDirectoryAtPath:(NSString *)path;
+ (BOOL)diskSpaceAvailable:(uint64_t)spaceRequired; // (in bytes)
+ (BOOL)deviceHasEnoughDiskSpace;
+ (NSURL *)writeJPEGToTmpWithImage:(UIImage *)image;
+ (NSURL *)writePNGToTmpWithImage:(UIImage *)image;

@end

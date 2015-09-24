//
//  NSFileManager+Additions.m
//
//
//  Created by Isaac Schmidt on 1/16/14.
//  Copyright (c) 2014 TENDIGI. All rights reserved.
//

#import "NSFileManager+Additions.h"

const uint64_t kMinimumDiskSpaceThreshold = 100 * 1024 * 1024; // 100 MB

@implementation NSFileManager (Additions)

+ (NSString *)uniqueName
{
    NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];
    return identifier;
}

+ (NSString *)documentDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/", [paths objectAtIndex:0]];
    return path;
}

+ (NSString *)uniqueSubdirectoryInDocumentsDirectory
{
    return [[self class] newUniqueSubdirectoryInDirectoryWithPath:[[self class] documentDirectoryPath]];
}

+ (NSString *)uniqueSubdirectoryInTempDirectory
{
    return [[self class] newUniqueSubdirectoryInDirectoryWithPath:[[self class] cacheDirectoryPath]];
}

+ (NSString *)newUniqueSubdirectoryInDirectoryWithPath:(NSString *)path
{
    NSString *newPath = [NSString stringWithFormat:@"%@%@/", path, [NSFileManager uniqueName]];
    BOOL created = [NSFileManager createDirectoryAtPath:newPath];
    if (!created) newPath = nil;
    return newPath;
}

+ (NSString *)pathForUniqueTemporaryFileWithExtension:(NSString*)extension
{
    NSString* tempPath = NSTemporaryDirectory();
    NSString* path;
    do
    {
        path = [tempPath stringByAppendingPathComponent:[[self class] uniqueName]];
        if (extension) path = [path stringByAppendingPathExtension:extension];
        
    } while ([[self defaultManager] fileExistsAtPath:path]);
    
    return path;
}

+ (NSURL *)urlForUniqueTemporaryFileWithExtension:(NSString*)extension
{
    NSString *lastPathComponent = [[self class] uniqueName];
    if (extension) lastPathComponent = [lastPathComponent stringByAppendingPathExtension:extension];
    // NSURL* tempUrl = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:lastPathComponent isDirectory:NO];
    NSURL* tempUrl = [NSURL fileURLWithPath:NSTemporaryDirectory()];
    
    
    NSURL *url;
    do
    {
        url = [tempUrl URLByAppendingPathComponent:lastPathComponent isDirectory:NO];
        
    } while ([[self defaultManager] fileExistsAtPath:[url path]]);
    
    return url;
}

+ (NSString *)cacheDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/", [paths objectAtIndex:0]];
    return path;
}

+ (BOOL)createDirectoryAtPath:(NSString *)path
{
    BOOL success = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *creationError;
    [fileManager createDirectoryAtPath:path
           withIntermediateDirectories:YES
                            attributes:[NSDictionary dictionary]
                                 error:&creationError];
    if (creationError)
    {
        NSLog(@"Error creating directory: %@", [creationError localizedDescription]);
        success = NO;
    }
    
    return success;
}

+ (BOOL)deleteDirectoryAtPath:(NSString *)path
{
    BOOL success = YES;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *deleteError;
    [manager removeItemAtPath:path error:&deleteError];
    if (deleteError)
    {
        success = NO;
        NSLog(@"Error deleting directory: %@", [deleteError localizedDescription]);
    }
    
    return success;
}

+ (void)removeFile:(NSURL *)fileURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [fileURL path];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
		if (!success)
			NSLog(@"Error removing file: %@", [error localizedDescription]);
    }
}

+ (BOOL)replaceFileAtURL:(NSURL *)destinationURL withFileAtURL:(NSURL *)sourceURL
{
    BOOL succeeded = NO;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    [manager replaceItemAtURL:destinationURL
                withItemAtURL:sourceURL
               backupItemName:@"bkup_"
                      options:0
             resultingItemURL:nil
                        error:&error];
    if (!error)
    {
        succeeded = YES;
    }
    else
    {
        NSLog(@"Error replacing original file: %@", [error localizedDescription]);
    }
    
    return succeeded;
}

+ (BOOL)deviceHasEnoughDiskSpace
{
    return [[self class] diskSpaceAvailable:kMinimumDiskSpaceThreshold];
}

+ (BOOL)diskSpaceAvailable:(uint64_t)space
{
    BOOL sufficient = NO;
    uint64_t available = [NSFileManager deviceAvailableDiskSpace];
    if ((available > space)) sufficient = YES;
    return sufficient;
}

+ (uint64_t)deviceAvailableDiskSpace
{
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    
    __autoreleasing NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalFreeSpace;
}

+ (NSURL *)writeJPEGToTmpWithImage:(UIImage *)image
{
    NSURL *tmpFileUrl = [NSFileManager urlForUniqueTemporaryFileWithExtension:@"jpg"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
    BOOL success = [imageData writeToFile:[tmpFileUrl path] atomically:YES];
    if (success)
    {
        return tmpFileUrl;
    }
    else
    {
        return nil;
    }
}

+ (NSURL *)writePNGToTmpWithImage:(UIImage *)image
{
    NSURL *tmpFileUrl = [NSFileManager urlForUniqueTemporaryFileWithExtension:@"png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    BOOL success = [imageData writeToFile:[tmpFileUrl path] atomically:YES];
    if (success)
    {
        return tmpFileUrl;
    }
    else
    {
        return nil;
    }
}

@end

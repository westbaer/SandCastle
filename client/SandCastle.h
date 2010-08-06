#include <Foundation/Foundation.h>

@class SandCastle, CPDistributedMessagingCenter;

@interface SandCastle : NSObject {
	CPDistributedMessagingCenter *center;
}

+ (SandCastle *)sharedInstance;
- (NSString *)temporaryPathForFileName:(NSString *)fileName;
- (void)moveTemporaryFile:(NSString *)file toResolvedPath:(NSString *)path;
- (void)removeItemAtResolvedPath:(NSString *)path;
- (void)createDirectoryAtResolvedPath:(NSString *)path;

@end
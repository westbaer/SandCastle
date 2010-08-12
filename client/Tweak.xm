#include <CPDistributedMessagingCenter.h>
#include <SandCastle.h>

static SandCastle *sharedInstance = nil;

@implementation SandCastle

- (id)init {
	if((self = [super init])) {
		center = [CPDistributedMessagingCenter centerNamed:@"me.haunold.sandcastle.center"];
	}
	
	return self;
}

- (NSString *)temporaryPathForFileName:(NSString *)fileName {
	CFUUIDRef uuidObj = CFUUIDCreate(nil);
	NSString *newUUID = (NSString *)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return [@"/tmp/" stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", [newUUID autorelease], [fileName pathExtension]]];
}

- (void)moveTemporaryFile:(NSString *)file toResolvedPath:(NSString *)path {
	NSDictionary *_params = [NSDictionary dictionaryWithObjectsAndKeys:	file, @"SandCastleTemporaryFile",
																		path, @"SandCastleResolvedPath",
																		nil, nil];
	
	[center sendMessageName:@"MoveNotification" userInfo:_params];
}

- (void)removeItemAtResolvedPath:(NSString *)path {
	NSDictionary *_params = [NSDictionary dictionaryWithObjectsAndKeys:	path, @"SandCastleResolvedPath",
																		nil, nil];
	
	[center sendMessageName:@"RemoveNotification" userInfo:_params];
}

- (void)createDirectoryAtResolvedPath:(NSString *)path {
	NSDictionary *_params = [NSDictionary dictionaryWithObjectsAndKeys:	path, @"SandCastleResolvedPath",
																		nil, nil];
	
	[center sendMessageName:@"CreateDirectoryNotification" userInfo:_params];	
}

#pragma mark -
#pragma mark Singleton Stuff

+ (SandCastle *)sharedInstance {
	@synchronized(self) {
		if (sharedInstance == nil)
			sharedInstance = [[SandCastle alloc] init];
	}
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;
}

- (void)release { }

- (id)autorelease {
	return self;
}

@end


static __attribute__((constructor)) void SandCastleClientInitialize() {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	%init;
	
	[SandCastle sharedInstance];
	
	[pool release];
}

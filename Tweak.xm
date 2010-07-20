#include <CPDistributedMessagingCenter.h>

@interface SandCastleObserver : NSObject {
	CPDistributedMessagingCenter *center;
}

@end

@implementation SandCastleObserver

- (id)init {
	if((self = [super init])) {
		center = [[CPDistributedMessagingCenter centerNamed:@"me.haunold.sandcastle.center"] retain];
		[center runServerOnCurrentThread];
		[center registerForMessageName:@"MoveNotification" target:self selector:@selector(handleMove:userInfo:)];
		[center registerForMessageName:@"RemoveNotification" target:self selector:@selector(handleRemove:userInfo:)];
	}
	
	return self;
}

- (void)handleMove:(NSString *)name userInfo:(NSDictionary *)userInfo {
	NSLog(@"handleMove:%@ userInfo:%@", name, userInfo);
	// TODO: Add Safety Checks or something
	[[NSFileManager defaultManager] copyItemAtPath:[userInfo objectForKey:@"SandCastleTemporaryFile"] toPath:[userInfo objectForKey:@"SandCastleResolvedPath"] error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:[userInfo objectForKey:@"SandCastleTemporaryFile"] error:nil];
}

- (void)handleRemove:(NSString *)name userInfo:(NSDictionary *)userInfo {
	NSLog(@"handleRemove:%@ userInfo:%@", name, userInfo);
	// TODO: Add Safety Checks or something
	[[NSFileManager defaultManager] removeItemAtPath:[userInfo objectForKey:@"SandCastleResolvedPath"] error:nil];
}

- (void)dealloc {
	[center release];
	[super dealloc];
}

@end

static SandCastleObserver *observer = nil;

static __attribute__((constructor)) void YourTubeHDInitialize() {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	%init;
	
	observer = [[SandCastleObserver alloc] init];
	
	[pool release];
}
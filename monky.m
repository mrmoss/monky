#import "Cocoa/Cocoa.h"
#include <Foundation/Foundation.h>

//02:14

float x_off=16;

NSAutoreleasePool* pool;
NSString* command;
float interval_in_secs=0;

NSString* runCommand(NSString* commandToRun)
{
	NSTask* task=[[[NSTask alloc] init] autorelease];
	[task setLaunchPath:@"/bin/sh"];

	NSArray* arguments=[NSArray arrayWithObjects:@"-c" ,[NSString stringWithFormat:@"%@",commandToRun],nil];
	[task setArguments:arguments];

	NSPipe* pipe=[NSPipe pipe];
	[task setStandardOutput:pipe];

	NSFileHandle* file=[pipe fileHandleForReading];

	[task launch];

	NSData* data=[file readDataToEndOfFile];
	NSString* output=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];

	task=nil;

	return output;
}

@interface app_t:NSObject
	@property NSRect windowRect;
	@property (nonatomic,retain) NSWindow* window;
	@property (nonatomic,retain) NSWindowController* windowController;
	@property (nonatomic,retain) NSTextView* textView;
	@property (nonatomic,retain) NSTimer* timer;

	-(id)init;
	-(void)timer_func;
	-(void)timer_cb:(NSTimer*)aTimer;
@end

@implementation app_t
	-(id)init
	{
		id newInstance=[super init];
		if (newInstance)
		{
			_windowRect=NSMakeRect(x_off,[[NSScreen mainScreen] frame].size.height,1000,1000);
			_window =
			[
				[NSWindow alloc] initWithContentRect:_windowRect
				styleMask:NSBorderlessWindowMask	//this is deprecated...no idea what to use...
				backing:NSBackingStoreBuffered
				defer:NO
				screen:[NSScreen mainScreen]
			];
			[_window autorelease];
			[_window setAlphaValue:1.0];
			[_window setBackgroundColor:NSColor.clearColor];
			[_window setOpaque:NO];
			_window.ignoresMouseEvents=true;
			[_window setOpaque:NSFloatingWindowLevel];

			NSUInteger collectionBehavior;
			collectionBehavior=[_window collectionBehavior];
			collectionBehavior|=NSWindowCollectionBehaviorStationary;
			collectionBehavior|=NSWindowCollectionBehaviorCanJoinAllSpaces;
			collectionBehavior|=NSWindowCollectionBehaviorFullScreenNone;
			[_window setCollectionBehavior:collectionBehavior];

			_windowController=[[[NSWindowController alloc] initWithWindow:_window] autorelease];
			[_windowController autorelease];

			_textView=[[[NSTextView alloc] initWithFrame:_windowRect] autorelease];
			[_textView autorelease];
			[_window setContentView:_textView];
			_textView.backgroundColor=NSColor.clearColor;
			_textView.textColor=NSColor.whiteColor;
			_textView.drawsBackground=true;

			NSFontManager* fontManager=[NSFontManager sharedFontManager];
			NSFont* font=[fontManager fontWithFamily:@"Monaco" traits:NSBoldFontMask weight:0 size:12];
			[_textView setFont:font];

			_timer=
			[
				NSTimer scheduledTimerWithTimeInterval:interval_in_secs
				target:self
				selector:@selector(timer_cb:)
				userInfo:nil
				repeats:YES
			];

			[_window orderBack:self];

			[self timer_func];
		}
		return newInstance;
	}

	-(void)timer_func
	{
		[_window setFrameTopLeftPoint:NSMakePoint(x_off,[[NSScreen mainScreen] frame].size.height)];
		NSString* command_data=runCommand(command);
		[_textView setString:[NSString stringWithFormat:@"\n%s",[command_data UTF8String]]];

		command_data=nil;
	}

	-(void)timer_cb:(NSTimer*)aTimer
	{
		[self timer_func];
	}
@end

int main(int argc,const char* argv[])
{
	if(argc!=3)
	{
		printf("Usage: %s [int INTERVAL_SECONDS] [str COMMAND]\n",argv[0]);
		return 1;
	}

	if(sscanf(argv[1],"%f",&interval_in_secs)!=1)
	{
		printf("\"%s\" is not an int.\n",argv[1]);
		return 1;
	}

	NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
	command=[[[NSString alloc] initWithUTF8String:argv[2]] autorelease];
	[NSApplication sharedApplication];
	app_t* app=[[[app_t alloc] init] autorelease];
	[NSApp run];
	return 0;
}
#import "Cocoa/Cocoa.h"
#include <Foundation/Foundation.h>

float x_off=16;

NSString* command;
int interval_in_secs=0;

NSString* runCommand(NSString* commandToRun)
{
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:@"/bin/sh"];

	NSArray *arguments = [NSArray arrayWithObjects:
						  @"-c" ,
						  [NSString stringWithFormat:@"%@", commandToRun],
						  nil];
	[task setArguments:arguments];

	NSPipe *pipe = [NSPipe pipe];
	[task setStandardOutput:pipe];

	NSFileHandle *file = [pipe fileHandleForReading];

	[task launch];

	NSData *data = [file readDataToEndOfFile];

	NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
			collectionBehavior|=NSWindowCollectionBehaviorCanJoinAllSpaces;
			[_window setCollectionBehavior:collectionBehavior];

			_windowController=[[NSWindowController alloc] initWithWindow:_window];
			[_windowController autorelease];

			_textView=[[NSTextView alloc] initWithFrame:_windowRect];
			[_textView autorelease];
			[_window setContentView:_textView];
			_textView.backgroundColor=NSColor.clearColor;
			_textView.textColor=NSColor.whiteColor;
			_textView.drawsBackground=true;

			NSFontManager* fontManager=[NSFontManager sharedFontManager];
			NSFont* font=[fontManager fontWithFamily:@"Monaco" traits:NSBoldFontMask weight:0 size:12];
			[_textView setFont:font];

			[_window orderFrontRegardless];

			_timer=
			[
				NSTimer scheduledTimerWithTimeInterval:interval_in_secs
				target:self
				selector:@selector(timer_cb:)
				userInfo:nil
				repeats:YES
			];

			[self timer_func];
		}
		return newInstance;
	}

	-(void)timer_func
	{
		[_window setFrameTopLeftPoint:NSMakePoint(x_off,[[NSScreen mainScreen] frame].size.height)];
		[_textView setString:runCommand(command)];
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

	if(sscanf(argv[1],"%d",&interval_in_secs)!=1)
	{
		printf("\"%s\" is not an int.\n",argv[1]);
		return 1;
	}

	command=[[NSString alloc] initWithUTF8String:argv[2]];
	[NSApplication sharedApplication];
	app_t* app=[[app_t alloc] init];
	[NSApp run];
	return 0;
}
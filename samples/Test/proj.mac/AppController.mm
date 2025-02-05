
 
#import "AppController.h"
#import "AppDelegate.h"

#define Screen_Width 750
#define Screen_Height 1344

@implementation AppController

	static AppDelegate s_sharedApplication;

	@synthesize window, glView;

	-(void) applicationDidFinishLaunching:(NSNotification *)aNotification
	{
		// create the window
		// note that using NSResizableWindowMask causes the window to be a little
		// smaller and therefore ipad graphics are not loaded
        NSRect rect = NSMakeRect(200, 100, Screen_Width/2, Screen_Height/2);
		window = [[NSWindow alloc] initWithContentRect:rect
			styleMask:( NSClosableWindowMask | NSTitledWindowMask )
			backing:NSBackingStoreBuffered
			defer:YES];
        
        NSOpenGLPixelFormatAttribute attributes[] =
        {
            NSOpenGLPFADoubleBuffer,
            NSOpenGLPFADepthSize, 24,
            NSOpenGLPFAStencilSize, 8,
            0
        };
        
        NSOpenGLPixelFormat *pixelFormat = [[[NSOpenGLPixelFormat alloc] initWithAttributes:attributes] autorelease];

        NSView* view = [[NSView alloc]initWithFrame:rect];
        
        // allocate our GL view
        // (isn't there already a shared EAGLView?)
        glView = [[[EAGLView alloc] initWithFrame:[view bounds] pixelFormat:pixelFormat] autorelease];;
        [view addSubview:glView];
        
        NSString* title = @"CrossApp-Demo";
		// set window parameters
		[window becomeFirstResponder];
		[window setContentView:view];
		[window setTitle:[NSString stringWithFormat:@"%@ (%dx%d)", title, Screen_Width, Screen_Height]];
		[window makeKeyAndOrderFront:self];
		[window setAcceptsMouseMovedEvents:NO];
        
		CrossApp::CCApplication::sharedApplication()->run();
	}

	-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)theApplication
	{
		return YES;
	}

	-(void) dealloc
	{
		CrossApp::CAApplication::getApplication()->end();
		[super dealloc];
	}

#pragma mark -
#pragma mark IB Actions

	-(IBAction) toggleFullScreen:(id)sender
	{
		EAGLView* pView = [EAGLView sharedEGLView];
		[pView setFullScreen:!pView.isFullScreen];
	}

	-(IBAction) exitFullScreen:(id)sender
	{
		[[EAGLView sharedEGLView] setFullScreen:NO];
	}

@end

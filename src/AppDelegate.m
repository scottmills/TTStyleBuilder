//
//  AppDelegate.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AppDelegate.h"
#import "StyleStructureController.h"
#import "StyleEditor.h"
#import "MainMenuController.h"
#import "RenderService.h"

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    // start-up the Render Service (available via Bonjour)
    renderService = [[RenderService alloc] init];
    
    // display the main menu on launch
    UIViewController *rootController = [[MainMenuController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
    
    // configure TTNavigationCenter
    TTNavigationCenter *nav = [TTNavigationCenter defaultCenter];
    nav.mainViewController = navigationController;
    nav.delegate = self;
    
    // hookup the in-memory object URL loading system
    // (This should belong in TTNavigationCenter initialization)
    nav.urlSchemes = [NSArray arrayWithObject:[NSObject inMemoryUrlScheme]];
    [nav addObjectLoader:[NSObject class] name:[NSObject inMemoryUrlHost]];
    
    // define the view controllers for TTStyle objects
    [nav addView:@"style_structure" controller:[StyleStructureController class]];
    [nav addView:@"style_config" controller:[StyleEditor class]];
    
    // create the window and show everything
    window = [[UIWindow alloc] initWithFrame:TTApplicationFrame()];
    [window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}

#pragma mark -

NSString *StyleArchivesDir(void)
{
#if TARGET_IPHONE_SIMULATOR
    // I would use NSHomeDirectory() here but when you build for iPhone simulator, 
    // NSHomeDirectory() instead gives the app's directory in 
    // ~/Library/Application Support/iPhone Simulator/User/Applications/
    // which is not what we want.
    return [[NSString stringWithFormat:@"/Users/%@/Desktop", NSUserName()] stringByExpandingTildeInPath];
#else
    return TTPathForDocumentsResource(@".");
#endif
}

#pragma mark -

- (void)dealloc
{
	[navigationController release];
	[window release];
    [renderService release];
	[super dealloc];
}


@end


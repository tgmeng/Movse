//
//  AppDelegate.m
//  MovseHelper
//
//  Created by tgmeng on 2018/4/23.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    appPath = [appPath stringByReplacingOccurrencesOfString: @"/Contents/Library/LoginItems/MovseHelper.app" withString:@""];
    appPath = [appPath stringByAppendingPathComponent:@"Contents/MacOS/Movse"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:appPath]) {
        [NSApp terminate:nil];
        return;
    }
    
    NSArray *runningArray = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.lazyfabric.Movse"];
    
    if ([runningArray count] > 0) {
        [NSApp terminate:nil];
        return;
    }
    [[NSWorkspace sharedWorkspace] launchApplication:appPath];
    
    [NSApp terminate:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end

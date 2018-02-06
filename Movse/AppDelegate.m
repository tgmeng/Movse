//
//  AppDelegate.m
//  Movse
//
//  Created by tgmeng on 2017/12/26.
//  Copyright © 2017年 lazyfabric. All rights reserved.
//

#import "AppDelegate.h"
#import "StatusBarController.h"
#import "PreferenceController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property StatusBarController *statusBarController;
@property PreferenceController *preferenceController;

@end

@implementation AppDelegate

+ (void)initialize {
    // Register default values
    NSMutableDictionary *defaultValue = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaultValue setObject:[NSNumber numberWithBool:YES] forKey:MVSIsLoop];
    
     [defaults registerDefaults:defaultValue];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
#ifdef DEBUG
    [self openPreferences:self];
#endif
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (void)openPreferences:(id)sender {
    if (!_preferenceController) {
        _preferenceController = [[PreferenceController alloc] init];
    }
    
    [NSApp activateIgnoringOtherApps:YES];
    [_preferenceController showWindow:self];;
}

@end

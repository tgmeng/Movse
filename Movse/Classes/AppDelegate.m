//
//  AppDelegate.m
//  Movse
//
//  Created by tgmeng on 2017/12/26.
//  Copyright © 2017年 lazyfabric. All rights reserved.
//

#import <MASShortcut/Shortcut.h>
#import "AppDelegate.h"
#import "StatusBarController.h"
#import "PreferenceController.h"
#import "MVSCenter.h"

@interface AppDelegate ()

@property StatusBarController *statusBarController;
@property PreferenceController *preferenceController;

@end

@implementation AppDelegate

+ (void)initialize {
    // Register default values
    NSMutableDictionary *defaultValue = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaultValue setObject:[NSNumber numberWithBool:YES] forKey:MVSLoop];
    
    [defaults registerDefaults:defaultValue];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // Init center
    [MVSCenter sharedCenter];
    
#ifdef DEBUG
    [self openPreferences:self];
#endif
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)openPreferences:(id)sender {
    if (!self.preferenceController) {
        self.preferenceController = [[PreferenceController alloc] init];
    }
    
    [NSApp activateIgnoringOtherApps:YES];
    [self.preferenceController showWindow:self];
}

@end

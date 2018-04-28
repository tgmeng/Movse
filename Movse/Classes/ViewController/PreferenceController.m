
//  PreferencesController.m
//  Movse
//
//  Created by tgmeng on 2018/1/31.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import <ServiceManagement/ServiceManagement.h>
#import "PreferenceController.h"
#import "MVSDisplayState.h"
#import "MVSMouseManager.h"

NSString *const MVSCustomPreviousShortcutKey = @"customPreviousShortcut";
NSString *const MVSCustomNextShortcut = @"customNextShortcut";
NSString *const MVSLoop = @"loop";
NSString *const MVSLaunchAtLogin = @"launchAtLogin";
NSString *const MVSHelperBundleIdentifier = @"com.lazyfabric.MovseHelper";

@implementation PreferenceController

- (id)init {
    self = [super initWithWindowNibName:@"Preferences"];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onDisplayStateChanged:)
                                                     name:MVSDisplayStateChangedNotification
                                                   object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.previousShortcutView setAssociatedUserDefaultsKey:MVSCustomPreviousShortcutKey];
    [self.nextShortcutView setAssociatedUserDefaultsKey:MVSCustomNextShortcut];
    
    self.launchAtLogin.state = [PreferenceController isLaunchAtLogin];
    
    self.displayArrangementView.delegate = self;
    [self updateDisplayArragementView];
}

#pragma mark Accesors

+ (BOOL)isPreferenceLoop {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:MVSLoop];
}

+ (void)setPreferenceLoop:(BOOL)loop {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults setBool:loop forKey:MVSLoop];
}

+ (BOOL)isLaunchAtLogin {
    // SMJobCopyDictionary is not useful
    NSArray *jobs = (__bridge_transfer NSArray *)(SMCopyAllJobDictionaries(kSMDomainUserLaunchd));
    BOOL value = NO;
    
    if ([jobs count] > 0) {
        for (NSDictionary *job in jobs) {
            if ([MVSHelperBundleIdentifier isEqualToString:[job objectForKey:@"Label"]]) {
                value = [[job objectForKey:@"OnDemand"] boolValue];
                break;
            }
        }
    }
    
    return value;
}

+ (void)setLaunchAtLogin:(BOOL)state {
    [self setLaunchAtLogin:state failureBlock:nil];
}

+ (void)setLaunchAtLogin:(BOOL)state failureBlock:(void (^)(void))block {
    BOOL res = SMLoginItemSetEnabled ((__bridge CFStringRef)MVSHelperBundleIdentifier, state);
    if (!res) {
        block();
    }
}

- (IBAction)toggleLaunchAtLogin:(id)sender {
    BOOL state = (BOOL)[sender state];
    [PreferenceController setLaunchAtLogin:state failureBlock:^{
        NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"ErrorOccurred", @"An error occurred")
                                         defaultButton:nil
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat: @"%@", (state ?
                                                                NSLocalizedString(@"ErrorOccurredWhenLaunchAtLoginChecked",
                                                                                  @"An error occurred when \"LaunchAtLogin\" is checked") :
                                                                NSLocalizedString(@"ErrorOccurredWhenLaunchAtLoginUnchecked",
                                                                                  @"An error occurred when \"LaunchAtLogin\" is unchecked"))];
        [alert beginSheetModalForWindow:self.window
                          modalDelegate:nil
                         didEndSelector:nil
                            contextInfo:nil];
    }];
}

- (void)updateDisplayArragementView {
    MVSDisplayState *state = [MVSDisplayState sharedState];
    self.displayArrangementView.displays = state.displays;
    self.displayArrangementView.needsDisplay = YES;
}

- (void)onDisplayStateChanged:(NSNotification *)notification {
    [self updateDisplayArragementView];
}

- (void)displayArragementView:(DisplayArrangementView *)view didClickDisplay:(NSUInteger)index withEvent:(NSEvent *)event {
    // Old position
    NSPoint offset = [event locationInWindow];
    
    MVSMouseManager *manager = [MVSMouseManager sharedManager];
    [manager moveCursorWithIndex:index];
    [manager showMouseCatcher];
    
    // New position
    NSPoint p = [NSEvent mouseLocation];
    [self.window setFrameOrigin:NSMakePoint(p.x - offset.x,
                                            p.y - offset.y)];
}

@end

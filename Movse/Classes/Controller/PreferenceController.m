
//  PreferencesController.m
//  Movse
//
//  Created by tgmeng on 2018/1/31.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import "PreferenceController.h"
#import "MVSDisplayState.h"

NSString *const MVSCustomPreviousShortcutKey = @"customPreviousShortcut";
NSString *const MVSCustomNextShortcut = @"customNextShortcut";
NSString *const MVSIsLoop = @"isLoop";

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
    
    [self updateDisplayArragementView];
}

#pragma mark Accesors

+ (BOOL)isPreferenceLoop {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:MVSIsLoop];
}

+ (void)setPreferenceLoop:(BOOL)isLoop {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults setBool:isLoop forKey:MVSIsLoop];
}

- (void)updateDisplayArragementView {
    MVSDisplayState *state = [MVSDisplayState sharedState];
    self.displayArrangementView.displays = state.displays;
    self.displayArrangementView.needsDisplay = YES;
}

- (void)onDisplayStateChanged:(NSNotification *)notification {
    [self updateDisplayArragementView];
}

@end

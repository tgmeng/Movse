
//  PreferencesController.m
//  Movse
//
//  Created by tgmeng on 2018/1/31.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import "PreferenceController.h"
#import "MVSDisplayState.h"
#import "MVSCenter.h"

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
    
    self.displayArrangementView.delegate = self;
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

- (void)displayArragementView:(DisplayArrangementView *)view didClickDisplay:(NSUInteger)index withEvent:(NSEvent *)event {
    // Old position
    NSPoint offset = [event locationInWindow];
    
    MVSCenter *center = [MVSCenter sharedCenter];
    [center moveCursorWithIndex:index];
    [center showMouseCatcher];
    
    // New position
    NSPoint p = [NSEvent mouseLocation];
    [self.window setFrameOrigin:NSMakePoint(p.x - offset.x,
                                            p.y - offset.y)];
}

@end

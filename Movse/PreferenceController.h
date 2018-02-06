//
//  PreferencesController.h
//  Movse
//
//  Created by tgmeng on 2018/1/31.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <MASShortcut/Shortcut.h>
#import "DisplayArrangementView.h"

static uint32_t const MAX_DISPLAYS = 50;

extern NSString *const MVSCustomPreviousShortcutKey;
extern NSString *const MVSCustomNextShortcut;
extern NSString *const MVSIsLoop;

@interface PreferenceController : NSWindowController {
    CGDirectDisplayID _displays[MAX_DISPLAYS];
    uint32_t _displayCount;
    
    NSMutableDictionary<NSNumber *, NSValue *> *_mousePos;
}

@property (nonatomic, weak) IBOutlet MASShortcutView *previousShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *nextShortcutView;
@property (weak) IBOutlet DisplayArrangementView *displayArrangementView;

- (void)updateDisplays;
- (void)updateDisplayArragementView;

@end

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
#import "Constants.h"

extern NSString *const MVSCustomPreviousShortcutKey;
extern NSString *const MVSCustomNextShortcut;
extern NSString *const MVSIsLoop;

@interface PreferenceController : NSWindowController

@property (nonatomic, weak) IBOutlet MASShortcutView *previousShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *nextShortcutView;
@property (weak) IBOutlet DisplayArrangementView *displayArrangementView;

- (void)updateDisplayArragementView;

+ (BOOL)isPreferenceLoop;
+ (void)setPreferenceLoop:(BOOL)isLoop;

@end

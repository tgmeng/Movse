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
extern NSString *const MVSLoop;
extern NSString *const MVSLaunchAtLogin;
extern NSString *const MVSHelperBundleIdentifier;

@interface PreferenceController : NSWindowController <DisplayArragementViewDelegate>

@property (nonatomic, weak) IBOutlet MASShortcutView *previousShortcutView;
@property (nonatomic, weak) IBOutlet MASShortcutView *nextShortcutView;
@property (weak) IBOutlet DisplayArrangementView *displayArrangementView;
@property (weak) IBOutlet NSButton *launchAtLogin;

- (void)updateDisplayArragementView;

+ (BOOL)isPreferenceLoop;
+ (void)setPreferenceLoop:(BOOL)loop;

+ (BOOL)isLaunchAtLogin;
+ (void)setLaunchAtLogin:(BOOL)state;
+ (void)setLaunchAtLogin:(BOOL)state failureBlock:(void (^)(void))block;


- (IBAction)toggleLaunchAtLogin:(id)sender;

@end

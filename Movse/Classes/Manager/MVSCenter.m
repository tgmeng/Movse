//
//  MVSCenter.m
//  Movse
//
//  Created by tgmeng on 2018/3/21.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import "MVSCenter.h"
#import "MVSDisplayState.h"
#import "PreferenceController.h"
#import "MVSDrawingWindow.h"
#import "MVSMouseCatcherView.h"

@interface MVSCenter ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSValue *> *mousePositonBuffer;
@property (nonatomic, strong) MVSDrawingWindow *mouseCatcher;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MVSCenter

+ (instancetype)sharedCenter {
    static dispatch_once_t once;
    static id sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [[super alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onDisplayStateChanged:)
                                                     name:MVSDisplayStateChangedNotification
                                                   object:nil];
        
        self.mousePositonBuffer = [NSMutableDictionary dictionary];
        
        [self settingMASShortcut];
        [self settingMouserCatcher];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MVSDisplayStateChangedNotification
                                                  object:nil];
}

- (void)showMouseCatcher {
    MVSDrawingWindow *win = self.mouseCatcher;
    if (nil == win) {
        return;
    }
    NSPoint mouseLoc = [NSEvent mouseLocation];
    
    NSSize size = [win frame].size;
    mouseLoc.x -= size.width / 2;
    mouseLoc.y -= size.height / 2;
    
    [win setFrameOrigin:mouseLoc];
    [win makeKeyAndOrderFront:self];
    
    NSTimeInterval time = 0.3;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(hideMouseCatcher)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)hideMouseCatcher {
    [self.mouseCatcher orderOut:self];
}

- (void)settingMouserCatcher {
    MVSDrawingWindow *win = self.mouseCatcher = [[MVSDrawingWindow alloc] initWithContentRect:NSZeroRect];
    MVSMouseCatcherView * v = [[MVSMouseCatcherView alloc] init];
    NSRect rect = [win frame];
    rect.size = v.image.size;
    [win setFrame:rect display:NO];
    win.contentView = v;
}

- (void)settingMASShortcut {
    MASShortcutValidator *sharedValidator = [MASShortcutValidator sharedValidator];
    MASShortcutBinder *sharedBinder = MASShortcutBinder.sharedBinder;
    
    // Allow any shortcut with option modifier
    sharedValidator.allowAnyShortcutWithOptionModifier = true;
    
    [sharedBinder bindShortcutWithDefaultsKey:MVSCustomPreviousShortcutKey toAction:^{
        [self moveCursorToSiblingScreen:YES];
        [self showMouseCatcher];
    }];
    
    [sharedBinder bindShortcutWithDefaultsKey:MVSCustomNextShortcut toAction:^{
        [self moveCursorToSiblingScreen:FALSE];
        [self showMouseCatcher];
    }];
}

/**
 @abstract Find the CGDirectDisplayID where the mouse at.
 */
- (CGDirectDisplayID)CGDirectDisplayIDWhereTheMouseAt {
    NSPoint mouseLoc = [NSEvent mouseLocation];
    CGRect mainDispRect = CGDisplayBounds(CGMainDisplayID());
    // Convert to global display coordinates
    mouseLoc.y = -mouseLoc.y + mainDispRect.size.height;
    
    return [self CGDirectDisplayIDAtPoint:mouseLoc];
}

/**
  @abstract Find the CGDirectDisplayID at a point in global display coordinate space.
  */
- (CGDirectDisplayID)CGDirectDisplayIDAtPoint:(NSPoint)point {
    u_int32_t count = 0;
    CGDirectDisplayID tDisplays[MAX_DISPLAYS];
    CGGetDisplaysWithPoint(NSPointToCGPoint(point), MAX_DISPLAYS, tDisplays, &count);
    
    // Find the display where the mouse at
    CGDirectDisplayID curDisplayID = 0;
    u_int32_t i = 0;
    while (i < count && !CGDisplayIsActive(tDisplays[i])) {
        i++;
    }
    curDisplayID = tDisplays[i];
    
    return curDisplayID;
}

- (void)moveCursorWithIndex:(NSUInteger)index {
    NSPoint mouseLoc = [NSEvent mouseLocation];
    CGRect mainDispRect = CGDisplayBounds(CGMainDisplayID());
    
    // Convert to global display coordinates
    mouseLoc.y = -mouseLoc.y + mainDispRect.size.height;
    
    MVSDisplayState *state = [MVSDisplayState sharedState];
    NSArray *displays = [state displays];
    NSUInteger displayCount = displays.count;
    
    CGDirectDisplayID curDisplayID = [self CGDirectDisplayIDAtPoint:mouseLoc];
    
    if (![PreferenceController isPreferenceLoop] && index >= displayCount) {
        return;
    }
    
    index = index % displayCount;
    CGDirectDisplayID nextDisplayID = [displays[index] unsignedIntValue];
    
    if (curDisplayID == nextDisplayID) {
        return;
    }
    
    NSValue *lastValue = [self.mousePositonBuffer objectForKey:[NSNumber numberWithUnsignedInteger:nextDisplayID]];
    CGPoint siblingPoint = CGPointZero;
    
    // Get last pos
    if (lastValue) {
        [lastValue getValue:&siblingPoint];
    } else {
        // Default: center of the display
        CGRect rect = CGDisplayBounds(nextDisplayID);
        siblingPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    }
    
    // Save pos
    CGPoint point = NSPointToCGPoint(mouseLoc);
    [self.mousePositonBuffer setObject:[NSValue valueWithBytes:&point
                                                      objCType:@encode(CGPoint)]
                                forKey:[NSNumber numberWithUnsignedInteger:curDisplayID]];
    
    // Move mouse
    CGWarpMouseCursorPosition(siblingPoint);
}

- (void)moveCursorToSiblingScreen:(BOOL)isPrevious {
    MVSDisplayState *state = [MVSDisplayState sharedState];
    NSArray *displays = [state displays];
    NSUInteger displayCount = displays.count;
    
    CGDirectDisplayID curDisplayID = [self CGDirectDisplayIDWhereTheMouseAt];
    
    u_int32_t i = 0;
    while (i < displayCount && curDisplayID != [displays[i] unsignedIntValue]) {
        i++;
    }
    u_int32_t siblingIndex = (i + (isPrevious ? -1 : 1) * 1);
    
    [self moveCursorWithIndex:siblingIndex];
}

- (void)onDisplayStateChanged:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGDisplayChangeSummaryFlags flags = [[userInfo objectForKey:@"CGDisplayChangeSummaryFlags"] unsignedIntValue];
    
    if (!(flags & (kCGDisplayAddFlag | kCGDisplayRemoveFlag
                   | kCGDisplayEnabledFlag | kCGDisplayDisabledFlag))) {
        return;
    }
    
    MVSDisplayState *state = [MVSDisplayState sharedState];
    NSArray *displays = [state displays];
    NSUInteger displayCount = displays.count;
    
    // Update mouse pos
    NSMutableDictionary<NSNumber *, NSValue *> *neoMousePosBuf = [NSMutableDictionary dictionary];
    
    for (uint32_t i = 0; i < displayCount; i++) {
        CGDirectDisplayID display = [displays[i] unsignedIntValue];
        NSNumber *nDisplayID = [NSNumber numberWithUnsignedInteger:display];
        NSValue *lastValue = [self.mousePositonBuffer objectForKey:nDisplayID];
        if (lastValue) {
            [neoMousePosBuf setObject:lastValue
                            forKey:[NSNumber numberWithUnsignedInteger:display]];
        }
    }
    
    self.mousePositonBuffer = neoMousePosBuf;
}

@end

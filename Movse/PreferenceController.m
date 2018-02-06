
//  PreferencesController.m
//  Movse
//
//  Created by tgmeng on 2018/1/31.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import "PreferenceController.h"

NSString *const MVSCustomPreviousShortcutKey = @"customPreviousShortcut";
NSString *const MVSCustomNextShortcut = @"customNextShortcut";
NSString *const MVSIsLoop = @"isLoop";

static void *MASObservingContext = &MASObservingContext;

void DisplayReconfigurationCallBack (CGDirectDisplayID display,
                                     CGDisplayChangeSummaryFlags flags,
                                     void *userInfo) {
    PreferenceController *obj = (__bridge PreferenceController *)(userInfo);
    if (flags & kCGDisplayAddFlag || flags & kCGDisplayRemoveFlag) {
        // display has been added or removed
        [obj updateDisplays];
    } else if (!(flags & kCGDisplayBeginConfigurationFlag)) {
        [obj updateDisplayArragementView];
    }
}

@implementation PreferenceController

- (id)init {
    self = [super initWithWindowNibName:@"Preferences"];
    if (self) {
        CGDisplayRegisterReconfigurationCallback(DisplayReconfigurationCallBack, (__bridge void * _Nullable)(self));
        _mousePos = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    CGDisplayRemoveReconfigurationCallback(DisplayReconfigurationCallBack, (__bridge void * _Nullable)(self));
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_previousShortcutView setAssociatedUserDefaultsKey:MVSCustomPreviousShortcutKey];
    [_nextShortcutView setAssociatedUserDefaultsKey:MVSCustomNextShortcut];
    
    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:MVSCustomPreviousShortcutKey toAction:^{
        [self moveCursorSiblingScreen:YES];
    }];
    
    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:MVSCustomNextShortcut toAction:^{
        [self moveCursorSiblingScreen:FALSE];
    }];
    
    [self updateDisplays];
}

- (void)moveCursorSiblingScreen:(BOOL)isPrevious {
    NSPoint mouseLoc = [NSEvent mouseLocation];
    NSScreen *mainScreen = [NSScreen mainScreen];
    
    u_int32_t count = 0;
    CGDirectDisplayID _tDisplays[MAX_DISPLAYS];
    CGGetDisplaysWithPoint(NSPointToCGPoint(mouseLoc), MAX_DISPLAYS, _tDisplays, &count);
    
    // Find the display where the mouse at
    CGDirectDisplayID curDisplayID = 0;
    u_int32_t i = 0;
    while (i < count && !CGDisplayIsActive(_tDisplays[i])) {
        i++;
    }
    curDisplayID = _tDisplays[i];
    
    // Get sibling display according to "isPrevious"
    CGDirectDisplayID siblingDisplayID = 0;
    while (i < _displayCount && curDisplayID != _displays[i]) {
        i++;
    }
    u_int32_t siblingIndex = (i + (isPrevious ? -1 : 1) * 1);

    if (![PreferenceController preferenceLoop] && siblingIndex >= _displayCount) {
        return;
    }
    
    siblingIndex = siblingIndex % _displayCount;
    siblingDisplayID = _displays[siblingIndex];
    
    NSValue *lastValue = [_mousePos objectForKey:[NSNumber numberWithUnsignedInteger:siblingDisplayID]];
    CGPoint siblingPoint = CGPointZero;
    
    // Get last pos
    if (lastValue) {
        [lastValue getValue:&siblingPoint];
    } else {
        CGRect rect = CGDisplayBounds(siblingDisplayID);
        siblingPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    }
    
    // Save pos
    // convert to global display coordinate
    NSRect frame = [mainScreen frame];
    mouseLoc.y = NSMaxY(frame) - mouseLoc.y;
    CGPoint point = NSPointToCGPoint(mouseLoc);
    [_mousePos setObject:[NSValue valueWithBytes:&point
                                        objCType:@encode(CGPoint)]
                  forKey:[NSNumber numberWithUnsignedInteger:curDisplayID]];
    
    // Move mouse
    CGWarpMouseCursorPosition(siblingPoint);
}

- (void)updateDisplayArragementView {
    [_displayArrangementView setNeedsDisplay:YES];
}

- (void)updateDisplays {
    uint32_t displayCount = 0;
    
    CGGetActiveDisplayList(MAX_DISPLAYS, _displays, &displayCount);
    
    NSMutableDictionary<NSNumber *, NSValue *> *neoMousePos = [NSMutableDictionary dictionary];
    
    for (uint32_t i = 0; i < displayCount; i++) {
        CGDirectDisplayID display = _displays[i];
        NSNumber *nDisplayID = [NSNumber numberWithUnsignedInteger:display];
        
        NSValue *lastValue = [_mousePos objectForKey:nDisplayID];
        if (lastValue) {
            [neoMousePos setObject:lastValue
                          forKey:[NSNumber numberWithUnsignedInteger:display]];
        }
        
#ifdef DEBUG
        [self logDisplayInfo:display];
#endif
    }
    
    _displayCount = displayCount;
    _mousePos = neoMousePos;
    [_displayArrangementView setDisplays:_displays andCount:displayCount];
}

- (void)logDisplayInfo:(CGDirectDisplayID)display {
    uint32_t vn = CGDisplayVendorNumber(display);
    uint32_t mn = CGDisplayModelNumber(display);
    uint32_t sn = CGDisplaySerialNumber(display);
    
    NSString *monitorUnique = [NSString stringWithFormat:@"%d-%d-%d", vn, mn, sn];
    
    NSLog(@"%d: %@", display, monitorUnique);
    
    CGDisplayModeRef mode = CGDisplayCopyDisplayMode(display);
    
    long h = 0, w = 0;
    h = CGDisplayModeGetHeight(mode);
    w = CGDisplayModeGetWidth(mode);
    
    NSLog(@"w, h: %ld, %ld", w, h);
    NSLog(@"================");
}

#pragma mark Accesors

+ (BOOL)preferenceLoop {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:MVSIsLoop];
}

+ (void)setPreferenceLoop:(BOOL)isLoop {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults setBool:isLoop forKey:MVSIsLoop];
}

@end

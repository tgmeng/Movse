//
//  MVSDisplayState.m
//  Movse
//
//  Created by tgmeng on 2018/2/24.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import "MVSDisplayState.h"

NSString * const MVSDisplayStateChangedNotification = @"MVSDisplayStateChanged";

static void *MASObservingContext = &MASObservingContext;

void DisplayReconfigurationCallBack (CGDirectDisplayID display,
                                     CGDisplayChangeSummaryFlags flags,
                                     void *userInfo) {
    MVSDisplayState *obj = (__bridge MVSDisplayState *)(userInfo);
    if (flags & (kCGDisplayAddFlag | kCGDisplayRemoveFlag
                 | kCGDisplayEnabledFlag | kCGDisplayDisabledFlag)) {
        // display has been added or removed or enabled or disabled
        [obj updateDisplayState];
    }
    
    if (!(flags & kCGDisplayBeginConfigurationFlag)) {
        // Notify
        [obj notifyDisplayStateUpdated:flags];
    }
}

@interface MVSDisplayState ()

@property (nonatomic, strong) NSArray *displays;

@end

@implementation MVSDisplayState

+ (instancetype)sharedState {
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
        CGDisplayRegisterReconfigurationCallback(DisplayReconfigurationCallBack,
                                                 (__bridge void * _Nullable)(self));
        [self updateDisplayState];
    }
    return self;
}

- (void)dealloc {
    CGDisplayRemoveReconfigurationCallback(DisplayReconfigurationCallBack,
                                           (__bridge void * _Nullable)(self));
}

- (void)updateDisplayState {
    uint32_t displayCount = 0;
    CGDirectDisplayID displays[MAX_DISPLAYS];
    
    CGGetActiveDisplayList(MAX_DISPLAYS, displays, &displayCount);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:displayCount];
    for (uint32_t i = 0; i < displayCount; i++) {
        [array addObject:@(displays[i])];
    }
    
    self.displays = [NSArray arrayWithArray:array];
}

- (void)notifyDisplayStateUpdated:(CGDisplayChangeSummaryFlags)flags {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:MVSDisplayStateChangedNotification
                      object:self
                    userInfo:@{ @"CGDisplayChangeSummaryFlags": @(flags) }];
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

@end

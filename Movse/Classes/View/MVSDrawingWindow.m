//
//  MVSDrawingWindow.m
//  Movse
//
//  Created by tgmeng on 2018/3/21.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import "MVSDrawingWindow.h"

@implementation MVSDrawingWindow

- (instancetype)initWithContentRect:(NSRect)contentRect {
    self = [self initWithContentRect:contentRect
                           styleMask:NSBorderlessWindowMask
                             backing:NSBackingStoreBuffered
                               defer:YES];
    return self;
}

- (instancetype)initWithContentRect:(NSRect)contentRect
                          styleMask:(NSWindowStyleMask)style
                            backing:(NSBackingStoreType)backingStoreType
                              defer:(BOOL)flag {
    
    self = [super initWithContentRect:contentRect
                            styleMask:style
                              backing:backingStoreType
                                defer:flag];
    if (self) {
        self.delegate = self;
        
        // Configure the window
        self.title = @"KBDrawingWindow";
        self.releasedWhenClosed = NO;
        self.backgroundColor = [NSColor clearColor];
        self.opaque = NO;
        self.hasShadow = NO;
        self.ignoresMouseEvents = YES;
        self.restorable = NO;
        self.hidesOnDeactivate  = NO;
        self.animationBehavior = NSWindowAnimationBehaviorNone;
        self.level = NSScreenSaverWindowLevel;
    }
    
    return self;
}

@end

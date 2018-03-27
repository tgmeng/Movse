//
//  StatusBarController.m
//  Movse
//
//  Created by tgmeng on 2018/1/31.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusBarController.h"

@implementation StatusBarController

- (id)init {
    self = [super init];
    if (self) {
        NSStatusBar *bar = [NSStatusBar systemStatusBar];
        
        self.statusItem = [bar statusItemWithLength:NSSquareStatusItemLength];
        
        NSImage *icon = [NSImage imageNamed:kStatusBarIcon];
        icon.template = YES;
        self.statusItem.image = icon;
        
        self.statusItem.highlightMode = YES;
    }
    return self;
}

- (void)awakeFromNib {
    self.statusItem.menu = _menu;
}

@end

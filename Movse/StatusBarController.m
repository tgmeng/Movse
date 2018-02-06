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
        
        _statusItem = [bar statusItemWithLength:NSSquareStatusItemLength];
        
        [_statusItem setImage: [NSImage imageNamed:@"StatusBarButtonImage"]];
        [_statusItem setHighlightMode:YES];
    }
    return self;
}

- (void)awakeFromNib {
    [_statusItem setMenu:_menu];
}

@end

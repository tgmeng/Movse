//
//  MVSMouseCatcherView.m
//  Movse
//
//  Created by tgmeng on 2018/3/21.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import "MVSMouseCatcherView.h"
#import "NSView+DrawString.h"

@interface MVSMouseCatcherView ()

@property (nonatomic, strong) NSImage *image;

@end

@implementation MVSMouseCatcherView

- (instancetype)init {
    self = [self initWithFrame:NSZeroRect];
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        self.image = [NSImage imageNamed:kMouseCatcherImage];
        [self setFrameSize:self.image.size];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect imageRect;
    imageRect.origin = NSZeroPoint;
    imageRect.size = [self.image size];
    NSRect drawingRect = imageRect;
    [self.image drawInRect:drawingRect
                  fromRect:imageRect
                 operation:NSCompositeSourceOver
                  fraction:1.0];
}

@end

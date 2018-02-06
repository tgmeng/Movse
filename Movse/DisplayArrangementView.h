//
//  DisplayArrangementView.h
//  Movse
//
//  Created by tgmeng on 2018/2/2.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DisplayArrangementView : NSView {
    CGDirectDisplayID *_displays;
    uint32_t _displayCount;
    NSMutableDictionary<NSAttributedStringKey, id> *_attributes;
}

- (CGDirectDisplayID *)displays;

- (void)setDisplays:(CGDirectDisplayID *)displays andCount:(uint32_t)number;
@end

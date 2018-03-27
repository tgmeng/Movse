//
//  MVSDrawingWindow.h
//  Movse
//
//  Created by tgmeng on 2018/3/21.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MVSDrawingWindow : NSPanel <NSWindowDelegate>

- (instancetype)initWithContentRect:(NSRect)contentRect;
    
@end

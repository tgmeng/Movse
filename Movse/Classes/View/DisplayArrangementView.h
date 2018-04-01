//
//  DisplayArrangementView.h
//  Movse
//
//  Created by tgmeng on 2018/2/2.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DisplayArrangementView;

@protocol DisplayArragementViewDelegate <NSObject>

- (void)displayArragementView:(DisplayArrangementView *)view didClickDisplay:(NSUInteger)index withEvent:(NSEvent *)event;

@end

@interface DisplayArrangementView : NSView

@property (nonatomic, weak) id<DisplayArragementViewDelegate> delegate;
@property (nonatomic, strong) NSArray *displays;

@end

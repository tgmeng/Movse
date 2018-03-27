//
//  MVSDisplayState.h
//  Movse
//
//  Created by tgmeng on 2018/2/24.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MVSDisplayStateChangedNotification;

@interface MVSDisplayState : NSObject

@property (nonatomic, strong, readonly) NSArray *displays;

+ (instancetype)sharedState;

- (void)updateDisplayState;
- (void)notifyDisplayStateUpdated:(CGDisplayChangeSummaryFlags)flags;

@end

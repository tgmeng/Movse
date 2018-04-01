//
//  MVSCenter.h
//  Movse
//
//  Created by tgmeng on 2018/3/21.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVSCenter : NSObject

+ (instancetype)sharedCenter;

- (void)moveCursorWithIndex:(NSUInteger)index;
- (void)showMouseCatcher;
    
@end

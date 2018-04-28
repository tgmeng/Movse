//
//  StatusBarController.h
//  Movse
//
//  Created by tgmeng on 2018/1/31.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusBarController : NSObject

@property NSStatusItem *statusItem;
@property (weak) IBOutlet NSMenu *menu;

@end

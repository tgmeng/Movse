//
//  NSView+DrawString.h
//  Movse
//
//  Created by tgmeng on 2018/3/21.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (DrawString)

- (void)drawString:(NSString *)str
    WithAttributes:(NSDictionary<NSAttributedStringKey, id> *)attr
        CenteredIn:(CGRect)r;
    
@end

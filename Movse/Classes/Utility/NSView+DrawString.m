//
//  NSView+DrawString.m
//  Movse
//
//  Created by tgmeng on 2018/3/21.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import "NSView+DrawString.h"

@implementation NSView (DrawString)

- (void)drawString:(NSString *)str
    WithAttributes:(NSDictionary<NSAttributedStringKey, id> *)attr
        CenteredIn:(CGRect)r {
    CGSize strSize = [str sizeWithAttributes:attr];
    
    CGPoint strOrigin;
    strOrigin = CGPointMake(r.origin.x + (r.size.width - strSize.width) / 2,
                            r.origin.y + (r.size.height - strSize.height) / 2);
    
    [str drawAtPoint:strOrigin withAttributes:attr];
}

@end

//
//  DisplayArrangementView.m
//  Movse
//
//  Created by tgmeng on 2018/2/2.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import "DisplayArrangementView.h"

@implementation DisplayArrangementView

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self prepareAttributes];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self prepareAttributes];
    }
    return self;
}

-(BOOL)isFlipped {
    return YES;
}

-(void)prepareAttributes {
    _attributes = [NSMutableDictionary dictionary];
    [_attributes setObject:[NSFont userFontOfSize:32] forKey:NSFontAttributeName];
    [_attributes setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
}

#pragma mark Drawing
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
    // Draw Background
    NSRect bounds = [self bounds];
    [[NSColor blueColor] set];
    [NSBezierPath fillRect:bounds];
    
    if (!_displays) {
        return;
    }
    
    if (_displayCount == 0) {
        return;
    }
    
    CGSize maxSize = {0, 0};
    CGRect rects[_displayCount];
    CGRect joinedRect = CGRectZero;
    
    // Prepare data for calculating scale, size and position
    for (uint32_t i = 0; i < _displayCount; i++) {
        CGDirectDisplayID display = _displays[i];
        CGRect rect = CGDisplayBounds(display);
        CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;
        
        if (maxSize.width < width) {
            maxSize.width = width;
        }
        
        if (maxSize.height < height) {
            maxSize.height = height;
        }
        
        joinedRect = [self makeWrapRectWith:rect and:joinedRect];
        
        rects[i] = rect;
    }
    
    // Calculate scale ratio
    CGSize maxScaledSize = CGSizeMake(bounds.size.width * 0.2, bounds.size.height * 0.2);
    double scaleRatio = maxScaledSize.width / maxSize.width;
    
    if (scaleRatio * maxSize.height > bounds.size.height) {
        scaleRatio = maxScaledSize.height / maxSize.height;
    }
    
    CGRect wrapRect = CGRectMake(joinedRect.origin.x * scaleRatio,
               joinedRect.origin.y * scaleRatio,
               joinedRect.size.width * scaleRatio,
               joinedRect.size.height * scaleRatio);
    
    CGFloat offsetX = (bounds.size.width - wrapRect.size.width) / 2;
    CGFloat offsetY = (bounds.size.height - wrapRect.size.height) / 2;
    
#ifdef DEBUG
    // Draw wrap rect
    wrapRect = CGRectOffset(wrapRect, offsetX, offsetY);
    [[NSColor grayColor] set];
    [NSBezierPath fillRect:NSRectFromCGRect(wrapRect)];
#endif
    
    for (uint32_t i = 0; i < _displayCount; i++) {
        // Draw display rect
        [[NSColor whiteColor] set];
        CGRect rect = rects[i];
        NSRect drawingRect = NSMakeRect(rect.origin.x * scaleRatio,
                                        rect.origin.y * scaleRatio,
                                        rect.size.width * scaleRatio,
                                        rect.size.height * scaleRatio);
        drawingRect = CGRectOffset(drawingRect, offsetX, offsetY);
        [NSBezierPath fillRect:NSRectFromCGRect(drawingRect)];
        [self drawString:[NSString stringWithFormat:@"%d", i + 1]
              WithAttributes:_attributes
              CenteredIn:drawingRect];
    }
}

- (void)drawString:(NSString *)str
    WithAttributes:(NSDictionary<NSAttributedStringKey, id> *)attr
        CenteredIn:(CGRect)r {
    CGSize strSize = [str sizeWithAttributes:attr];
    
    CGPoint strOrigin;
    strOrigin = CGPointMake(r.origin.x + (r.size.width - strSize.width) / 2,
                           r.origin.y + (r.size.height - strSize.height) / 2);

    [str drawAtPoint:strOrigin withAttributes:attr];
}

- (CGRect)makeWrapRectWith:(CGRect)rectA and:(CGRect)rectB {
    CGFloat xl = MIN(CGRectGetMinX(rectA), CGRectGetMinX(rectB));
    CGFloat xr = MAX(CGRectGetMaxX(rectA), CGRectGetMaxX(rectB));
    
    CGFloat yt = MIN(CGRectGetMinY(rectA), CGRectGetMinY(rectB));
    CGFloat yb = MAX(CGRectGetMaxY(rectA), CGRectGetMaxY(rectB));
    
    return CGRectMake(xl, yt, xr - xl, yb - yt);
}

#pragma mark Accessors

- (CGDirectDisplayID *)displays {
    return _displays;
}

- (void)setDisplays:(CGDirectDisplayID *)displays andCount:(uint32_t)number{
    _displays = displays;
    _displayCount = number;
    [self setNeedsDisplay:YES];
}

@end

//
//  DisplayArrangementView.m
//  Movse
//
//  Created by tgmeng on 2018/2/2.
//  Copyright © 2018年 lazyfabric. All rights reserved.
//

#import "DisplayArrangementView.h"
#import "NSView+DrawString.h"

@interface DisplayArrangementView () {
    NSMutableDictionary<NSAttributedStringKey, id> *_attributes;
    NSArray *_rects;
}
@end

@implementation DisplayArrangementView

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self prepareAttributes];
        _rects = @[];
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
    
    NSArray *displays = self.displays;
    NSUInteger displayCount = displays.count;
    
    if (displayCount == 0) {
        return;
    }
    
    CGSize maxSize = {0, 0};
    CGRect rects[displayCount];
    CGRect joinedRect = CGRectZero;
    
    // Prepare data for calculating scale, size and position
    for (uint32_t i = 0; i < displayCount; i++) {
        CGDirectDisplayID display = [self.displays[i] unsignedIntValue];
        CGRect rect = CGDisplayBounds(display);
        CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;
        
        if (width > maxSize.width) {
            maxSize.width = width;
        }
        
        if (height > maxSize.height) {
            maxSize.height = height;
        }
        
        joinedRect = [self joinRect:rect and:joinedRect];
        
        rects[i] = rect;
    }
    
    // Calculate scale ratio
    CGSize maxScaledSize = CGSizeMake(bounds.size.width * 0.2, bounds.size.height * 0.2);
    double scaleRatio = maxScaledSize.width / maxSize.width;
    
    if (scaleRatio * maxSize.height > bounds.size.height) {
        // Still bigger than container
        scaleRatio = maxScaledSize.height / maxSize.height;
    }
    
    CGRect joinedScaledRect = CGRectMake(joinedRect.origin.x * scaleRatio,
               joinedRect.origin.y * scaleRatio,
               joinedRect.size.width * scaleRatio,
               joinedRect.size.height * scaleRatio);
    
    // Calc offset for centering display rect
    CGFloat offsetX = (bounds.size.width - joinedScaledRect.size.width) / 2;
    if (joinedScaledRect.origin.x < 0) {
        offsetX += fabs(joinedScaledRect.origin.x);
    }
    CGFloat offsetY = (bounds.size.height - joinedScaledRect.size.height) / 2;
    if (joinedScaledRect.origin.y < 0) {
        offsetY += fabs(joinedScaledRect.origin.y);
    }

#ifdef DEBUG
    // Draw wrap rect
    joinedScaledRect = CGRectOffset(joinedScaledRect, offsetX, offsetY);
    [[NSColor grayColor] set];
    [NSBezierPath fillRect:NSRectFromCGRect(joinedScaledRect)];
#endif
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:displayCount];
    for (uint32_t i = 0; i < displayCount; i++) {
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
        [array addObject:@(drawingRect)];
    }
    
    _rects = [NSArray arrayWithArray:array];
}

- (CGRect)joinRect:(CGRect)rectA and:(CGRect)rectB {
    CGFloat xl = MIN(CGRectGetMinX(rectA), CGRectGetMinX(rectB));
    CGFloat xr = MAX(CGRectGetMaxX(rectA), CGRectGetMaxX(rectB));
    
    CGFloat yt = MIN(CGRectGetMinY(rectA), CGRectGetMinY(rectB));
    CGFloat yb = MAX(CGRectGetMaxY(rectA), CGRectGetMaxY(rectB));
    
    return CGRectMake(xl, yt, xr - xl, yb - yt);
}

#pragma mark Accessors

@synthesize displays = _displays;

- (NSArray *)displays {
    return _displays;
}

- (void)setDisplays:(NSArray *)displays {
    _displays = displays;
    [self setNeedsDisplay:YES];
}

#pragma mark - Events
- (void)mouseDown:(NSEvent *)event {
    NSPoint p = [self convertPoint:[event locationInWindow] fromView:nil];
    
    for (NSValue *v in _rects) {
        NSRect rect = [v rectValue];
        if (NSPointInRect(p, rect)) {
            break;
        }
    }
}

@end

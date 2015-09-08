//
//  UIView+Additions.m
//  KFAmplifire
//
//  Created by Federico Lagarmilla on 10/04/14.
//
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (CGFloat)gl_left {
    return self.frame.origin.x;
}

- (void)setGl_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)gl_top {
    return self.frame.origin.y;
}

- (void)setGl_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)gl_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setGl_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)gl_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setGl_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)gl_width {
    return self.frame.size.width;
}

- (void)setGl_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)gl_height {
    return self.frame.size.height;
}

- (void)setGl_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGPoint)gl_origin {
    return self.frame.origin;
}

- (void)setGl_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)gl_size {
    return self.frame.size;
}

- (void)setGl_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


@end

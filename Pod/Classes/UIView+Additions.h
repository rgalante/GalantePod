//
//  UIView+Additions.h
//  KFAmplifire
//
//  Created by Federico Lagarmilla on 10/04/14.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat gl_left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat gl_top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat gl_right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat gl_bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat gl_width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat gl_height;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint gl_origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize gl_size;


@end

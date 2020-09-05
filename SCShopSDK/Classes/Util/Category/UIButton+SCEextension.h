//
//  UIButton+SCEextension.h
//  shopping
//
//  Created by zhangtao on 2020/7/7.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, XGButtonEdgeInsetsStyle) {
    XGButtonEdgeInsetsStyleTop, // image在上，label在下
    XGButtonEdgeInsetsStyleLeft, // image在左，label在右
    XGButtonEdgeInsetsStyleBottom, // image在下，label在上
    XGButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (SCEextension)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(XGButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

-(void)badgeNum:(NSInteger)num fontSize:(NSInteger)size bgColor:(UIColor *)color;


//block blockskit搬运
- (void)sc_addEventTouchUpInsideHandle:(void (^)(id sender))handler;

/** Adds a block for a particular event to an internal dispatch table.

@param handler A block representing an action message, with an argument for the sender.
@param controlEvents A bitmask specifying the control events for which the action message is sent.
@see removeEventHandlersForControlEvents:
*/
- (void)sc_addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

/** Removes all blocks for a particular event combination.
 @param controlEvents A bitmask specifying the control events for which the block will be removed.
 @see addEventHandler:forControlEvents:
 */
- (void)sc_removeEventHandlersForControlEvents:(UIControlEvents)controlEvents;

/** Checks to see if the control has any blocks for a particular event combination.
 @param controlEvents A bitmask specifying the control events for which to check for blocks.
 @see addEventHandler:forControlEvents:
 @return Returns YES if there are blocks for these control events, NO otherwise.
 */
- (BOOL)sc_hasEventHandlersForControlEvents:(UIControlEvents)controlEvents;


@end

NS_ASSUME_NONNULL_END

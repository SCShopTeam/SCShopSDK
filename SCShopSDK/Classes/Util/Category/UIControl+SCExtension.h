//
//  UIControl+SCExtension.h
//  shopping
//
//  Created by gejunyu on 2020/9/10.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (SCExtension)


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

//
//  MyButton.h
//  OnlineFinance
//
//  Created by FairyLand on 15/8/27.
//  Copyright (c) 2015年 jezz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLXOpenMyButtonDebugStyle 1

#ifdef kLXOpenMyButtonDebugStyle
//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
//#define LXNSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define LXNSLog(fmt, ...) NSLog((@"--->>" fmt), ##__VA_ARGS__);
#else
#define LXNSLog(...)
#endif

#define kDisabledAfterEvent 1.5f
//#define kDisabledAfterEvent .0f
@interface LXButton : UIButton
{
    
}
@property (nonatomic,retain)UIColor *disabledColor;

+ (instancetype)buttonWithType:(UIButtonType)buttonType;

- (void)addEvent:(void(^)(id sender))handle forControlEvents:(UIControlEvents)event;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (UIColor *)backgroundColorForState:(UIControlState)state;

@end

@interface UIButton (EventHandler)
{
    
}

#pragma mark - Handle Events
- (void)addEvent:(void(^)(id sender))handle forControlEvents:(UIControlEvents)event;

@end

@interface UIControl (BlocksKit)
{
    
}

- (void)LX_addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;
- (void)LX_removeEventHandlersForControlEvents:(UIControlEvents)controlEvents;
- (BOOL)LX_hasEventHandlersForControlEvents:(UIControlEvents)controlEvents;

@end

@interface UIImage (colorImage)
{
    
}

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

@end

//
//  CustomAlertView.h
//  BlurGlassTtest
//
//  Created by iyaya on 14-7-29.
//  Copyright (c) 2014年 iyaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXAlertButtonItem.h"
@class CustomAlertView;
typedef void(^CXAlertViewHandler)(CustomAlertView *alertView);
@interface CustomAlertView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIView *contentView;

@property (nonatomic, copy) CXAlertViewHandler willShowHandler;
@property (nonatomic, copy) CXAlertViewHandler didShowHandler;
@property (nonatomic, copy) CXAlertViewHandler willDismissHandler;
@property (nonatomic, copy) CXAlertViewHandler didDismissHandler;


@property (nonatomic, readonly, getter = isVisible) BOOL visible;

@property (nonatomic, strong) UIColor *titleColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;


@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, strong) UIColor *cancelButtonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *customButtonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;



- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;
- (id)initWithTitle:(NSString *)title contentView:(UIView *)contentView cancelButtonTitle:(NSString *)cancelButtonTitle;

- (void)addButtonWithTitle:(NSString *)title type:(CXAlertViewButtonType)type handler:(CXAlertButtonHandler)handler;

- (void)show;
- (void)dismiss;

@end

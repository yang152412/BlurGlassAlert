//
//  CustomAlertView.m
//  BlurGlassTtest
//
//  Created by iyaya on 14-7-29.
//  Copyright (c) 2014年 iyaya. All rights reserved.
//

#import "CustomAlertView.h"
#import "CXAlertButtonItem.h"
#import "CXAlertBackgroundWindow.h"

static CXAlertBackgroundWindow *__cx_alert_background_window;

static CGFloat const kDefaultScrollViewPadding = 10.;
static CGFloat const kDefaultButtonHeight = 44.;
static CGFloat const kDefaultContainerWidth = 280.;
static CGFloat const kDefaultVericalPadding = 10.;
static CGFloat const kDefaultContentScrollViewMaxHeight = 180.;
static CGFloat const kDefaultContentScrollViewMinHeight = 0.;
static CGFloat const kDefaultBottomScrollViewHeight = 44.;

@interface CustomAlertView ()

@property (nonatomic, assign) CGFloat buttonHeight;
@property (nonatomic, assign) CGFloat scrollViewPadding;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIWindow *alertWindow;

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat shadowRadius;

@property (nonatomic, strong) UIColor *viewBackgroundColor;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *buttonFont;
@property (nonatomic, strong) UIFont *cancelButtonFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default [UIFont boldSystemFontOfSize:18.]
@property (nonatomic, strong) UIFont *customButtonFont;

@property (nonatomic, strong) UIView *seperatorLine;

@end


@implementation CustomAlertView

- (void)dealloc
{
    self.alertWindow = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = [UIFont systemFontOfSize:14.0];
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.text = message;
    messageLabel.frame = CGRectMake( self.vericalPadding, 0, self.containerWidth - self.vericalPadding*2, [self heightWithText:message font:messageLabel.font]);
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
#else
    messageLabel.lineBreakMode = UILineBreakModeTailTruncation;
#endif
    
    return  [self initWithTitle:title contentView:messageLabel cancelButtonTitle:cancelButtonTitle];
}
- (id)initWithTitle:(NSString *)title contentView:(UIView *)contentView cancelButtonTitle:(NSString *)cancelButtonTitle
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        
        _contentView = contentView;
        _title = title;
        _buttons = [[NSMutableArray alloc] init];
        _buttonHeight = kDefaultButtonHeight;
        _containerWidth = kDefaultContainerWidth;
        _scrollViewPadding = kDefaultScrollViewPadding;
        _contentScrollView = [[UIScrollView alloc] init];
        
        
        self.viewBackgroundColor = [UIColor whiteColor];
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont boldSystemFontOfSize:20];
        self.buttonFont = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
        self.buttonColor = [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f];
        self.cancelButtonColor = [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f];
        self.cancelButtonFont = [UIFont systemFontOfSize:18.];
        self.customButtonColor = [UIColor colorWithRed:0.075f green:0.6f blue:0.9f alpha:1.0f];
        self.customButtonFont = [UIFont systemFontOfSize:18.];
        self.cornerRadius = 8;
        self.shadowRadius = 8;
        
        [self setup];
        
        if (cancelButtonTitle) {
            [self addButtonWithTitle:cancelButtonTitle type:CXAlertViewButtonTypeCancel handler:^(CustomAlertView *alertView, CXAlertButtonItem *button) {
                [alertView dismiss];
            }];
        }
        [self validateLayout];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setup
{
    [self setupContainerView];
    
    [self updateTitleLabel];
    [self updateContentScrollView];
    [self updateBottomScrollView];
}

- (void)setupContainerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_containerView];
    }
    
    _containerView.clipsToBounds = YES;
    
    _containerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    _containerView.layer.cornerRadius = self.cornerRadius;
    _containerView.layer.shadowOffset = CGSizeZero;
    _containerView.layer.shadowRadius = self.shadowRadius;
    _containerView.layer.shadowOpacity = 0.5;
    
}

- (void)updateTitleLabel
{
    if (self.title) {
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] init];
            [_containerView addSubview:_titleLabel];
        }
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = self.titleFont;
        _titleLabel.textColor = self.titleColor;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.numberOfLines = 0;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
        _titleLabel.minimumScaleFactor = 0.75;
#else
        _titleLabel.minimumFontSize = self.titleLabel.font.pointSize * 0.75;
#endif
        _titleLabel.frame = CGRectMake( self.vericalPadding, 0, self.containerWidth - self.vericalPadding*2, [self heightWithText:self.title font:_titleLabel.font]);
        _titleLabel.text = self.title;
        
    }
    else {
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
}

- (void)updateContentScrollView
{
    for (UIView *view in _contentScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    if (_contentView) {
        
        if (CGRectGetWidth(_contentView.frame) < self.containerWidth) {
            CGRect frame = _contentView.frame;
            frame.origin.x = (self.containerWidth - CGRectGetWidth(_contentView.frame))/2;
            _contentView.frame = frame;
        }
        
        [_contentScrollView addSubview:_contentView];
        
        CGFloat y = 0;
        y += [self heightForTitleLabel];
//        + self.scrollViewPadding;
//        y += self.scrollViewPadding;
        
        _contentScrollView.frame = CGRectMake( 0, y, self.containerWidth, [self heightForContentScrollView]);
        _contentScrollView.contentSize = _contentView.bounds.size;
        
        if (![_containerView.subviews containsObject:_contentScrollView]) {
            [_containerView addSubview:_contentScrollView];
        }
        
        [_contentScrollView setScrollEnabled:([self heightForContentScrollView] < CGRectGetHeight(_contentView.frame))];
    }
    else {
        [_contentScrollView setFrame:CGRectZero];
        [_contentScrollView removeFromSuperview];
    }
    
}

- (void)updateBottomScrollView
{
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc] init];
    }
    
    if (_buttons.count > 0) {
        CGFloat y = 0;
        //y += [self heightForTitleLabel] + self.scrollViewPadding;
        //y += [self heightForContentScrollView] + self.scrollViewPadding;
        //    y += self.scrollViewPadding;
        y = CGRectGetMaxY(_contentScrollView.frame);
        if (!_seperatorLine) {
            _seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.containerWidth, 1)];
            _seperatorLine.backgroundColor = [UIColor grayColor];
            [_containerView addSubview:_seperatorLine];
        }
        
        _bottomScrollView.backgroundColor = [UIColor redColor];
        _bottomScrollView.frame = CGRectMake( 0, y+1, self.containerWidth, [self heightForBottomScrollView]);
    }
    
    if (![_containerView.subviews containsObject:_bottomScrollView]) {
        [_containerView addSubview:_bottomScrollView];
    }
}

- (void)validateLayout
{
    CGFloat height = [self preferredHeight];
    CGFloat left = (self.bounds.size.width - self.containerWidth) * 0.5;
    CGFloat top = (self.bounds.size.height - height) * 0.5;
    _containerView.transform = CGAffineTransformIdentity;

    _containerView.frame = CGRectMake(left, top, self.containerWidth, height);
    _containerView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_containerView.bounds cornerRadius:_containerView.layer.cornerRadius].CGPath;
}

- (CGFloat)heightWithText:(NSString *)text font:(UIFont *)font
{
    if (text) {
        CGSize size = CGSizeZero;
        CGSize rSize = CGSizeMake(self.containerWidth - 2*self.vericalPadding - 1, NSUIntegerMax);
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, nil];
        CGRect rect = [text boundingRectWithSize:rSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        size = rect.size;
#else
        size = [text sizeWithFont:font constrainedToSize:rSize];
#endif
        return size.height;
    }
    
    return 0;
}

- (CGFloat)heightForTitleLabel
{
    return CGRectGetHeight(_titleLabel.frame);
}

- (CGFloat)heightForContentScrollView
{
    return MAX(kDefaultContentScrollViewMinHeight, MIN(kDefaultContentScrollViewMaxHeight, CGRectGetHeight(self.contentView.frame)));
}

- (CGFloat)heightForBottomScrollView
{
    if (_buttons.count > 0) {
        return kDefaultBottomScrollViewHeight;
    } else {
        return 0;
    }
}

- (CGFloat)preferredHeight
{
    CGFloat height = 0;
    height += ([self heightForTitleLabel]);
    height += ([self heightForContentScrollView]);
    height += ([self heightForBottomScrollView]);
    return height;
}


#pragma mark - add button
// Buttons
- (void)addButtonWithTitle:(NSString *)title type:(CXAlertViewButtonType)type handler:(CXAlertButtonHandler)handler
{
    UIFont *font = nil;
    switch (type) {
		case CXAlertViewButtonTypeCancel:
			font = self.cancelButtonFont;
			break;
		case CXAlertViewButtonTypeCustom:
            font = self.customButtonFont;
			break;
		case CXAlertViewButtonTypeDefault:
		default:
			font = self.buttonFont;
			break;
	}
    [self addButtonWithTitle:title type:type handler:handler font:font];
}

// Buttons
- (void)addButtonWithTitle:(NSString *)title type:(CXAlertViewButtonType)type handler:(CXAlertButtonHandler)handler font:(UIFont *)font
{
    CXAlertButtonItem *button = [self buttonItemWithType:type font:font];
    button.action = handler;
    button.type = type;
    button.defaultRightLineVisible = YES;
    [button setTitle:title forState:UIControlStateNormal];
    if ([_buttons count] == 0) {
        button.defaultRightLineVisible = NO;
        button.frame = CGRectMake( self.containerWidth/4, 0, self.containerWidth/2, self.buttonHeight);
    }
    else {
        // correct first button
        CXAlertButtonItem *firstButton = [_buttons objectAtIndex:0];
        firstButton.defaultRightLineVisible = YES;
        CGRect newFrame = firstButton.frame;
        newFrame.origin.x = 0;
        [firstButton setNeedsDisplay];
        
        CGFloat last_x = self.containerWidth/2 * [_buttons count];
        button.frame = CGRectMake( last_x + self.containerWidth/2, 0, self.containerWidth/2, self.buttonHeight);
        button.alpha = 0.;
        if (self.isVisible) {
            [UIView animateWithDuration:0.3 animations:^{
                firstButton.frame = newFrame;
                button.alpha = 1.;
                button.frame = CGRectMake( last_x, 0, self.containerWidth/2, self.buttonHeight);
            }];
        }
        else {
            firstButton.frame = newFrame;
            button.alpha = 1.;
            button.frame = CGRectMake( last_x, 0, self.containerWidth/2, self.buttonHeight);
        }
    }
    
    [_buttons addObject:button];
    [_bottomScrollView addSubview:button];
    CGFloat newContentWidth = self.bottomScrollView.contentSize.width + CGRectGetWidth(button.frame);
    _bottomScrollView.contentSize = CGSizeMake( newContentWidth, self.buttonHeight);
    
    [self updateBottomScrollView];
    [self validateLayout];
}

- (CXAlertButtonItem *)buttonItemWithType:(CXAlertViewButtonType)type font:(UIFont *)font
{
	CXAlertButtonItem *button = [CXAlertButtonItem buttonWithType:UIButtonTypeCustom];
    //	button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    button.titleLabel.font = font;
	UIImage *normalImage = nil;
	UIImage *highlightedImage = nil;
	switch (type) {
		case CXAlertViewButtonTypeCancel:
			[button setTitleColor:self.cancelButtonColor forState:UIControlStateNormal];
            [button setTitleColor:[self.cancelButtonColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
			break;
		case CXAlertViewButtonTypeCustom:
            [button setTitleColor:self.customButtonColor forState:UIControlStateNormal];
            [button setTitleColor:[self.customButtonColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
			break;
		case CXAlertViewButtonTypeDefault:
		default:
			[button setTitleColor:self.buttonColor forState:UIControlStateNormal];
            [button setTitleColor:[self.buttonColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
			break;
	}
	CGFloat hInset = floorf(normalImage.size.width / 2);
	CGFloat vInset = floorf(normalImage.size.height / 2);
	UIEdgeInsets insets = UIEdgeInsetsMake(vInset, hInset, vInset, hInset);
	normalImage = [normalImage resizableImageWithCapInsets:insets];
	highlightedImage = [highlightedImage resizableImageWithCapInsets:insets];
	[button setBackgroundImage:normalImage forState:UIControlStateNormal];
	[button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
	[button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)buttonAction:(CXAlertButtonItem *)buttonItem
{
    if (buttonItem.action) {
        buttonItem.action(self,buttonItem);
    }
}

#pragma mark - show/hide
+ (void)showBackground
{
    if (!__cx_alert_background_window) {
        __cx_alert_background_window = [[CXAlertBackgroundWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        __cx_alert_background_window.hidden = NO;
        
//        [__cx_alert_background_window makeKeyAndVisible];
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:__cx_alert_background_window];
        [keyWindow bringSubviewToFront:__cx_alert_background_window];
        
        __cx_alert_background_window.alpha = 0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             __cx_alert_background_window.alpha = 1;
                         }];
    }
}

+ (void)hideBackgroundAnimated:(BOOL)animated
{
    if (!animated) {
        [__cx_alert_background_window removeFromSuperview];
        __cx_alert_background_window = nil;
        return;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         __cx_alert_background_window.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [__cx_alert_background_window removeFromSuperview];
                         __cx_alert_background_window = nil;
                     }];
}

- (void)show
{
    
    if (self.willShowHandler) {
        self.willShowHandler(self);
    }
    
    _visible = YES;
    
//    if (!self.alertWindow) {
//        self.alertWindow = [[UIApplication sharedApplication] keyWindow];
//    }
    
    // transition background
    [CustomAlertView showBackground];
    
    [__cx_alert_background_window addSubview:self];
    
    [self transitionInCompletion:^{
        if (self.didShowHandler) {
            self.didShowHandler(self);
        }
        
    }];
}

- (void)dismiss
{
    [self dismissWithCleanup:YES];
}

- (void)dismissWithCleanup:(BOOL)cleanup
{
    BOOL isVisible = self.isVisible;
    
    if (isVisible) {
        if (self.willDismissHandler) {
            self.willDismissHandler(self);
        }
    }
    
    void (^dismissComplete)(void) = ^{
        _visible = NO;
        [self tearDown];
        
        if (isVisible) {
            if (self.didDismissHandler) {
                self.didDismissHandler(self);
            }
        }
        
        // check if we should show next alert
        if (!isVisible) {
            return;
        }
        
    };
    
    if (isVisible) {
        [self transitionOutCompletion:dismissComplete];
        [CustomAlertView hideBackgroundAnimated:YES];
        
    } else {
        dismissComplete();
        [CustomAlertView hideBackgroundAnimated:YES];
    }
    
}

// Transition
- (void)transitionInCompletion:(void(^)(void))completion
{
    _containerView.alpha = 0;
    _containerView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _containerView.alpha = 1.;
                         _containerView.transform = CGAffineTransformMakeScale(1.0,1.0);
                         
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)transitionOutCompletion:(void(^)(void))completion
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         _containerView.alpha = 0;
                         _containerView.transform = CGAffineTransformMakeScale(0.9,0.9);
                         
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}


- (void)tearDown
{
    [self.titleLabel removeFromSuperview];
    self.titleLabel = nil;
    
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    
    [self.contentScrollView removeFromSuperview];
    self.contentScrollView = nil;
    
    [self.bottomScrollView removeFromSuperview];
    self.bottomScrollView = nil;
    
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    
    [self removeFromSuperview];
    
//    [self.alertWindow removeFromSuperview];
//    self.alertWindow = nil;
}

#pragma mark - setter
#pragma mark - UIAppearance setters

- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor
{
    if (_viewBackgroundColor == viewBackgroundColor) {
        return;
    }
    _viewBackgroundColor = viewBackgroundColor;
    self.containerView.backgroundColor = viewBackgroundColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius == cornerRadius) {
        return;
    }
    _cornerRadius = cornerRadius;
    self.containerView.layer.cornerRadius = cornerRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    if (_shadowRadius == shadowRadius) {
        return;
    }
    _shadowRadius = shadowRadius;
    self.containerView.layer.shadowRadius = shadowRadius;
}


@end

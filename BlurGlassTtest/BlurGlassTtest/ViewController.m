//
//  ViewController.m
//  BlurGlassTtest
//
//  Created by iyaya on 14-7-29.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "LFGlassView.h"
#import "CustomAlertView.h"

@interface ViewController ()

@property (nonatomic, strong) LFGlassView *blurView;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self showAlert];
    
//    [self showCustomAlert];
    return;
    UIView *aview = [[UIView alloc] initWithFrame:self.view.bounds];
    aview.backgroundColor = [UIColor blackColor];
    aview.alpha = 0.5;
    [self.view addSubview:aview];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, 190, 200, 200)];
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    view.layer.cornerRadius = 8.0;
    [self.view addSubview:view];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    return;
    [self setupContainerView];
    
    if (self.blurView == nil) {
        self.blurView = [[LFGlassView alloc] initWithFrame:CGRectMake(30-10, 100-10, 260+20, 200+20)];
//        self.blurView = [[LFGlassView alloc] initWithFrame:self.containerView.frame];
        self.blurView.backgroundColor = [UIColor clearColor];
        self.blurView.clipsToBounds = YES;
        self.blurView.layer.cornerRadius = 1.0;
        self.blurView.blurRadius = 10.;
        self.blurView.scaleFactor = 1.;
        self.blurView.blurSuperView = self.view;
        
        [self.view addSubview:self.blurView];
//        [self.view insertSubview:self.blurView belowSubview:self.containerView];
    }
    
//    [self.blurView addSubview:view];
}

- (void)setupContainerView
{
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(30, 100, 260, 200)];
    [self.view addSubview:self.containerView];
    
    _containerView.clipsToBounds = YES;
    
//    _containerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.layer.cornerRadius = .5;
    _containerView.layer.shadowOffset = CGSizeMake(1, 1);
    _containerView.layer.shadowRadius = .5;
    _containerView.layer.shadowOpacity = 0.5;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert{
//    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:nil message:@"\"Steven Paul Jobs, the co-founder, two-time CEO, and chairman of Apple Inc., died October 5, 2011, after a long battle with cancer. He was 56. He was is survived by his wife and four children.The achievements in Jobs' career included helping to popularize the personal computer, leading the development of groundbreaking technology products including the Macintosh, iPod, and iPhone, and driving Pixar Animation Studios to prominence. Jobs’ charisma, drive for success and control, and vision contributed to revolutionary changes in the way technology integrates into and affects the daily life of most people in the world.\" - Wikipedia" cancelButtonTitle:nil];
//    alertView.buttonHeight = 0.0;
//    alertView.showButtonLine = NO;
//    [alertView show];
}

- (IBAction)showCustomAlert:(id)sender
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 10)];
    view.backgroundColor = [UIColor whiteColor];
    
    
//    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"title" contentView:view cancelButtonTitle:@"cancel"];

    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"title" message:@"\"Steven Paul Jobs, the co-founder, two-time CEO, and chairman of Apple Inc., died October 5, 2011, after a long battle with cancer. He was 56. He was is survived by his wife and four children.The achievements in Jobs' career included helping to popularize the personal computer, leading the development of groundbreaking technology products including the Macintosh, iPod, and iPhone, and driving Pixar Animation Studios to prominence. Jobs’ charisma, drive for success and control, and vision contributed to revolutionary changes in the way technology integrates into and affects the daily life of most people in the world.\" - Wikipedia" cancelButtonTitle:@"cancel"];
    alertView.cancelButtonColor = [UIColor redColor];
    [alertView addButtonWithTitle:@"sure" type:CXAlertViewButtonTypeDefault handler:^(CustomAlertView *alertView, CXAlertButtonItem *button) {
        NSLog(@" \n sure \n ");
    }];
    
    [alertView show];
}

@end

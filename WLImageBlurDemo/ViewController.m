//
//  ViewController.m
//  WLImageBlurDemo
//
//  Created by Lane on 16/3/1.
//  Copyright © 2016年 lane128. All rights reserved.
//


#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.height
#define APPLICATION_WINDOW [UIApplication sharedApplication].delegate.window

#import "ViewController.h"
#import "UIImageEffects.h"
#import <Masonry.h>

static CGFloat const popViewHeight = 300;

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIImage *showImage;

//setting
@property (nonatomic, strong) UIStepper *radiusStepper;
@property (nonatomic, strong) UIStepper *saturationDeltaFactorStepper;
@property (nonatomic, strong) UITextField *radiusField;
@property (nonatomic, strong) UITextField *saturationDeltaFactorField;
@property (nonatomic, strong) UILabel *radiusLabel;
@property (nonatomic, strong) UILabel *saturationDeltaFactorLabel;

//pop view
@property (nonatomic, strong) UIButton *popButton;
@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, assign) BOOL popViewIsShow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showImage = [UIImage imageNamed:@"testImage"];
    self.popViewIsShow = NO;
    [self setupViews];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)setupViews {
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.filterButton];
    [self.view addSubview:self.resetButton];
    [self.view addSubview:self.radiusLabel];
    [self.view addSubview:self.radiusField];
    [self.view addSubview:self.saturationDeltaFactorLabel];
    [self.view addSubview:self.saturationDeltaFactorField];
    [self.view addSubview:self.popButton];
}

#pragma mark - setter & getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 100)];
        [_imageView setImage:self.showImage];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIButton *)filterButton {
    if (!_filterButton) {
        _filterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kHeight - 50, kWidth / 2, 50)];
        [_filterButton setTitle:@"Filter" forState:UIControlStateNormal];
        _filterButton.backgroundColor = [UIColor grayColor];
        _filterButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _filterButton.layer.borderWidth = 1.0f;
        [_filterButton addTarget:self action:@selector(filterTheImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth / 2, kHeight - 50, kWidth / 2, 50)];
        [_resetButton setTitle:@"Reset" forState:UIControlStateNormal];
        _resetButton.backgroundColor = [UIColor grayColor];
        _resetButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _resetButton.layer.borderWidth = 1.0f;
        [_resetButton addTarget:self action:@selector(resetTheImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

- (UITextField *)radiusField {
    if (!_radiusField) {
        _radiusField = [[UITextField alloc] initWithFrame:CGRectMake(kWidth / 4, kHeight - 100, kWidth / 4, 50)];
        _radiusField.keyboardType = UIKeyboardTypeDecimalPad;
        _radiusField.returnKeyType = UIReturnKeyDone;
        _radiusField.layer.borderColor = [UIColor grayColor].CGColor;
        _radiusField.layer.borderWidth = 1.0f;
    }
    return _radiusField;
}

- (UITextField *)saturationDeltaFactorField {
    if (!_saturationDeltaFactorField) {
        _saturationDeltaFactorField = [[UITextField alloc] initWithFrame:CGRectMake(3 * kWidth / 4, kHeight - 100, kWidth / 4, 50)];
        _saturationDeltaFactorField.keyboardType = UIKeyboardTypeDecimalPad;
        _saturationDeltaFactorField.returnKeyType = UIReturnKeyDone;
        _saturationDeltaFactorField.layer.borderColor = [UIColor grayColor].CGColor;
        _saturationDeltaFactorField.layer.borderWidth = 1.0f;
    }
    return _saturationDeltaFactorField;
}

- (UILabel *)radiusLabel {
    if (!_radiusLabel) {
        _radiusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight - 100, kWidth / 4, 50)];
        _radiusLabel.text = @"radius";
        _radiusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _radiusLabel;
}

- (UILabel *)saturationDeltaFactorLabel {
    if (!_saturationDeltaFactorLabel) {
        _saturationDeltaFactorLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 2, kHeight - 100, kWidth / 4, 50)];
        _saturationDeltaFactorLabel.text = @"delta";
        _saturationDeltaFactorLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _saturationDeltaFactorLabel;
}

- (UIButton *)popButton {
    if (!_popButton) {
        _popButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, kWidth / 4, 40)];
        [_popButton setTitle:@"pop" forState:UIControlStateNormal];
        _popButton.backgroundColor = [UIColor grayColor];
        _popButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _popButton.layer.borderWidth = 1.0f;
        [_popButton addTarget:self action:@selector(popViewFromBottom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popButton;
}

- (UIView *)popView {
    if (!_popView) {
        _popView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight, kWidth, popViewHeight)];
        _popView.backgroundColor = [UIColor whiteColor];
    }
    return _popView;
}

#pragma mark - filter events

- (void)filterTheImage {
    NSLog(@"filterTheImage");
    CGFloat radius = [self.radiusField.text integerValue] > 0 ? [self.radiusField.text integerValue] : 30;
    CGFloat deltal = [self.saturationDeltaFactorField.text integerValue] > 0 ? [self.saturationDeltaFactorField.text integerValue] : 1.5;
    UIImage *filterImage = [UIImageEffects imageByApplyingBlurToImage:[UIImage imageNamed:@"testImage"]
                                                           withRadius:radius
                                                            tintColor:[UIColor colorWithWhite:1 alpha:0.2]
                                                saturationDeltaFactor:deltal
                                                            maskImage:nil];
    [self.imageView setImage:filterImage];
}

- (void)resetTheImage {
    NSLog(@"resetTheImage");
    [self.imageView setImage:self.showImage];
}

- (void)hiddenKeyBoard {
    [self.radiusField resignFirstResponder];
    [self.saturationDeltaFactorField resignFirstResponder];
}

- (void)popViewFromBottom {
    NSLog(@"popViewFromBottom");
    [self addContentView];
    [self loadPopView];
}

- (UIImage *)takeSnapshotOfView:(UIView *)view withRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
    [view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)addContentView {
    UIView *containerView = [UIView new];
    containerView.backgroundColor = [UIColor clearColor];
    UIWindow *window = APPLICATION_WINDOW;
    [window addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    self.containerView = containerView;
    
    UIImageView *backgroundView = [[UIImageView alloc] init];
    UIImage *snapShot = [self takeSnapshotOfView:self.view withRect:self.view.frame];
    UIImage *filterImage = [UIImageEffects imageByApplyingBlurToImage:snapShot
                                                           withRadius:30
                                                            tintColor:[UIColor colorWithWhite:1 alpha:0.2]
                                                saturationDeltaFactor:1.5
                                                            maskImage:nil];
    [backgroundView setImage:filterImage];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [containerView addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(containerView);
    }];
    self.backgroundView = backgroundView;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.containerView addGestureRecognizer:tapGesture];
    
    [self.backgroundView addSubview:self.popView];

    [window setNeedsLayout];
    [window layoutIfNeeded];
}

- (void)dismiss {
    NSLog(@"dismiss");
    if (!self.popViewIsShow) {
        NSLog(@"dismiss return");
        return;
    }
    [UIView animateWithDuration:1.5f animations:^{
        [self.containerView setNeedsLayout];
        [self.containerView layoutIfNeeded];
        CGRect rect = self.popView.frame;
        rect.origin.y = kHeight + self.popView.frame.size.height;
        self.popView.frame = rect;
    } completion:^(BOOL finished) {
        [self.containerView removeFromSuperview];
        self.containerView = nil;
        self.popViewIsShow = NO;
    }];
}

- (void)loadPopView {
    NSLog(@"loadPopView");
    if (self.popViewIsShow) {
        NSLog(@"loadPopView return");
        return;
    }
    [UIView animateWithDuration:1.5f animations:^{
        CGRect rect = self.popView.frame;
        rect.origin.y = kHeight - self.popView.frame.size.height;
        self.popView.frame = rect;
    } completion:^(BOOL finished) {
        self.popViewIsShow = YES;
    }];
}

@end

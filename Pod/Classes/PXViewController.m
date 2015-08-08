//
//  PXViewController.m
//
//  Created by Daniel Blakemore on 4/4/14.
//
//  Copyright (c) 2015 Pixio
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "PXViewController.h"

#import "PXDoubleNavTitle.h"

@interface PXViewController ()

@end

@implementation PXViewController
{
    PXDoubleNavTitle * _titleView;
    UIBarButtonItem * _backBarButtonItem;
    
    NSDictionary * _navBarColor;
    NSDictionary * _statusBarStyle;
    NSDictionary * _navBarTextColor;
}

+ (id)appearance
{
    return [MZAppearance appearanceForClass:[self class]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _titleView = [PXDoubleNavTitle new];
        _canGoBack = TRUE;
        _showsNavBar = TRUE;
        _showsStatusBar = TRUE;
        _darkTintColor = [UIColor blackColor];
        _lightTintColor = [UIColor whiteColor];
        _navBarStyle = PXViewControllerNavBarStyleDarkContent;
        
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-nav"] style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
        _statusBarStyle = @{@(PXViewControllerNavBarStyleLightContent) : @(UIStatusBarStyleLightContent), @(PXViewControllerNavBarStyleDarkContent) : @(UIStatusBarStyleDefault)};
        
        [[[self class] appearance] applyInvocationRecursivelyTo:self upToSuperClass:[PXViewController class]];
        
        [self updateStyleColors];
    }
    return self;
}

#pragma mark - view related methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // always give self the custom navigation view
    [[self navigationItem] setTitleView:_titleView];
    
    // Do any additional setup after loading the view.
    [[self navigationItem] setHidesBackButton:TRUE];
    
    [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)]];
    
    [self updateViewControllerAttributes:FALSE force:TRUE];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // set up buttons here, so subclasses can change whether they show up in viewDidLoad.
    // back button
    if (_canGoBack && [[self navigationItem] leftBarButtonItem] != _backBarButtonItem) {
        [[self navigationItem] setLeftBarButtonItem:_backBarButtonItem];
    }
    
    [self updateViewControllerAttributes:animated force:TRUE];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // status bar
    [[UIApplication sharedApplication] setStatusBarHidden:!_showsStatusBar];
}

- (void)updateViewControllerAttributes:(BOOL)animated force:(BOOL)force
{
    if (!force && (!self.isViewLoaded || !self.view.window)) {
        // viewController is not visible
        return;
    }
    
    [[self navigationItem] setHidesBackButton:TRUE animated:animated]; // like seriously, this needs to be everywhere
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE]; // just do it.
    [_titleView sizeToFit];
    
    // clear nav bar stuff
    [[[self navigationController] navigationBar] setBackgroundImage:(_clearNavBar ? [UIImage new] : nil)
                                                      forBarMetrics:UIBarMetricsDefault];
    [[[self navigationController] navigationBar] setShadowImage:(_clearNavBar ? [UIImage new] : nil)];
    [[[self navigationController] navigationBar] setTranslucent:_clearNavBar];
    
    [[[[self navigationController] navigationBar] layer] setShadowRadius:((_clearNavBar && _clearNavBarShadow) ? 2.0f : 0.0f)];
    [[[[self navigationController] navigationBar] layer] setShadowOpacity:((_clearNavBar && _clearNavBarShadow) ? 0.5f : 0.0f)];
    [[[[self navigationController] navigationBar] layer] setShadowOffset:((_clearNavBar && _clearNavBarShadow) ? CGSizeMake(0, 0) : CGSizeMake(0.0f, -3.0f))];
    
    // nav bar
    
    [[self navigationController] setNavigationBarHidden:!_showsNavBar animated:animated];
    
    BOOL makeRoomForNavBar = (_showsNavBar && !_clearNavBar);
    
    [self setAutomaticallyAdjustsScrollViewInsets:makeRoomForNavBar];
    
    UIRectEdge edges = makeRoomForNavBar ? UIRectEdgeNone : UIRectEdgeAll;
    [self setEdgesForExtendedLayout:edges];
    
    // status bar
    // this works when viewcontrollerbasedstatusbarappearance is true
    [self setNeedsStatusBarAppearanceUpdate];
    // this works when it's false
    [[UIApplication sharedApplication] setStatusBarHidden:!_showsStatusBar];
    [[UIApplication sharedApplication] setStatusBarStyle:[_statusBarStyle[@(_navBarStyle)] intValue]];
    // colors
    [_titleView setTintColor:_navBarTextColor[@(_navBarStyle)]];
    [[[self navigationController] navigationBar] setTintColor:_navBarTextColor[@(_navBarStyle)]];
    [[[self navigationController] navigationBar] setBarTintColor:_navBarColor[@(_navBarStyle)]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [_statusBarStyle[@(_navBarStyle)] intValue];
}

- (BOOL)prefersStatusBarHidden
{
    return !_showsStatusBar;
}

- (void)setShowsStatusBar:(BOOL)showsStatusBar
{
    _showsStatusBar = showsStatusBar;
    
    [self updateViewControllerAttributes:FALSE force:TRUE];
}

- (void)setClearNavBar:(BOOL)clearNavBar
{
    if (_clearNavBar == clearNavBar) {
        return;
    }
    
    _clearNavBar = clearNavBar;
    
    [self updateViewControllerAttributes:FALSE force:TRUE];
}

- (void)setClearNavBarShadow:(BOOL)clearNavBarShadow
{
    if (_clearNavBarShadow == clearNavBarShadow) {
        return;
    }
    
    _clearNavBarShadow = clearNavBarShadow;
    
    [self updateViewControllerAttributes:FALSE force:TRUE];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)backPressed
{
    [[self navigationController] popViewControllerAnimated:TRUE];
}

- (void)setLightTintColor:(UIColor *)lightTintColor
{
    _lightTintColor = lightTintColor;
    
    [self updateStyleColors];
}

- (void)setDarkTintColor:(UIColor *)darkTintColor
{
    _darkTintColor = darkTintColor;
    
    [self updateStyleColors];
}

- (void)updateStyleColors
{
    _navBarTextColor = @{@(PXViewControllerNavBarStyleLightContent) : [self lightTintColor], @(PXViewControllerNavBarStyleDarkContent) : [self darkTintColor]};
    _navBarColor = @{@(PXViewControllerNavBarStyleLightContent) : [self darkTintColor], @(PXViewControllerNavBarStyleDarkContent) : [self lightTintColor]};
}

#pragma mark - navigation titles

- (NSString *)title
{
    return [_titleView title];
}

- (void)setTitle:(NSString *)title
{
    [_titleView setTitle:title];
    [_titleView sizeToFit];
}

- (NSString *)subtitle
{
    return [_titleView subtitle];
}

- (void)setSubtitle:(NSString *)subtitle
{
    [_titleView setSubtitle:subtitle];
    [_titleView sizeToFit];
}

- (void)setNavBarStyle:(PXViewControllerNavBarStyle)navBarStyle
{
    _navBarStyle = navBarStyle;
    [self updateStyleColors];
    [self updateViewControllerAttributes:TRUE force:FALSE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  UIViewController+PXViewController.m
//  PXViewController
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

#import "UIViewController+PXViewController.h"
#import "PXNavigationItem.h"
#import "PXNavigationItem_Private.h"
#import <objc/runtime.h>

#import "PXViewController.h"
#import "PXCollectionViewController.h"
#import "PXTabBarController.h"
#import "PXTableViewController.h"

#pragma mark - Helper methods
static inline BOOL px_addMethod(Class class, Class sender, SEL selector)
{
    Method method = class_getInstanceMethod(sender, selector);
    return class_addMethod(class, selector, method_getImplementation(method), method_getTypeEncoding(method));
}

static inline void px_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

static inline void px_swizzleInstanceMethod(Class class, Class sender, SEL originalSelector, SEL swizzledSelector)
{
    px_addMethod(class, class, originalSelector);
    px_addMethod(class, sender, swizzledSelector);

    px_swizzleSelector(class, originalSelector, swizzledSelector);
}

static inline void px_swizzleClassMethod(Class class, Class sender, SEL originalSelector, SEL swizzledSelector)
{
    px_swizzleInstanceMethod(object_getClass((id)class), object_getClass((id)sender), originalSelector, swizzledSelector);
}





@interface PXViewControllerSwizzlingObject : UIViewController
@end

@implementation PXViewControllerSwizzlingObject

/**
 *  List of classes that should be swizzled. These view controllers will act like
 *  PXViewController
 */
static inline NSArray* swizzledClasses()
{
    static NSArray* classes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classes = @[
                    [PXCollectionViewController class],
                    [PXTabBarController class],
                    [PXTableViewController class],
                    [PXViewController class],
                    ];
    });

    return classes;
}

/**
 *  Get the base class of the passed in class. The returned class should be one
 *  of the classes returned from swizzledClasses().
 */
static inline Class getBaseClass(Class c)
{
    for (Class baseClass in swizzledClasses())
    {
        if ([c isSubclassOfClass:baseClass])
        {
            return baseClass;
        }
    }
    return nil;
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (Class c in swizzledClasses())
        {
            [self swizzleMethodsForClass:c];
        }
    });
}

+ (void) swizzleMethodsForClass:(Class)class
{
    px_swizzleInstanceMethod(class, self, @selector(initWithNibName:bundle:), @selector(init__px_WithNibName:bundle:));
    px_swizzleInstanceMethod(class, self, @selector(viewDidLoad), @selector(px_viewDidLoad));
    px_swizzleInstanceMethod(class, self, @selector(viewWillAppear:), @selector(px_viewWillAppear:));
    px_swizzleInstanceMethod(class, self, @selector(viewDidAppear:), @selector(px_viewDidAppear:));
    px_swizzleInstanceMethod(class, self, @selector(viewWillDisappear:), @selector(px_viewWillDisappear:));
    px_swizzleInstanceMethod(class, self, @selector(viewDidDisappear:), @selector(px_viewDidDisappear:));

    px_swizzleInstanceMethod(class, self, @selector(preferredStatusBarStyle), @selector(px_preferredStatusBarStyle));
    px_swizzleInstanceMethod(class, self, @selector(prefersStatusBarHidden), @selector(px_prefersStatusBarHidden));

    px_swizzleInstanceMethod(class, self, @selector(setTitle:), @selector(px_setTitle:));

    px_swizzleInstanceMethod(class, self, @selector(methodSignatureForSelector:), @selector(px_methodSignatureForSelector:));
    px_swizzleInstanceMethod(class, self, @selector(forwardInvocation:), @selector(px_forwardInvocation:));
    px_swizzleInstanceMethod(class, self, @selector(forwardingTargetForSelector:), @selector(px_forwardingTargetForSelector:));
    px_swizzleInstanceMethod(class, self, @selector(isKindOfClass:), @selector(px_isKindOfClass:));

    px_swizzleClassMethod(class, self, @selector(appearance), @selector(px_appearance));
}

- (instancetype) init__px_WithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [self init__px_WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self == nil)
    {
        return nil;
    }

    NSBundle *bundle = [NSBundle bundleForClass:[PXViewController class]];
    NSURL *url = [bundle URLForResource:@"PXViewController" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];

    UIImage* backImage = [[UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"back-nav" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
    objc_setAssociatedObject(self, @selector(backBarButtonItem), backBarButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);


    [[[self class] appearance] applyInvocationRecursivelyTo:self upToSuperClass:getBaseClass([self class])];

    return self;
}

- (void)px_viewDidLoad
{
    [self px_viewDidLoad];
    // Do any additional setup after loading the view.

    // always give self the custom navigation view
    [[self navigationItem] setTitleView:[[self px_navigationItem] titleView]];

    // Do any additional setup after loading the view.
    [[self navigationItem] setHidesBackButton:TRUE];

    [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)]];

    [self updateViewControllerAttributes:FALSE force:TRUE];
}

- (void)px_viewWillAppear:(BOOL)animated
{
    [self px_viewWillAppear:animated];

    // set up buttons here, so subclasses can change whether they show up in viewDidLoad.
    // back button

    UIBarButtonItem* backBarButtonItem = objc_getAssociatedObject(self, @selector(backBarButtonItem));
    if ([[self px_navigationItem] canGoBack] && [[self navigationItem] leftBarButtonItem] != backBarButtonItem) {
        [[self navigationItem] setLeftBarButtonItem:backBarButtonItem];
    }

    [self updateViewControllerAttributes:animated force:TRUE];
}

- (void)px_viewDidAppear:(BOOL)animated
{
    [self px_viewDidAppear:animated];

    // status bar
    [[UIApplication sharedApplication] setStatusBarHidden:![[self px_navigationItem] showsStatusBar]];
}

- (void)px_viewWillDisappear:(BOOL)animated
{
    [self px_viewWillDisappear:animated];
}

- (void)px_viewDidDisappear:(BOOL)animated
{
    [self px_viewDidDisappear:animated];
}

- (UIStatusBarStyle)px_preferredStatusBarStyle
{
    // No
    switch ([[self px_navigationItem] navBarStyle]) {
        case PXViewControllerNavBarStyleLightContent:
            return UIStatusBarStyleLightContent;
        case PXViewControllerNavBarStyleDarkContent:
        default:
            return UIStatusBarStyleDefault;
    }
}

- (BOOL)px_prefersStatusBarHidden
{
    return ![[self px_navigationItem] showsStatusBar];
}

- (void)px_setTitle:(NSString *)title
{
    [self px_setTitle:title];
    [[[self px_navigationItem] titleView] setTitle:title];
}

#pragma mark - Method Forwarding

- (NSMethodSignature *)px_methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature* signature = [[self px_navigationItem] methodSignatureForSelector:aSelector];
    if (signature != nil)
    {
        return signature;
    }
    return [self px_methodSignatureForSelector:aSelector];
}

- (void)px_forwardInvocation:(NSInvocation *)invocation
{
    if ([[self px_navigationItem] respondsToSelector:[invocation selector]])
    {
        [invocation invokeWithTarget:[self px_navigationItem]];
        return;
    }

    [self px_forwardInvocation:invocation];
}

- (BOOL)px_isKindOfClass:(Class)aClass
{
    if (aClass == [PXViewController class])
    {
        return TRUE;
    }
    return [self px_isKindOfClass:aClass];
}

- (id)px_forwardingTargetForSelector:(SEL)aSelector
{
    if ([[self navigationItem] respondsToSelector:aSelector])
    {
        return [self navigationItem];
    }

    return [self px_forwardingTargetForSelector:aSelector];
}

+ (id) px_appearance
{
    return [MZAppearance appearanceForClass:getBaseClass([self class])];
}

#pragma mark - Dummy Methods

- (void)updateViewControllerAttributes:(BOOL)animated force:(BOOL)force
{
    NSAssert(FALSE, @"Dummy method that shouldn't be called");
}

- (void)backPressed
{
    NSAssert(FALSE, @"Dummy method that shouldn't be called");
}

@end





@implementation UIViewController (PXViewController)

// Mark all properties as dynamic. Allow the forward invocation methods to forward
// invocations to the underlying PXNavigationItem object
@dynamic canGoBack;
@dynamic clearNavBar;
@dynamic clearNavBarShadow;
@dynamic darkTintColor;
@dynamic lightTintColor;
@dynamic subtitle;
@dynamic showsNavBar;
@dynamic navBarStyle;
@dynamic showsStatusBar;

- (void)updateViewControllerAttributes:(BOOL)animated force:(BOOL)force
{
    if (![self isKindOfClass:[PXViewController class]]) {
        return;
    }
    if (!force && (!self.isViewLoaded || !self.view.window)) {
        // viewController is not visible
        return;
    }

    static UIImage* clearImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clearImage = [UIImage new];
    });

    [[self navigationItem] setHidesBackButton:TRUE animated:animated]; // like seriously, this needs to be everywhere

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE]; // just do it.
    [[[self px_navigationItem] titleView] sizeToFit];

    // clear nav bar stuff
    BOOL clearNavBar = [[self px_navigationItem] clearNavBar];
    BOOL navBarShadow = (clearNavBar && [[self px_navigationItem] clearNavBarShadow]);

    [[[self navigationController] navigationBar] setBackgroundImage:(clearNavBar ? clearImage : nil)
                                                      forBarMetrics:UIBarMetricsDefault];
    [[[self navigationController] navigationBar] setShadowImage:(clearNavBar ? clearImage : nil)];
    [[[self navigationController] navigationBar] setTranslucent:clearNavBar];

    [[[[self navigationController] navigationBar] layer] setShadowRadius:(navBarShadow ? 2.0f : 0.0f)];
    [[[[self navigationController] navigationBar] layer] setShadowOpacity:(navBarShadow ? 0.5f : 0.0f)];
    [[[[self navigationController] navigationBar] layer] setShadowOffset:(navBarShadow ? CGSizeZero : CGSizeMake(0.0f, -3.0f))];

    // nav bar

    [[self navigationController] setNavigationBarHidden:![[self px_navigationItem] showsNavBar] animated:animated];

    BOOL makeRoomForNavBar = ([[self px_navigationItem] showsNavBar] && ![[self px_navigationItem] clearNavBar]);

    [self setAutomaticallyAdjustsScrollViewInsets:makeRoomForNavBar];

    UIRectEdge edges = makeRoomForNavBar ? UIRectEdgeNone : UIRectEdgeAll;
    [self setEdgesForExtendedLayout:edges];

    // status bar
    // this works when viewcontrollerbasedstatusbarappearance is true
    [self setNeedsStatusBarAppearanceUpdate];
    // this works when it's false
    [[UIApplication sharedApplication] setStatusBarHidden:![[self px_navigationItem] showsStatusBar]];
    [[UIApplication sharedApplication] setStatusBarStyle:[self preferredStatusBarStyle]];
    // colors
    [[[self px_navigationItem] titleView] setTintColor:[self px_navBarTextColor]];
    [[[self navigationController] navigationBar] setTintColor:[self px_navBarTextColor]];
    [[[self navigationController] navigationBar] setBarTintColor:[self px_navBarColor]];

    [[[self tabBarController] tabBar] setBarTintColor:[self px_navBarColor]];
}

- (UIStatusBarStyle) px_statusBarStyle
{
    switch ([[self px_navigationItem] navBarStyle]) {
        case PXViewControllerNavBarStyleLightContent:
            return UIStatusBarStyleLightContent;
        case PXViewControllerNavBarStyleDarkContent:
        default:
            return UIStatusBarStyleDefault;
    }
}

- (UIColor*) px_navBarColor
{
    switch ([[self px_navigationItem] navBarStyle]) {
        case PXViewControllerNavBarStyleLightContent:
            return [[self px_navigationItem] darkTintColor];
        case PXViewControllerNavBarStyleDarkContent:
        default:
            return [[self px_navigationItem] lightTintColor];
    }
}

- (UIColor*) px_navBarTextColor
{
    switch ([[self px_navigationItem] navBarStyle]) {
        case PXViewControllerNavBarStyleLightContent:
            return [[self px_navigationItem] lightTintColor];
        case PXViewControllerNavBarStyleDarkContent:
        default:
            return [[self px_navigationItem] darkTintColor];
    }
}

- (void)setShowsStatusBar:(BOOL)showsStatusBar
{
    [[self px_navigationItem] setShowsStatusBar:showsStatusBar];

    [self updateViewControllerAttributes:FALSE force:TRUE];
}

- (void)setClearNavBar:(BOOL)clearNavBar
{
    if ([[self px_navigationItem] clearNavBar] == clearNavBar) {
        return;
    }

    [[self px_navigationItem] setClearNavBar:clearNavBar];

    [self updateViewControllerAttributes:FALSE force:TRUE];
}

- (void)setClearNavBarShadow:(BOOL)clearNavBarShadow
{
    if ([[self px_navigationItem] clearNavBarShadow] == clearNavBarShadow) {
        return;
    }

    [[self px_navigationItem] setClearNavBarShadow:clearNavBarShadow];

    [self updateViewControllerAttributes:FALSE force:TRUE];
}

- (void)backPressed
{
    [[self navigationController] popViewControllerAnimated:TRUE];
}

- (void)setLightTintColor:(UIColor *)lightTintColor
{
    [[self px_navigationItem] setLightTintColor:lightTintColor];

    [self updateViewControllerAttributes:FALSE force:TRUE];
}

- (void)setDarkTintColor:(UIColor *)darkTintColor
{
    [[self px_navigationItem] setDarkTintColor:darkTintColor];

    [self updateViewControllerAttributes:FALSE force:TRUE];
}

#pragma mark - navigation titles

- (void)setNavBarStyle:(PXViewControllerNavBarStyle)navBarStyle
{
    [[self px_navigationItem] setNavBarStyle:navBarStyle];
    [self updateViewControllerAttributes:TRUE force:FALSE];
}

@end

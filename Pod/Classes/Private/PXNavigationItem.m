//
//  PXNavigationItem.m
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


#import "PXNavigationItem.h"
#import <objc/runtime.h>

#import "PXNavigationItem_Private.h"

@implementation PXNavigationItem

- (instancetype)init
{
    self = [super init];
    if (self == nil)
    {
        return nil;
    }
    
    _titleView = [PXDoubleNavTitle new];
    _canGoBack = TRUE;
    _showsNavBar = TRUE;
    _showsStatusBar = TRUE;
    _darkTintColor = [UIColor blackColor];
    _lightTintColor = [UIColor whiteColor];
    _navBarStyle = PXViewControllerNavBarStyleDarkContent;

    return self;
}

- (NSString *)title
{
    return [_titleView title];
}

- (void)setTitle:(NSString *)title
{
    [_titleView setTitle:title];
}

- (NSString *)subtitle
{
    return [_titleView subtitle];
}

- (void)setSubtitle:(NSString *)subtitle
{
    [_titleView setSubtitle:subtitle];
}

@end

@implementation UIViewController (PXNavigationItem)

- (PXNavigationItem *)px_navigationItem
{
    PXNavigationItem* item = objc_getAssociatedObject(self, @selector(px_navigationItem));

    if (item == nil)
    {
        item = [[PXNavigationItem alloc] init];
        objc_setAssociatedObject(self, @selector(px_navigationItem), item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return item;
}

@end
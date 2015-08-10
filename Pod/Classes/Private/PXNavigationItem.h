//
//  PXNavigationItem.h
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

#import <Foundation/Foundation.h>
#import "UIViewController+PXViewController.h"

@interface PXNavigationItem : NSObject

/**
 *  The title displayed in the navigation bar.
 */
@property (nonatomic, copy) NSString * title;

/**
 *  A subtitle which, if set, is shown below the title in the navigation bar.
 *  If this property is nil or @@"", the position of the title text is placed where the default navigation title would be.
 */
@property (nonatomic, copy) NSString * subtitle;

/**
 *  The color of the nav title and buttons (or the bar, depending on the style).  Defaults to [UIColor whiteColor].
 */
@property (nonatomic, copy) UIColor * lightTintColor;

/**
 *  The color of the nav bar (or the title and buttons, depending on the style).  Defaults to [UIColor blackColor].
 */
@property (nonatomic, copy) UIColor * darkTintColor;

/**
 *  Set to indicate whether or not this viewcontroller has the ability to go back. For example, modal viewcontrollers should not.
 *  The default value is TRUE.
 */
@property (nonatomic) BOOL canGoBack;

/**
 *  Whether or not the nav bar is 100% trasparent.  The default value is FALSE.
 */
@property (nonatomic) BOOL clearNavBar;

/**
 *  Whether or not the nav bar has a shadow when transparent.  The default value is FALSE.
 */
@property (nonatomic) BOOL clearNavBarShadow;

/**
 *  Whether or not to show the status bar.  The default value is TRUE.
 */
@property (nonatomic) BOOL showsStatusBar;

/**
 *  Whether or not the nav bar is shown.  The default value is TRUE.
 */
@property (nonatomic) BOOL showsNavBar;

/**
 *  The style of the nav bar.  The default value is PXViewControllerNavBarStyleDarkContent.
 */
@property (nonatomic) PXViewControllerNavBarStyle navBarStyle;

@end

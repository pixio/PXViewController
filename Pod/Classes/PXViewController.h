//
//  PXViewController.h
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

#import <UIKit/UIKit.h>

#import <MZAppearance/MZAppearance.h>

/**
 *  The color scheme of the nav bar (title, tint, bar).
 */
typedef NS_ENUM(NSInteger, PXViewControllerNavBarStyle) {
    /**
     *  darkTint colored text on a lightTint colored background.
     */
    PXViewControllerNavBarStyleDarkContent,
    /**
     *  lightTint colored text on a tint darkTint colored background.
     */
    PXViewControllerNavBarStyleLightContent,
};

/**
 *  Custom viewcontroller which manages the interface to the double label navigation title view.
 *  Also takes care of which buttons are shown in the navigation bar and when.  Allows subclasses to implement custom back behavior.
 */
@interface PXViewController : UIViewController <MZAppearance>

/**
 *  Appearance proxy for this view controller.
 *
 *  @return appearance proxy object
 */
+ (id)appearance;

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
@property (nonatomic, copy) UIColor * lightTintColor MZ_APPEARANCE_SELECTOR;

/**
 *  The color of the nav bar (or the title and buttons, depending on the style).  Defaults to [UIColor blackColor].
 */
@property (nonatomic, copy) UIColor * darkTintColor MZ_APPEARANCE_SELECTOR;

/**
 *  Set to indicate whether or not this viewcontroller has the ability to go back. For example, modal viewcontrollers should not.
 *  The default value is TRUE.
 */
@property (nonatomic) BOOL canGoBack;

/**
 *  Called when the back button is pressed.  Default implementation calls popViewControllerAnimated on the navigation controller.
 *  Subclasses override to add custom behavior for going back (form validation, etc.).  Should not be called directly.
 */
- (void) backPressed;

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

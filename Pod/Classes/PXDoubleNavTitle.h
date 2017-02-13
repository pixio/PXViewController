//
//  PXDoubleNavTitle.h
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

/**
 *  A titleview for a navigation bar with a title and a subtitle.
 */
@interface PXDoubleNavTitle : UIView

/**
 *  The font to use for this instance.  The size of the font is ignored.
 *
 *  This font is inherited at instantiation from the class font.  Changing this font property
 *  changes the font for this title only.  Setting this property to nil, falls back on the 
 *  PXDoubleNavTitle class font.
 */
@property (nonatomic, nullable) UIFont* font UI_APPEARANCE_SELECTOR;

/**
 *  The title displayed in the navigation bar.
 */
@property (nonatomic, copy, nullable) NSString * title;

/**
 *  A subtitle which, if set, is shown below the title in the navigation bar.
 *  If this property is nil or @@"", the position of the title text is placed where the default navigation title would be.
 */
@property (nonatomic, copy, nullable) NSString * subtitle;

/**
 *  Color applied to text of titles.
 */
@property (nonatomic, nullable) UIColor * tintColor UI_APPEARANCE_SELECTOR;

@end

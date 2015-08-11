//
//  PXBlockAlertView.h
//
//  Created by Daniel Blakemore on 9/5/13.
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

@class PXBlockAlertView;

typedef void (^ button_block_t)(PXBlockAlertView * sender);

/**
 *  UIAlertView-like class which takes blocks for the buttons rather than requiring a delegate.
 */
@interface PXBlockAlertView : NSObject

/**
 *  Show an alert with two buttons.
 *
 *  @param title       the alert title
 *  @param message     the message for the alert
 *  @param acceptTitle the title for the accept button
 *  @param acceptBlock the block to run if the accept button is pressed
 *  @param cancelTitle the title for the cancel button
 *  @param cancelBlock the block to run if the cancel button is pressed
 */
+ (void)showWithTitle:(NSString*)title message:(NSString*)message acceptButtonTitle:(NSString*)acceptTitle block:(button_block_t)acceptBlock cancelButtonTitle:(NSString*)cancelTitle block:(button_block_t)cancelBlock;

/**
 *  Show an alert with one button.
 *
 *  @param title       the title of the alert
 *  @param message     the message text for the alert
 *  @param acceptTitle the title of the accept button (the only button)
 *  @param acceptBlock the block to run if the accept button is pressed
 */
+ (void)showWithTitle:(NSString*)title message:(NSString*)message acceptButtonTitle:(NSString*)acceptTitle block:(button_block_t)acceptBlock;

@end

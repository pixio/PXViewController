//
//  PXBlockAlertView.m
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

#import "PXBlockAlertView.h"

#import <UIAlertController-BetterConstructor/UIAlertController+BetterConstructor.h>

@interface PXBlockAlertView () <UIAlertViewDelegate>

@end

@implementation PXBlockAlertView
{
    NSString * _title;
    NSString * _message;
    NSString * _acceptTitle;
    NSString * _cancelTitle;
    button_block_t _accept;
    button_block_t _cancel;
    
    NSInteger _offset;
}

static PXBlockAlertView * sharedObject;

- (id)initWithTitle:(NSString*)title message:(NSString*)message acceptButtonTitle:(NSString*)acceptTitle block:(button_block_t)acceptBlock cancelButtonTitle:(NSString*)cancelTitle block:(button_block_t)cancelBlock
{
    self = [super init];
    if (self) {
        // Initialization code
        _title = title;
        _message = message;
        _acceptTitle = acceptTitle;
        _cancelTitle = cancelTitle;
        _accept = acceptBlock;
        _cancel = cancelBlock;
        
        _offset = !cancelTitle;
    }
    return self;
}

- (void)accepted
{
    if (_accept) {
        _accept(self);
    }
    _accept = nil;
    _cancel = nil;
    [PXBlockAlertView suicide];
}

- (void)canceled
{
    if (_cancel) {
        _cancel(self);
    }
    _cancel = nil;
    _accept = nil;
    [PXBlockAlertView suicide];
}

+ (void)showWithTitle:(NSString*)title message:(NSString*)message acceptButtonTitle:(NSString*)acceptTitle block:(button_block_t)acceptBlock cancelButtonTitle:(NSString*)cancelTitle block:(button_block_t)cancelBlock
{
    sharedObject = [[PXBlockAlertView alloc] initWithTitle:title message:message acceptButtonTitle:acceptTitle block:acceptBlock cancelButtonTitle:cancelTitle block:cancelBlock];
    [sharedObject show];
}

+ (void)showWithTitle:(NSString*)title message:(NSString*)message acceptButtonTitle:(NSString*)acceptTitle block:(button_block_t)acceptBlock
{
    sharedObject = [[PXBlockAlertView alloc] initWithTitle:title message:message acceptButtonTitle:acceptTitle block:acceptBlock cancelButtonTitle:nil block:nil];
    [sharedObject show];
}

+ (void)suicide
{
    sharedObject = nil;
}

- (void)show
{
    if ([UIAlertController class]) {
        UIAlertController * ac = [UIAlertController alertControllerWithTitle:_title message:_message style:UIAlertControllerStyleAlert cancelButtonTitle:_cancelTitle cancelButtonBlock:^(UIAlertAction *action) {
            [self canceled];
        } destructiveButtonTitle:nil destructiveButtonBlock:nil otherButtonTitlesAndBlocks:_acceptTitle, ^(UIAlertAction *action) {
            [self accepted];
        }, nil];
        
        // should probably deal with extensions here at some point
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:ac animated:TRUE completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:_title message:_message delegate:self cancelButtonTitle:_cancelTitle otherButtonTitles:_acceptTitle, nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // If the button index is -1 it means we were dismissed with no selection
    switch (buttonIndex + _offset) {
        case 0:
            // cancel
            [self canceled];
            break;
            
        case 1:
            // accept
            [self accepted];
            break;
            
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

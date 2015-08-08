//
//  PXDoubleNavTitle.m
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

#import "PXDoubleNavTitle.h"

@implementation PXDoubleNavTitle
{
    BOOL _haveSubtitle;
    UILabel * _titleLabel;
    UILabel * _subtitleLabel;
    
    NSMutableArray * _constraints;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _constraints = [NSMutableArray array];
        
        _titleLabel = [UILabel new];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[[self font] fontWithSize:16.0f]];
//        [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:FALSE];
        [self addSubview:_titleLabel];
        
        _subtitleLabel = [UILabel new];
        [_subtitleLabel setTextColor:[UIColor whiteColor]];
        [_subtitleLabel setTextAlignment:NSTextAlignmentCenter];
        [_subtitleLabel setFont:[[self font] fontWithSize:11.0f]];
//        [_subtitleLabel setTranslatesAutoresizingMaskIntoConstraints:FALSE];
        [self addSubview:_subtitleLabel];

#warning Uncomment when iOS 8+ adoption doesn't suck.
//        NSDictionary* views = NSDictionaryOfVariableBindings(_titleLabel, _subtitleLabel);
//        NSDictionary* metrics = @{};
//        
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|" options:0 metrics:metrics views:views]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_subtitleLabel]|" options:0 metrics:metrics views:views]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel]" options:0 metrics:metrics views:views]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_subtitleLabel]|" options:0 metrics:metrics views:views]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:_subtitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBaseline multiplier:1.0f constant:0.0f]];
        
        // call directly
//        [self updateConstraints];
    }
    return self;
}

- (void)setSubtitle:(NSString *)subtitle
{
    _haveSubtitle = !![subtitle length];
    
    _subtitle = [subtitle copy];
    
    [_subtitleLabel setText:subtitle];
    
    [self layoutIfNeeded];
    
//#warning trigger layout change
//    [self setNeedsUpdateConstraints];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    [_titleLabel setText:title];
    [self layoutIfNeeded];
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;

    [_titleLabel setTextColor:_tintColor];
    [_subtitleLabel setTextColor:_tintColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect r = self.bounds;
    
    CGSize size = [self sizeThatFits:r.size];
    
    CGSize titleSize = [_titleLabel sizeThatFits:CGSizeZero];
    CGSize subtitleSize = [_subtitleLabel sizeThatFits:CGSizeZero];
    
    size.width = r.size.width; // this change should allow the title to be changed on the same instance and not have centering issues.
    CGFloat titleHeight = _haveSubtitle ? titleSize.height : size.height;
    CGFloat subtitleHeight = _haveSubtitle ? subtitleSize.height : 0;
    
    CGRect titleFrame = CGRectMake(0, 0, size.width, titleHeight);
    CGRect subtitleFrame = CGRectMake(0, size.height - subtitleHeight, size.width, subtitleHeight);
    
    [_titleLabel setFrame:CGRectIntegral(titleFrame)];
    [_subtitleLabel setFrame:CGRectIntegral(subtitleFrame)];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize titleSize = [_titleLabel sizeThatFits:size];
    CGSize subtitleSize = [_subtitleLabel sizeThatFits:size];
    CGFloat width = MAX(titleSize.width, subtitleSize.width);
    CGFloat height = titleSize.height + (_haveSubtitle ? subtitleSize.height : 0.0f);
    return CGSizeMake(width, height);
}

//- (void)updateConstraints
//{
//    [self removeConstraints:_constraints];
//    [_constraints removeAllObjects];
//    
//    NSDictionary* views = NSDictionaryOfVariableBindings(_titleLabel, _subtitleLabel);
//    NSDictionary* metrics = @{};
//    if (_haveSubtitle) {
//        // show the label
//        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_subtitleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeHeight multiplier:0.6f constant:0.0f]];
//    } else {
//        [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_subtitleLabel(0)]" options:0 metrics:metrics views:views]];
//    }
//    
//    [self addConstraints:_constraints];
//    
//    [super updateConstraints];
//}

//- (CGSize)sizeThatFitsThatDOESNTMAKEAPPLEFUCKITSELFWITHACACTUS:(CGSize)size // doesn't crash // apple has since fixed this
//{
//    CGSize titleSize = [_titleLabel sizeThatFits:size];
//    CGSize subtitleSize = [_subtitleLabel sizeThatFits:size];
//    CGFloat width = MAX(titleSize.width, subtitleSize.width);
//    CGFloat height = titleSize.height + (_haveSubtitle ? subtitleSize.height : 0.0f);
//    NSLog(@"%f, %f", width, height);
//    return CGSizeMake(width, height);
//}

@end

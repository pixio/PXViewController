//
//  PXViewController.m
//  PXViewController
//
//  Created by Daniel Blakemore on 05/01/2015.
//  Copyright (c) 2014 Daniel Blakemore. All rights reserved.
//

#import "PXExampleViewController.h"

#import <PXBlockAlertView/PXBlockAlertView.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface PXExampleViewController ()

@end

@implementation PXExampleViewController
{
    UIInterfaceOrientationMask _interfaceOrientations; // demo purposes only
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self setLightTintColor:[UIColor whiteColor]];
    [self setDarkTintColor:[UIColor blackColor]];
    
    if ([[[self navigationController] viewControllers] count] == 1) {
        [self setTitle:@"Root"];
        [self setCanGoBack:FALSE];
    } else {
        [self setTitle:[NSString stringWithFormat:@"View Controller %d", (int)[[[self navigationController] viewControllers] count]]];
    }
    
    UITapGestureRecognizer * _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addVC)];
    [[self view] addGestureRecognizer:_tapRecognizer];
    
    // interface orientations
    if (arc4random_uniform(2)) {
        _interfaceOrientations = UIInterfaceOrientationMaskPortrait;
    } else {
        _interfaceOrientations = UIInterfaceOrientationMaskAll;
    }

    // nav bar clear
    if (arc4random_uniform(4) == 0) {
        [self setClearNavBar:TRUE];
        [self setClearNavBarShadow:TRUE];
    }
    
    // nav bar style
    if (arc4random_uniform(2)) {
        [self setNavBarStyle:PXViewControllerNavBarStyleLightContent]; // notice how this changes the status bar accordingly
    }

    // subtitle
    if (arc4random_uniform(2)) {
        [self setSubtitle:@"Has a Subtitle"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [SVProgressHUD showInfoWithStatus:@"Tap to push a new view controller."];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return _interfaceOrientations;
}

- (void)addVC
{
    [[self navigationController] pushViewController:[PXExampleViewController new] animated:TRUE];
}

- (void)backPressed
{
    if (arc4random_uniform(4) == 0) {
        [PXBlockAlertView showWithTitle:@"AH AH AH" message:@"You didn't say the magic word..." acceptButtonTitle:@"Back" block:^(PXBlockAlertView *sender) {
            [super backPressed];
        } cancelButtonTitle:@"Stay" block:nil];
    } else {
        [super backPressed];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

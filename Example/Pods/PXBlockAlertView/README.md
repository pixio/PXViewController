# PXBlockAlertView

[![Version](https://img.shields.io/cocoapods/v/PXBlockAlertView.svg?style=flat)](http://cocoapods.org/pods/PXBlockAlertView)
[![License](https://img.shields.io/cocoapods/l/PXBlockAlertView.svg?style=flat)](http://cocoapods.org/pods/PXBlockAlertView)
[![Platform](https://img.shields.io/cocoapods/p/PXBlockAlertView.svg?style=flat)](http://cocoapods.org/pods/PXBlockAlertView)

## TL;DR

Class methods that give you the ability to show an alert by providing a title, message, and one or two button titles and button blocks:

```objective-c
[PXBlockAlertView showWithTitle:@"So Simple" message:@"I can't believe it's not a pain." acceptButtonTitle:@"Show Me Another" block:^(PXBlockAlertView *sender) {
    [self showAlert];
} cancelButtonTitle:@"Awesome" block:^(PXBlockAlertView *sender) {
    // do nothing
}];
```

## Usage

1. Import <PXBlockAlertView/PXBlockAlertView.h>.  
2. Call one of the showWith.. methods.
3. ???
4. \</project>

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

PXBlockAlertView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PXBlockAlertView"
```

## Author

Daniel Blakemore, DanBlakemore@gmail.com

## License

PXBlockAlertView is available under the MIT license. See the LICENSE file for more info.

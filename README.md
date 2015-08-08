# PXViewController

[![Version](https://img.shields.io/cocoapods/v/PXViewController.svg?style=flat)](http://cocoapods.org/pods/PXViewController)
[![License](https://img.shields.io/cocoapods/l/PXViewController.svg?style=flat)](http://cocoapods.org/pods/PXViewController)
[![Platform](https://img.shields.io/cocoapods/p/PXViewController.svg?style=flat)](http://cocoapods.org/pods/PXViewController)

## Usage

There are a couple of annoying restrictions that `UIViewController` and `UINavigationController` enforce: there's nothing you can do about a user pressing the back button, individual view controllers can't determine their desired interface orientations when in a navigation controller, and matching the status bar style with the nav bar style is easy to miss and looks terrible.

These classes add this and other potentially useful functionality to `UIViewController`, `UITableViewController`, `UICollectionViewController`, `UITabBarController`, and `UINavigationController`.  Some of this functionality addresses the above "limitations", some of it was added to expand the capabilities of these subclasses for specific projects.

For `PXViewController`, `PXTableViewController`, `PXCollectionViewController`, and `PXTabBarController`, you get the following additions:

* A light and dark tint color that behave like UIAppearance selectors (thanks to [`MZAppearance`](https://github.com/m1entus/MZAppearance)).
* An overridable function for when the user presses the back button.
* A title and subtitle in the navigation bar.
* The option to have a clear navigation bar with or without shadows under the elements (title, buttons, etc).
* The option to hide the default chevron back button.
* Whether or not to hide the status bar in a given view controller.
* Whether or not to hide the nav bar in a given view controller.

`PXNavigationController` provides the following functionality:

```objective-c
- (NSUInteger)supportedInterfaceOrientations
{
    // let the top view controller decide, since it's the one being displayed
    return [[self topViewController] supportedInterfaceOrientations];
}

- (BOOL)prefersStatusBarHidden
{
    return [[self topViewController] prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    // view controllers get to decide because that actually makes sense.
    return [[self topViewController] preferredStatusBarStyle];
}
```

There is an example project.  It should give you a taste for how I intended to use these classes, but reading the headers is also helpful.  To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Notes

There are some oddities of these subclasses worth mentioning.  First of all, they are subclasses.  Why are they subclasses?

Short answer: I can't force `UITableViewController` to inherit from my `PXViewController` class.  
Long answer: We're working on a shared code version for code maintenance reasons.  Keep an eye out for a large commit sometime in the future.

Second note: The `UITabBarController` subclass has navigation bar properties.  Don't people usually put navigation stacks in tabs, not tab bars in the navigation stack?

Short answer: Yes.  But I have done the tab-bar-in-nav-stack version enough times that this is worth it.  
Long answer: Almost all of these classes are centered around limitations relating to `UINavigationController` and the navigation bar.  So if you aren't using a tab bar controller in an navigation controller, it doesn't make sense to use `PXTabBarController` anyway.

Third note: Why is the back button forced to be a chevron only?

Short answer: That's what all the kids are doing these days.  
Long answer: Essentially every design we get or produce for clients uses this for the back button.  Usually, if someone needs some of the more advanced capabilities that these classes offer, they also use a plain-ol' chevron back button (no text).  


## Installation

PXViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PXViewController"
```

## Author

Daniel Blakemore, DanBlakemore@gmail.com

## License

PXViewController is available under the MIT license. See the LICENSE file for more info.

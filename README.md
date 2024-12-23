# PulseTabBar

PulseTabBar is a custom UITabBarController subclass that provides an animated tab bar with a unique distortion effect when switching between tabs. It includes options for customizing the appearance and animation behavior.

https://github.com/user-attachments/assets/4ce3ab94-c7ca-4979-a43e-79bf0d5b96fc

## Initialization
To use PulseTabBar, simply initialize it as you would a standard UITabBarController:
```swift
let pulseTabBar = PulseTabBar()
pulseTabBar.viewControllers = [viewController1, viewController2, viewController3]
```
## Customization
You can change the background color dynamically using the background(color:) method.
```swift
pulseTabBar.background(color: .blue)
```
Adjust the distortion height using the distortion(height:) method.
```swift
pulseTabBar.distortion(height: 15)
```

## Requirements

iOS 13.0+ Swift 5.0+

## Installation

PulseTabBar is available through CocoaPods. To install it, simply add the following line to your Podfile:
```ruby
pod "PulseTabBar"
```

## License

LabelTextFormatter is available under the New BSD license. See the LICENSE file for more info.

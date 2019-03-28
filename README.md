iOS Twitter Text Counter
==================

[![Version](https://img.shields.io/cocoapods/v/VSTwitterTextCounter.svg?style=flat)](http://cocoapods.org/pods/VSTwitterTextCounter)
[![License](https://img.shields.io/cocoapods/l/VSTwitterTextCounter.svg?style=flat)](http://cocoapods.org/pods/VSTwitterTextCounter)
[![Platform](https://img.shields.io/cocoapods/p/VSTwitterTextCounter.svg?style=flat)](http://cocoapods.org/pods/VSTwitterTextCounter)

This custom UIControl resembles Twitter's new progress based web UI that represents the number of characters left. It also handles highlighting any extra characters in your UITextView.

# Screenshot

Here's an animated screenshot to show you an idea of how it works.

![ScreenShot](https://raw.github.com/DynamicSignal/ios-twitter-text-counter/master/Example/Assets/sample.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

You should install [twitter-text](https://github.com/twitter/twitter-text/tree/master/objc) and use it to parse your string then pass your *weightedLength* to the control.

# Installation

__Cocoapods:__ VSTwitterTextCounter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'VSTwitterTextCounter'
```

__Manual__:

1. In your Xcode Project, take *VSTwitterCounter.swift* from VSTwitterTextCounter folder and drag them into your project.

2. Start using this new UIControl Subclass!

__Supported Swift Versions__:

| Library Version     | Supported Swift Version |
| :-----------------: | :---------------------- |
| **0.1.3 and above** | Swift 5                 |
| **0.1.2**           | Swift 3                 |

# SDK Support

It supports iOS 8.0 to iOS 12.2
Live rendering in Interface builder will require Xcode 6.x

# Usage

## Creating your filter
### By Code
Somewhere, for example in your viewDidLoad, alloc and init the filter UIControl:

```
let twitterTextCounter = VSTwitterTextCounter()
```

This initializes our Twitter Text Counter using default size and max characters count to 280.

*Note that the size of the control is predefined and should not be changed*. Use __CONTROL_SIZE__ static property for reference.

Adding to your UIView:

```
view.addSubview(twitterTextCounter)
```

Then, after your text gets updated, most probably in:-
```
func textViewDidChange(_ textView: UITextView)
```
You will need to parse the text using Twitter's *TwitterTextParser SDK*, which should look like that:-

```
let weightedLength = TwitterTextParser.defaultParser().parseTweet(textView.text).weightedLength
```

You will need to update your text length by calling:-
```
twitterTextCounter.update(with: textView, textWeightedLength: weightedLength)
```
Note: textView will be needed in order for the control to update the highlighted state of any overflowing text.

### Via Interface builder
Add a new UIView to your xib, and update its class to __VSTwitterTextCounter__.
Enjoy ;)

## Configuration
### Counter

| Property            | Effect                                | Default value  |
| :-----------------: | :------------------------------------ | :------------- |
| **Max Count**       | Sets the max value for weightedLength | DEFAULT_MAX_COUNT / 280 |
| **Weighted Length** | Current text weight                   |   0                     |

## Author

Shady Elyaski, shady@dynamicsignal.com

License
-------

This Code is released under the MIT License by [Dynamic Signal](http://dynamicsignal.com)

[PS. We are hiring, check out our hiring page.](https://stackoverflow.com/jobs/131439/ios-developer-dynamic-signal)

http://dynamicsignal.com

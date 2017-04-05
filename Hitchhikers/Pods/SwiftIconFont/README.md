<p align="center"><img src="https://raw.githubusercontent.com/0x73/SwiftIconFont/master/Assets/logo.png" alt="SwiftIconFont Banner"></p>

[![Build Status](https://travis-ci.org/0x73/SwiftIconFont.svg)](https://travis-ci.org/0x73/SwiftIconFont)
[![Version](https://img.shields.io/cocoapods/v/SwiftIconFont.svg?style=flat)](http://cocoapods.org/pods/SwiftIconFont)
[![License](https://img.shields.io/cocoapods/l/SwiftIconFont.svg?style=flat)](http://cocoapods.org/pods/SwiftIconFont)
[![Platform](https://img.shields.io/cocoapods/p/SwiftIconFont.svg?style=flat)](http://cocoapods.org/pods/SwiftIconFont)

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate SwiftIconFont into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "0x73/SwiftIconFont"
```

### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate SwiftIconFont into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!

pod 'SwiftIconFont'
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Prefixes

| Font         | Prefix | Cheat Sheet                               |
|--------------|--------|-------------------------------------------|
| Font Awesome | fa:    | [List](http://fontawesome.io/cheatsheet/) |
| Ion Icons    | io:    | [List](http://ionicons.com)               |
| Octicons     | oc:    | [List](https://octicons.github.com)       |
| Open Iconic  | ic:    | [List](https://useiconic.com/open/)       |
| Material Icon   | ma:    | [List](https://design.google.com/icons/)       |
| Themify   | ti:    | [List](https://themify.me/themify-icons)       |
| Map Icons   | mi:    | [List](http://map-icons.com)       |

## Fonts
````swift
public enum Fonts: String {
    case FontAwesome = "FontAwesome"
    case Iconic = "open-iconic"
    case Ionicon = "Ionicons"
    case Octicon = "octicons"
    case Themify = "themify"
    case MapIcon = "map-icons"
    case MaterialIcon = "MaterialIcons-Regular"
}
````

## Runtime Structure
> ###< Prefix >:< Icon >


##Usage

In your UILabel, UIButton or UITextField, set a text containing a placeholder anywhere you want the icon to be. Somethink like this

> oc:logo-github


Then you can choose between 3 ways you can use SwiftIconFont.

####1. No Custom Class

Simply import SwiftIconFont and call processIcons on any UILabel, UIButton or UITextField that has a placeholder.

```swift
label.parseIcon()
```

####2. Custom Class

The lazy way, just set your UILabel, UITextField, UIButton, UITextView, UIBarButtonItem class as SwiftIconLabel, SwiftIconTextField, SwiftIconButton, SwiftIconTextView, SwiftBarButtonItem, and thats it, your icons will be processed at runtime.


####3. Programmatically

````swift
import SwiftIconFont

label.font = UIFont.icon(from: .FontAwesome, ofSize: 50.0)
label.text = String.fontAwesomeIcon(code: "twitter")
````


####UIBarButtonItem (No Custom Class)

````swift
import SwiftIconFont

twitterBarButton.icon(from: .FontAwesome, code: "twitter", ofSize: 20)
````

####UITabBarItem (No Custom Class)

````swift
import SwiftIconFont

twitterTabBarButton.icon(from: .FontAwesome, code: "twitter", imageSize: CGSizeMake(20, 20), ofSize: 20)
````

## Author

* Sedat Gokbek CIFTCI, me@sedat.ninja
* Jose Quintero, [@josejuanqm](https://github.com/josejuanqm)

## License

SwiftIconFont is available under the MIT license. See the LICENSE file for more info.


## Contributing

1. Fork it (http://github.com/0x73/SwiftIconFont/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

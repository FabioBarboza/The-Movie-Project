## Synopsis
The movie project is an iOS app for cinephiles and movie hobbyists, written in Swift. This first version (MVP) of the app is very simple and limited to show the list of upcoming movies. The app is fed with content from  [The Movie Database (TMDb)](https://www.themoviedb.org/).

## Installation

The current code is located in the (development branch)[https://github.com/FabioBarboza/The-Movie-Project/tree/development]

### Pre-requisites:
- iOS 10.0+
- Xcode 8.0+
- Swift 3.0+
- [CocoaPods](https://cocoapods.org/)
- [Swiftlint](https://github.com/realm/SwiftLint)

### Swiftlint
[Swiftlint](https://github.com/realm/SwiftLint) is a tool to enforce swift style and conventions. 
To install the tool, just donwload the [swiftLint.pkg](https://github.com/realm/SwiftLint/releases/download/0.13.0/SwiftLint.pkg) and running it.

After the installation, go to XCode in the build phase tab and add a new "Run Script Phase" and type

```bash
if which swiftlint >/dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
```

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required

Then, Install dependencies running the following command:

```bash
$ pod install
```
> Make sure you are in the project root folder

## API Reference
The TMDb API documentation and examples of use can be found here:
● https://developers.themoviedb.org/3
## Third-Party Libraries
### Alamofire
[Alamofire](https://github.com/Alamofire/Alamofire) is an HTTP networking library written in Swift. It leverages NSURLSession and the Foundation URL Loading System to provide first-class networking capabilities in a convenient Swift interface.
#### Usage - Making a Request

```swift
import Alamofire

Alamofire.request("https://httpbin.org/get")
```

#### Response Handling

Handling the `Response` of a `Request` made in Alamofire involves chaining a response handler onto the `Request`.

```swift
Alamofire.request("https://httpbin.org/get").responseJSON { response in
    print(response.request)  // original URL request
    print(response.response) // HTTP URL response
    print(response.data)     // server data
    print(response.result)   // result of response serialization

    if let JSON = response.result.value {
        print("JSON: \(JSON)")
    }
}
```

## Screens

![Screen1](http://i.imgur.com/jKXhOhY.png)
![Screen2](http://i.imgur.com/KpoepPk.png)
![Screen1](http://i.imgur.com/wBggHa3.png)

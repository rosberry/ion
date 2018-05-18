# Ion
__Ion__ is a lightweight data transfer layer loosely based on publish-subscribe messaging pattern. 
It provides following components:
* __Subscriber__, which acts as a wrapper for a data processing logic
* __Emitter__, which manages subscribers, receives and propagates data
* __Matcher__, which acts as a wrapper for a data validation logic
* __Collector__, which provides convenience functions for working with subscribers
* __Case__ data wrapper, for wrapping a non-equatable object in an equatable container
* __Some__ data wrapper, for wrapping an equatable object in a non-equatable container
* __Result__ data wrapper, for wrapping an object or an error in a container

It also provides `AnyEventSource` & `AnyEventSync` wrapper for `Emitter` object for convenient access level management. 

## Requirements

* Swift 4.1+

## Usage
The most basic use case would look something like this:
```swift
// Service.swift
class Service {
    // Prepare emitter & eventSource
    private let emitter = Emitter<String>()
    lazy var eventSource = AnyEventSource(emitter) // read-only access
    // ...
    
    // Send updates
    func update() {
        emitter.emit("Hello")
    }
    // ...
}
```

```swift
// ViewModel.swift
class ViewModel {
    // Prepare collector
    private let service = Service()
    private lazy var collector = Collector(source: service.eventSource)
    // ...
    
    // Subscribe
    init() {
        collector.subscribe { (data: String) in
            print(data)
        }
    }
    // ...
```

It's possible to create subscribers manually, but you'd need to take care of unsubscribing then, in order to avoid retain loops:
```swift
let subscriber = Subscriber(AnyMatcher()) { (data: String) in
    print(data)
}
service.eventSource.subscribe(subscriber)
```

__Matcher__ objects provide basic filtering functionality, so in order to receive only certain data, it's possible to do something like this:
```swift
let matcher = ObjectMatcher(object: "Hello")
let subscriber = Subscriber(matcher) { (data: String) in
    print(data) // only "Hello" string will be received
}
service.eventSource.subscribe(subscriber)
```

__Ion__ provides following matchers out of the box:
* `AnyMatcher`, which matches any objects
* `ObjectMatcher`, which matches equatable objects
* `PropertyMatcher`, which matches objects by a specified keyPath
* `ClosureMatcher`, which uses user-defined closure to match objects
* `TrainMatcher`, which matches sequences
* `ResultMatcher`, which matches objects of `Result` wrapper type

It's possible to write custom matchers as well by implementing `Matcher` protocol.

## Disclaimer
__Ion__ is not intended and never will be a replacement for RxSwift or any similar library. __Ion__ is aimed at providing minimal functionality and be as lightweight and simple as possible.

## Installation
__Carthage__

Create a Cartfile that lists the framework and run carthage update. Follow the instructions to add the framework to your project.
```
github "rosberry/ion"
```

## Authors

* Anton Kormakov, anton.kormakov@rosberry.com

## About

<img src="https://github.com/rosberry/Foundation/blob/master/Assets/full_logo.png?raw=true" height="100" />

This project is owned and maintained by Rosberry. We build mobile apps for users worldwide 🌏.

Check out our [open source projects](https://github.com/rosberry), read [our blog](https://medium.com/@Rosberry) or give us a high-five on 🐦 [@rosberryapps](http://twitter.com/RosberryApps).

## License

Ion is available under the MIT license. See the LICENSE file for more info.

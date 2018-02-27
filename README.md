# SwiftyMapper

[![CI Status](http://img.shields.io/travis/evgeniy-bizhanov/SwiftyMapper.svg?style=flat)](https://travis-ci.org/evgeniy-bizhanov/SwiftyMapper)
[![Version](https://img.shields.io/cocoapods/v/SwiftyMapper.svg?style=flat)](http://cocoapods.org/pods/SwiftyMapper)
[![License](https://img.shields.io/cocoapods/l/SwiftyMapper.svg?style=flat)](http://cocoapods.org/pods/SwiftyMapper)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyMapper.svg?style=flat)](http://cocoapods.org/pods/SwiftyMapper)

## Overview
SwiftyMapper give a chance to map data's in n-layer architectures by scheme 'Model-DTO-Model'

## Usage

Create binding configuration:
```ruby
try SwiftyMapper.shared.bind(DestinationData.self).to(SourceData.self)
```

Map to source data:
```ruby
destination: DestinationData? = try SwiftyMapper.shared.map(to: source)
```

## Requirements
- Swift 4.x

## Installation

SwiftyMapper is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyMapper'
```

## Example

An example project is included with this repo. To run the example project, clone the repo, and run ``pod install`` from the Example directory first.

## Postscriptum

It still can not bind types with optional fields, cause optioanls is part of pure swift but not Objective C.
At the same time pure swift reflection can't read or write values by string keyPath

It's a cool thing to use KeyPath like \DataType.field but I could not find solution how programmatically create KeyPath from string.

Yes, I know that I could do something like the OptionalRealm but my skills are still very scarce especially with regard to Objective C

In other words if someone wants to help with the implementation of optionals functionality, you are welcome

p.s. let me know that you need it :)

## Author

Evgeniy Bizhanov

## License

SwiftyMapper is available under the MIT license. See the LICENSE file for more info.
# SwiftyMapper

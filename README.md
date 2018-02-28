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

## Example

Data types example:
```ruby
@objcMembers
class SourceData: NSObject {
    var string: String?
    var integer: Int = 0
    var float: Float = 0.0
}
```

```ruby
@objcMembers
class DestinationData: NSObject {
    var string: String?
    var integer: Int = 0
    var double: Double = 0.0
}
```

Wrong data type with an optional Int:
```ruby
@objcMembers
class WrongData: NSObject {
    var string: String?
    var integer: Int?
}
```

Best practice of configure the binding:
```ruby
do {
    try SwiftyMapper.shared.bind(DestinationData.self).to(SourceData.self)
    // try SwiftyMapper.shared.bind(DestinationData.self).to(SourceData.self) // throws configurationExists
    // try SwiftyMapper.shared.bind(DestinationData.self).to(WrongData.self) // throws typeIsNotSupported
} catch SwiftyMapperError.cantCreateInstance(of: let instance) {
    print("Can't create the mirroring instance of type \(instance)")
} catch SwiftyMapperError.configurationExists {
    print("Configuration already exists")
} catch SwiftyMapperError.typeIsNotSupported(type: let type, memberType: let memberType) {
    print("\(memberType) of \(type) is not actually supported")
} catch {
    print("Unexpected error \(error)")
}
```

Create sample data:
```ruby
let source = SourceData()
source.string = "Hello Swift!"
source.integer = 123
source.float = 321.0
```

Map to sample data:
```ruby
do {
    if let destination: DestinationData = try SwiftyMapper.shared.map(to: source) {
        print(destination.string) // Prints "Hello Swift!"
        print(destination.integer) // Prints "123"
        print(destination.double) // Prints "0
    }

    // let _: WrongData? = try SwiftyMapper.shared.map(to: source) // throws cantFindConfiguration
    // let _ = try SwiftyMapper.shared.map(to: source) // throws cantFindConfiguration
} catch SwiftyMapperError.cantCreateInstance(of: let instance) {
    print("Can't create the mirroring instance of type \(instance)")
} catch SwiftyMapperError.cantFindConfiguration(destination: let destinationType, source: let sourceType) {
    print("Can't find configuration with\n   destination: \(destinationType)\n   source:      \(sourceType)")
} catch {
    print("Unexpected error \(error)")
}
```

## Requirements
- Swift 4.x

## Installation

SwiftyMapper is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyMapper'
```

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

//
//  SwiftyMapper.swift
//  Pods-SwiftyMapper_Example
//
//  Created by Евгений Бижанов on 27.02.2018.
//

// MARK: Protocols

// Hack for combining all the optional types
// Give us the opportunity for dynamic type checking like this
//
// memberType is OptionalType.Type
//
private protocol OptionalType {}

// Defines the starting point of a binding
public protocol SwiftyMapperDestinationProtocol {
    // Return self as SwiftMapperSourceProtocol (SwiftMapper) to further customize the binding
    // self as SwiftMapperSourceProtocol give access to complete binding to<TSource>
    //
    // Input type must be NSObject, because further the Objective C will be involved
    // for create an instance and mirror it
    
    /// Creates a binding key based on destination type
    func bind<TDestination: NSObject>(_ destination: TDestination.Type) throws -> SwiftyMapperSourceProtocol
}

// Defines the ending point of a binding
public protocol SwiftyMapperSourceProtocol {
    // Input type must be NSObject, because further the Objective C will be involved
    // for create an instance and mirror it
    //
    // IS NOT THREAD-SAFE. It simply takes the last created binding configuration
    
    /// Сompletes the binding process based on source type
    func to<TSource: NSObject>(_ source: TSource.Type) throws
}

// Defines all other actions
public protocol SwiftyMapperProtocol {
    // A configuration is searched based on two types
    //
    // If the configuration is exists a new instance of TDestination type is created
    // If the configuration doesn't exists throws the cantFindConfiguration exception
    //
    // Input types must be NSObject, because further the Objective C will be involved
    // for create an instance and get/set values for keyPath
    
    /// Creates a new instance based on the SwiftMapper configuration and map it to the source
    func map<TDestination: NSObject, TSource: NSObject>(to source: TSource) throws -> TDestination?
}

// MARK: SwiftMapper

// SwiftyMapper designed for map Model-DTO-Model in the n-layer architectures
/// Dto Swifty mapper
final public class SwiftyMapper {
    // Store SwiftyMapper configuration
    private lazy var dictionary = [MapConfigurationItem]()
    
    // Reflect properties from type
    private func getProperties(of typeOf: Any.Type) throws -> [PropertyInfo] {
        // Because a reflecting works only with an instance of type (not type)
        // dynamically create an instance of type
        guard let instance = Factory.getClassInstance(typeOf as! AnyClass) else {
            throw SwiftyMapperError.cantCreateInstance(of: String(describing: typeOf))
        }
        
        var result = [PropertyInfo]()
        
        let mirror = Mirror(reflecting: instance)
        for (label, value) in mirror.children {
            guard let label = label else {
                continue
            }
            
            // Extracting the property type. If type is OptionalType (aka Optional<...>)
            // throws the typeIsNotSupported exception
            let memberType = type(of: value)
            if memberType is OptionalType.Type {
                switch memberType {
                case is Optional<String>.Type:
                    break
                case is Optional<Date>.Type:
                    break
                case is Optional<Data>.Type:
                    break
                default:
                    throw SwiftyMapperError.typeIsNotSupported(type: typeOf, memberType: memberType)
                }
            }
            
            result.append(PropertyInfo(label: label, type: memberType))
        }
        
        return result
    }
    
    // Creates singleton SwiftyMapper instance
    // In order to exclude the wrong binding execution sequence returns instance
    // conforms only to SwiftyMapperDestinationProtocol & SwiftyMapperProtocol
    public static let shared = SwiftyMapper() as SwiftyMapperDestinationProtocol & SwiftyMapperProtocol
    private init() {}
}

// MARK: Protocol implementations
extension Optional: OptionalType {}

// 'bind' implementation
extension SwiftyMapper: SwiftyMapperDestinationProtocol {
    public func bind<TDestination>(_ destination: TDestination.Type) throws -> SwiftyMapperSourceProtocol {
        // Add the configuration binding key
        let item = MapConfigurationItem(key: TDestination.self)
        item.properties = try Set(getProperties(of: destination))
        
        dictionary.append(item)
        return self
    }
}

// 'to' implementation
extension SwiftyMapper: SwiftyMapperSourceProtocol {
    public func to<TSource>(_ source: TSource.Type) throws {
        // Get the last configuration pointer
        let item = dictionary[dictionary.count - 1]
        
        guard !dictionary.contains(where: { ($0.key == item.key) && ($0.linkedTo == TSource.self) }) else {
            throw SwiftyMapperError.configurationExists
        }
        
        let properties = try Set(getProperties(of: source))
        
        item.linkedTo = TSource.self
        
        // Intersect common properties for two types
        item.properties = item.properties?.intersection(properties)
    }
}

// 'map' implementation
extension SwiftyMapper: SwiftyMapperProtocol {
    public func map<TDestination, TSource>(to source: TSource) throws -> TDestination? where TDestination: NSObject, TSource: NSObject {
        // Extract binding configuration if exists
        guard let configuration = dictionary.first(where: {
            (item) in return (item.key == TDestination.self) && (item.linkedTo == TSource.self)
        }), let properties = configuration.properties else {
            throw SwiftyMapperError.cantFindConfiguration(destination: TDestination.self, source: TSource.self)
        }
        
        // Creates a new instance of TDestination
        guard let instance = Factory.getClassInstance(TDestination.self) else {
            throw SwiftyMapperError.cantCreateInstance(of: String(describing: TDestination.self))
        }
        
        // Mapping values from the source to the newly created object
        for property in properties {
            let value = source.value(forKey: property.label)
            instance.setValue(value, forKey: property.label)
        }
        
        return instance as? TDestination
    }
}

// MARK: Data structures

// Configuration data item
final fileprivate class MapConfigurationItem: CustomStringConvertible {
    /// Key (destination) type
    var key: Any.Type
    
    /// Linked (source) type
    var linkedTo: Any.Type?
    
    /// Intersected properties array of two types
    var properties: Set<PropertyInfo>?
    
    init(key: Any.Type) {
        self.key = key
    }
    
    var description: String {
        var description = "\nkey: \(key)\n"
        
        if linkedTo != nil {
            description += "linkedTo: \(linkedTo!)\n"
        }
        
        if properties != nil {
            description += "properties: \(properties!)\n"
        }
        
        return description
    }
}

// One property info, hashable for purposes of storing by Set
fileprivate struct PropertyInfo: Hashable {
    /// Property label (name)
    let label: String
    
    /// Property type
    let type: Any.Type
    
    var hashValue: Int {
        let result = String(describing: type) + label
        return result.hashValue
    }
    
    static func ==(left: PropertyInfo, right: PropertyInfo) -> Bool {
        return (left.label == right.label) && (left.type == right.type)
    }
}


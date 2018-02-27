//
//  SwiftyErrors.swift
//  Pods-SwiftyMapper_Example
//
//  Created by Евгений Бижанов on 27.02.2018.
//

/// SwiftMapper throws errors enum
public enum SwiftyMapperError: Error {
    /// Throws if SwiftMapper can't create bindable instance
    case cantCreateInstance(of: String)
    
    /// Throws if SwiftMapper can't find binding configuration while mapping
    case cantFindConfiguration(destination: Any.Type, source: Any.Type)
    
    /// Throws if mappable configuration already exists
    case configurationExists
    
    /// Throws if mappable types contains Optional<...> types
    case typeIsNotSupported(type: Any.Type, memberType: Any.Type)
}


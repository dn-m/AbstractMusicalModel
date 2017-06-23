//
//  Performer.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import Foundation
import Collections

/// Model of a signle `Performer` in a `PerformanceContext`.
public struct Performer {
    
    // MARK: - Associated Types
    
    /// Type of `Identifier`.
    public typealias Identifier = String

    // MARK: - Instance Properties
    
    /// Identifier.
    public let identifier: Identifier
    
    /// Storage of `Instrument` values by their `identifier`.
    public let instruments: [Instrument.Identifier: Instrument]
    
    // MARK: - Inializers
    
    /// Create a `Performer` with a given `identifier` and an array of `Instrument` values.
    public init(
        _ identifier: Identifier = UUID().uuidString,
        _ instruments: [Instrument] = []
    )
    {
        self.identifier = identifier
        self.instruments = Dictionary(instruments.map { ($0.identifier, $0) })
    }
    
    // MARK: - Instance Methods
    
    /// - returns: `Instrument` with the given `id`, if present. Otherwise, `nil`.
    public func instrument(id: Instrument.Identifier) -> Instrument? {
        return instruments[id]
    }
}

extension Performer: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        return "Performer: \(identifier)\n" +
            (instruments.map { "\($0)" }.joined(separator: "\n")).indented()
    }
}

extension Performer: AnyCollectionWrapping {
    
    // MARK: - AnyCollectionWrapping
    
    public var collection: AnyCollection<Instrument> {
        return AnyCollection(instruments.values)
    }
}

extension Performer: Equatable {
    
    // MARK: - Equatable
    
    public static func == (lhs: Performer, rhs: Performer) -> Bool {
        return lhs.instruments == rhs.instruments
    }
}

extension Performer: Hashable {
    
    public var hashValue: Int {
        return identifier.hashValue
    }
}

//
//  Performer.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import Collections

/// Model of a signle `Performer` in a `PerformanceContext`.
public struct Performer {
    
    /// Type of `Identifier`.
    public typealias Identifier = String

    /// Identifier.
    public let identifier: Identifier
    
    /// The `Instrument` values contained herein.
    public let instruments: [Instrument]
    
    /// Create a `Performer` with a given `identifier` and an array of `Instrument` values.
    public init(_ identifier: Identifier, _ instruments: [Instrument]) {
        self.identifier = identifier
        self.instruments = instruments
    }
}

extension Performer: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    public var description: String {
        return "Performer: \(identifier)\n" +
            (instruments.map { "\($0)" }.joined(separator: "\n")).indented()
    }
}

extension Performer: AnyCollectionWrapping {
    
    // MARK: - AnyCollectionWrapping
    
    public var collection: AnyCollection<Instrument> {
        return AnyCollection(instruments)
    }
}

extension Performer: Equatable {
    
    // MARK: - Equatable
    
    public static func == (lhs: Performer, rhs: Performer) -> Bool {
        return lhs.instruments == rhs.instruments
    }
}

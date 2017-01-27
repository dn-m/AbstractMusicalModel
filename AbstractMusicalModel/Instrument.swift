//
//  Instrument.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import Collections

/// - TODO: Add instrument specifications (vn, vc, tpt, bfl cl, etc.)
public struct Instrument {
    
    public typealias Identifier = String
    
//    // TODO: Add more complex naming structure
//    struct Name {
//        let long: String
//        let short: String
//    }

    /// Identifier.
    public let identifier: Identifier
    
    /// Storage of `Voice` values by their `identifier`.
    public let voices: [Voice.Identifier: Voice]
    
    /// Create an `Instrument` with an `identifier` and an array of `Voice` values.
    public init(_ identifier: Identifier, _ voices: [Voice]) {
        self.identifier = identifier
        self.voices = Dictionary(voices.map { ($0.identifier, $0) })
    }
}

extension Instrument: CustomStringConvertible {
    
    public var description: String {
        return "Instrument: \(identifier)\n" +
            voices.map { "\($0)" }.joined(separator: "\n").indented()
    }
}

extension Instrument: AnyCollectionWrapping {
    
    public var collection: AnyCollection<Voice> {
        return AnyCollection(voices.values)
    }
}

extension Instrument: Equatable {
    
    public static func == (lhs: Instrument, rhs: Instrument) -> Bool {
        return lhs.voices == rhs.voices
    }
}

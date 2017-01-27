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
    
    // TODO: Add more complex naming structure
    struct Name {
        let long: String
        let short: String
    }
    
    // public let name: Name
    
    public let identifier: Identifier
    public let voices: [Voice]
    
    public init(_ identifier: Identifier, _ voices: [Voice]) {
        self.identifier = identifier
        self.voices = voices
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
        return AnyCollection(voices)
    }
}

extension Instrument: Equatable {
    
    public static func == (lhs: Instrument, rhs: Instrument) -> Bool {
        return lhs.voices == rhs.voices
    }
}

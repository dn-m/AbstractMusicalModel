//
//  PerformanceContext.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

/// Descriptor to whom (or what) a given `Entity` belongs.
public struct PerformanceContext {
    
    /// `Path` within a `PerformanceContext` hierarchy.
    public struct Path {
        let performer: Performer.Identifier
        let instrument: Instrument.Identifier
        let voice: Voice.Identifier
        
        public init(
            _ performer: Performer.Identifier,
            _ instrument: Instrument.Identifier,
            _ voice: Voice.Identifier
        )
        {
            self.performer = performer
            self.instrument = instrument
            self.voice = voice
        }
    }
    
    /// `Performer` of a given `PerformanceContext`.
    public let performer: Performer
    
    /// Create a `PerformanceContext` with a `Performer`
    public init(_ performer: Performer = Performer("abc", [])) {
        self.performer = performer
    }
    
    /// - returns:
    public func contains(path: Path) -> Bool {
        guard performer.identifier == path.performer else { return false }
        guard let instrument = performer.instruments[path.performer] else { return false }
        return instrument.voices[path.voice] != nil
    }
}

extension PerformanceContext: Equatable {
    
    /// - returns: `true` if the `performer` values of each `PerformanceContext` are
    /// equivalent.
    public static func == (lhs: PerformanceContext, rhs: PerformanceContext) -> Bool {
        return lhs.performer == rhs.performer
    }
}

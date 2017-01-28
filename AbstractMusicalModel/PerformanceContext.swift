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
        
        public let performer: Performer.Identifier
        public let instrument: Instrument.Identifier
        public let voice: Voice.Identifier
        
        /// Create a `Path` with identifiers of a `performer`, `instrument`, and `voice`.
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
    
    
    public struct Scope {
        
        public let performer: Performer.Identifier?
        public let instrument: Instrument.Identifier?
        public let voice: Voice.Identifier?
        
        public init() {
            self.performer = nil
            self.instrument = nil
            self.voice = nil
        }
        
        public init(_ performer: (Performer.Identifier)) {
            self.performer = performer
            self.instrument = nil
            self.voice = nil
        }
        
        public init(_ performer: Performer.Identifier, _ instrument: Instrument.Identifier) {
            self.performer = performer
            self.instrument = instrument
            self.voice = nil
        }
        
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
        
        public func contains(_ context: PerformanceContext) -> Bool {
            
            guard let performerID = performer else {
                return true
            }

            guard context.performer.identifier == performerID else {
                return false
            }

            guard let instrumentID = instrument else {
                return true
            }

            guard let instrument = context.performer.instrument(with: instrumentID) else {
                return false
            }

            guard let voiceID = voice else {
                return true
            }

            return instrument.voice(with: voiceID) != nil
        }
    }
    
    /// `Performer` of a given `PerformanceContext`.
    public let performer: Performer
    
    /// Create a `PerformanceContext` with a `Performer`
    public init(_ performer: Performer = Performer("abc", [])) {
        self.performer = performer
    }
    
    /// - returns: `true` if this `PerformanceContext` contains the given `Path`.
    public func contains(_ path: Path) -> Bool {
        guard performer.identifier == path.performer else { return false }
        guard let instrument = performer.instruments[path.instrument] else { return false }
        return instrument.voices[path.voice] != nil
    }

    public func isContained(by scope: Scope) -> Bool {
        return scope.contains(self)
    }
}

extension PerformanceContext: Equatable {
    
    /// - returns: `true` if the `performer` values of each `PerformanceContext` are
    /// equivalent.
    public static func == (lhs: PerformanceContext, rhs: PerformanceContext) -> Bool {
        return lhs.performer == rhs.performer
    }
}

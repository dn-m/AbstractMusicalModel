//
//  PerformanceContext.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

public struct PerformanceContext {
    
    let performer: Performer.Identifier
    let instrument: Instrument.Identifier
    let voice: Voice.Identifier
    
    public init(
        performer: Performer.Identifier = "P",
        instrument: Instrument.Identifier = "I",
        voice: Voice.Identifier = 0
    )
    {
        self.performer = performer
        self.instrument = instrument
        self.voice = voice
    }
}

extension PerformanceContext: Equatable {
    
    /// - returns: `true` if `performer`, `instrument` and `voice` values of each 
    /// `PerformanceContext` are equivalent.
    public static func == (lhs: PerformanceContext, rhs: PerformanceContext) -> Bool {
        return (
            lhs.performer == rhs.performer &&
            lhs.instrument == rhs.instrument &&
            lhs.voice == rhs.voice
        )
    }
}

//
//  PerformanceContext.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

public struct PerformanceContext {
    
    let performerIdentifier: Performer.Identifier
    let instrumentIdentifier: Instrument.Identifier
    let voice: Voice.Identifier
    
    public init(
        performer: Performer.Identifier,
        instrument: Instrument.Identifier,
        voice: Voice.Identifier
    )
    {
        self.performerIdentifier = performer
        self.instrumentIdentifier = instrument
        self.voice = voice
    }
}

extension PerformanceContext: Equatable {
    
    public static func == (lhs: PerformanceContext, rhs: PerformanceContext) -> Bool {
        return (
            lhs.performerIdentifier == rhs.performerIdentifier &&
            lhs.instrumentIdentifier == rhs.instrumentIdentifier &&
            lhs.voice == rhs.voice
        )
    }
}

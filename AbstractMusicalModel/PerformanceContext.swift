//
//  PerformanceContext.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

public struct PerformanceContext {
    
    public typealias PerformerIdentifier = Int
    public typealias InstrumentIdentifier = Int
    public typealias VoiceIdentifier = Int
    
    let performerID: PerformerIdentifier
    let instrumentID: InstrumentIdentifier
    let voice: Int
}

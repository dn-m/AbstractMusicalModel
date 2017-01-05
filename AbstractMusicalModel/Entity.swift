//
//  Entity.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import IntervalTools
import Rhythm

public struct Entity {
    
    /// Type of unique identifier. Provides shade for refactoring implementation.
    public typealias Identifier = Int
    
    /// Unique identifier for a single `Entity`.
    let identifier: Identifier
    
    /// `Performer` / `Instrument` / `Voice` context which is enacting this `Entity`.
    let context: PerformanceContext
    
    /// Interval in which this `Entity` occurs.
    ///
    /// - note: Currently only `MetricalDurationInterval` values. Expand outward incrementally.
    let interval: MetricalDurationInterval
}

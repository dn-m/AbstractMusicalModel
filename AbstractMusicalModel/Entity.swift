//
//  Entity.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import IntervalTools
import Rhythm

/// Durational and performative context for musical attributes.
/// 
/// - TODO: Consider making more generic re: `interval`.
public struct Entity {
    
    // MARK: - Associated Types
    
    /// Type of unique identifier. Provides shade for refactoring implementation.
    public typealias Identifier = Int
    
    // MARK: - Instance Properties
    
    /// `Performer` / `Instrument` / `Voice` context which is enacting this `Entity`.
    public let context: PerformanceContext
    
    /// Interval in which this `Entity` occurs.
    ///
    /// - note: Currently only `MetricalDurationInterval` values. Expand outward incrementally.
    public let interval: MetricalDurationInterval
    
    // MARK: - Initializers
    
    /// Create an `Entity` with a given `interval` and `context`.
    public init(interval: MetricalDurationInterval, context: PerformanceContext) {
        self.interval = interval
        self.context = context
    }
}

extension Entity: Equatable {
    
    public static func == (lhs: Entity, rhs: Entity) -> Bool {
        return lhs.context == rhs.context && lhs.interval == rhs.interval
    }
}

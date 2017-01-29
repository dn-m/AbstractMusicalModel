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
    /// - note: Currently only `MetricalDurationInterval` values. Make more geneic.
    public let interval: MetricalDurationInterval
    
    // MARK: - Initializers
    
    /// Create an `Entity` with a given `interval` and `context`.
    public init(interval: MetricalDurationInterval, context: PerformanceContext) {
        self.interval = interval
        self.context = context
    }
    
    /// - returns: `true` if an `Entity` is contained both within the given `interval` and 
    /// the given `scope`. Otherwise, `false`.
    public func isContained(
        in interval: MetricalDurationInterval,
        _ scope: PerformanceContext.Scope = PerformanceContext.Scope()
    ) -> Bool
    {
        return isContained(in: scope) && isContained(in: interval)
    }
    
    private func isContained(in scope: PerformanceContext.Scope) -> Bool {
        return scope.contains(context)
    }
    
    private func isContained(in interval: MetricalDurationInterval) -> Bool {
        let allowed: Relationship = [.equals, .contains, .startedBy, .finishedBy]
        return allowed.contains(interval.relationship(with: self.interval))
    }
}

extension Entity: Equatable {

    /// - returns: `true` if the `context` and `interval` of each `Entity` are equivalent.
    /// Otherwise, `nil`.
    public static func == (lhs: Entity, rhs: Entity) -> Bool {
        return lhs.context == rhs.context && lhs.interval == rhs.interval
    }
}

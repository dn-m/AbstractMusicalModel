//
//  Model.Context.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 6/22/17.
//
//

import ArithmeticTools
import Rhythm

//extension Model {
//
//    /// Durational and performative context for musical attributes.
//    public struct Context {
//        
//        // MARK: - Instance Properties
//        
//        /// `Performer` / `Instrument` / `Voice` context.
//        public let performanceContext: PerformanceContext
//        
//        /// Durational context.
//        public let interval: ClosedRange<MetricalDuration>
//        
//        // MARK: - Initializers
//        
//        /// Create a `Context` with a `performanceContext` and `interval`.
//        public init(
//            _ interval: ClosedRange<MetricalDuration> = .zero ... .zero,
//            _ performanceContext: PerformanceContext = PerformanceContext()
//            )
//        {
//            self.performanceContext = performanceContext
//            self.interval = interval
//        }
//        
//        // MARK: - Instance Methods
//        
//        /// - returns: `true` if an `Entity` is contained both within the given `interval` and
//        /// the given `scope`. Otherwise, `false`.
//        public func isContained(
//            in interval: ClosedRange<MetricalDuration>,
//            _ scope: PerformanceContext.Scope = PerformanceContext.Scope()
//        ) -> Bool
//        {
//            return isContained(in: scope) && isContained(in: interval)
//        }
//        
//        private func isContained(in scope: PerformanceContext.Scope) -> Bool {
//            return scope.contains(performanceContext)
//        }
//        
//        private func isContained(in interval: ClosedRange<MetricalDuration>) -> Bool {
//            let allowed: IntervalRelation = [.equals, .contains, .startedBy, .finishedBy]
//            return allowed.contains(interval.relation(with: self.interval))
//        }
//    }
//}
//
//extension Model.Context: Equatable {
//    
//    /// - returns: `true` if the `context` and `interval` of each `Context` are equivalent.
//    /// Otherwise, `nil`.
//    public static func == (lhs: Model.Context, rhs: Model.Context) -> Bool {
//        return lhs.performanceContext == rhs.performanceContext && lhs.interval == rhs.interval
//    }
//}

//
//  Model.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import Collections
import IntervalTools
import Rhythm

/// - TODO: Conform to `DictionaryWrapping`.
public final class Model {
    
    // MARK: - Associated Types
    
    /// Unique identifier for an `Attribute` and a `Context`.
    public typealias Entity = Int
    
    /// Mapping of an identifier of an `Entity` to a generic `Attribute`.
    public typealias Attribution <Attribute> = Dictionary<Entity, Attribute>
    
    /// Mapping of an identifier of an `Attribution` to an `Attribution`.
    public typealias AttributionCollection <Attribute> = Dictionary<
        AttributionIdentifier, Attribution<Attribute>
    >
    
    // MARK: - Nested Types
    
    /// Durational and performative context for musical attributes.
    public struct Context {
        
        // MARK: - Associated Types
        
        /// `Performer` / `Instrument` / `Voice` context.
        public let performanceContext: PerformanceContext
        
        /// Durational context.
        public let interval: MetricalDurationInterval
        
        // MARK: - Initializers
        
        /// Create a `Context` with a `performanceContext` and `interval`.
        public init(
            _ interval: MetricalDurationInterval = MetricalDurationInterval(.zero, .zero),
            _ performanceContext: PerformanceContext = PerformanceContext()
        )
        {
            self.performanceContext = performanceContext
            self.interval = interval
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
            return scope.contains(performanceContext)
        }
        
        private func isContained(in interval: MetricalDurationInterval) -> Bool {
            let allowed: Relationship = [.equals, .contains, .startedBy, .finishedBy]
            return allowed.contains(interval.relationship(with: self.interval))
        }
    }
    
    // MARK: - Instance Properties
    
    internal private(set) var entity: Entity = 0
    
    // `Entity` values stored by a unique identifier.
    /// - TODO: Make `private` / `fileprivate`
    internal var contexts: [Entity: Context] = [:]
    
    /// [AttributeID: [EntityID: Attribute]]
    internal var attributions: AttributionCollection <Any> = [:]

    // MARK: - Initializers
    
    /// Create an empty `Model`.
    public init() { }
    
    // MARK: - Instance Methods
    
    /// Add a generic `attribute`, of a given `kind`, within a given `context`.
    ///
    /// - Parameters:
    ///   - attribute: Any type of attribute (`Pitch`, `Dynamic`, `Int`, etc)
    ///   - kind: Label for the `kind` of attribute ("pitch", "dynamic", "fingering", etc.)
    ///   - context: `Context` for this attribute (who and when)
    ///
    /// - TODO: Instead of applying an `Entity` to a `PerformanceContext`, consider applying
    /// it to a `Scope`.
    public func put <Attribute> (
        _ attribute: Attribute,
        kind: AttributionIdentifier = "?",
        context: Context = Context()
    )
    {
        let entity = makeEntity()
        contexts[entity] = context
        try! attributions.update(attribute, keyPath: [kind, entity])
    }
    
    /// - returns: The `Context` with the given `identifier`, if it exists. Otherwise, `nil`.
    /// 
    /// - TODO: Make this a subscript
    public func context(identifier: Entity) -> Context? {
        return contexts[identifier]
    }

    /// - returns: Identifiers of all `Entity` values held here that are contained within the
    /// given `interval` and `scope` values.
    ///
    /// - TODO: Attributes
    /// - TODO: Refine `scope` to `scopes`
    public func entities(
        in interval: MetricalDurationInterval,
        performedBy scope: PerformanceContext.Scope = PerformanceContext.Scope(),
        including kinds: [AttributionIdentifier]? = nil
    ) -> [Entity]
    {
        
        // TODO: Inject kinds
        let kinds = kinds ?? Array(attributions.keys)
        let filtered = attributions.filter { kind, attribution in
            kinds.contains(kind)
        }

        return contexts
            .lazy
            .filter { identifier, entity in entity.isContained(in: interval, scope) }
            .map { $0.0 }
    }
    
    private func entities(of kinds: [AttributionIdentifier]) -> AttributionCollection<Any> {
        return Dictionary(attributions.filter { kind, _ in kinds.contains(kind) })
    }
    
    private func makeEntity() -> Entity {
        
        defer {
            entity += 1
        }
        
        return entity
    }
}

extension Model: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        return "\(attributions)"
    }
}

extension Model.Context: Equatable {
    
    /// - returns: `true` if the `context` and `interval` of each `Context` are equivalent.
    /// Otherwise, `nil`.
    public static func == (lhs: Model.Context, rhs: Model.Context) -> Bool {
        return lhs.performanceContext == rhs.performanceContext && lhs.interval == rhs.interval
    }
}

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

/// The database of musical information contained in a single musical _work_.
///
/// **Creating an empty `Model`:**
///
/// ```
/// let model = Model()
/// ```
///
/// ## Adding a new attribute to the model
///
/// ### Create a `Pitch` attribute
///
/// ```
/// let pitch = Pitch(60)
/// ```
///
/// ### Create the `Context` that will enact this `Pitch` value
///
/// ```
/// let instrument = Instrument("Violin")
/// let performer = Performer("Pat", [instrument])
/// let performanceContext = PerformanceContext(performer)
/// let interval = MetricalDurationInterval(MetricalDuration(1,8), MetricalDuration(2,8))
/// let context = Model.Context(interval, performanceContext)
/// ```
///
/// ### Add the `Pitch` value, with the `context` created above
///
/// ```
/// model.put(pitch, kind: "pitch", context: context)
/// ```
public final class Model {
    
    // MARK: - Associated Types
    
    /// Unique identifier for an `Attribute` and a `Context`.
    public typealias Entity = Int
    
    /// Type used to group classes of attributes ("pitch", "dynamics", "rhythm", etc.)
    public typealias AttributeKind = String
    
    /// Mapping of an identifier of an `Entity` to a generic `Attribute`.
    fileprivate typealias Attribution <Attribute> = Dictionary<Entity, Attribute>
    
    /// Mapping of an identifier of an `Attribution` to an `Attribution`.
    fileprivate typealias AttributionCollection <Attribute> = Dictionary<
        AttributeKind, Attribution<Attribute>
    >
    
    // MARK: - Nested Types
    
    /// Durational and performative context for musical attributes.
    public struct Context {
        
        // MARK: - Instance Properties
        
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
        
        // MARK: - Instance Methods
        
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
    fileprivate var contexts: [Entity: Context] = [:]
    
    /// [AttributeID: [EntityID: Attribute]]
    fileprivate var attributions: AttributionCollection <Any> = [:]

    // MARK: - Initializers
    
    /// Create an empty `Model`.
    public init() { }

    // MARK: - Instance Methods
    
    /// - returns: The context attribute for a given `Entity`, if present. Otherwise, `nil`.
    public subscript (entity: Entity) -> (attribute: Any, context: Context)? {
        
        guard let attribute = attribute(entity: entity) else {
            return nil
        }
        
        guard let context = contexts[entity] else {
            return nil
        }
        
        return (attribute, context)
    }
    
    /// Add a generic `attribute`, of a given `kind`, within a given `context`.
    ///
    /// - parameters:
    ///   - attribute: Any type of attribute (`Pitch`, `Dynamic`, `Int`, etc)
    ///   - kind: Label for the `kind` of attribute ("pitch", "dynamic", "fingering", etc.)
    ///   - context: `Context` for this attribute (who and when)
    ///
    /// - returns: `Entity` for the new attribute.
    @discardableResult public func put <Attribute> (
        _ attribute: Attribute,
        kind: AttributeKind = "?",
        context: Context = Context()
    ) -> Entity
    {
        let entity = makeEntity()
        contexts[entity] = context
        try! attributions.update(attribute, keyPath: [kind, entity])
        return entity
    }
    
    /// - returns: Identifiers of all `Entity` values held here that are contained within the
    /// given `interval` and `scope` values.
    ///
    /// - TODO: Refine `scope` to `scopes`
    public func entities(
        in interval: MetricalDurationInterval,
        performedBy scope: PerformanceContext.Scope = PerformanceContext.Scope(),
        including kinds: [AttributeKind]? = nil
    ) -> Set<Entity>
    {
        // If no `kinds` are specified, all possible are included
        let kinds = kinds ?? Array(attributions.keys)
        return entities(with: kinds) ∩ entities(in: interval, scope)
    }
    
    /// - returns: The `Context` with the given `entity`, if it exists. Otherwise, `nil`.
    ///
    /// - TODO: Make this a subscript
    public func context(entity: Entity) -> Context? {
        return contexts[entity]
    }
    
    /// - returns: The attribute for the given `entity`, if it exists. Otherwise, `nil`.
    public func attribute(entity: Entity) -> Any? {
        
        return attributions.lazy
            
            // disregard `kind`
            .flatMap { $0.1 }
            
            // pairs that match `entity`
            .filter { e, _ in e == entity }
            
            // extract only the `attribute`
            .map { $0.1 }
            
            // can only be one or zero results
            .first
    }
    
    private func entities(
        in interval: MetricalDurationInterval,
        _ scope: PerformanceContext.Scope = PerformanceContext.Scope()
    ) -> Set<Entity>
    {
        return Set(
            contexts
                .filter { _, context in context.isContained(in: interval, scope) }
                .map { $0.0 }
        )
    }
    
    private func entities(with kinds: [AttributeKind]) -> Set<Entity> {
        return Set(
            attributions
                .filter { kind, _ in kinds.contains(kind) }
                .flatMap { _, attribution in attribution.keys }
        )
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


// TODO: Move down to `Collections`
infix operator ∩: AdditionPrecedence
func ∩ <T> (a: Set<T>, b: Set<T>) -> Set<T> {
    return a.intersection(b)
}

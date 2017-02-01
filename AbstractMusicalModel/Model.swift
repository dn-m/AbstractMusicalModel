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

/// - TODO: Conform to `AnyCollectionWrapping`.
public final class Model {
    
    // MARK: - Instance Properties
    
    internal private(set) var identifier: Entity.Identifier = 0
    
    // `Entity` values stored by a unique identifier.
    /// - TODO: Make `private` / `fileprivate`
    internal var entities: [Entity.Identifier: Entity] = [:]
    
    /// [AttributeID: [EntityID: Attribute]]
    internal var attributions: AttributionCollection <Any> = [:]

    // MARK: - Initializers
    
    /// Create an empty `Model`.
    public init() { }
    
    // MARK: - Instance Methods
    
    /// Add a generic attribute, of a given `kind`, within a given `interval`, with a given
    /// `context`.
    ///
    /// - Parameters:
    ///   - attribute: Any type of attribute (`Pitch`, `Dynamic`, `Int`)
    ///   - kind: Kind of attribute ("pitch", "dynamic", "fingering", etc.)
    ///   - interval: `MetricalDurationInterval` in which this attribute occurs
    ///   - context: `PerformanceContext` enacting this attribute
    ///
    /// - TODO: Instead of applying an `Entity` to a `PerformanceContext`, consider applying
    /// it to a `Scope`.
    public func addAttribute <Attribute> (
        _ attribute: Attribute,
        kind: String = "attribute",
        interval: MetricalDurationInterval = MetricalDurationInterval(.zero, .zero),
        context: PerformanceContext = PerformanceContext()
    )
    {
        let (entity, entityID) = makeEntityWithIdentifier(in: interval, with: context)
        entities[entityID] = entity
        try! attributions.update(attribute, keyPath: [kind, entityID])
    }
    
    /// - returns: The `Entity` with the given `identifier`, if it exists. Otherwise, `nil`.
    /// 
    /// - TODO: Make this a subscript?
    public func entity(identifier: Entity.Identifier) -> Entity? {
        return entities[identifier]
    }

    /// - returns: Identifiers of all `Entity` values held here that are contained within the
    /// given `interval` and `scope` values.
    ///
    /// - TODO: Refine `scope` to `scopes`
    public func entities(
        in interval: MetricalDurationInterval,
        performedBy scope: PerformanceContext.Scope = PerformanceContext.Scope(),
        including kinds: [AttributionIdentifier]? = nil
    )
        -> [Entity.Identifier]
    {
        
        // TODO: Inject kinds
        let kinds = kinds ?? Array(attributions.keys)
        let filtered = attributions.filter { kind, attribution in
            kinds.contains(kind)
        }

        return entities
            .lazy
            .filter { _, entity in entity.isContained(in: interval, scope) }
            .map { $0.0 }
    }
    
    public func entities(of kinds: [AttributionIdentifier]) -> AttributionCollection<Any> {
        return Dictionary(attributions.filter { kind, _ in kinds.contains(kind) })
    }
    
    private func makeEntityWithIdentifier(
        in interval: MetricalDurationInterval,
        with context: PerformanceContext
    ) -> (Entity, Entity.Identifier)
    {
        defer { identifier += 1 }
        let entity = Entity(interval: interval, context: context)
        return (entity, identifier)
    }
}

extension Model: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        return "\(attributions)"
    }
}

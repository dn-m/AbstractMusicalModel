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
    private var entities: [Entity.Identifier: Entity] = [:]
    internal var attributions: AttributionCollection <Any> = [:]

    // MARK: - Initializers
    
    /// Create an empty `Model`.
    public init() { }
    
    // MARK: - Instance Methods
    
    /// Add an generic attribute, of a given `kind`, within a given `interval, with a given
    /// `context`.
    ///
    /// - TODO: Improve naming for `attributeID`.
    public func addAttribute <Attribute> (
        _ attribute: Attribute,
        identifier attributeID: String,
        interval: MetricalDurationInterval,
        context: PerformanceContext
    ) throws
    {
        let (entity, entityID) = makeEntityWithIdentifier(in: interval, with: context)
        entities[entityID] = entity
        try attributions.update(attribute, keyPath: [attributeID, entityID])
    }
    
    /// - returns: The `Entity` with the given `identifier`, if it exists. Otherwise, `nil`.
    /// 
    /// - TODO: Make this a subscript?
    public func entity(identifier: Entity.Identifier) -> Entity? {
        return entities[identifier]
    }

    /// - returns: Identifiers of all `Entity` values held here that are contained within the
    /// given `interval` and `scope` values.
    public func entities(
        in interval: MetricalDurationInterval,
        _ scope: PerformanceContext.Scope = PerformanceContext.Scope()
    )
        -> [Entity.Identifier]
    {
        return entities
            .lazy
            .filter { _, entity in entity.isContained(by: interval, scope) }
            .map { $0.0 }
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

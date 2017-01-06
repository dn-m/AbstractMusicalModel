//
//  Model.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import Collections
import Rhythm

public final class Model {
    
    // MARK: - Instance Properties
    
    internal private(set) var identifier: Entity.Identifier = 0
    
    // `Entity` values stored by a unique identifier.
    /// - TODO: Make `private` / `fileprivate`
    internal var entities: [Entity.Identifier: Entity] = [:]
    internal var attributions: AttributionCollection <Any> = [:]

    // MARK: - Initializers
    
    public init() { }
    
    // MARK: - Instance Methods
    
    /// Add an generic attribute, of a given `kind`, within a given `interval, with a given
    /// `context`.
    public func addAttribute <Attribute> (
        _ attribute: Attribute,
        identifier attributeID: String,
        interval: MetricalDurationInterval,
        context: PerformanceContext
    ) throws
    {
        let (entityID, entity) = makeEntity(in: interval, with: context)
        entities[entityID] = entity
        try attributions.update(attribute, keyPath: [attributeID, entityID])
    }
    
    /// - returns: The `Entity` with the given `identifier`, if it exists. Otherwise, `nil`.
    public func entity(identifier: Entity.Identifier) -> Entity? {
        return entities[identifier]
    }
    
    private func makeEntity(
        in interval: MetricalDurationInterval,
        with context: PerformanceContext
    ) -> (Entity.Identifier, Entity)
    {
        defer { identifier += 1 }
        let entity = Entity(interval: interval, context: context)
        return (identifier, entity)
    }
}

extension Model: CustomStringConvertible {
    
    public var description: String {
        
        return ""
    }
}

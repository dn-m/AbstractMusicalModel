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
        let (entity, entityID) = makeEntityWithIdentifier(in: interval, with: context)
        entities[entityID] = entity
        
        // FIXME: Fix Collections update API !
        if attributions[attributeID] != nil {
            attributions[attributeID]![entityID] = attribute
        } else {
            attributions[attributeID] = [entityID: attribute]
        }
        
        //try attributions.update(attribute, keyPath: [attributeID, entityID])
    }
    
    public func entities(in interval: MetricalDurationInterval) -> [Entity.Identifier] {
        
        // TODO: Refactor
        let allowed: Relationship = [.contains, .starts, .finishes]
        return entities
            .filter { id, entity
                in allowed.contains(entity.interval.relationship(with: interval))
            }.reduce([:]) { accum, idAndEntity in
                var accum = accum
                let (id, entity) = idAndEntity
                accum[id] = entity
                return accum
            }.map { $0.0 }
    }
    
    /// - returns: The `Entity` with the given `identifier`, if it exists. Otherwise, `nil`.
    public func entity(identifier: Entity.Identifier) -> Entity? {
        return entities[identifier]
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
    
    public var description: String {
        return "\(attributions)"
    }
}

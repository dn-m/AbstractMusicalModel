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
    
    internal private(set) var identifier: Entity.Identifier = 0
    
    // `Entity` values stored by a unique identifier.
    private var entities: [Entity.Identifier: Entity] = [:]
    
    private var attributions: AttributionCollection <Any> = [:]
    
    // TODO: Make `throws`.
    // FIXME: Confront API, types, etc.
    public func add <Attribute> (
        attribute: Attribute,
        identifier attributionID: String,
        in interval: MetricalDurationInterval,
        with context: PerformanceContext
    )
    {
        let (entityID, entity) = makeEntity(in: interval, with: context)
        entities[entityID] = entity
        
        // FIXME: This will be throwing with update to `Collections` API.
        attributions.update(attribute, keyPath: [attributionID.hashValue, entityID])
    }
    
    public func makeEntity(
        in interval: MetricalDurationInterval,
        with context: PerformanceContext
    ) -> (Entity.Identifier, Entity)
    {
        defer { identifier += 1 }
        let entity = Entity(interval: interval, context: context)
        return (identifier, entity)
    }
    
    public init() { }
}

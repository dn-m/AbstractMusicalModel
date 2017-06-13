//
//  Model.Builder.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 6/13/17.
//
//

import Collections
import ArithmeticTools
import Rhythm
import Pitch

extension Model {
    
    public class Builder {
        
        internal private(set) var entity: Entity = 0
        
        // `Entity` values stored by a unique identifier.
        /// - TODO: Make `private` / `fileprivate`
        private var contexts: [Entity: Context] = [:]
        
        /// `[AttributeKind: [Entity: Attribute]]`
        private var attributions: AttributionCollection <Any> = [:]
        
        /// `[Entity: [Entity]]`
        private var events: [Entity: Event] = [:]
        
        private let tempoStratumBuilder = Tempo.Stratum.Builder()
        
        private var meters: [Meter] = []
        
        public init() { }
        
        /// Add the given `tempo` at the given `offset`, and whether or not it shall be
        /// prepared to interpolate to the next given tempo.
        public func add(
            _ tempo: Tempo,
            at offset: MetricalDuration,
            interpolating: Bool = false
        )
        {
            tempoStratumBuilder.add(tempo, at: offset, interpolating: interpolating)
        }
        
        public func add(_ meter: Meter) {
            meters.append(meter)
        }
        
        // Creation
        /// Add a generic `attribute`, of a given `kind`, within a given `context`.
        ///
        /// - parameters:
        ///   - attribute: Any type of attribute (`Pitch`, `Dynamic`, `Int`, etc)
        ///   - kind: Label for the `kind` of attribute ("pitch", "dynamic", "fingering", etc.)
        ///   - context: `Context` for this attribute (who and when)
        ///
        /// - returns: `Entity` for the new attribute.
        @discardableResult public func add <Attribute> (
            _ attribute: Attribute,
            kind: AttributeKind = "?",
            in context: Context = Context()
        ) -> Entity
        {
            let entity = makeEntity()
            contexts[entity] = context
            try! attributions.update(attribute, keyPath: [kind, entity])
            return entity
        }
        
        public func build() -> Model {
            
            let tempi = tempoStratumBuilder.build()
            let meterStructure = Meter.Structure(meters: meters, tempi: tempi)
            
            return Model(
                attributions: attributions,
                events: events,
                contexts: contexts,
                meterStructure: meterStructure
            )
        }
        
        // Creation
        private func makeEntity() -> Entity {
            
            defer {
                entity += 1
            }
            
            return entity
        }
    }
}

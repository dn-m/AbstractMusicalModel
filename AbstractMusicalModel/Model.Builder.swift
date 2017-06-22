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

public struct NamedAttribute {
    
    let name: String
    let attribute: Any
    
    public init(_ attribute: Any, name: String) {
        self.attribute = attribute
        self.name = name
    }
}

extension Model {
    
    /// ## Creating a `Model` with a `Model.Builder`.
    ///
    /// The `AbstractMusicalModel` is a static database, containing the musical information of 
    /// a single _work_. In order to create an `AbstractMusicalModel`, we can use a `Builder`,
    /// which decouples the construction process of the model from the completed structure.
    ///
    /// First, create a `Builder`:
    ///
    ///     let builder = Model.Builder()
    ///
    /// Then, we can put things in it:
    ///
    ///     // Create a middle-c, to be played by "Pat" on the "Violin", starting on the
    ///     // second quarter-note of the piece, and will last for a single quarter-note.
    ///     let pitch = Pitch(60) // middle c
    ///     let instrument = Instrument("Violin")
    ///     let performer = Performer("Pat", [instrument])
    ///     let performanceContext = PerformanceContext(performer)
    ///     let interval = 1/>4...2/>4
    ///     let context = Model.Context(interval, performanceContext)
    ///
    ///     // Now, we can ask the `Builder` to add it:
    ///     builder.add(pitch, kind: "pitch", in: context)
    ///
    /// Lastly, we can ask for the `AbstractMusicModel` in completed form:
    ///
    ///     let model = builder.build()
    ///
    public class Builder {
        
        internal private(set) var entity: Entity = 0
        
        // `Entity` values stored by a unique identifier.
        /// - TODO: Make `private` / `fileprivate`
        private var contexts: [Entity: Context] = [:]
        
        /// `[AttributeKind: [Entity: Attribute]]`
        internal var attributions: AttributionCollection <Any> = [:]
        
        /// `[Entity: [Entity]]`
        internal var events: [Entity: Event] = [:]
        
        internal let tempoStratumBuilder = Tempo.Stratum.Builder()
        
        internal var meters: [Meter] = []
        
        private var performanceContext: PerformanceContext?
        
        public init() { }
        
        public func set(_ performanceContext: PerformanceContext) -> Builder {
            self.performanceContext = performanceContext
            return self
        }
        
        /// Add the given `tempo` at the given `offset`, and whether or not it shall be
        /// prepared to interpolate to the next given tempo.
        @discardableResult public func add(
            _ tempo: Tempo,
            at offset: MetricalDuration,
            interpolating: Bool = false
        ) -> Builder
        {
            tempoStratumBuilder.add(tempo, at: offset, interpolating: interpolating)
            return self
        }
        
        /// Initializes `Event` values for each `.event` leaf in the given `rhythm`.
        public func add(_ rhythm: Rhythm<Int>) -> Builder {
            
            // Map the rhythm so that each `.event` (i.e., non-rest / non-tie) leaf has a 
            // unique identifier for storage.
            let rhythm = rhythm.map { [unowned self] _ in self.makeEntity() }
            
            // Store the rhythm, and each of its `.event` leaves.
            store(rhythm)

            return self
        }
        
        private func store(_ rhythm: Rhythm<Int>) {
            try! attributions.update(rhythm, keyPath: ["rhythm", makeEntity()])
            storeEvents(for: rhythm)
        }
        
        private func storeEvents(for rhythm: Rhythm<Int>) {
            rhythm.events.forEach { entity in events[entity] = [] }
        }
        
        public func add(_ attribute: Any, name: String) -> Entity {
            let entity = makeEntity()
            try! attributions.update(attribute, keyPath: [name, entity])
            return entity
        }
        
        public func add(_ rhythms: [Rhythm<Int>]) -> Builder {
            rhythms.forEach { rhythm in add(rhythm) }
            return self
        }
        
        // FIXME: Refactor
        public func zip(_ attributes: [NamedAttribute?]) -> Builder {
            
            var attributes = attributes
            
            for (_, rhythm) in attributions["rhythm"]! as! [Entity: Rhythm<Int>] {
                
                for eventEntity in rhythm.events {
                    
                    guard let attribute = attributes.first else {
                        fatalError("Not enough attributes")
                    }
                    
                    let maybeAttr = attributes.remove(at: 0)
                    
                    guard let attr = maybeAttr else {
                        continue
                    }
                    
                    let attributeEntity = add(attr.attribute, name: attr.name)
                    events.safelyAppend(attributeEntity, toArrayWith: eventEntity)
                }
            }
            
            return self
        }
        
        @discardableResult public func add(_ meter: Meter) -> Builder {
            meters.append(meter)
            return self
        }
        
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
        ) -> Builder
        {
            let entity = makeEntity()
            contexts[entity] = context
            try! attributions.update(attribute, keyPath: [kind, entity])
            return self
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
        
        private func makeEntity() -> Entity {

            defer {
                entity += 1
            }
            
            return entity
        }
    }
    
    public static var builder: Builder {
        return Builder()
    }
}

extension Model.Builder: CustomStringConvertible {
    
    public var description: String {
        return "\(attributions)"
    }
}

extension Rhythm {
    var events: [T] {
        return leaves.flatMap { leaf in
            switch leaf.context {
            case .instance(let absenceOrEvent):
                switch absenceOrEvent {
                case .event(let value):
                    return value
                default:
                    return nil
                }
            default:
                return nil
            }
        }
    }
}

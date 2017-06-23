//
//  Model.Builder.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 6/13/17.
//
//

import Foundation
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
    ///
    ///     // Now, we can ask the `Builder` to add it:
    ///     builder.add(pitch, label: "pitch", with: performanceContext, in: interval)
    ///
    /// Lastly, we can ask for the `AbstractMusicModel` in completed form:
    ///
    ///     let model = builder.build()
    ///
    public class Builder {
        
        /// Concrete values associated with a given unique identifier.
        public var values: [UUID: Any] = [:]
        
        /// `PerformanceContext.Path` for each entity.
        public var performanceContexts: [UUID: PerformanceContext.Path] = [:]
        
        /// Interval of each entity.
        ///
        /// - TODO: Keep sorted by interval.lowerBound
        /// - TODO: Create a richer offset type (incorporating metrical and non-metrical sections)
        public var intervals: [UUID: ClosedRange<Fraction>] = [:]
        
        /// Collection of entities for a single event (all containing same
        /// `PerformanceContext.Path` and `interval`).
        public var events: [UUID: [UUID]] = [:]
        
        /// Entities stored by their label (e.g., "rhythm", "pitch", "articulation", etc.)
        public var byLabel: [String: [UUID]] = [:]
        
        // MARK: - Tempo Strata
        
        internal let tempoStratumBuilder = Tempo.Stratum.Builder()
        internal var meters: [Meter] = []
        
        // MARK: - Private State
        private var performanceContext: PerformanceContext?
        
        public init() { }
        
        @discardableResult public func add(
            _ event: [NamedAttribute],
            with performanceContext: PerformanceContext.Path,
            in interval: ClosedRange<Fraction>
        ) -> Builder
        {
            let entities = event.map { namedAttribute in
                createEntity(for: namedAttribute, with: performanceContext, in: interval)
            }   
            createEvent(for: entities)
            return self
        }
        
        private func createEvent(for entities: [UUID]) {
            let eventID = UUID()
            events[eventID] = entities
        }
        
        @discardableResult public func add(
            _ value: Any,
            label: String,
            with performanceContext: PerformanceContext.Path,
            in interval: ClosedRange<Fraction>
        ) -> Builder
        {
            createEntity(for: value, label: label, with: performanceContext, in: interval)
            return self
        }
        
        @discardableResult private func createEntity(
            for value: NamedAttribute,
            with performanceContext: PerformanceContext.Path,
            in interval: ClosedRange<Fraction>
        ) -> UUID
        {
            return createEntity(
                for: value.attribute,
                label: value.name,
                with: performanceContext,
                in: interval
            )
        }
        
        @discardableResult private func createEntity(
            for value: Any,
            label: String,
            with performanceContext: PerformanceContext.Path,
            in interval: ClosedRange<Fraction>
        ) -> UUID
        {
            let id = UUID()
            values[id] = value
            byLabel.safelyAppend(id, toArrayWith: label)
            performanceContexts[id] = performanceContext
            intervals[id] = interval
            return id
        }
        
//        public func set(_ performanceContext: PerformanceContext) -> Builder {
//            self.performanceContext = performanceContext
//            return self
//        }
        
//        /// Add the given `tempo` at the given `offset`, and whether or not it shall be
//        /// prepared to interpolate to the next given tempo.
//        @discardableResult public func add(
//            _ tempo: Tempo,
//            at offset: MetricalDuration,
//            interpolating: Bool = false
//        ) -> Builder
//        {
//            tempoStratumBuilder.add(tempo, at: offset, interpolating: interpolating)
//            return self
//        }
//        
//        /// Initializes `Event` values for each `.event` leaf in the given `rhythm`.
//        public func add(_ rhythm: Rhythm<Int>) -> Builder {
//            
//            // Map the rhythm so that each `.event` (i.e., non-rest / non-tie) leaf has a 
//            // unique identifier for storage.
//            let rhythm = rhythm.map { _ in UUID() }
//            
//            // Store the rhythm, and each of its `.event` leaves.
//            store(rhythm)
//
//            return self
//        }
//        
//        private func store(_ rhythm: Rhythm<UUID>) {
//            let entity = UUID()
//            values[entity] = rhythm
//            byLabel.safelyAppend(entity, toArrayWith: "rhythm")
//            //try! attributions.update(rhythm, keyPath: ["rhythm", UUID()])
//            storeEvents(for: rhythm)
//        }
//        
//        private func storeEvents(for rhythm: Rhythm<UUID>) {
//            rhythm.events.forEach { entity in values[entity] = [] }
//            rhythm.events.forEach { entity in events[entity] = [] }
//        }
        
//        public func add(_ attribute: Any, name: String) -> UUID {
//            let entity = UUID()
//            try! attributions.update(attribute, keyPath: [name, entity])
//            return entity
//        }
        
//        public func add(_ rhythms: [Rhythm<Int>]) -> Builder {
//            rhythms.forEach { rhythm in add(rhythm) }
//            return self
//        }
        
//        // FIXME: Refactor
//        public func zip(_ attributes: [NamedAttribute?]) -> Builder {
//            
//            var attributes = attributes
//            
//            for (_, rhythm) in attributions["rhythm"]! as! [Entity: Rhythm<Entity>] {
//                
//                for eventEntity in rhythm.events {
//                    
//                    guard !attributes.isEmpty else {
//                        fatalError("Not enough attributes")
//                    }
//                    
//                    let maybeAttr = attributes.remove(at: 0)
//                    
//                    guard let attr = maybeAttr else {
//                        continue
//                    }
//                    
//                    let attributeEntity = add(attr.attribute, name: attr.name)
//                    events.safelyAppend(attributeEntity, toArrayWith: eventEntity)
//                }
//            }
//            
//            return self
//        }
        
//        @discardableResult public func add(_ meter: Meter) -> Builder {
//            meters.append(meter)
//            return self
//        }
        
//        /// Add a generic `attribute`, of a given `kind`, within a given `context`.
//        ///
//        /// - parameters:
//        ///   - attribute: Any type of attribute (`Pitch`, `Dynamic`, `Int`, etc)
//        ///   - kind: Label for the `kind` of attribute ("pitch", "dynamic", "fingering", etc.)
//        ///   - context: `Context` for this attribute (who and when)
//        ///
//        /// - returns: `Entity` for the new attribute.
//        @discardableResult public func add <Attribute> (
//            _ attribute: Attribute,
//            kind: AttributeKind = "?",
//            in context: Context = Context()
//        ) -> Builder
//        {
//            let entity = UUID()
//            contexts[entity] = context
//            try! attributions.update(attribute, keyPath: [kind, entity])
//            return self
//        }
        
        public func build() -> Model {
            
            let tempi = tempoStratumBuilder.build()
            let meterStructure = Meter.Structure(meters: meters, tempi: tempi)
            
            return Model(
                values: values,
                performanceContexts: performanceContexts,
                intervals: intervals,
                events: events,
                byLabel: byLabel,
                meterStructure: meterStructure
            )
        }
    }
    
    public static var builder: Builder {
        return Builder()
    }
}

extension Model.Builder: CustomStringConvertible {
    
    public var description: String {
        return "\(values)"
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

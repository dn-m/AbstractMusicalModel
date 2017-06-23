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
        internal var values: [UUID: Any] = [:]
        
        /// `PerformanceContext.Path` for each entity.
        internal var performanceContexts: [UUID: PerformanceContext.Path] = [:]
        
        /// Interval of each entity.
        ///
        /// - TODO: Keep sorted by interval.lowerBound
        /// - TODO: Create a richer offset type (incorporating metrical and non-metrical sections)
        internal var intervals: [UUID: ClosedRange<Fraction>] = [:]
        
        /// Collection of entities for a single event (all containing same
        /// `PerformanceContext.Path` and `interval`).
        internal var events: [UUID: [UUID]] = [:]
        
        /// Entities stored by their label (e.g., "rhythm", "pitch", "articulation", etc.)
        internal var byLabel: [String: [UUID]] = [:]
        
        internal var rhythmOffsets: [UUID: Fraction] = [:]
        
        // MARK: - Tempo Strata
        
        internal let tempoStratumBuilder = Tempo.Stratum.Builder()
        internal var meters: [Meter] = []
        
        // MARK: - Initializers
        
        /// Creates `Builder` prepared to construct a `Model`.
        public init() { }
        
        /// Add the given `rhythm` at the given `offset`, zipping the given `events`, with
        /// the given `performanceContext`.
        ///
        /// - TODO: Interrogate `Rhythm<Int> type`
        ///
        @discardableResult public func add(
            _ rhythm: Rhythm<Int>,
            at offset: Fraction,
            with events: [[NamedAttribute]],
            and performanceContext: PerformanceContext.Path = PerformanceContext.Path()
        ) -> Builder
        {
            guard events.count == rhythm.events.count else {
                fatalError("Incompatible rhythm and events!")
            }
            
            // Create UUIDs for each event in the given `rhythm`.
            let rhythm = rhythm.map { _ in UUID() }
            
            // Store rhythm
            let rhythmID = createEntity(for: rhythm, label: "rhythm")
            rhythmOffsets[rhythmID] = offset
            
            // Store each event
            var events = events
            for eventEntity in rhythm.events {
                
                guard !events.isEmpty else {
                    fatalError("Incompatible events for rhythm")
                }
                
                // Create event
                self.events[eventEntity] = createEntities(for: events.remove(at: 0))
            }
            
            return self
        }
        
        @discardableResult public func add(
            _ event: [NamedAttribute],
            with performanceContext: PerformanceContext.Path = PerformanceContext.Path(),
            in interval: ClosedRange<Fraction>? = nil
        ) -> Builder
        {
            let entities = event.map { namedAttribute in
                createEntity(for: namedAttribute, with: performanceContext, in: interval)
            }
            createEvent(for: entities)
            return self
        }
        
        @discardableResult public func add(
            _ value: Any,
            label: String,
            with performanceContext: PerformanceContext.Path = PerformanceContext.Path(),
            in interval: ClosedRange<Fraction>? = nil
        ) -> Builder
        {
            createEntity(for: value, label: label, with: performanceContext, in: interval)
            return self
        }
        
        // MARK: - Private
        
        @discardableResult private func createEntity(
            for value: NamedAttribute,
            with performanceContext: PerformanceContext.Path = PerformanceContext.Path(),
            in interval: ClosedRange<Fraction>? = nil
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
            with performanceContext: PerformanceContext.Path = PerformanceContext.Path(),
            in interval: ClosedRange<Fraction>? = nil
        ) -> UUID
        {
            let id = UUID()
            values[id] = value
            byLabel.safelyAppend(id, toArrayWith: label)
            performanceContexts[id] = performanceContext
            intervals[id] = interval
            return id
        }
        
        @discardableResult private func createEntities(
            for namedAttributes: [NamedAttribute],
            with performanceContext: PerformanceContext.Path = PerformanceContext.Path()
        ) -> [UUID]
        {
            return namedAttributes.map { namedAttribute in
                createEntity(for: namedAttribute, with: performanceContext)
            }
        }
        
        private func createEvent(for entities: [UUID]) {
            let eventID = UUID()
            events[eventID] = entities
        }
        
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
        
        public func build() -> Model {
            
            // complete rhythms
            for (rhythmID, offset) in rhythmOffsets {
                print("\(rhythmID): offset: \(offset)")
                let rhythm = values[rhythmID] as! Rhythm<UUID>
                let eventIntervals = rhythm.eventIntervals
                print(eventIntervals)
            }
            
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

/// - TODO: Move to `dn-m/Rhythm`.
extension Rhythm {
    var events: [T] {
        return leaves.flatMap { leaf in
            guard case let .instance(.event(value)) = leaf.context else { return nil }
            return value
        }
    }
    
    
    var eventIntervals: [ClosedRange<MetricalDuration>] {
        
        var result: [ClosedRange<MetricalDuration>] = []
        var start: MetricalDuration = .zero
        var current: MetricalDuration = .zero
        for (l,leaf) in leaves.enumerated() {

            switch leaf.context {
            case .continuation:
                break
            case .instance(let absenceOrEvent):
                switch absenceOrEvent {
                case .absence:
                    if current > .zero {
                        result.append(start ... current)
                    }
                    start = current + leaf.metricalDuration
                case .event:
                    
                    if let previous = leaves[safe: l-1] {
                        
                        if previous.context != .instance(.absence) {
                            result.append(start ... current)
                        }
                    }
                    
                    start = current
                }
            }
            
            current += leaf.metricalDuration
        }
        
        if leaves.last!.context != .instance(.absence) {
            result.append(start ... current)
        }
        
        return result
    }
}

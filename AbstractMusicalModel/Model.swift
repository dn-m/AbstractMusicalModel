//
//  Model.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import Collections
import ArithmeticTools
import Rhythm

/// The database of musical information contained in a single musical _work_.
public final class Model {
    
    // MARK: - Associated Types
    
    /// Unique identifier for an `Attribute` and a `Context`.
    public typealias Entity = Int
    
    /// Type used to group classes of attributes ("pitch", "dynamics", "rhythm", etc.)
    public typealias AttributeKind = String
    
    public typealias Event = [Entity]
    
    /// Mapping of an identifier of an `Entity` to a generic `Attribute`.
    public typealias Attribution <Attribute> = Dictionary<Entity, Attribute>
    
    /// Mapping of an identifier of an `Attribution` to an `Attribution`.
    public typealias AttributionCollection <Attribute> =
        Dictionary<AttributeKind, Attribution<Attribute>>
    
    // MARK: - Nested Types
    
    
    
    // MARK: - Instance Properties
    
    internal private(set) var entity: Entity = 0

    /// `[AttributeKind: [Entity: Attribute]]`
    public let attributions: AttributionCollection<Any>
    
    /// `[Entity: [Entity]]`
    public let events: [Entity: Event]
    
    // `Entity` values stored by a unique identifier.
    /// - TODO: Make `private` / `fileprivate`
    public let contexts: [Entity: Context]
    
    /// `Meter.Structure` overlay.
    ///
    /// - TODO: Implement `TemporalStructure` enum (`Meter.Structure` / `Seconds` / etc.)
    /// - TODO: Refactor this into `temporalStructures: [TemporalStructure]`
    public var meterStructure: Meter.Structure?
    
    // MARK: - Initializers
    
    /// Creates a `Model` with the given `attributesion` and `meterStructure`, if there is one.
    public init(
        attributions: AttributionCollection<Any>,
        events: [Entity: Event],
        contexts: [Entity: Context],
        meterStructure: Meter.Structure? = nil
    )
    {
        self.attributions = attributions
        self.events = events
        self.contexts = contexts
        self.meterStructure = meterStructure
    }

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
    
    /// - returns: Identifiers of all `Entity` values held here that are contained within the
    /// given `interval` and `scope` values.
    ///
    /// - TODO: Refine `scope` to `scopes`
    public func entities(
        in interval: ClosedRange<MetricalDuration>,
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
        in interval: ClosedRange<MetricalDuration>,
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
}

extension Model: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        return "\(meterStructure)\n\(attributions)"
    }
}

// TODO: Move down to `Collections`
infix operator ∩: AdditionPrecedence
func ∩ <T> (a: Set<T>, b: Set<T>) -> Set<T> {
    return a.intersection(b)
}

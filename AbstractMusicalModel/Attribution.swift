//
//  Attribution.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

/// A mapping between a generic `Attribute` and an atomic `Event`.
///
/// - note: Consider splitting this out between `AtomicAttribution` and `SpanningAttribution`.
typealias Attribution <Attribute> = Dictionary<Event, Attribute>

/// The unique identifier for a given `Attribution`.
///
/// - note: This could be a `String` or an `Int`.
typealias AttributeIdentifier = String

/// Dictionary mapping `AttributionIdentifier` values to `Attribution` values.
typealias AttributionModel <Attribute> = Dictionary<AttributeIdentifier, Attribution>

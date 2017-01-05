//
//  Attribution.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

typealias Attribution <Attribute> = Dictionary<Entity.Identifier, Attribute>
typealias AttributionIdentifier = Int
typealias AttributionModel <Attribute> =
    Dictionary<AttributionIdentifier, Attribution<Attribute>>


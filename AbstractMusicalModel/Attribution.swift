//
//  Attribution.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

public typealias Attribution <Attribute> = Dictionary<Entity.Identifier, Attribute>
public typealias AttributionIdentifier = Int
public typealias AttributionCollection <Attribute> =
    Dictionary<AttributionIdentifier, Attribution<Attribute>>


//
//  Event.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

// Used primarily for a unique identifier.
// In the case that no extra info needs to be carried explicitly by this, 
// consider just using a numerical identifier.
public final class Event { }

extension Event: Equatable {
    
    public static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs === rhs
    }
}

extension Event: Hashable {
    
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
}

//
//  Spanner.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import Foundation

public final class Spanner { }

extension Spanner: Equatable {
    
    public static func == (lhs: Spanner, rhs: Spanner) -> Bool {
        return lhs === rhs
    }
}

extension Spanner: Hashable {
    
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
}

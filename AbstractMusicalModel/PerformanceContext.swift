//
//  PerformanceContext.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

/// Descriptor to whom (or what) a given `Entity` belongs.
public struct PerformanceContext {
    
    /// `Performer` of a given `PerformanceContext`.
    public let performer: Performer
    
    public init(_ performer: Performer = Performer("abc", [])) {
        self.performer = performer
    }
    
    // contains()
}

extension PerformanceContext: Equatable {
    
    /// - returns: `true` if the `performer` values of each `PerformanceContext` are
    /// equivalent.
    public static func == (lhs: PerformanceContext, rhs: PerformanceContext) -> Bool {
        return lhs.performer == rhs.performer
    }
}

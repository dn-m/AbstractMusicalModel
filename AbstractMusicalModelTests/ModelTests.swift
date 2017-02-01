//
//  ModelTests.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import XCTest
import IntervalTools
import Rhythm
import Pitch
@testable import AbstractMusicalModel

class ModelTests: XCTestCase {
    
    func testAddPitchAttribute() {
        let model = Model()
        model.put(Pitch(60), kind: "pitch")
        XCTAssertEqual(model.contexts.count, 1)
        XCTAssertEqual(model.attributions.count, 1)
        XCTAssertNotNil(model.contexts[0])
        XCTAssertEqual(model.attributions["pitch"]![0]! as! Pitch, 60)
    }
    
    func testAddPitchArrayAttribute() {
        let model = Model()
        let pitches: PitchSet = [60, 61, 62]
        model.put(pitches, kind: "pitch")
    }
    
    func testEntitySubscript() {
        
        let model = Model()
        let pitch: Pitch = 60
        
        let context = Model.Context(
            MetricalDurationInterval(.zero, .zero),
            PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        )
        
        model.put(pitch, kind: "pitch", context: context)

        let result = model.context(entity: 0)!
        let expected = context
        XCTAssertEqual(result, expected)
    }
    
    func testCustomStringConvertible() {
        let pitches: [Pitch] = [60,61,62,63,65,66,67,68,69,70,71,72]
        let model = Model()
        pitches.forEach { model.put($0, kind: "pitch") }
        print("model:\n\(model)")
    }
    
    func testSingleEntityNotInInterval() {
        
        let model = Model()
        let pitch: Pitch = 60
        
        let context = Model.Context(
            MetricalDurationInterval(MetricalDuration(1,8), MetricalDuration(2,8))
        )

        model.put(pitch, kind: "pitch", context: context)
        
        let searchInterval = MetricalDurationInterval(
            MetricalDuration(3,8),
            MetricalDuration(4,8)
        )
        
        XCTAssertEqual(model.entities(in: searchInterval).count, 0)
    }
    
    func testSingleEntityEqualToInterval() {
        let model = Model()
        let pitch: Pitch = 60
        let interval = MetricalDurationInterval(MetricalDuration(1,8), MetricalDuration(3,16))
        let context = Model.Context(interval)
        model.put(pitch, kind: "pitch", context: context)
        
        let searchInterval = MetricalDurationInterval(
            MetricalDuration(1,8),
            MetricalDuration(3,16)
        )
        
        XCTAssertEqual(model.entities(in: searchInterval).count, 1)
    }
    
    func testMultipleEntitiesContainedWithinScopeAndInterval() {
        
        // Prepare search interval
        let searchInterval = MetricalDurationInterval(
            MetricalDuration(4,8),
            MetricalDuration(8,8)
        )
        
        // Prepare search scopre
        let scope = PerformanceContext.Scope("P", "I")
        
        // Prepare entity outside of scope, inside interval (1)
        let contextA = Model.Context(
            MetricalDurationInterval(MetricalDuration(4,8), MetricalDuration(5,8)),
            PerformanceContext(Performer("P", [Instrument("J", [Voice(0)])]))
        )
        
        // Prepare entity inside scope, outside of interval (1)
        let contextB = Model.Context(
            MetricalDurationInterval(MetricalDuration(1,8), MetricalDuration(2,8)),
            PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        )
        
        // Prepare entity inside of scope and interval (1)
        let contextC = Model.Context (
            MetricalDurationInterval(MetricalDuration(4,8), MetricalDuration(5,8)),
            PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        )
        
        // Populate model
        let model = Model()
        model.put(1, kind: "pitch", context: contextA)
        model.put(1, kind: "pitch", context: contextB)
        model.put(1, kind: "pitch", context: contextC)

        XCTAssertEqual(model.entities(in: searchInterval, performedBy: scope).count, 1)
    }
    
    func testEntitiesWithAttributeIdentifiers() {
        
        // Prepare context outside of scope, inside interval (1)
        let contextA = Model.Context(
            MetricalDurationInterval(MetricalDuration(4,8), MetricalDuration(5,8)),
            PerformanceContext(Performer("P", [Instrument("J", [Voice(0)])]))
        )
        
        // Prepare entity inside scope, outside of interval (1)
        let contextB = Model.Context(
            MetricalDurationInterval(MetricalDuration(1,8), MetricalDuration(2,8)),
            PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        )
        
        // Prepare entity inside of scope and interval (1)
        let contextC = Model.Context (
            MetricalDurationInterval(MetricalDuration(4,8), MetricalDuration(5,8)),
            PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        )
        
        // Populate model
        let model = Model()
        
        // matches kind but not context
        model.put(1, kind: "pitch", context: contextA)
        
        // matches kind but not context
        model.put(1, kind: "articulations", context: contextB)
        
        // matches all
        model.put(1, kind: "dynamics", context: contextC)
        
        // matches all
        model.put(1, kind: "pitch", context: contextC)
        
        // Prepare search interval
        let searchInterval = MetricalDurationInterval(
            MetricalDuration(4,8),
            MetricalDuration(8,8)
        )
        
        // Prepare search scope
        let scope = PerformanceContext.Scope("P", "I")
        
        // Prepare search kinds
        let kinds = ["pitch", "dynamics"]
        
        XCTAssertEqual(
            model.entities(in: searchInterval, performedBy: scope, including: kinds).count, 2
        )
    }
    
    func testSubscript() {
        let model = Model()
        let entity = model.put(1, kind: "pitch")
        XCTAssertEqual(entity, 0)
        XCTAssertEqual(model[0]!.0 as! Int, 1)
        XCTAssertEqual(model[0]!.1, Model.Context())
        
    }
}

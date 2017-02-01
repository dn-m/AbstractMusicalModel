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
        model.addAttribute(Pitch(60), kind: "pitch")
        XCTAssertEqual(model.entities.count, 1)
        XCTAssertEqual(model.attributions.count, 1)
        XCTAssertNotNil(model.entities[0])
        XCTAssertEqual(model.attributions["pitch"]![0]! as! Pitch, 60)
    }
    
    func testAddPitchArrayAttribute() {
        let model = Model()
        let pitches: PitchSet = [60, 61, 62]
        model.addAttribute(pitches, kind: "pitch")
    }
    
    func testEntitySubscript() {
        let model = Model()
        let pitch: Pitch = 60
        let interval = MetricalDurationInterval(.zero, .zero)
        let context = PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        model.addAttribute(pitch, kind: "pitch", interval: interval, context: context)

        let result = model.entity(identifier: 0)!
        let expected = Entity(interval: interval, context: context)
        XCTAssertEqual(result, expected)
    }
    
    func testCustomStringConvertible() {
        let pitches: [Pitch] = [60,61,62,63,65,66,67,68,69,70,71,72]
        let model = Model()
        pitches.forEach { model.addAttribute($0, kind: "pitch") }
        print("model:\n\(model)")
    }
    
    func testSingleEntityNotInInterval() {
        let model = Model()
        let pitch: Pitch = 60
        let interval = MetricalDurationInterval(MetricalDuration(1,8), MetricalDuration(2,8))
        model.addAttribute(pitch, kind: "pitch", interval: interval)
        
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
        model.addAttribute(pitch, kind: "pitch", interval: interval)
        
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
        let intervalA = MetricalDurationInterval(MetricalDuration(4,8), MetricalDuration(5,8))
        let contextA = PerformanceContext(Performer("P", [Instrument("J", [Voice(0)])]))
        
        // Prepare entity inside scope, outside of interval (1)
        let intervalB = MetricalDurationInterval(MetricalDuration(1,8), MetricalDuration(2,8))
        let contextB = PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        
        // Prepare entity inside of scope and interval (1)
        let intervalC = MetricalDurationInterval(MetricalDuration(4,8), MetricalDuration(5,8))
        let contextC = PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        
        // Populate model
        let model = Model()
        model.addAttribute(1, kind: "pitch", interval: intervalA, context: contextA)
        model.addAttribute(1, kind: "pitch", interval: intervalB, context: contextB)
        model.addAttribute(1, kind: "pitch", interval: intervalC, context: contextC)

        XCTAssertEqual(model.entities(in: searchInterval, performedBy: scope).count, 1)
    }
    
    func testEntitiesOfKinds() {

        let model = Model()
        
        // add 1 pitch
        model.addAttribute(1, kind: "pitch")
        
        // add 1 dynamic
        model.addAttribute("fff", kind: "dynamics")
        
        // add 1 articulation
        model.addAttribute(".", kind: "articulation")
        
        // Expect only to retrieve pitch / dynamics kinds
        let kinds = ["pitch", "dynamics"]
        XCTAssertEqual(model.entities(of: kinds).count, 2)
        
    }
    
    func testEntitiesWithAttributeIdentifiers() {
        
        // Prepare search interval
        let searchInterval = MetricalDurationInterval(
            MetricalDuration(4,8),
            MetricalDuration(8,8)
        )
        
        // Prepare search scope
        let scope = PerformanceContext.Scope("P", "I")
        
        // Prepare search kinds
        let kinds = ["pitch", "articulations"]
        
        // Prepare entity outside of scope, inside interval (1)
        let intervalA = MetricalDurationInterval(MetricalDuration(4,8), MetricalDuration(5,8))
        let contextA = PerformanceContext(Performer("P", [Instrument("J", [Voice(0)])]))
        
        // Prepare entity inside scope, outside of interval (1)
        let intervalB = MetricalDurationInterval(MetricalDuration(1,8), MetricalDuration(2,8))
        let contextB = PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        
        // Prepare entity inside scope and interval (1)
        let intervalC = MetricalDurationInterval(MetricalDuration(4,8), MetricalDuration(5,8))
        let contextC = PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        
        // Populate model
        let model = Model()
        model.addAttribute(1, kind: "pitch", interval: intervalA, context: contextA)
        model.addAttribute(1, kind: "articulations", interval: intervalB, context: contextB)
        
        // matches scope, interval, and kind
        model.addAttribute(1, kind: "dynamics", interval: intervalC, context: contextC)
        
        // matches scope, interval, and kind
        model.addAttribute(1, kind: "pitch", interval: intervalC, context: contextC)
        
        XCTAssertEqual(
            model.entities(in: searchInterval, performedBy: scope, including: kinds).count, 2
        )
    }
}

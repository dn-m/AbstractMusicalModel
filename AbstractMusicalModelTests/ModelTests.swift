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

    func add <T> (
        _ attribute: T,
        id: String = "id",
        to model: Model,
        interval: MetricalDurationInterval = MetricalDurationInterval(.zero, .zero),
        context: PerformanceContext = PerformanceContext()
    )
    {
        do {
            try model.addAttribute(attribute,
                identifier: id,
                interval: interval,
                context: context
            )
        } catch {
            XCTFail()
        }
    }
    
    func testAddAttributeWithoutThrowingError() {
        add(1, to: Model())
    }
    
    func testAddPitchAttribute() {
        let model = Model()
        add(Pitch(60), id: "pitch", to: model)
        XCTAssertEqual(model.entities.count, 1)
        XCTAssertEqual(model.attributions.count, 1)
        XCTAssertNotNil(model.entities[0])
        XCTAssertEqual(model.attributions["pitch"]![0]! as! Pitch, 60)
    }
    
    func testAddPitchArrayAttribute() {
        let model = Model()
        let pitches: PitchSet = [60, 61, 62]
        add(pitches, id: "pitch", to: model)
    }
    
    func testEntitySubscript() {
        let model = Model()
        let pitch: Pitch = 60
        let interval = MetricalDurationInterval(.zero, .zero)
        let context = PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        add(pitch, id: "pitch", to: model, interval: interval, context: context)

        let result = model.entity(identifier: 0)!
        let expected = Entity(interval: interval, context: context)
        XCTAssertEqual(result, expected)
    }
    
    func testCustomStringConvertible() {
        let pitches: [Pitch] = [60,61,62,63,65,66,67,68,69,70,71,72]
        let model = Model()
        pitches.forEach { add($0, id: "pitch", to: model) }
        print("model:\n\(model)")
    }
    
    func testSingleEntityNotInInterval() {
        let model = Model()
        let pitch: Pitch = 60
        let interval = MetricalDurationInterval(MetricalDuration(1,8), MetricalDuration(2,8))
        add(pitch, id: "pitch", to: model, interval: interval, context: PerformanceContext())
        
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
        add(pitch, id: "pitch", to: model, interval: interval, context: PerformanceContext())
        
        let searchInterval = MetricalDurationInterval(
            MetricalDuration(1,8),
            MetricalDuration(3,16)
        )
        
        XCTAssertEqual(model.entities(in: searchInterval).count, 1)
    }
    
    func testMultipleEntitiesContainedWithinScopeAndInterval() {
        
        // Prepare boundaries of search
        let searchInterval = MetricalDurationInterval(
            MetricalDuration(4,8),
            MetricalDuration(8,8)
        )
        
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
        add(Pitch(60), id: "pitch", to: model, interval: intervalA, context: contextA)
        add(Pitch(60), id: "pitch", to: model, interval: intervalB, context: contextB)
        add(Pitch(60), id: "pitch", to: model, interval: intervalC, context: contextC)
        
        XCTAssertEqual(model.entities(in: searchInterval, scope).count, 1)
    }
}

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
    
//    func testEntitySubscript() {
//        let model = Model()
//        let pitch: Pitch = 60
//        let interval = MetricalDurationInterval(.zero, .zero)
//        let context = PerformanceContext(performer: "a", instrument: "b", voice: 0)
//        add(pitch, id: "pitch", to: model, interval: interval, context: context)
//
//        let result = model.entity(identifier: 0)!
//        let expected = Entity(interval: interval, context: context)
//        XCTAssertEqual(result, expected)
//    }
    
    func testCustomStringConvertible() {
        let pitches: [Pitch] = [60,61,62,63,65,66,67,68,69,70,71,72]
        let model = Model()
        pitches.forEach { add($0, id: "pitch", to: model) }
        print("model:\n\(model)")
    }
    
    func testSingleEntityNotInInterval() {
        let model = Model()
        let pitch: Pitch = 60
        let interval = MetricalDurationInterval(MetricalDuration(1,8), MetricalDuration(3,16))
        add(pitch, id: "pitch", to: model, interval: interval, context: PerformanceContext())
        
        let searchInterval = MetricalDurationInterval(
            MetricalDuration(5,16),
            MetricalDuration(13,32)
        )
        
        XCTAssertEqual(model.entities(in: searchInterval), [])
    }
    
    func testSingleEntityInInterval() {
        let model = Model()
        
    }
}

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

    func testAddAttribute() {
        let model = Model()
        let attribute = 1
        let interval = MetricalDurationInterval(.zero, .zero)
        let context = PerformanceContext(performer: "a", instrument: "b", voice: 0)
        
        do {
            
            try model.addAttribute(attribute,
                kind: "kind",
                interval: interval,
                context: context
            )
            
        } catch {
            XCTFail()
        }
    }
    
    func testAddPitchAttribute() {
        
        // Prepare model
        let model = Model()
        
        // Prepare attribute
        let kind = "pitch"
        let pitch: Pitch = 60
        
        // Prepare context
        let interval = MetricalDurationInterval(.zero, .zero)
        let context = PerformanceContext(performer: "a", instrument: "b", voice: 0)
        
        do {
            try model.addAttribute(pitch,
                kind: kind,
                interval: interval,
                context: context
            )
        } catch {
            XCTFail()
        }

        XCTAssertEqual(model.entities.count, 1)
        XCTAssertEqual(model.attributions.count, 1)
        
        XCTAssertNotNil(model.entities[0])
        XCTAssertEqual(model.attributions[kind]![0]! as! Pitch, 60)

        try? model.addAttribute("a", kind: "pitch", interval: interval, context: context)
        print(model.attributions)
    }
    
    func testAddPitchArrayAttribute() {
        
        // Prepare model
        let model = Model()
        
        // Prepare attribute
        let kind = "pitch"
        let pitches: [Pitch] = [60, 61, 62]
        
        // Prepare context
        let interval = MetricalDurationInterval(.zero, .zero)
        let context = PerformanceContext(performer: "a", instrument: "b", voice: 0)
        
        do {
            try model.addAttribute(pitches, kind: kind, interval: interval, context: context)
            XCTAssert(model.attributions["pitch"]![0] is [Pitch])
        } catch {
            XCTFail()
        }
    }
}

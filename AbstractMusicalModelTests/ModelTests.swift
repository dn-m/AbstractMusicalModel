//
//  ModelTests.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import XCTest
import ArithmeticTools
import Rhythm
import Pitch
import AbstractMusicalModel

class ModelTests: XCTestCase {
    
    func testAddPitchArrayAttribute() {
        let model = Model()
        let pitches: PitchSet = [60, 61, 62]
        model.put(pitches, kind: "pitch")
    }
    
    func testEntitySubscript() {
        
        let model = Model()
        let pitch: Pitch = 60
        
        let context = Model.Context(
            .zero ... .zero,
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
        
        let context = Model.Context(1/>8 ... 2/>8)

        model.put(pitch, kind: "pitch", context: context)
        
        let searchInterval = 3/>8 ... 4/>8
        
        XCTAssertEqual(model.entities(in: searchInterval).count, 0)
    }
    
    func testSingleEntityEqualToInterval() {
        let model = Model()
        let pitch: Pitch = 60
        let interval = 1/>8 ... 3/>16
        let context = Model.Context(interval)
        model.put(pitch, kind: "pitch", context: context)
        
        let searchInterval = 1/>8 ... 3/>16
        
        XCTAssertEqual(model.entities(in: searchInterval).count, 1)
    }
    
    func testMultipleEntitiesContainedWithinScopeAndInterval() {
        
        // Prepare search interval
        let searchInterval = 4/>8 ... 8/>8
        
        // Prepare search scopre
        let scope = PerformanceContext.Scope("P", "I")
        
        // Prepare entity outside of scope, inside interval (1)
        let contextA = Model.Context(
            4/>8 ... 5/>8,
            PerformanceContext(Performer("P", [Instrument("J", [Voice(0)])]))
        )
        
        // Prepare entity inside scope, outside of interval (1)
        let contextB = Model.Context(
            1/>8 ... 2/>8,
            PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        )
        
        // Prepare entity inside of scope and interval (1)
        let contextC = Model.Context (
            4/>8 ... 5/>8,
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
            4/>8 ... 5/>8,
            PerformanceContext(Performer("P", [Instrument("J", [Voice(0)])]))
        )
        
        // Prepare entity inside scope, outside of interval (1)
        let contextB = Model.Context(
            1/>8 ... 2/>8,
            PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        )
        
        // Prepare entity inside of scope and interval (1)
        let contextC = Model.Context (
            4/>8 ... 5/>8,
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
        let searchInterval = 4/>8 ... 8/>8
        
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
    
    func testAddRhythm() {
        
        let model = Model()
        
        let events: [[(String, Any)]] = [
            [("pitch", 60)],
            [("pitch", 61)],
            [("pitch", 62)],
            [("pitch", 63)]
        ]
        
        let rt = RhythmTree<Int>(
            3/>16 * [1,2,3,1],
            [
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0))
            ]
        )
    }
}

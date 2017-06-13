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
        let builder = Model.Builder()
        let pitches: PitchSet = [60, 61, 62]
        builder.add(pitches, kind: "pitch")
        let model = builder.build()
    }
    
    func testEntitySubscript() {
        
        let builder = Model.Builder()
        let pitch: Pitch = 60
        
        let context = Model.Context(
            .zero ... .zero,
            PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
        )
        
        builder.add(pitch, kind: "pitch", in: context)
        let model = builder.build()
        //model.put(pitch, kind: "pitch", context: context)

        let result = model.context(entity: 0)!
        let expected = context
        XCTAssertEqual(result, expected)
    }
    
    func testCustomStringConvertible() {
        let pitches: [Pitch] = [60,61,62,63,65,66,67,68,69,70,71,72]
        let builder = Model.Builder()
        pitches.forEach { builder.add($0, kind: "pitch") }
        let model = builder.build()
        print("model:\n\(model)")
    }
    
    func testSingleEntityNotInInterval() {
        
        let builder = Model.Builder()
        let pitch: Pitch = 60
        let context = Model.Context(1/>8 ... 2/>8)
        builder.add(pitch, kind: "pitch", in: context)
        let model = builder.build()
        
        let searchInterval = 3/>8 ... 4/>8
        XCTAssertEqual(model.entities(in: searchInterval).count, 0)
    }
    
    func testSingleEntityEqualToInterval() {
        
        let builder = Model.Builder()
        let pitch: Pitch = 60
        let interval = 1/>8 ... 3/>16
        let context = Model.Context(interval)
        builder.add(pitch, kind: "pitch", in: context)
        let model = builder.build()
        
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
        let builder = Model.Builder()
        builder.add(1, kind: "pitch", in: contextA)
        builder.add(1, kind: "pitch", in: contextB)
        builder.add(1, kind: "pitch", in: contextC)
        let model = builder.build()

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
        let builder = Model.Builder()
        
        // matches kind but not context
        builder.add(1, kind: "pitch", in: contextA)
        
        // matches kind but not context
        builder.add(1, kind: "articulations", in: contextB)
        
        // matches all
        builder.add(1, kind: "dynamics", in: contextC)
        
        // matches all
        builder.add(1, kind: "pitch", in: contextC)
        
        let model = builder.build()
        
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
        
        let builder = Model.Builder()
        let entity = builder.add(1, kind: "pitch")
        let model = builder.build()
        
        XCTAssertEqual(entity, 0)
        XCTAssertEqual(model[0]!.0 as! Int, 1)
        XCTAssertEqual(model[0]!.1, Model.Context())
    }
    
    func testAddRhythm() {

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
        
        // TODO: Assert something!
    }
    
    func testAddMeterStructure() {

        let builder = Model.Builder()
        
        for meter in [Meter(4,4), Meter(3,8), Meter(5,16), Meter(29,64), Meter(3,2)] {
            builder.add(meter)
        }

        builder.add(Tempo(90), at: 0/>4)
        builder.add(Tempo(60), at: 4/>4, interpolating: true)
        builder.add(Tempo(120), at: 24/>4, interpolating: false)
        
        let model = builder.build()
        
        // TODO: Assert something!
    }
}

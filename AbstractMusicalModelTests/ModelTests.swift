//
//  ModelTests.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/5/17.
//
//

import XCTest
import Collections
import ArithmeticTools
import Rhythm
import Pitch
import Articulations
@testable import AbstractMusicalModel

class ModelTests: XCTestCase {
    
    func testRhythmEventIntervals() {
        
        let rhythm = Rhythm<Int>(
            4/>8 * [1,1,1,1],
            [
                .instance(.absence),
                .instance(.event(0)),
                .continuation,
                .instance(.absence)
            ]
        )
        
        let intervals = rhythm.eventIntervals
        print(intervals)
    }
    
    func testAddPitchArrayAttribute() {
        let pitches: PitchSet = [60,61,62]
        let interval = Fraction(4,8)...Fraction(5,8)
        let model = Model.builder
            .add(pitches, label: "pitch", with: PerformanceContext.Path(), in: interval)
            .build()
        print(model)
    }
    
    func testPitchesAndAtriculations() {
        let intervals = (0..<2).map { offset in Fraction(offset, 8)...Fraction(offset + 1, 8) }
        let pitches: [Pitch] = [60,61,62]
        let namedPitches = pitches.map { NamedAttribute($0, name: "pitch") }
        let articulations: [Articulation] = [.staccato, .accent, .tenuto]
        let namedArticulations = articulations.map { NamedAttribute($0, name: "articulation") }
        let events = zip(namedPitches, namedArticulations).map { [$0.0,$0.1] }
        let builder = Model.builder
        zip(events, intervals).forEach { event, interval in builder.add(event, in: interval) }
        let model = builder.build()
        print(model)
    }
    
//    func testCustomStringConvertible() {
//        let pitches: [Pitch] = [60,61,62,63,65,66,67,68,69,70,71,72]
//        let builder = Model.Builder()
//        pitches.forEach { builder.add($0, kind: "pitch") }
//        let model = builder.build()
//        print("model:\n\(model)")
//    }
//    
//    func testSingleEntityNotInInterval() {
//        
//        let builder = Model.Builder()
//        let pitch: Pitch = 60
//        let context = Model.Context(1/>8 ... 2/>8)
//        builder.add(pitch, kind: "pitch", in: context)
//        let model = builder.build()
//        
//        let searchInterval = 3/>8 ... 4/>8
//        XCTAssertEqual(model.entities(in: searchInterval).count, 0)
//    }
//    
//    func testSingleEntityEqualToInterval() {
//        
//        let builder = Model.Builder()
//        let pitch: Pitch = 60
//        let interval = 1/>8 ... 3/>16
//        let context = Model.Context(interval)
//        builder.add(pitch, kind: "pitch", in: context)
//        let model = builder.build()
//        
//        let searchInterval = 1/>8 ... 3/>16
//        XCTAssertEqual(model.entities(in: searchInterval).count, 1)
//    }
//    
//    func testMultipleEntitiesContainedWithinScopeAndInterval() {
//        
//        // Prepare search interval
//        let searchInterval = 4/>8 ... 8/>8
//        
//        // Prepare search scopre
//        let scope = PerformanceContext.Scope("P", "I")
//        
//        // Prepare entity outside of scope, inside interval (1)
//        let contextA = Model.Context(
//            4/>8 ... 5/>8,
//            PerformanceContext(Performer("P", [Instrument("J", [Voice(0)])]))
//        )
//        
//        // Prepare entity inside scope, outside of interval (1)
//        let contextB = Model.Context(
//            1/>8 ... 2/>8,
//            PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
//        )
//        
//        // Prepare entity inside of scope and interval (1)
//        let contextC = Model.Context (
//            4/>8 ... 5/>8,
//            PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
//        )
//        
//        // Populate model
//        let builder = Model.Builder()
//        builder.add(1, kind: "pitch", in: contextA)
//        builder.add(1, kind: "pitch", in: contextB)
//        builder.add(1, kind: "pitch", in: contextC)
//        let model = builder.build()
//
//        XCTAssertEqual(model.entities(in: searchInterval, performedBy: scope).count, 1)
//    }
//    
//    func testEntitiesWithAttributeIdentifiers() {
//        
//        // Prepare context outside of scope, inside interval (1)
//        let contextA = Model.Context(
//            4/>8 ... 5/>8,
//            PerformanceContext(Performer("P", [Instrument("J", [Voice(0)])]))
//        )
//        
//        // Prepare entity inside scope, outside of interval (1)
//        let contextB = Model.Context(
//            1/>8 ... 2/>8,
//            PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
//        )
//        
//        // Prepare entity inside of scope and interval (1)
//        let contextC = Model.Context (
//            4/>8 ... 5/>8,
//            PerformanceContext(Performer("P", [Instrument("I", [Voice(0)])]))
//        )
//        
//        // Populate model
//        let builder = Model.Builder()
//        
//        // matches kind but not context
//        builder.add(1, kind: "pitch", in: contextA)
//        
//        // matches kind but not context
//        builder.add(1, kind: "articulations", in: contextB)
//        
//        // matches all
//        builder.add(1, kind: "dynamics", in: contextC)
//        
//        // matches all
//        builder.add(1, kind: "pitch", in: contextC)
//        
//        let model = builder.build()
//        
//        // Prepare search interval
//        let searchInterval = 4/>8 ... 8/>8
//        
//        // Prepare search scope
//        let scope = PerformanceContext.Scope("P", "I")
//        
//        // Prepare search kinds
//        let kinds = ["pitch", "dynamics"]
//        
//        XCTAssertEqual(
//            model.entities(in: searchInterval, performedBy: scope, including: kinds).count, 2
//        )
//    }
//    
    func testAddRhythm() {
        
        let rhythm = Rhythm<Int>(
            3/>16 * [1,2,3,1],
            [
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0))
            ]
        )
        
        let pitches: [Pitch] = [60,61,62,63]
        let namedPitches = pitches.map { NamedAttribute($0, name: "pitch") }
        let articulations: [Articulation] = [.staccato, .accent, .tenuto, .accent]
        let namedArticulations = articulations.map { NamedAttribute($0, name: "articulation") }
        let events = zip(namedPitches, namedArticulations).map { [$0.0,$0.1] }
        
        let model = Model.builder
            .add(rhythm, at: 0, with: events)
            .build()
        print(model)

        for rhythm in model.rhythms {
            print("RHYTHM:")
            for event in rhythm.events {
                let attributeIDs = model.events[event]!
                print(attributeIDs.map { model.values[$0] })
            }
        }
    }
    
    func testAddManyRhythms() {

        let rhythm = Rhythm<Int>(
            1/>4 * [1,2,3,1],
            [
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0))
            ]
        )

        let pitches: [Pitch] = [60,61,62,63]
        let namedPitches = pitches.map { NamedAttribute($0, name: "pitch") }
        let articulations: [Articulation] = [.staccato, .accent, .tenuto, .accent]
        let namedArticulations = articulations.map { NamedAttribute($0, name: "articulation") }
        let events = zip(namedPitches, namedArticulations).map { [$0.0,$0.1] }
        
        let builder = Model.builder
        (0..<100).forEach { offsetBeats in
            builder.add(rhythm, at: Fraction(offsetBeats,4), with: events)
        }
    
        let model = builder.build()
        print(model)
    }
    
    func testFilter() {
        
        let rhythm = Rhythm<Int>(
            1/>4 * [1,1,1,1],
            [
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0)),
                .instance(.event(0))
            ]
        )
        
        let context1 = PerformanceContext.Path("P", "I", 0)
        let context2 = PerformanceContext.Path("P", "II", 3)
        let pitches: [Pitch] = [60,61,62,63]
        let namedPitches = pitches.map { NamedAttribute($0, name: "pitch") }
        let articulations: [Articulation] = [.staccato, .accent, .tenuto, .accent]
        let namedArticulations = articulations.map { NamedAttribute($0, name: "articulation") }
        let events = zip(namedPitches, namedArticulations).map { [$0.0,$0.1] }
        
        let builder = Model.builder
        
        // Add a bunch of rhythms
        (0..<1000).forEach { offsetBeats in
            builder.add(rhythm, at: Fraction(offsetBeats,4), with: events, and: context1)
            builder.add(rhythm, at: Fraction(offsetBeats,4), with: events, and: context2)
        }
        
        // Construct the model
        let model = builder.build()

        // Create a filter
        let filter = Model.Filter(
            interval: Fraction(4,4)...Fraction(5/>4),
            scope: PerformanceContext.Scope("P","I"),
            label: "articulation"
        )
        
        // Get the ids of all of the attributes within the given filter
        let filteredIDs = model.filtered(by: filter)
        
        filteredIDs.forEach { id in
            let value = model.values[id]!
            let interval = model.intervals[id]!
            let context = model.performanceContexts[id]!
            print("\(value); interval: \(interval); contexts: \(context)")
        }
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
        print(model)
        // TODO: Assert something!
    }
}

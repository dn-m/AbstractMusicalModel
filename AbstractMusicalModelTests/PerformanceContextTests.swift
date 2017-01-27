//
//  PerformanceContextTests.swift
//  AbstractMusicalModel
//
//  Created by James Bean on 1/27/17.
//
//

import XCTest
import AbstractMusicalModel

class PerformanceContextTests: XCTestCase {

    func testVoiceInit() {
        _ = Voice(4)
    }
    
    func testInstrumentInitEmpty() {
        _ = Instrument("VC", [])
    }
    
    func testInstrumentInitArrayOfVoiceIdentifiers() {
        
        let i = Instrument("VN", [1,4,5,6].map(Voice.init))
        XCTAssertEqual(i.count, 4)
        print(i)
    }
    
    func testPerformerInitArrayOfInstruments() {
        
        let i1 = Instrument("VOX", [1,2,3].map(Voice.init))
        let i2 = Instrument("DB", [1,2,3,4].map(Voice.init))
        let i3 = Instrument("FL", [1,4].map(Voice.init))
        let p = Performer("ABC", [i1, i2, i3])
        print(p)
    }
}

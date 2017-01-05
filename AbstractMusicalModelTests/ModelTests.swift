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
import AbstractMusicalModel

class ModelTests: XCTestCase {

    let model = Model()
    
    func testAddAttribute() {
        
        let attribute = 1
        let interval = MetricalDurationInterval(.zero, .zero)
        let context = PerformanceContext(performer: 0, instrument: 1, voice: 0)
        model.add(attribute: attribute, identifier: "int", in: interval, with: context)
    }
}

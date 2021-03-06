//
//  Time.swift
//  VideoCapture
//
//  Created by Nathan Perkins on 11/28/15.
//  Copyright © 2015 GardnerLab. All rights reserved.
//

import Foundation
import Darwin

class Time
{
    private var timeStart: UInt64 = 0
    private var timeStop: UInt64 = 0
    
    private static var timeBase: Double?
    
    private static var globalTimers = [String: Time]()
    private static var globalStats = [String: [Double]]()
    
    private static func getTimeBase() -> Double {
        if let base = self.timeBase {
            return base
        }
        
        var info = mach_timebase_info(numer: 0, denom: 0)
        mach_timebase_info(&info)
        
        // calculate base
        let base = Double(info.numer) / Double(info.denom)
        self.timeBase = base
        return base
    }
    
    func start() {
        timeStart = mach_absolute_time()
    }
    
    func stop() {
        timeStop = mach_absolute_time()
    }
    
    var nanoseconds: Double {
        return Double(timeStop - timeStart) * Time.getTimeBase()
    }
    
    static func start(withName key: String) {
        if let t = Time.globalTimers[key] {
            t.start()
        }
        else {
            let t = Time()
            Time.globalTimers[key] = t
            t.start()
        }
    }
    
    @discardableResult static func stop(withName key: String) -> Double {
        if let t = Time.globalTimers[key] {
            t.stop()
            return t.nanoseconds
        }
        
        return -1.0
    }
    
    static func stopAndSave(withName key: String) {
        if let t = Time.globalTimers[key] {
            t.stop()
            
            if nil == Time.globalStats[key] {
                Time.globalStats[key] = [Double]()
            }
            
            Time.globalStats[key]!.append(t.nanoseconds)
        }
    }
    
    static func stopAndPrint(withName key: String) {
        if let t = Time.globalTimers[key] {
            t.stop()
            print("\(key): \(t.nanoseconds)ns")
        }
    }
    
    static func save(withName key: String, andValue value: Double) {
        if nil == Time.globalStats[key] {
            Time.globalStats[key] = [Double]()
        }
        
        Time.globalStats[key]!.append(value)
    }
    
    static func printAll() {
        for (k, a) in Time.globalStats {
            print("\(k):")
            a.forEach { print("\($0)") }
        }
    }
}

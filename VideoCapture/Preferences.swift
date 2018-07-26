//  Preferences.swift
//  VideoCapture
//
//  Created by L. Nathan Perkins on 7/2/15.
//  Copyright © 2015

import Foundation
import Cocoa

private let keyPinAnalogTrigger = "PinAnalogTrigger"
private let keyPinDigitalCamera = "PinDigitalCamera"
private let keyPinDigitalFeedback = "PinDigitalFeedback"
private let keyPinAnalogLED = "PinAnalogLED"
private let keyPinAnalogSecondLED = "PinAnalogSecondLED"
private let keyPinDigitalSync = "PinDigitalSync"
private let keyTriggerType = "TriggerType"
private let keyTriggerPollTime = "TriggerPollTime"
private let keyTriggerValue = "TriggerValue"
private let keySecondsAfterSong = "SecondsAfterSong"
private let keyThresholdSongNonsongRatio = "ThresholdSongNonsongRatio"
private let keyThresholdSongBackgroundRatio = "ThresholdSongBackgroundRatio"
private let keyVideoFormat = "VideoFormat"

//Z-score value names
private let keyTimeWindow = "TimeWindow"
private let keyZScoresTimeWindow = "ZScoresTimeWindow"
private let keyActivationThreshold = "ActivationThreshold"
private let keyResetThreshold = "ResetThreshold"
private let keyTTLPulsePin = "TTLPulsePin"
private let keyBMIAudioPin = "BMIAudioPin"
private let keyAudioSmoothed = "AudioSmoothed"

enum PreferenceVideoFormat: CustomStringConvertible, Equatable {
    case raw
    case h264
    
    init?(fromString s: String) {
        switch s {
        case "Raw":
            self = .raw
        case "H264":
            self = .h264
        default:
            return nil
        }
    }
    
    var description: String {
        get {
            switch self {
            case .h264:
                return "H264"
            case .raw:
                return "Raw"
            }
        }
    }
}

enum PreferenceTriggerType: CustomStringConvertible, Equatable {
    case arduinoPin
    
    init?(fromString s: String) {
        switch s {
        case "ArduinoPin", "Arduino Pin":
            self = .arduinoPin
        default:
            return nil
        }
    }
    
    var description: String {
        get {
            switch self {
            case .arduinoPin:
                return "Arduino Pin"
            }
        }
    }
}

/// Potentially customizable application preferences.
struct Preferences {
    // pin preferences
    var pinAnalogTrigger: Int {
        didSet {
            UserDefaults.standard.set(pinAnalogTrigger, forKey: keyPinAnalogTrigger)
        }
    }
    var pinDigitalCamera: Int {
        didSet {
            UserDefaults.standard.set(pinDigitalCamera, forKey: keyPinDigitalCamera)
        }
    }
    var pinDigitalFeedback: Int {
        didSet {
            UserDefaults.standard.set(pinDigitalFeedback, forKey: keyPinDigitalFeedback)
        }
    }
    var pinAnalogLED: Int {
        didSet {
            UserDefaults.standard.set(pinAnalogLED, forKey: keyPinAnalogLED)
        }
    }
    var pinAnalogSecondLED: Int? {
        didSet {
            UserDefaults.standard.set(pinAnalogSecondLED, forKey: keyPinAnalogSecondLED)
        }
    }
    var pinDigitalSync: Int {
        didSet {
            UserDefaults.standard.set(pinDigitalSync, forKey: keyPinDigitalSync)
        }
    }
    
    // frames after song to store
    var secondsAfterSong: Double {
        didSet {
            UserDefaults.standard.set(secondsAfterSong, forKey: keySecondsAfterSong)
        }
    }
    
    // trigger
    var triggerType: PreferenceTriggerType {
        didSet {
            UserDefaults.standard.setValue(triggerType.description, forKey: keyTriggerType)
        }
    }
    
    // arduino trigger
    var triggerPollTime: Double {
        didSet {
            UserDefaults.standard.set(triggerPollTime, forKey: keyTriggerPollTime)
        }
    }
    var triggerValue: Int {
        didSet {
            UserDefaults.standard.set(triggerValue, forKey: keyTriggerValue)
        }
    }
    
    // thresholds
    var thresholdSongNongsongRatio: Double {
        didSet {
            UserDefaults.standard.set(thresholdSongNongsongRatio, forKey: keyThresholdSongNonsongRatio)
        }
    }
    var thresholdSongBackgroundRatio: Double {
        didSet {
            UserDefaults.standard.set(thresholdSongBackgroundRatio, forKey: keyThresholdSongBackgroundRatio)
        }
    }
    
    // output format
    var videoFormat: PreferenceVideoFormat {
        didSet {
            UserDefaults.standard.setValue(videoFormat.description, forKey: keyVideoFormat)
        }
    }
    
    //z-score calculation time window
    var timeWindow: Int {
        didSet {
            UserDefaults.standard.setValue(timeWindow, forKey: keyTimeWindow)
        }
    }
    
    //z-score smoothing time window
    var zScoresTimeWindow: Int {
        didSet {
            UserDefaults.standard.setValue(zScoresTimeWindow, forKey: keyZScoresTimeWindow)
        }
    }
    
    //z-score activation threshold
    var activationThreshold: Float {
        didSet {
            UserDefaults.standard.setValue(activationThreshold, forKey: keyActivationThreshold)
        }
    }
    
    //z-score reset threshold
    var resetThreshold: Float {
        didSet {
            UserDefaults.standard.setValue(resetThreshold, forKey: keyResetThreshold)
        }
    }
    
    //BMI rule TTL pulse output
    var ttlPulsePin: Int {
        didSet {
            UserDefaults.standard.setValue(ttlPulsePin, forKey: keyTTLPulsePin)
        }
    }
    
    //BMI audio cursor output
    var bmiAudioPin: Int {
        didSet {
            UserDefaults.standard.setValue(bmiAudioPin, forKey: keyBMIAudioPin)
        }
    }
    
    // Whether or not to use zScoredSmoothed, as opposed to zScores, for audio dynamic range
    var audioSmoothed: Bool {
        didSet {
            UserDefaults.standard.setValue(audioSmoothed, forKey: keyAudioSmoothed)
        }
    }
    
    init() {
        // register preference defaults
        Preferences.registerDefaults()
        
        // get defaults
        let defaults = UserDefaults.standard
        
        pinAnalogTrigger = defaults.integer(forKey: keyPinAnalogTrigger)
        pinDigitalCamera = defaults.integer(forKey: keyPinDigitalCamera)
        pinDigitalFeedback = defaults.integer(forKey: keyPinDigitalFeedback)
        pinAnalogLED = defaults.integer(forKey: keyPinAnalogLED)
        
        // second led is optional
        let pin = defaults.integer(forKey: keyPinAnalogSecondLED)
        if pin > 0 {
            pinAnalogSecondLED = pin
        }
        else {
            pinAnalogSecondLED = nil
        }
        
        pinDigitalSync = defaults.integer(forKey: keyPinDigitalSync)
        secondsAfterSong = defaults.double(forKey: keySecondsAfterSong)
        triggerType = PreferenceTriggerType(fromString: defaults.string(forKey: keyTriggerType) ?? "Arduino Pin") ?? PreferenceTriggerType.arduinoPin
        triggerPollTime = defaults.double(forKey: keyTriggerPollTime)
        triggerValue = defaults.integer(forKey: keyTriggerValue)
        thresholdSongNongsongRatio = defaults.double(forKey: keyThresholdSongNonsongRatio)
        thresholdSongBackgroundRatio = defaults.double(forKey: keyThresholdSongBackgroundRatio)
        videoFormat = PreferenceVideoFormat(fromString: defaults.string(forKey: keyVideoFormat) ?? "H264") ?? PreferenceVideoFormat.h264
        
        // Set z-score variables
        timeWindow = defaults.integer(forKey: keyTimeWindow)
        zScoresTimeWindow = defaults.integer(forKey: keyZScoresTimeWindow)
        activationThreshold = defaults.float(forKey: keyActivationThreshold)
        resetThreshold = defaults.float(forKey: keyResetThreshold)
        ttlPulsePin = defaults.integer(forKey: keyTTLPulsePin)
        bmiAudioPin = defaults.integer(forKey: keyBMIAudioPin)
        audioSmoothed = defaults.bool(forKey: keyAudioSmoothed)
    }
    
    static let defaultPreferences: [String: Any] = [
        keyPinAnalogTrigger: NSNumber(value: 0 as Int),
        keyPinDigitalCamera: NSNumber(value: 4 as Int),
        keyPinDigitalFeedback: NSNumber(value: 9 as Int),
        keyPinAnalogLED: NSNumber(value: 13 as Int),
        //keyPinAnalogSecondLED: nil,
        keyPinDigitalSync: NSNumber(value: 7 as Int),
        keySecondsAfterSong: NSNumber(value: 1.5 as Double),
        keyTriggerType: "Arduino Pin",
        keyTriggerPollTime: NSNumber(value: 0.05 as Double),
        keyTriggerValue: NSNumber(value: 500 as Int),
        keyThresholdSongNonsongRatio: NSNumber(value: 1.4 as Double),
        keyThresholdSongBackgroundRatio: NSNumber(value: 25.0 as Double),
        keyVideoFormat: "H264",
        
        // Set z-score variables
        keyTimeWindow: NSNumber(value: 4 as Int),
        keyZScoresTimeWindow: NSNumber(value: 500 as Int),
        keyActivationThreshold: NSNumber(value: 6.0 as Float),
        keyResetThreshold: NSNumber(value: 1.0 as Float),
        keyTTLPulsePin: NSNumber(value: 2 as Int),
        keyBMIAudioPin: NSNumber(value: 3 as Int),
        keyAudioSmoothed: NSNumber(value: false as Bool)
    ]
    
    // track
    private static var _doneRegisteringDefaults = false
    
    static func registerDefaults() {
        // register defaults only once
        if _doneRegisteringDefaults { return }
        _doneRegisteringDefaults = true
        UserDefaults.standard.register(defaults: defaultPreferences)
    }
}

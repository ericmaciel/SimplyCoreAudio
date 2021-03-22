//
//  AudioObject.swift
//
//  Created by Ruben Nine on 13/04/16.
//

import CoreAudio.AudioHardwareBase
import Foundation

/// `AudioObject` represents a Core Audio managed audio object. In Core Audio, audio objects are referenced by
/// its `AudioObjectID` and belong to a specific `AudioClassID`.
///
/// For more information, please refer to Core Audio's documentation or source code.
public class AudioObject {
    // MARK: - Internal Properties

    let objectID: AudioObjectID

    // MARK: - Public Properties

    /// The `AudioClassID` that identifies the class of this audio object.
    ///
    /// - Returns: *(optional)* An `AudioClassID`.
    public lazy var classID: AudioClassID? = {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioObjectPropertyClass,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMaster
        )

        guard AudioObjectHasProperty(self.objectID, &address) else { return nil }

        var klassID = AudioClassID()
        let status = self.getPropertyData(address, andValue: &klassID)

        guard noErr == status else { return nil }

        return klassID
    }()

    /// The audio object that owns this audio object.
    ///
    /// - Returns: *(optional)* An `AudioObject`.
    public lazy var owningObject: AudioObject? = {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioObjectPropertyOwner,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMaster
        )

        guard AudioObjectHasProperty(self.objectID, &address) else { return nil }

        var objectID = AudioObjectID()
        let status = self.getPropertyData(address, andValue: &objectID)

        guard noErr == status else { return nil }

        return AudioObject(objectID: objectID)
    }()

    /// The audio device that owns this audio object.
    ///
    /// - Returns: *(optional)* An `AudioDevice`.
    public lazy var owningDevice: AudioDevice? = {
        guard let object = self.owningObject, object.classID == kAudioDeviceClassID else { return nil }

        return AudioDevice.lookup(by: object.objectID)
    }()

    /// The audio object's name as reported by Core Audio.
    ///
    /// - Returns: *(optional)* An audio object's name.
    public var name: String? {
        var name: CFString = "" as CFString

        let address = AudioObjectPropertyAddress(
            mSelector: kAudioObjectPropertyName,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMaster
        )

        let status = getPropertyData(address, andValue: &name)

        return noErr == status ? (name as String) : nil
    }

    // MARK: - Lifecycle

    init(objectID: AudioObjectID) {
        self.objectID = objectID
    }
}

// MARK: - Hashable Conformance

extension AudioObject: Hashable {
    /// The hash value.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(objectID)
    }
}

// MARK: - Equatable Conformance

/// :nodoc:
public func == (lhs: AudioObject, rhs: AudioObject) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
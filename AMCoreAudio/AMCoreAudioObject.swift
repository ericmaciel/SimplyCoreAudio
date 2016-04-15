//
//  AMCoreAudioObject.swift
//  AMCoreAudio
//
//  Created by Ruben Nine on 13/04/16.
//  Copyright © 2016 9Labs. All rights reserved.
//

import Foundation
import CoreAudio.AudioHardwareBase

public class AMCoreAudioObject: NSObject {
    internal var objectID: AudioObjectID

    internal func directionToScope(direction: Direction) -> AudioObjectPropertyScope {
        return AMUtils.directionToScope(direction)
    }

    internal func scopeToDirection(scope: AudioObjectPropertyScope) -> Direction {
        return AMUtils.scopeToDirection(scope)
    }

    internal init(objectID: AudioObjectID) {
        self.objectID = objectID
        super.init()
    }
}

extension AMCoreAudioObject {

    // MARK: - Class Methods

    internal class func getPropertyDataSize<Q>(objectID: AudioObjectID, address: AudioObjectPropertyAddress, qualifierDataSize: UInt32?, inout qualifierData: [Q], inout andSize size: UInt32) -> (OSStatus) {
        var theAddress = address

        return AudioObjectGetPropertyDataSize(objectID, &theAddress, qualifierDataSize ?? UInt32(0), &qualifierData, &size)
    }

    internal class func getPropertyDataSize<Q>(objectID: AudioObjectID, address: AudioObjectPropertyAddress, qualifierDataSize: UInt32?, inout qualifierData: Q, inout andSize size: UInt32) -> (OSStatus) {
        var theAddress = address

        return AudioObjectGetPropertyDataSize(objectID, &theAddress, qualifierDataSize ?? UInt32(0), &qualifierData, &size)
    }

    internal class func getPropertyDataSize(objectID: AudioObjectID, address: AudioObjectPropertyAddress, inout andSize size: UInt32) -> (OSStatus) {
        var nilValue: NilLiteralConvertible?
        return getPropertyDataSize(objectID, address: address, qualifierDataSize: nil, qualifierData: &nilValue, andSize: &size)
    }

    internal class func getPropertyData<T>(objectID: AudioObjectID, address: AudioObjectPropertyAddress, inout andValue value: T) -> OSStatus {
        var theAddress = address
        var size = UInt32(sizeof(T))
        let status = AudioObjectGetPropertyData(objectID, &theAddress, UInt32(0), nil, &size, &value)

        return status
    }

    internal class func getPropertyDataArray<T,Q>(objectID: AudioObjectID, address: AudioObjectPropertyAddress, qualifierDataSize: UInt32?, inout qualifierData: Q, inout value: [T], andDefaultValue defaultValue: T) -> OSStatus {
        var size = UInt32(0)
        let sizeStatus = getPropertyDataSize(objectID, address: address, qualifierDataSize: qualifierDataSize, qualifierData: &qualifierData, andSize: &size)

        if noErr == sizeStatus {
            value = [T](count: Int(size) / sizeof(T), repeatedValue: defaultValue)
        } else {
            return sizeStatus
        }

        var theAddress = address
        let status = AudioObjectGetPropertyData(objectID, &theAddress, qualifierDataSize ?? UInt32(0), &qualifierData, &size, &value)

        return status
    }

    internal class func getPropertyDataArray<T,Q>(objectID: AudioObjectID, address: AudioObjectPropertyAddress, qualifierDataSize: UInt32?, inout qualifierData: [Q], inout value: [T], andDefaultValue defaultValue: T) -> OSStatus {
        var size = UInt32(0)
        let sizeStatus = getPropertyDataSize(objectID, address: address, qualifierDataSize: qualifierDataSize, qualifierData: &qualifierData, andSize: &size)

        if noErr == sizeStatus {
            value = [T](count: Int(size) / sizeof(T), repeatedValue: defaultValue)
        } else {
            return sizeStatus
        }

        var theAddress = address
        let status = AudioObjectGetPropertyData(objectID, &theAddress, qualifierDataSize ?? UInt32(0), &qualifierData, &size, &value)

        return status
    }

    internal class func getPropertyDataArray<T>(objectID: AudioObjectID, address: AudioObjectPropertyAddress, inout value: [T], andDefaultValue defaultValue: T) -> OSStatus {
        var nilValue: NilLiteralConvertible?
        return getPropertyDataArray(objectID, address: address, qualifierDataSize: nil, qualifierData: &nilValue, value: &value, andDefaultValue: defaultValue)
    }

    // MARK: - Instance Methods

    internal func getPropertyDataSize<Q>(objectID: AudioObjectID, address: AudioObjectPropertyAddress, qualifierDataSize: UInt32?, inout qualifierData: [Q], inout andSize size: UInt32) -> (OSStatus) {
        return self.dynamicType.getPropertyDataSize(objectID, address: address, qualifierDataSize: qualifierDataSize, qualifierData: &qualifierData, andSize: &size)
    }

    internal func getPropertyDataSize<Q>(objectID: AudioObjectID, address: AudioObjectPropertyAddress, qualifierDataSize: UInt32?, inout qualifierData: Q, inout andSize size: UInt32) -> (OSStatus) {
        return self.dynamicType.getPropertyDataSize(objectID, address: address, qualifierDataSize: qualifierDataSize, qualifierData: &qualifierData, andSize: &size)
    }

    internal func getPropertyDataSize(objectID: AudioObjectID, address: AudioObjectPropertyAddress, inout andSize size: UInt32) -> OSStatus {
        return self.dynamicType.getPropertyDataSize(objectID, address: address, andSize: &size)
    }

    internal func getPropertyDataSize<Q>(address: AudioObjectPropertyAddress, qualifierDataSize: UInt32?, inout qualifierData: [Q], inout andSize size: UInt32) -> (OSStatus) {
        return self.dynamicType.getPropertyDataSize(objectID, address: address, qualifierDataSize: qualifierDataSize, qualifierData: &qualifierData, andSize: &size)
    }

    internal func getPropertyDataSize<Q>(address: AudioObjectPropertyAddress, qualifierDataSize: UInt32?, inout qualifierData: Q, inout andSize size: UInt32) -> (OSStatus) {
        return self.dynamicType.getPropertyDataSize(objectID, address: address, qualifierDataSize: qualifierDataSize, qualifierData: &qualifierData, andSize: &size)
    }

    internal func getPropertyDataSize(address: AudioObjectPropertyAddress, inout andSize size: UInt32) -> OSStatus {
        return self.dynamicType.getPropertyDataSize(objectID, address: address, andSize: &size)
    }

    internal func getPropertyData<T>(objectID: AudioObjectID, address: AudioObjectPropertyAddress, inout andValue value: T) -> OSStatus {
        return self.dynamicType.getPropertyData(objectID, address: address, andValue: &value)
    }

    internal func getPropertyDataArray<T,Q>(objectID: AudioObjectID, address: AudioObjectPropertyAddress, qualifierDataSize: UInt32?, inout qualifierData: Q, inout value: [T], andDefaultValue defaultValue: T) -> OSStatus {
        return self.dynamicType.getPropertyDataArray(objectID, address: address, qualifierDataSize: qualifierDataSize, qualifierData: &qualifierData, value: &value, andDefaultValue: defaultValue)
    }

    internal func getPropertyDataArray<T>(objectID: AudioObjectID, address: AudioObjectPropertyAddress, inout value: [T], andDefaultValue defaultValue: T) -> OSStatus {
        return getPropertyDataArray(objectID, address: address, value: &value, andDefaultValue: defaultValue)
    }

    internal func getPropertyData<T>(address: AudioObjectPropertyAddress, inout andValue value: T) -> OSStatus {
        return self.dynamicType.getPropertyData(objectID, address: address, andValue: &value)
    }

    internal func getPropertyDataArray<T,Q>(address: AudioObjectPropertyAddress, qualifierDataSize: UInt32?, inout qualifierData: Q, inout value: [T], andDefaultValue defaultValue: T) -> OSStatus {
        return self.dynamicType.getPropertyDataArray(objectID, address: address, qualifierDataSize: qualifierDataSize, qualifierData: &qualifierData, value: &value, andDefaultValue: defaultValue)
    }

    internal func getPropertyDataArray<T,Q>(address: AudioObjectPropertyAddress, qualifierDataSize: UInt32?, inout qualifierData: [Q], inout value: [T], andDefaultValue defaultValue: T) -> OSStatus {
        return self.dynamicType.getPropertyDataArray(objectID, address: address, qualifierDataSize: qualifierDataSize, qualifierData: &qualifierData, value: &value, andDefaultValue: defaultValue)
    }

    internal func getPropertyDataArray<T>(address: AudioObjectPropertyAddress, inout value: [T], andDefaultValue defaultValue: T) -> OSStatus {
        return self.dynamicType.getPropertyDataArray(objectID, address: address, value: &value, andDefaultValue: defaultValue)
    }

    internal func setPropertyData<T>(objectID: AudioObjectID, address: AudioObjectPropertyAddress, inout andValue value: T) -> OSStatus {
        var theAddress = address
        let size = UInt32(sizeof(T))
        let status = AudioObjectSetPropertyData(objectID, &theAddress, UInt32(0), nil, size, &value)

        return status
    }

    internal func setPropertyData<T>(objectID: AudioObjectID, address: AudioObjectPropertyAddress, inout andValue value: [T]) -> OSStatus {
        var theAddress = address
        let size = UInt32(value.count * sizeof(T))
        let status = AudioObjectSetPropertyData(objectID, &theAddress, UInt32(0), nil, size, &value)

        return status
    }

    internal func setPropertyData<T>(address: AudioObjectPropertyAddress, inout andValue value: T) -> OSStatus {
        return setPropertyData(objectID, address: address, andValue: &value)
    }

    internal func setPropertyData<T>(address: AudioObjectPropertyAddress, inout andValue value: [T]) -> OSStatus {
        return setPropertyData(objectID, address: address, andValue: &value)
    }
}
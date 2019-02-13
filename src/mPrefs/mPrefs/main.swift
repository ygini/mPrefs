//
//  main.swift
//  mPrefs
//
//  Created by Yoann Gini on 13/02/2019.
//  Copyright © 2019 Yoann Gini (Open Source Project). All rights reserved.
//

import Foundation

enum InternalError: Int32 {
    case missingDomain
    case missingOperation
    case invalidOperation
    case domainUnavailable
    case invalidKeyPath
}

let kTargetDomain = "d"
let kOperation = "o"
let kKey = "k"
let kIsKeyPath = "kp"

enum kOperationType: String {
    case list
    case listall
    case read
}

let unwantedKeys = UserDefaults.init().dictionaryRepresentation().keys

func help() {
    print("Someone should write a doc")
}

func listManagedKeys(in defaults:UserDefaults) {
    let allKeys = defaults.dictionaryRepresentation().keys
    for key in allKeys {
        if (defaults.objectIsForced(forKey: key)) {
            print(key)
        }
    }
}

func listAllKeys(in defaults:UserDefaults, atKey key:String?, keyIsKeyPath: Bool = false) {
    var dictionaryRepresentation = defaults.dictionaryRepresentation()
    
    for unwantedKey in unwantedKeys {
        dictionaryRepresentation.removeValue(forKey: unwantedKey)
    }
    
    let dict = dictionaryRepresentation as NSDictionary
    var potentialKeys: [String]?
    if let key = key {
        var subDict: NSDictionary?
        if keyIsKeyPath{
            subDict = dict.value(forKeyPath: key) as? NSDictionary
        } else {
            subDict = dict.value(forKey: key) as? NSDictionary
        }
        if let subDict = subDict {
            potentialKeys = subDict.allKeys as? [String]
        }
    } else {
        potentialKeys = dict.allKeys as? [String]
    }
    
    guard let allKeys = potentialKeys else {
        print("Requested keypath does not return a dictionary, unable to list all keys")
        exit(InternalError.missingDomain.rawValue)
    }
    
    for key in allKeys {
        print(key)
    }
}

func readKey(in defaults:UserDefaults, atKey key:String?, keyIsKeyPath: Bool = false) {
    var dictionaryRepresentation = defaults.dictionaryRepresentation()
    
    for unwantedKey in unwantedKeys {
        dictionaryRepresentation.removeValue(forKey: unwantedKey)
    }
    
    let dict = dictionaryRepresentation as NSDictionary
    if let key = key {
        var value: Any?
        if keyIsKeyPath{
            value = dict.value(forKeyPath: key)
        } else {
            value = dict.value(forKey: key)
        }
        if let value = value {
            print(value)
        }
    } else {
        print(dict)
    }
}

guard let targetDomain = UserDefaults.standard.string(forKey: kTargetDomain) else {
    print("No reading domain set, please use -\(kTargetDomain) to specify your desired domain")
    help()
    exit(InternalError.missingDomain.rawValue)
}

guard let requestedOperationAsString = UserDefaults.standard.string(forKey: kOperation) else {
    print("No operation set, please use -\(kOperation) to specify your action")
    help()
    exit(InternalError.missingOperation.rawValue)
}

guard let requestedOperation = kOperationType(rawValue: requestedOperationAsString) else {
    print("Invalid operation '\(requestedOperationAsString)', please use -\(kOperation) with a supported action type")
    help()
    exit(InternalError.invalidOperation.rawValue)
}

let requestedKey = UserDefaults.standard.string(forKey: kKey)
let requestedKeyIsKeyPath = UserDefaults.standard.bool(forKey: kIsKeyPath)

guard let targetDefaults = UserDefaults.init(suiteName: targetDomain) else {
    print("Unable to read preference domain '\(targetDomain)'")
    exit(InternalError.domainUnavailable.rawValue)
}


switch requestedOperation {
case .list:
    listManagedKeys(in: targetDefaults)
case .listall:
    listAllKeys(in: targetDefaults, atKey: requestedKey, keyIsKeyPath:requestedKeyIsKeyPath)
case .read:
    readKey(in: targetDefaults, atKey: requestedKey, keyIsKeyPath:requestedKeyIsKeyPath)
}

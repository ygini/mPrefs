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
    print("mPrefs is a simple command line allowing system administrator to check a target domain with managed preferences applied.")
    print("")
    print("-d com.github.ygini.Hello-IT\t\t\t\tUse the -d to specify the target domain to read")
    print("-o read\t\t\t\t\t\t\t\t\t\tThe -o option allow you to select your operation:")
    print("\t\t\t\t\t\t\t\t\t\t\t\t\"list\" to list all managed keys")
    print("\t\t\t\t\t\t\t\t\t\t\t\t\"listall\" to list all keys, managed or not")
    print("\t\t\t\t\t\t\t\t\t\t\t\t\"read\" to read all keys, managed or not")
    print("-k content\t\t\t\t\t\t\t\t\tWith -k, you can specify the key to read")
    print("\t\t\t\t\t\t\t\t\t\t\t(usable with operation listall and read)")
    print("-k 1\t\t\t\t\t\t\t\t\t\tWhen -pk is set to 1, you can use a keypath with -k")
    print("")
    print("More informations on keypath available here: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/CollectionOperators.html")
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
    print("No reading domain set, please use -\(kTargetDomain) to specify your desired domain\n")
    help()
    exit(InternalError.missingDomain.rawValue)
}

guard let requestedOperationAsString = UserDefaults.standard.string(forKey: kOperation) else {
    print("No operation set, please use -\(kOperation) to specify your action\n")
    help()
    exit(InternalError.missingOperation.rawValue)
}

guard let requestedOperation = kOperationType(rawValue: requestedOperationAsString) else {
    print("Invalid operation '\(requestedOperationAsString)', please use -\(kOperation) with a supported action type\n")
    help()
    exit(InternalError.invalidOperation.rawValue)
}

let requestedKey = UserDefaults.standard.string(forKey: kKey)
let requestedKeyIsKeyPath = UserDefaults.standard.bool(forKey: kIsKeyPath)

guard let targetDefaults = UserDefaults.init(suiteName: targetDomain) else {
    print("Unable to read preference domain '\(targetDomain)'\n")
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

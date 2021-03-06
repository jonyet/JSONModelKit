//
//  Parser.swift
//  JSONModelKit
//
//  Created by Anton Doudarev on 7/17/15.
//  Copyright © 2015 Ustwo. All rights reserved.
//

import Foundation

class Parser {
    
    final class func retrieveValue(from dictionary : Dictionary<String, AnyObject>, applying propertyMapping : Dictionary<String, AnyObject>, employing instantiator : JMInstantiatorProtocol, defaultsEnabled : Bool) -> Any? {
        
        if propertyMapping[JMMapperTransformerKey] != nil {
            return Transformer.transformedValue(from: dictionary, applying : propertyMapping, employing : instantiator)
        } 
        
        if let jsonKey = propertyMapping[JMMapperJSONKey] as? String {
            if let dataType = propertyMapping[JMMapperTypeKey]  as? String {
                
                let subType = propertyMapping[JMMapperCollectionSubTypeKey] as? String
                
                if let retrievedValue: AnyObject = dictionaryValueForKey(jsonKey, dictionary: dictionary) {
                    return parsedValue(forValue : retrievedValue, dataType, subType, instantiator : instantiator)
                } else if let retrievedDefaultValue: AnyObject = propertyMapping[JMMapperDefaultKey] {
                    
                    if defaultsEnabled {
                        return parsedValue(forValue : retrievedDefaultValue, dataType, subType, instantiator : instantiator)
                    } else {
                        return nil
                    }
                }
            }
        }
        
        return nil
    }
    
    final class func parsedValue(forValue value : AnyObject, _ dataType : String, _ subType: String?, instantiator : JMInstantiatorProtocol) -> AnyObject? {
        
        if nativeDataTypes.containsValue(dataType) {
            
            return NativeTypeParser.nativeRepresentation(fromValue : value, asType : dataType)
            
        } else if collectionTypes.containsValue(dataType) {
            
            switch dataType {
            case JMDataTypeArray:
                return CollectionParser.arrayRepresentation(fromValue : value, ofType : subType, using : instantiator) as AnyObject?
            case JMDataTypeDictionary:
                return CollectionParser.dictionaryRepresentation(fromValue : value, ofType : subType, using : instantiator) as AnyObject?
            default:
                if let unwrappedValue = value as? Dictionary<String, AnyObject> {
                    return ComplexTypeParser.complexObject(fromValue: unwrappedValue, ofType: subType, using : instantiator)
                }
            }
        } else {
            return instantiator.newInstance(ofType: dataType, withValue: value as! Dictionary<String, AnyObject>)
        }
        
        return nil
    }
    
    final class func dictionaryValueForKey(_ key : String, dictionary : Dictionary<String, AnyObject>) -> AnyObject? {
        var keys = key.components(separatedBy: ".")
        var nestedDictionary = dictionary
        
        var x = 0
        
        repeat {
            if x >= (keys.count - 1) {
                if let finalValue: AnyObject = nestedDictionary[keys[x]] {
                    return finalValue
                } else {
                    break
                }
            } else if let nextLevelDictionary = nestedDictionary[keys[x]] as? Dictionary<String, AnyObject> {
                nestedDictionary = nextLevelDictionary
            } else {
                break
            }

            x =  x + 1
        } while (x < keys.count )

        return nil
    }
}

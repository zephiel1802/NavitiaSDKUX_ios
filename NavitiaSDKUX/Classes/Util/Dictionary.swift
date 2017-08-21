//
//  Dictionary.swift
//  RenderTest
//
//  Created by Thomas Noury on 01/08/2017.
//  Copyright © 2017 Kisio. All rights reserved.
//

import Foundation

func mergeDictionaries(dict1: Dictionary<String, Any>, dict2: Dictionary<String, Any>) -> Dictionary<String, Any> {
    var result: Dictionary<String, Any> = [:]
    for key in dict1.keys {
        result[key] = dict1[key]
    }
    for key in dict2.keys {
        result[key] = dict2[key]
    }
    return result
}

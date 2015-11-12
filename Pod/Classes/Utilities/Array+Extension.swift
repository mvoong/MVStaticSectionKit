//
//  Array+Extension.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 12/11/2015.
//  Copyright © 2015 MVStaticSectionKit. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}
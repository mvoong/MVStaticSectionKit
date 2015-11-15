//
//  Person.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 15/11/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import CoreData
import AlecrimCoreData

class Person: NSManagedObject {

}

extension DataContext {
    var people: Table<Person> { return Table<Person>(dataContext: self) }
}

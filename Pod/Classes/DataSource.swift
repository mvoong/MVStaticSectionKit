//
//  DataSource.swift
//  Pods
//
//  Created by Michael Voong on 13/11/2015.
//
//

import Foundation

public protocol DataSource : class {
    func numberOfSections() -> Int
    func numberOfItemsInSection(index: Int) -> Int
    func numberOfItems() -> Int
    func isEmpty() -> Bool
    func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject?
}

extension DataSource {
    public func isEmpty() -> Bool {
        return self.numberOfItems() == 0
    }
}
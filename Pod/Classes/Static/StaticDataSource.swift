//
//  StaticDataSource.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 12/11/2015.
//  Copyright © 2015 Michael Voong. All rights reserved.
//

import Foundation
import CoreData

public class StaticDataSource<S: Section> : NSObject {
    /**
     The static sections
     */
    lazy var sections = [S]()
    
    lazy var resultsControllerDelegates = [NSFetchedResultsController: NSFetchedResultsControllerDelegate]()

    /**
     Add an empty `Section` to the receiver
     
     - returns: The empty `Section` that has been added
     */
    public func addSection() -> S {
        let section = S()
        self.addSection(section)
        
        return section
    }
    
    /**
     Add a `Section` to the receiver
     
     - returns: The `Section` that has been added
     */
    public func addSection(section: S) -> S {
        self.sections.append(section)
        
        section.resultsControllerChanged = { [unowned self] in
            self.updateResultsControllerDelegates()
        }
        
        return section
    }

    /**
     Inserts a `Section` to the receiver
     
     -  returns: The `Section` that has been inserted
     */
    public func insertSection(section: S, atIndex: Int) -> S {
        self.sections.insert(section, atIndex: atIndex)
        
        section.resultsControllerChanged = { [unowned self] in
            self.updateResultsControllerDelegates()
        }
        
        return section
    }
    
    /**
     Deletes a section from the receiver
     */
    public func deleteSection(section: S, atIndex: Int) {
        if let resultsController = section.fetchedResultsController {
            resultsController.delegate = nil
            self.resultsControllerDelegates.removeValueForKey(resultsController)
        }
        
        self.sections.removeObject(section)
    }

    /**
     Finds the `Section` for the given index
     
     - returns: The `Section`, or nil if no section exists at that index
     */
    public func sectionForIndex(index: Int) -> S? {
        return self.sections[index]
    }
    
    /**
     Finds the index of the section that has the given `NSFetchedResultsController` assigned
     
     - parameter resultsController: The results controller to search the sections for
     - returns: The index of the found `Section`
     */
    public func sectionIndexForFetchedResultsController(resultsController: NSFetchedResultsController) -> Int? {
        if let section = self.sectionForFetchedResultsController(resultsController) {
            return self.sectionIndexForSection(section)
        }
        
        return nil
    }
    
    /**
     Finds the `Section` for the given fetched results controller
     
     - parameter resultsController: The results controller to search the sections for
     - returns: The found `Section`
     */
    public func sectionForFetchedResultsController(resultsController: NSFetchedResultsController) -> S? {
        for section in self.sections {
            if section.fetchedResultsController == resultsController {
                return section
            }
        }
        return nil
    }
    
    /**
     Finds the index for a given `Section`
     
     - parameter section: The `Section` to search for
     */
    public func sectionIndexForSection(section: S) -> Int? {
        return self.sections.indexOf(section)
    }
    
    func updateResultsControllerDelegates() {
        
    }
    
    deinit {
        for section in self.sections {
            section.fetchedResultsController?.delegate = nil
        }
    }
}

extension StaticDataSource : DataSource {
    /**
     - returns: The number of `Section` objects
     */
    public func numberOfSections() -> Int {
        return self.sections.count
    }
    
    /**
     - parameter index: The index of the `Section`
     - returns: The number of items in a given `Section`
     */
    public func numberOfItemsInSection(index: Int) -> Int {
        return self.sections[index].numberOfItems()
    }
    
    /**
     - returns: The total number of `Item` objects across all sections
     */
    public func numberOfItems() -> Int {
        var count = 0
        for section in self.sections {
            count += section.numberOfItems()
        }
        
        return count
    }
    
    /**
     - returns: True if the receiver is empty, false otherwise
     */
    public func isEmpty() -> Bool {
        return self.numberOfItems() == 0
    }
    
    /**
     Finds the object at a given index path. For convenience, if the object is a subclass of `Item` and the item has an assigned `object`,
     that object will be returned. Otherwise, the item is returned.
     
     - returns: The object, or nil if there is no object at the specified index path
     */
    public func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject? {
        return self.sections[indexPath.section].objectAtIndex(indexPath.row)
    }
}

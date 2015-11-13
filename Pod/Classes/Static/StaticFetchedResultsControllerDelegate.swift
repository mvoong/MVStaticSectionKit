//
//  FetchedResultsControllerDelegate.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 13/11/2015.
//
//

import CoreData

public class StaticFetchedResultsControllerDelegate<S: Section, V: UIView> : NSObject {
    typealias ViewType = V
    typealias ObjectChangeTuple = (changeType: NSFetchedResultsChangeType, indexPaths: [NSIndexPath])
    
    /**
     Disables animations if set to true
     */
    public var disableAnimations = false
    
    /**
     The current `NSFetchedResultsController` changes being applied
     */
    var objectChanges = [ObjectChangeTuple]()
    
    /**
     The current objects being updated
     */
    var updatedObjects = [NSIndexPath: AnyObject]()
    
    weak var resultsController: NSFetchedResultsController?
    weak var dataSource: StaticDataSource<S>?
    weak var view: V?
    
    var section: S? {
        if let dataSource = self.dataSource, resultsController = self.resultsController {
            return dataSource.sectionForFetchedResultsController(resultsController)
        }
        
        return nil
    }
    
    var sectionIndex: Int? {
        if let dataSource = self.dataSource, section = self.section {
            return dataSource.sectionIndexForSection(section)
        }
        
        return nil
    }
}
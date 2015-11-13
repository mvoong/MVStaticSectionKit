//
//  FetchedDataSource.swift
//  Pods
//
//  Created by Michael Voong on 13/11/2015.
//
//

import CoreData

public class FetchedDataSource : NSObject, DataSource {
    let resultsController: NSFetchedResultsController
    
    public init(resultsController: NSFetchedResultsController) {
        self.resultsController = resultsController
    }
    
    public func numberOfSections() -> Int {
        return self.resultsController.sections?.count ?? 0
    }
    
    public func numberOfItems() -> Int {
        return self.resultsController.fetchedObjects?.count ?? 0
    }
    
    public func numberOfItemsInSection(index: Int) -> Int {
        return self.resultsController.sections?[index].numberOfObjects ?? 0
    }
    
    public func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject? {
        return self.resultsController.objectAtIndexPath(indexPath)
    }
}
//
//  TableFetchedResultsControllerDelegate.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 13/11/2015.
//
//

import CoreData
import UIKit

public class TableFetchedResultsControllerDelegate : FetchedResultsControllerDelegate<TableSection, UITableView>, NSFetchedResultsControllerDelegate {
    public init(view: UITableView, resultsController: NSFetchedResultsController, dataSource: TableDataSource) {
        super.init()
        
        self.view = view
        self.resultsController = resultsController
        self.dataSource = dataSource
        
        resultsController.delegate = self
    }
    
    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
        guard !self.disableAnimations && self.section != nil else {
            return
        }

        self.view?.beginUpdates()
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        guard let section = self.section, sectionIndex = self.sectionIndex else {
            return
        }
        
        switch type {
        case .Insert:
            if let newIndexPath = newIndexPath {
                self.view?.insertRowsAtIndexPaths([NSIndexPath(forRow: newIndexPath.row, inSection: sectionIndex)], withRowAnimation: .Middle)
            }
        case .Delete:
            if let indexPath = indexPath {
                self.view?.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: sectionIndex)], withRowAnimation: .Middle)
            }
        case .Update:
            if let indexPath = indexPath,
                cell = self.view?.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: sectionIndex)),
                configureCell = section.configureCell {
                    configureCell(tableView: self.view!, cell: cell, item: anObject)
            }
        case .Move:
            if let indexPath = indexPath, newIndexPath = newIndexPath {
                self.view?.moveRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: sectionIndex), toIndexPath: NSIndexPath(forRow: newIndexPath.row, inSection: sectionIndex))
            }
        }
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        guard !self.disableAnimations else {
            self.view?.reloadData()
            return
        }
        
        self.view?.endUpdates()

        self.updatedObjects.removeAll()
        self.objectChanges.removeAll()
    }
}
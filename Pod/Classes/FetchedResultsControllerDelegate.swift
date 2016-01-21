//
//  FetchedResultsControllerDelegate.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 13/11/2015.
//
//

import CoreData
import UIKit

class FetchedResultsControllerDelegate : NSObject {
    typealias ObjectChangeTuple = (changeType: NSFetchedResultsChangeType, indexPaths: [NSIndexPath])
    
    var objectChanges = [ObjectChangeTuple]()
    var updatedObjects = [NSIndexPath: AnyObject]()
    
    weak var resultsController: NSFetchedResultsController?
    
    init(resultsController: NSFetchedResultsController) {
        super.init()
        
        self.resultsController = resultsController
        try! resultsController.performFetch()
    }
    
    deinit {
        if resultsController?.delegate === self {
            resultsController?.delegate = nil
        }
    }
}

class TableFetchedResultsControllerDelegate : FetchedResultsControllerDelegate, NSFetchedResultsControllerDelegate {
    private weak var tableView: UITableView?
    private weak var dataSource: TableDataSource?
    
    init(tableView: UITableView, resultsController: NSFetchedResultsController, dataSource: TableDataSource) {
        super.init(resultsController: resultsController)
        
        self.tableView = tableView
        self.dataSource = dataSource
        
        resultsController.delegate = self
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView?.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let newIndexPath = newIndexPath,
                sectionIndex = self.dataSource?.convertSectionForResultsController(controller, sectionIndex: newIndexPath.section) {
                    self.tableView?.insertRowsAtIndexPaths([NSIndexPath(forRow: newIndexPath.row, inSection: sectionIndex)], withRowAnimation: .Middle)
            }
        case .Delete:
            if let indexPath = indexPath,
                sectionIndex = self.dataSource?.convertSectionForResultsController(controller, sectionIndex: indexPath.section) {
                    self.tableView?.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: sectionIndex)], withRowAnimation: .Middle)
            }
        case .Update:
            if let indexPath = indexPath,
                sectionIndex = self.dataSource?.convertSectionForResultsController(controller, sectionIndex: indexPath.section),
                cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: sectionIndex)),
                configureCell = self.dataSource?.configureCellForSection(indexPath.section) {
                    configureCell(cell: cell, object: anObject)
            }
        case .Move:
            if let indexPath = indexPath, newIndexPath = newIndexPath,
                sectionIndex = self.dataSource?.convertSectionForResultsController(controller, sectionIndex: indexPath.section),
                newSectionIndex = self.dataSource?.convertSectionForResultsController(controller, sectionIndex: newIndexPath.section) {
                    self.tableView?.moveRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: sectionIndex), toIndexPath: NSIndexPath(forRow: newIndexPath.row, inSection: newSectionIndex))
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            if let sectionIndex = self.dataSource?.convertSectionForResultsController(controller, sectionIndex: sectionIndex) {
                self.tableView?.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Middle)
            }
        case .Delete:
            if let sectionIndex = self.dataSource?.convertSectionForResultsController(controller, sectionIndex: sectionIndex) {
                self.tableView?.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Middle)
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView?.endUpdates()
        
        self.updatedObjects.removeAll()
        self.objectChanges.removeAll()
    }
}

class CollectionFetchedResultsControllerDelegate : FetchedResultsControllerDelegate, NSFetchedResultsControllerDelegate {
    weak var collectionView: UICollectionView?
    weak var dataSource: CollectionDataSource?
    var showEmptyCell = false
    
    init(collectionView: UICollectionView, resultsController: NSFetchedResultsController, dataSource: CollectionDataSource) {
        super.init(resultsController: resultsController)
        
        self.collectionView = collectionView
        self.dataSource = dataSource
        
        resultsController.delegate = self
    }
    
    func showEmptyCellAtSection(sectionIndex: Int) -> Bool {
        return dataSource?.isSectionEmpty(sectionIndex) == true && dataSource?.emptyCellFactoryForSection(sectionIndex) != nil
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        showEmptyCell = self.dataSource?.isSectionEmpty(0) == true
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let newIndexPath = newIndexPath,
                sectionIndex = self.dataSource?.convertSectionForResultsController(controller, sectionIndex: newIndexPath.section) {
                    if newIndexPath.row == 0 && showEmptyCell {
                        // First object inserted, "empty cell" is replaced by "object cell"
                        self.objectChanges.append((.Update, [(NSIndexPath(forItem: newIndexPath.row, inSection: sectionIndex))]))
                    } else {
                        self.objectChanges.append((type, [(NSIndexPath(forItem: newIndexPath.row, inSection: sectionIndex))]))
                    }
            }
        case .Delete:
            if let indexPath = indexPath,
                sectionIndex = self.dataSource?.convertSectionForResultsController(controller, sectionIndex: indexPath.section) {
                    // Last object removed, "cell" is replaced by "placeholder cell"
                    if showEmptyCellAtSection(sectionIndex) {
                        self.objectChanges.append((.Update, [(NSIndexPath(forItem: indexPath.row, inSection: sectionIndex))]))
                    } else {
                        self.objectChanges.append((type, [(NSIndexPath(forItem: indexPath.row, inSection: sectionIndex))]))
                    }
            }
        case .Update:
            if let indexPath = indexPath,
                sectionIndex = self.dataSource?.convertSectionForResultsController(controller, sectionIndex: indexPath.section) {
                    self.objectChanges.append((type, [(NSIndexPath(forItem: indexPath.row, inSection: sectionIndex))]))
                    self.updatedObjects[indexPath] = anObject
            }
        case .Move:
            if let indexPath = indexPath, newIndexPath = newIndexPath,
                sectionIndex = self.dataSource?.convertSectionForResultsController(controller, sectionIndex: indexPath.section),
                newSectionIndex = self.dataSource?.convertSectionForResultsController(controller, sectionIndex: newIndexPath.section) {
                    self.objectChanges.append((type, [NSIndexPath(forItem: indexPath.row, inSection: sectionIndex), NSIndexPath(forItem: newIndexPath.row, inSection: newSectionIndex)]))
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.collectionView?.performBatchUpdates({
            for (changeType, indexPaths) in self.objectChanges {
                switch(changeType) {
                case .Insert:
                    self.collectionView?.insertItemsAtIndexPaths(indexPaths)
                case .Delete:
                    self.collectionView?.deleteItemsAtIndexPaths(indexPaths)
                case .Update:
                    // Reconfigure cell if item represents an object
                    if let indexPath = indexPaths.first,
                        object = self.updatedObjects[indexPath],
                        cell = self.collectionView?.cellForItemAtIndexPath(indexPath),
                        configureCell = self.dataSource?.configureCellForSection(indexPath.section) {
                            configureCell(cell: cell, object: object)
                    } else {
                        // Reload item, e.g. if it changed into an empty cell
                        self.collectionView?.reloadItemsAtIndexPaths(indexPaths)
                    }
                case .Move:
                    if let deleteIndexPath = indexPaths.first {
                        self.collectionView?.deleteItemsAtIndexPaths([deleteIndexPath])
                    }
                    
                    if let insertIndexPath = indexPaths.last {
                        self.collectionView?.insertItemsAtIndexPaths([insertIndexPath])
                    }
                }
            }
        }, completion: { finished in
            self.updatedObjects.removeAll()
            self.objectChanges.removeAll()
        })
    }
}
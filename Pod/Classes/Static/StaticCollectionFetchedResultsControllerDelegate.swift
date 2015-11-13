//
//  CollectionFetchedResultsControllerDelegate.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 13/11/2015.
//
//

import CoreData
import UIKit

public class StaticCollectionFetchedResultsControllerDelegate : StaticFetchedResultsControllerDelegate<CollectionSection, UICollectionView>, NSFetchedResultsControllerDelegate {
    public init(view: UICollectionView, resultsController: NSFetchedResultsController, dataSource: StaticCollectionDataSource) {
        super.init()
        
        self.view = view
        self.resultsController = resultsController
        self.dataSource = dataSource
        
        resultsController.delegate = self
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        guard let sectionIndex = self.sectionIndex else {
            return
        }
        
        switch type {
        case .Insert:
            if let newIndexPath = newIndexPath {
                self.objectChanges.append((type, [(NSIndexPath(forItem: newIndexPath.row, inSection: sectionIndex))]))
            }
        case .Delete:
            if let indexPath = indexPath {
                self.objectChanges.append((type, [(NSIndexPath(forItem: indexPath.row, inSection: sectionIndex))]))
            }
        case .Update:
            if let indexPath = indexPath {
                self.objectChanges.append((type, [(NSIndexPath(forItem: indexPath.row, inSection: sectionIndex))]))
                self.updatedObjects[indexPath] = anObject
            }
        case .Move:
            if let oldIndexPath = indexPath, newIndexPath = newIndexPath {
                self.objectChanges.append((type, [NSIndexPath(forItem: oldIndexPath.row, inSection: sectionIndex), NSIndexPath(forItem: newIndexPath.row, inSection: sectionIndex)]))
            }
        }
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        guard !self.disableAnimations else {
            self.view?.reloadData()
            return
        }
        
        guard let section = self.section else {
            return
        }
        
        self.view?.performBatchUpdates({
            for (changeType, indexPaths) in self.objectChanges {
                switch(changeType) {
                case .Insert:
                    self.view?.insertItemsAtIndexPaths(indexPaths)
                case .Delete:
                    self.view?.deleteItemsAtIndexPaths(indexPaths)
                case .Update:
                    if let indexPath = indexPaths.first,
                        object = self.updatedObjects[indexPath],
                        cell = self.view?.cellForItemAtIndexPath(indexPath),
                        configureCell = section.configureCell {
                            configureCell(collectionView: self.view!, cell: cell, item: object)
                    }
                case .Move:
                    if let deleteIndexPath = indexPaths.first {
                        self.view?.deleteItemsAtIndexPaths([deleteIndexPath])
                    }
                    
                    if let insertIndexPath = indexPaths.last {
                        self.view?.insertItemsAtIndexPaths([insertIndexPath])
                    }
                }
            }
        }, completion: { finished in
            self.updatedObjects.removeAll()
            self.objectChanges.removeAll()
        })
    }
    
    deinit {
        if self.view?.dataSource === self {
            self.view?.dataSource = nil
        }
    }
}
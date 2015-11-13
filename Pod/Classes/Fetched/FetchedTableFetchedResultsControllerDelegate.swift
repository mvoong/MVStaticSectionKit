//
//  FetchedTableFetchedResultsControllerDelegate.swift
//  Pods
//
//  Created by Michael Voong on 13/11/2015.
//
//

import CoreData

public class FetchedTableFetchedResultsControllerDelegate : NSObject, NSFetchedResultsControllerDelegate {
    weak var tableView: UITableView?
    weak var resultsController: NSFetchedResultsController?
    weak var dataSource: FetchedTableDataSource?
    
    public init(tableView: UITableView, resultsController: NSFetchedResultsController, dataSource: FetchedTableDataSource) {
        super.init()
        
        self.tableView = tableView
        self.resultsController = resultsController
        self.dataSource = dataSource
        
        resultsController.delegate = self
    }
    
    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView?.beginUpdates()
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if let tableView = self.tableView {
            switch type {
            case .Insert:
                if let newIndexPath = newIndexPath {
                    tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Middle)
                }
            case .Delete:
                if let indexPath = indexPath {
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)
                }
            case .Update:
                if let indexPath = indexPath,
                    cell = tableView.cellForRowAtIndexPath(indexPath),
                    configureCell = self.dataSource?.configureCell {
                        configureCell(tableView: tableView, cell: cell, item: anObject)
                }
            case .Move:
                if let indexPath = indexPath, newIndexPath = newIndexPath {
                    tableView.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
                }
            }
        }
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        if let tableView = self.tableView {
            switch type {
            case .Insert:
                tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Middle)
            case .Delete:
                tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Middle)
            default:
                break
            }
        }
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView?.endUpdates()
    }
    
    deinit {
        if self.resultsController?.delegate === self {
            self.resultsController?.delegate = nil
        }
    }
}

//
//  TableDataSource.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 12/11/2015.
//  Copyright © 2015 Michael Voong. All rights reserved.
//

import CoreData

public class TableDataSource : DataSource<TableSection>, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    var updatingSection: SectionType?
    var trackUpdates: Bool?
    var disableAnimations = false
    var updatedCells: [UITableViewCell]?
    weak var tableView: UITableView?
    
    /**
     Initialises the data source with a given table. A weak reference is made to the table view.
     
     - parameter tableView: The table view
     */
    public init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.dataSource = self
    }
    
    /**
     Returns the selected object, or nil if there is no selection

     - returns: The selected object or nil
     */
    public func selectedObject() -> AnyObject? {
        guard let indexPath = self.tableView?.indexPathForSelectedRow else {
            return nil
        }
        return self.objectAtIndexPath(indexPath)
    }
    
    // MARK: UITableViewDataSource
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionForIndex(section)?.numberOfItems() ?? 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var item = self.objectAtIndexPath(indexPath)
        
        if let object = item as? Item {
            item = object.object ?? object
        }
        
        let section = self.sectionForIndex(indexPath.section)!
        
        if let cellFactory = section.cellFactory {
            let cell = cellFactory(tableView: tableView, indexPath: indexPath, item: item!)
            if let configureCell = section.configureCell {
                configureCell(tableView: tableView, item: item!)
            }
            return cell
        }
        
        return UITableViewCell()
    }

    
    deinit {
        if self.tableView?.dataSource === self {
            self.tableView?.dataSource = nil
        }
    }
}

// MARK: NSFetchedResultsController

extension TableDataSource {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        let sectionIndex = self.sectionIndexForFetchedResultsController(controller)!
        self.updatingSection = self.sectionForIndex(sectionIndex)
        self.trackUpdates = self.updatingSection?.fetchedResultsController != nil
        
        if self.trackUpdates == true {
            if !self.disableAnimations {
                self.updatedCells = []
                self.tableView?.beginUpdates()
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        guard self.trackUpdates == true && !self.disableAnimations else {
            return
        }
        
        guard let sectionIndex = self.sectionIndexForFetchedResultsController(controller) else {
            return
        }
        
        switch type {
            case .Insert:
                self.tableView?.insertRowsAtIndexPaths([NSIndexPath(forRow: newIndexPath!.row, inSection: sectionIndex)], withRowAnimation: .Middle)
            case .Delete:
                self.tableView?.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath!.row, inSection: sectionIndex)], withRowAnimation: .Middle)
            case .Update:
                if let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath!.row, inSection: sectionIndex)) {
                    self.updatedCells!.append(cell)
                }
            case .Move:
                self.tableView?.moveRowAtIndexPath(NSIndexPath(forRow: indexPath!.row, inSection: sectionIndex), toIndexPath: NSIndexPath(forRow: newIndexPath!.row, inSection: sectionIndex))
            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if self.trackUpdates == true {
            if self.disableAnimations {
                self.tableView?.reloadData()
            } else {
                self.tableView?.endUpdates()
                
                if let updatedCells = updatedCells {
                    for cell in updatedCells {
                        if let indexPath = self.tableView?.indexPathForCell(cell) {
                            // Reconfigure cell
                            let section = self.sectionForIndex(indexPath.section)
                            if let object = section?.objectAtIndex(indexPath.row), let configureCell = section?.configureCell {
                                configureCell(tableView: self.tableView!, item: object)
                            }
                        }
                    }
                }
                
                self.updatedCells = nil
            }
        } else {
            self.tableView?.reloadData()
        }
    }
}

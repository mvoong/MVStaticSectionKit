//
//  StaticTableDataSource.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 12/11/2015.
//  Copyright © 2015 Michael Voong. All rights reserved.
//

import CoreData

public class StaticTableDataSource : StaticDataSource<TableSection>, UITableViewDataSource {
    /**
     The associated view
     */
    weak var tableView: UITableView?
    
    /**
     Initialises the data source with a given table. A weak reference is made to the table view.
     
     - parameter view: The table view
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
        guard let object = self.objectAtIndexPath(indexPath), section = self.sectionForIndex(indexPath.section), cellFactory = section.cellFactory else {
            fatalError("Invalid section: \(indexPath)")
        }
        
        let cell = cellFactory(tableView: tableView, indexPath: indexPath, item: object)
        
        if let configureCell = section.configureCell {
            configureCell(tableView: tableView, cell: cell, item: object)
        }
        
        return cell
    }
    
    override func updateResultsControllerDelegates() {
        for section in self.sections {
            if let tableView = self.tableView, resultsController = section.fetchedResultsController {
                if self.resultsControllerDelegates[resultsController] == nil {
                    self.resultsControllerDelegates[resultsController] = StaticTableFetchedResultsControllerDelegate(view: tableView, resultsController: resultsController, dataSource: self)
                }
            }
        }
    }
    
    deinit {
        if self.tableView?.dataSource === self {
            self.tableView?.dataSource = nil
        }
    }
}
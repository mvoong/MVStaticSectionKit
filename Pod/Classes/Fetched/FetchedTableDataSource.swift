//
//  FetchedTableDataSource.swift
//  Pods
//
//  Created by Michael Voong on 13/11/2015.
//
//

import CoreData

public class FetchedTableDataSource: FetchedDataSource, UITableViewDataSource {
    public typealias CellFactoryType = (tableView: UITableView, indexPath: NSIndexPath, item: AnyObject) -> (UITableViewCell)
    public typealias ConfigureCellType = (tableView: UITableView, cell: UITableViewCell, item: AnyObject) -> (UITableViewCell)
    
    /**
     The associated view
     */
    weak var tableView: UITableView?
    
    var cellFactory: CellFactoryType?
    var configureCell: ConfigureCellType?
    var resultsControllerDelegate: FetchedTableFetchedResultsControllerDelegate?
    
    /**
     Initialises the data source with a given table. A weak reference is made to the table view.
     
     - parameter view: The table view
     */
    public init(tableView: UITableView, resultsController: NSFetchedResultsController) {
        super.init(resultsController: resultsController)
        
        self.tableView = tableView
        tableView.dataSource = self
        
        self.resultsControllerDelegate = FetchedTableFetchedResultsControllerDelegate(tableView: tableView, resultsController: resultsController, dataSource: self)
    }
    
    public func withCellFactory(cellFactory: CellFactoryType) -> Self {
        self.cellFactory = cellFactory
        return self
    }
    
    public func withConfigureCell(configureCell: ConfigureCellType) -> Self {
        self.configureCell = configureCell
        return self
    }
    
    // Mark: UITableViewDataSource
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfItemsInSection(section)
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let object = self.objectAtIndexPath(indexPath), cellFactory = self.cellFactory else {
            fatalError("Invalid section: \(indexPath)")
        }
        
        let cell = cellFactory(tableView: tableView, indexPath: indexPath, item: object)
        
        if let configureCell = self.configureCell {
            configureCell(tableView: tableView, cell: cell, item: object)
        }
        
        return cell
    }
    
    deinit {
        if self.tableView?.dataSource === self {
            self.tableView?.dataSource = nil
        }
    }
}
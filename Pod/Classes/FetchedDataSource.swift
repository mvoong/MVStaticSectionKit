//
//  FetchedDataSource.swift
//  Pods
//
//  Created by Michael Voong on 13/11/2015.
//
//

import CoreData

// MARK: FetchedDataSource

public class FetchedDataSource : NSObject {
    let resultsController: NSFetchedResultsController
    
    public init(resultsController: NSFetchedResultsController) {
        self.resultsController = resultsController
    }
}

extension FetchedDataSource : DataSource {
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
    
    /**
     No change in mapping required, as the results controller sections matches the `UITableView` sections
     
     - returns: The original section index, unchanged
     */
    public func convertSectionForResultsController(resultsController: NSFetchedResultsController, sectionIndex: Int) -> Int {
        return sectionIndex
    }
    
    public func titleForSection(index: Int) -> String? {
        return self.resultsController.sections?[index].name
    }
    
    public func footerTitleForSection(index: Int) -> String? {
        return nil
    }
}

// MARK: FetchedTableDataSource

public class FetchedTableDataSource : FetchedDataSource {
    var tableViewAdapter: TableViewAdapter!
    
    var cellFactory: TableCellFactoryType!
    var configureCell: TableConfigureCellType?
    var sectionViewFactory: TableSectionViewFactoryType?
    var resultsControllerDelegate: TableFetchedResultsControllerDelegate?
    var reuseIdentifier: String?
    
    /**
     Initialises the data source with a given table. A weak reference is made to the table view.
     
     - parameter view: The table view
     */
    public init(tableView: UITableView, resultsController: NSFetchedResultsController) {
        super.init(resultsController: resultsController)
        
        self.tableViewAdapter = TableViewAdapter(tableView: tableView, dataSource: self)
        self.resultsControllerDelegate = TableFetchedResultsControllerDelegate(tableView: tableView, resultsController: resultsController, dataSource: self)
    }
    
    public func withCellFactory(cellFactory: TableCellFactoryType, configureCell: TableConfigureCellType? = nil) -> Self {
        self.cellFactory = cellFactory
        self.configureCell = configureCell
        
        return self
    }
    
    public func withConfigureCell(configureCell: TableConfigureCellType) -> Self {
        self.configureCell = configureCell
        
        return self
    }
    
    public func withReuseIdentifier(reuseIdentifier: String) -> Self {
        self.reuseIdentifier = reuseIdentifier
        
        return self
    }
}

extension FetchedTableDataSource : TableDataSource {
    public func cellFactoryForSection(sectionIndex: Int) -> TableCellFactoryType {
        return self.cellFactory!
    }
    
    public func configureCellForSection(sectionIndex: Int) -> TableConfigureCellType? {
        return self.configureCell
    }
    
    public func sectionViewFactoryForSection(sectionIndex: Int) -> TableSectionViewFactoryType? {
        return self.sectionViewFactory
    }
    
    public func reuseIdentifierForSection(sectionIndex: Int) -> String? {
        return self.reuseIdentifier
    }
}
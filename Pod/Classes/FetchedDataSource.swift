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
}

// MARK: FetchedTableDataSource

public class FetchedTableDataSource : FetchedDataSource {
    weak var tableView: UITableView?
    
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
        
        self.tableView = tableView
        tableView.dataSource = self
        
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

    deinit {
        if self.tableView?.dataSource === self {
            self.tableView?.dataSource = nil
        }
    }
}

extension FetchedTableDataSource : UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfItemsInSection(section)
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let object = self.objectAtIndexPath(indexPath) else {
            fatalError("Invalid section: \(indexPath)")
        }
        
        var cell: UITableViewCell?

        if let reuseIdentifier = self.reuseIdentifier {
            cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        } else if let cellFactory = self.cellFactory {
            cell = cellFactory(tableView: tableView, indexPath: indexPath, object: object)
        }
        
        if let configureCell = self.configureCell {
            configureCell(cell: cell!, object: object)
        }
        
        return cell!
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
}
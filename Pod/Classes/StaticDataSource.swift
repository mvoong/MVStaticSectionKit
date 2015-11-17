//
//  StaticDataSource.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 12/11/2015.
//  Copyright © 2015 Michael Voong. All rights reserved.
//

import Foundation
import CoreData

// MARK: StaticDataSource

public class StaticDataSource<S: Section> : NSObject {
    /**
     The static sections
     */
    private lazy var sections = [S]()
    
    private lazy var resultsControllerDelegates = [NSFetchedResultsController: NSFetchedResultsControllerDelegate]()

    /**
     Add an empty `Section` to the receiver
     
     - returns: The empty `Section` that has been added
     */
    public func addSection(title: String? = nil) -> S {
        let section = S()
        section.title = title
        self.addSection(section)
        
        return section
    }
    
    /**
     Add a `Section` to the receiver
     
     - returns: The `Section` that has been added
     */
    public func addSection(section: S) -> S {
        self.sections.append(section)
        
        section.resultsControllerChanged = { [unowned self] in
            self.updateResultsControllerDelegates()
        }
        
        return section
    }

    /**
     Inserts a `Section` to the receiver
     
     -  returns: The `Section` that has been inserted
     */
    public func insertSection(section: S, atIndex: Int) -> S {
        self.sections.insert(section, atIndex: atIndex)
        
        section.resultsControllerChanged = { [unowned self] in
            self.updateResultsControllerDelegates()
        }
        
        return section
    }
    
    /**
     Deletes a section from the receiver
     */
    public func deleteSection(section: S, atIndex: Int) {
        if let resultsController = section.fetchedResultsController {
            resultsController.delegate = nil
            self.resultsControllerDelegates.removeValueForKey(resultsController)
        }
        
        self.sections.removeObject(section)
    }

    /**
     Finds the `Section` for the given index
     
     - returns: The `Section`, or nil if no section exists at that index
     */
    func sectionForIndex(index: Int) -> S? {
        return self.sections[index]
    }
    
    /**
     Finds the index of the section that has the given `NSFetchedResultsController` assigned
     
     - parameter resultsController: The results controller to search the sections for
     - returns: The index of the found `Section`
     */
    func sectionIndexForFetchedResultsController(resultsController: NSFetchedResultsController) -> Int? {
        if let section = self.sectionForFetchedResultsController(resultsController) {
            return self.sectionIndexForSection(section)
        }
        
        return nil
    }
    
    /**
     Finds the `Section` for the given fetched results controller
     
     - parameter resultsController: The results controller to search the sections for
     - returns: The found `Section`
     */
    func sectionForFetchedResultsController(resultsController: NSFetchedResultsController) -> S? {
        for section in self.sections {
            if section.fetchedResultsController == resultsController {
                return section
            }
        }
        return nil
    }
    
    /**
     Finds the index for a given `Section`
     
     - parameter section: The `Section` to search for
     */
    func sectionIndexForSection(section: S) -> Int? {
        return self.sections.indexOf(section)
    }
    
    func updateResultsControllerDelegates() {
        fatalError("updateResultsControllerDelegates not implemented")
    }
}

extension StaticDataSource : DataSource {
    /**
     - returns: The number of `Section` objects
     */
    public func numberOfSections() -> Int {
        return self.sections.count
    }
    
    /**
     - parameter index: The index of the `Section`
     - returns: The number of items in a given `Section`
     */
    public func numberOfItemsInSection(index: Int) -> Int {
        return self.sections[index].numberOfItems()
    }
    
    /**
     - returns: The total number of `Item` objects across all sections
     */
    public func numberOfItems() -> Int {
        var count = 0
        for section in self.sections {
            count += section.numberOfItems()
        }
        
        return count
    }
    
    /**
     Finds the object at a given index path. For convenience, if the object is a subclass of `Item` and the item has an assigned `object`,
     that object will be returned. Otherwise, the item is returned.
     
     - returns: The object, or nil if there is no object at the specified index path
     */
    public func objectAtIndexPath(indexPath: NSIndexPath) -> Any? {
        return self.sections[indexPath.section].objectAtIndex(indexPath.row)
    }
    
    public func titleForSection(index: Int) -> String? {
        return self.sectionForIndex(index)?.title
    }
    
    public func footerTitleForSection(index: Int) -> String? {
        return self.sectionForIndex(index)?.footerTitle
    }
    
    /**
     Maps the section for the results controller to the actual UITableView section
     */
    public func convertSectionForResultsController(resultsController: NSFetchedResultsController, sectionIndex: Int) -> Int {
        return self.sectionIndexForFetchedResultsController(resultsController)!
    }
}

// MARK: StaticTableDataSource

public class StaticTableDataSource : StaticDataSource<TableSection> {
    weak var tableView: UITableView?
    var tableViewAdapter: TableViewAdapter!
    
    /**
     Initialises the data source with a given table. A weak reference is made to the table view.
     
     - parameter view: The table view
     */
    public init(tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        self.tableViewAdapter = TableViewAdapter(tableView: tableView, dataSource: self)
    }
    
    /**
     Returns the selected object, or nil if there is no selection
     
     - returns: The selected object or nil
     */
    public func selectedObject() -> Any? {
        guard let indexPath = self.tableView?.indexPathForSelectedRow else {
            return nil
        }
        return self.objectAtIndexPath(indexPath)
    }

    override func updateResultsControllerDelegates() {
        for section in self.sections {
            if let tableView = self.tableView, resultsController = section.fetchedResultsController {
                if self.resultsControllerDelegates[resultsController] == nil {
                    self.resultsControllerDelegates[resultsController] = TableFetchedResultsControllerDelegate(tableView: tableView, resultsController: resultsController, dataSource: self)
                }
            }
        }
    }
}

extension StaticTableDataSource : TableDataSource {
    public func cellFactoryForSection(sectionIndex: Int) -> TableCellFactoryType {
        return (self.sectionForIndex(sectionIndex)?.cellFactory!)!
    }
    
    public func configureCellForSection(sectionIndex: Int) -> TableConfigureCellType? {
        return self.sectionForIndex(sectionIndex)?.configureCell
    }
    
    public func sectionViewFactoryForSection(sectionIndex: Int) -> TableSectionViewFactoryType? {
        return self.sectionForIndex(sectionIndex)?.sectionViewFactory
    }
    
    public func reuseIdentifierForSection(sectionIndex: Int) -> String? {
        return self.sectionForIndex(sectionIndex)?.reuseIdentifier
    }
}

// MARK: StaticCollectionDataSource

public class StaticCollectionDataSource : StaticDataSource<CollectionSection> {
    weak var collectionView: UICollectionView?
    var collectionViewAdapter: CollectionViewAdapter!
    
    public init(collectionView: UICollectionView) {
        super.init()
        
        self.collectionView = collectionView
        
        self.collectionViewAdapter = CollectionViewAdapter(collectionView: collectionView, dataSource: self)
    }
    
    override func updateResultsControllerDelegates() {
        for section in self.sections {
            if let collectionView = self.collectionView, resultsController = section.fetchedResultsController {
                if self.resultsControllerDelegates[resultsController] == nil {
                    self.resultsControllerDelegates[resultsController] = CollectionFetchedResultsControllerDelegate(collectionView: collectionView, resultsController: resultsController, dataSource: self)
                }
            }
        }
    }
}

extension StaticCollectionDataSource : CollectionDataSource {
    public func cellFactoryForSection(sectionIndex: Int) -> CollectionCellFactoryType {
        return (self.sectionForIndex(sectionIndex)?.cellFactory!)!
    }
    
    public func configureCellForSection(sectionIndex: Int) -> CollectionConfigureCellType? {
        return self.sectionForIndex(sectionIndex)?.configureCell
    }
    
    public func sectionViewFactoryForSection(sectionIndex: Int) -> CollectionSectionViewFactoryType? {
        return self.sectionForIndex(sectionIndex)?.sectionViewFactory
    }
}

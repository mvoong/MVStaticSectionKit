//
//  Section.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 12/11/2015.
//  Copyright © 2015 Michael Voong. All rights reserved.
//

import CoreData

public class Section : NSObject {
    public var title: String?
    public var items = [AnyObject]()
    public var reuseIdentifier: String?
    
    var resultsControllerChanged: (() -> Void)?
    
    var fetchedResultsController: NSFetchedResultsController? {
        didSet {
            if oldValue != fetchedResultsController {
                oldValue?.delegate = nil
                self.resultsControllerChanged?()
            }
        }
    }
    
    public override required init() {
        super.init()
    }
    
    public init(title: String, fetchedResultsController: NSFetchedResultsController) {
        self.title = title
        self.fetchedResultsController = fetchedResultsController
    }
    
    public init(_ title: String, items: [AnyObject]) {
        self.title = title
        self.items = items
    }
    
    public func withResultsController(resultsController: NSFetchedResultsController) -> Self {
        self.fetchedResultsController = resultsController
        
        return self
    }
    
    public func withItems(items: [AnyObject]) -> Self {
        self.items = items
        
        return self
    }
    
    public func withReuseIdentifier(reuseIdentifier: String) -> Self {
        self.reuseIdentifier = reuseIdentifier
        
        return self
    }
    
    public func addItem(item: AnyObject) {
        self.items.append(item)
    }
    
    public func objectAtIndex(index: Int) -> AnyObject? {
        if let controller = self.fetchedResultsController {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            return controller.objectAtIndexPath(indexPath)
        } else if index < self.items.count {
            return self.items[index]
        }
        
        return nil
    }
    
    public func numberOfItems() -> Int {
        if let fetchedResultsController = self.fetchedResultsController {
            return fetchedResultsController.fetchedObjects?.count ?? 0
        } else {
            return self.items.count
        }
    }
}

public class TableSection : Section {
    var cellFactory: TableCellFactoryType!
    var configureCell: TableConfigureCellType?
    var sectionViewFactory: TableSectionViewFactoryType?
    
    required public init() {
        super.init()
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
    
    public func withSectionViewFactory(sectionViewFactory: TableSectionViewFactoryType) -> Self {
        self.sectionViewFactory = sectionViewFactory
        
        return self
    }
}

public class CollectionSection : Section {
    var cellFactory: CollectionCellFactoryType!
    var configureCell: CollectionConfigureCellType?
    var sectionViewFactory: CollectionSectionViewFactoryType?
    
    public required init() {
        super.init()
    }
    
    public func withCellFactory(cellFactory: CollectionCellFactoryType) -> Self {
        self.cellFactory = cellFactory
        self.reuseIdentifier = nil
        
        return self
    }
    
    public func withConfigureCell(configureCell: CollectionConfigureCellType) -> Self {
        self.configureCell = configureCell
        
        return self
    }
    
    public func withSectionViewFactory(sectionViewFactory: CollectionSectionViewFactoryType) -> Self {
        self.sectionViewFactory = sectionViewFactory
        
        return self
    }
}

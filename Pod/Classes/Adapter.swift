//
//  Adapter.swift
//  Pods
//
//  Created by Michael Voong on 15/11/2015.
//
//

import UIKit

class TableViewAdapter : NSObject, UITableViewDataSource {
    weak var dataSource: TableDataSource?
    weak var tableView: UITableView?
    
    init(tableView: UITableView, dataSource: TableDataSource) {
        super.init()
        
        self.tableView = tableView
        self.dataSource = dataSource
        
        tableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataSource?.numberOfSections() ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.numberOfItemsInSection(section) ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let object = self.dataSource?.objectAtIndexPath(indexPath) else {
            fatalError("Invalid section: \(indexPath)")
        }
        
        var cell: UITableViewCell?
        
        if let reuseIdentifier = self.dataSource?.reuseIdentifierForSection(indexPath.section) {
            cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        } else if let cellFactory = self.dataSource?.cellFactoryForSection(indexPath.section) {
            cell = cellFactory(tableView: tableView, indexPath: indexPath, object: object)
        }
        
        if let configureCell = self.dataSource?.configureCellForSection(indexPath.section) {
            configureCell(cell: cell!, object: object)
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dataSource?.titleForSection(section)
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.dataSource?.footerTitleForSection(section)
    }
    
    deinit {
        if self.tableView?.dataSource === self {
            self.tableView?.dataSource = nil
        }
    }
}

class CollectionViewAdapter : NSObject, UICollectionViewDataSource {
    weak var dataSource: CollectionDataSource?
    weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView, dataSource: CollectionDataSource) {
        super.init()
        
        self.collectionView = collectionView
        self.dataSource = dataSource
        
        collectionView.dataSource = self
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.dataSource?.numberOfSections() ?? 0
    }
    
    func showEmptyCellAtSection(sectionIndex: Int) -> Bool {
        return dataSource?.isSectionEmpty(sectionIndex) == true && dataSource?.emptyCellFactoryForSection(sectionIndex) != nil
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if showEmptyCellAtSection(section) {
            return 1
        } else {
            return self.dataSource?.numberOfItemsInSection(section) ?? 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if showEmptyCellAtSection(indexPath.section) {
            let cellFactory = self.dataSource?.emptyCellFactoryForSection(indexPath.section)
            
            return cellFactory!(collectionView: collectionView, indexPath: indexPath)
        } else {
            guard let object = self.dataSource?.objectAtIndexPath(indexPath),
                cellFactory = self.dataSource?.cellFactoryForSection(indexPath.section) else {
                    fatalError("Invalid section: \(indexPath)")
            }
            
            let cell = cellFactory(collectionView: collectionView, indexPath: indexPath, object: object)
            
            if let configureCell = self.dataSource?.configureCellForSection(indexPath.section) {
                configureCell(cell: cell, object: object)
            }
            
            return cell
        }
    }
    
    deinit {
        if self.collectionView?.dataSource === self {
            self.collectionView?.dataSource = nil
        }
    }
}
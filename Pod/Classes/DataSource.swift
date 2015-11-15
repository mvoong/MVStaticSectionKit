//
//  DataSource.swift
//  Pods
//
//  Created by Michael Voong on 13/11/2015.
//
//

import UIKit
import CoreData

public protocol DataSource {
    func numberOfSections() -> Int
    func numberOfItemsInSection(index: Int) -> Int
    func numberOfItems() -> Int
    func isEmpty() -> Bool
    func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject?
    func convertSectionForResultsController(resultsController: NSFetchedResultsController, sectionIndex: Int) -> Int
}

extension DataSource {
    public func isEmpty() -> Bool {
        return self.numberOfItems() == 0
    }
}

public typealias TableCellFactoryType = (tableView: UITableView, indexPath: NSIndexPath, object: AnyObject) -> (UITableViewCell)
public typealias TableConfigureCellType = (cell: UITableViewCell, object: AnyObject) -> Void
public typealias TableSectionViewFactoryType = (tableView: UITableView, section: TableSection) -> (UITableViewHeaderFooterView)

public protocol TableDataSource : class, DataSource {
    func cellFactoryForSection(sectionIndex: Int) -> TableCellFactoryType
    func configureCellForSection(sectionIndex: Int) -> TableConfigureCellType?
    func sectionViewFactoryForSection(sectionIndex: Int) -> TableSectionViewFactoryType?
}

public typealias CollectionCellFactoryType = (collectionView: UICollectionView, indexPath: NSIndexPath, object: AnyObject) -> (UICollectionViewCell)
public typealias CollectionConfigureCellType = (cell: UICollectionViewCell, object: AnyObject) -> Void
public typealias CollectionSectionViewFactoryType = (collectionView: UICollectionView, section: CollectionSection) -> (UICollectionReusableView)

public protocol CollectionDataSource : class, DataSource {
    func cellFactoryForSection(sectionIndex: Int) -> CollectionCellFactoryType
    func configureCellForSection(sectionIndex: Int) -> CollectionConfigureCellType?
    func sectionViewFactoryForSection(sectionIndex: Int) -> CollectionSectionViewFactoryType?
}
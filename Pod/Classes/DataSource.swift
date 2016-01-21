//
//  DataSource.swift
//  Pods
//
//  Created by Michael Voong on 13/11/2015.
//
//

import UIKit
import CoreData

public protocol DataSource : NSObjectProtocol {
    func numberOfSections() -> Int
    func numberOfItemsInSection(index: Int) -> Int
    func numberOfItems() -> Int
    func isEmpty() -> Bool
    func titleForSection(index: Int) -> String?
    func footerTitleForSection(index: Int) -> String?
    func objectAtIndexPath(indexPath: NSIndexPath) -> Any?
    func convertSectionForResultsController(resultsController: NSFetchedResultsController, sectionIndex: Int) -> Int
}

extension DataSource {
    public func isEmpty() -> Bool {
        return self.numberOfItems() == 0
    }
    
    public func isSectionEmpty(sectionIndex: Int) -> Bool {
        return self.numberOfItemsInSection(sectionIndex) == 0
    }
}

public typealias TableCellFactoryType = (tableView: UITableView, indexPath: NSIndexPath, object: Any) -> (UITableViewCell)
public typealias TableConfigureCellType = (cell: UITableViewCell, object: Any) -> Void
public typealias TableSectionViewFactoryType = (tableView: UITableView, section: TableSection) -> (UITableViewHeaderFooterView)

public protocol TableDataSource : NSObjectProtocol, DataSource {
    func cellFactoryForSection(sectionIndex: Int) -> TableCellFactoryType
    func reuseIdentifierForSection(sectionIndex: Int) -> String?
    func configureCellForSection(sectionIndex: Int) -> TableConfigureCellType?
    func sectionViewFactoryForSection(sectionIndex: Int) -> TableSectionViewFactoryType?
}

public typealias CollectionCellFactoryType = (collectionView: UICollectionView, indexPath: NSIndexPath, object: Any) -> (UICollectionViewCell)
public typealias CollectionEmptyCellFactoryType = (collectionView: UICollectionView, indexPath: NSIndexPath) -> (UICollectionViewCell)
public typealias CollectionConfigureCellType = (cell: UICollectionViewCell, object: Any) -> Void
public typealias CollectionSectionViewFactoryType = (collectionView: UICollectionView, section: CollectionSection) -> (UICollectionReusableView)

public protocol CollectionDataSource : NSObjectProtocol, DataSource {
    func cellFactoryForSection(sectionIndex: Int) -> CollectionCellFactoryType
    func emptyCellFactoryForSection(sectionIndex: Int) -> CollectionEmptyCellFactoryType?
    func configureCellForSection(sectionIndex: Int) -> CollectionConfigureCellType?
    func sectionViewFactoryForSection(sectionIndex: Int) -> CollectionSectionViewFactoryType?
}
//
//  DataSource.swift
//  Pods
//
//  Created by Michael Voong on 13/11/2015.
//
//

import UIKit
import CoreData

protocol DataSource : NSObjectProtocol {
    func numberOfSections() -> Int
    func numberOfItemsInSection(index: Int) -> Int
    func numberOfItems() -> Int
    func isEmpty() -> Bool
    func titleForSection(index: Int) -> String?
    func footerTitleForSection(index: Int) -> String?
    func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject?
    func convertSectionForResultsController(resultsController: NSFetchedResultsController, sectionIndex: Int) -> Int
}

extension DataSource {
    func isEmpty() -> Bool {
        return self.numberOfItems() == 0
    }
}

public typealias TableCellFactoryType = (tableView: UITableView, indexPath: NSIndexPath, object: AnyObject) -> (UITableViewCell)
public typealias TableConfigureCellType = (cell: UITableViewCell, object: AnyObject) -> Void
public typealias TableSectionViewFactoryType = (tableView: UITableView, section: TableSection) -> (UITableViewHeaderFooterView)

protocol TableDataSource : NSObjectProtocol, DataSource {
    func cellFactoryForSection(sectionIndex: Int) -> TableCellFactoryType
    func reuseIdentifierForSection(sectionIndex: Int) -> String?
    func configureCellForSection(sectionIndex: Int) -> TableConfigureCellType?
    func sectionViewFactoryForSection(sectionIndex: Int) -> TableSectionViewFactoryType?
}

public typealias CollectionCellFactoryType = (collectionView: UICollectionView, indexPath: NSIndexPath, object: AnyObject) -> (UICollectionViewCell)
public typealias CollectionConfigureCellType = (cell: UICollectionViewCell, object: AnyObject) -> Void
public typealias CollectionSectionViewFactoryType = (collectionView: UICollectionView, section: CollectionSection) -> (UICollectionReusableView)

protocol CollectionDataSource : NSObjectProtocol, DataSource {
    func cellFactoryForSection(sectionIndex: Int) -> CollectionCellFactoryType
    func configureCellForSection(sectionIndex: Int) -> CollectionConfigureCellType?
    func sectionViewFactoryForSection(sectionIndex: Int) -> CollectionSectionViewFactoryType?
}
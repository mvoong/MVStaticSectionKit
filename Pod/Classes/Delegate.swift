//
//  Delegate.swift
//  Pods
//
//  Created by Michael Voong on 16/11/2015.
//
//

import Foundation

public class Delegate : NSObject {
    weak var dataSource: DataSource?
    weak var viewController: UIViewController?
    
    public init(dataSource: DataSource, viewController: UIViewController) {
        super.init()
        
        self.dataSource = dataSource
        self.viewController = viewController
    }
    
    func performActionAtIndexPath(indexPath: NSIndexPath) {
        let object = self.dataSource?.objectAtIndexPath(indexPath)
        
        if let object = object as? Item {
            if let action = object.action {
                action()
            } else if let segueIdentifier = object.segueIdentifier {
                viewController?.performSegueWithIdentifier(segueIdentifier, sender: self)
            }
        }
    }
}

public class TableDelegate : Delegate, UITableViewDelegate {
    weak var tableView: UITableView?
    
    public init(tableView: UITableView, dataSource: TableDataSource, viewController: UIViewController) {
        super.init(dataSource: dataSource, viewController: viewController)
        
        self.tableView = tableView
        tableView.delegate = self
    }
    
    deinit {
        if self.tableView?.delegate === self {
            self.tableView?.delegate = nil
        }
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performActionAtIndexPath(indexPath)
    }
}

public class CollectionDelegate : Delegate, UICollectionViewDelegate {
    weak var collectionView: UICollectionView?
    
    public init(collectionView: UICollectionView, dataSource: CollectionDataSource, viewController: UIViewController) {
        super.init(dataSource: dataSource, viewController: viewController)
        
        self.collectionView = collectionView
        collectionView.delegate = self
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performActionAtIndexPath(indexPath)
    }
    
    deinit {
        if self.collectionView?.delegate === self {
            self.collectionView?.delegate = nil
        }
    }
}
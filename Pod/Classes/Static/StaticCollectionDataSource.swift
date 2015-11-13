//
//  StaticCollectionDataSource.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 12/11/2015.
//  Copyright © 2015 Michael Voong. All rights reserved.
//

import Foundation
import CoreData

public class StaticCollectionDataSource : StaticDataSource<CollectionSection>, UICollectionViewDataSource {
    weak var collectionView: UICollectionView?
    
    public init(collectionView: UICollectionView) {
        super.init()
        
        self.collectionView = collectionView
        collectionView.dataSource = self
    }
    
    // MARK: UICollectionViewDataSource
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].numberOfItems()
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let object = self.objectAtIndexPath(indexPath), section = self.sectionForIndex(indexPath.section), cellFactory = section.cellFactory else {
            fatalError("Invalid section: \(indexPath)")
        }
        
        let cell = cellFactory(collectionView: collectionView, indexPath: indexPath, item: object)
        
        if let configureCell = section.configureCell {
            configureCell(collectionView: collectionView, cell: cell, item: object)
        }
        
        return cell
    }
    
    override func updateResultsControllerDelegates() {
        for section in self.sections {
            if let collectionView = self.collectionView, resultsController = section.fetchedResultsController {
                if self.resultsControllerDelegates[resultsController] == nil {
                    self.resultsControllerDelegates[resultsController] = StaticCollectionFetchedResultsControllerDelegate(view: collectionView, resultsController: resultsController, dataSource: self)
                }
            }
        }
    }
    
    deinit {
        if self.collectionView?.dataSource === self {
            self.collectionView?.dataSource = nil
        }
    }
}
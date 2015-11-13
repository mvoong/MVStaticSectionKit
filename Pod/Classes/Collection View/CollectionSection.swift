//
//  CollectionSection.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 12/11/2015.
//  Copyright © 2015 Michael Voong. All rights reserved.
//

import CoreData

public class CollectionSection : Section {
    public typealias CellFactoryType = (collectionView: UICollectionView, indexPath: NSIndexPath, item: AnyObject) -> (UICollectionViewCell)
    public typealias ConfigureCellType = (collectionView: UICollectionView, cell: UICollectionViewCell, item: AnyObject) -> (UICollectionViewCell)
    public typealias SectionViewFactoryType = (collectionView: UICollectionView, section: CollectionSection) -> (UICollectionReusableView)
    
    var cellFactory: CellFactoryType?
    var configureCell: ConfigureCellType?
    var sectionViewFactory: SectionViewFactoryType?
    
    public required init() {
        super.init()
    }
}

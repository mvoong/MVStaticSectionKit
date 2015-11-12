//
//  CollectionSection.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 12/11/2015.
//  Copyright © 2015 Michael Voong. All rights reserved.
//

import Foundation

public class CollectionSection : Section {
    public typealias CellFactoryType = (collectionView: UICollectionView, section: CollectionSection, item: AnyObject) -> (UICollectionViewCell)
    public typealias SectionViewFactoryType = (collectionView: UICollectionView, section: CollectionSection) -> (UICollectionReusableView)
    
    var cellFactory: CellFactoryType?
    var sectionViewFactory: SectionViewFactoryType?
    
    public required init() {
        super.init()
    }
    
    public init(cellFactory: CellFactoryType, sectionViewFactory: SectionViewFactoryType? = nil) {
        super.init()
        
        self.cellFactory = cellFactory
        self.sectionViewFactory = sectionViewFactory
    }
}

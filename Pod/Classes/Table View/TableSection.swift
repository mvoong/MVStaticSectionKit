//
//  TableSection.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 12/11/2015.
//  Copyright © 2015 Michael Voong. All rights reserved.
//

import Foundation

public class TableSection : Section {
    public typealias CellFactoryType = (tableView: UITableView, indexPath: NSIndexPath, item: AnyObject) -> (UITableViewCell)
    public typealias ConfigureCellType = (tableView: UITableView, item: AnyObject) -> (UITableViewCell)
    public typealias SectionViewFactoryType = (tableView: UITableView, section: TableSection) -> (UITableViewHeaderFooterView)
    
    var cellFactory: CellFactoryType?
    var configureCell: ConfigureCellType?
    var sectionViewFactory: SectionViewFactoryType?
    
    required public init() {
        super.init()
    }
    
    public func withCellFactory(cellFactory: CellFactoryType) -> TableSection {
        self.cellFactory = cellFactory
        
        return self
    }
    
    public func withConfigureCell(configureCell: ConfigureCellType) -> TableSection {
        self.configureCell = configureCell
        
        return self
    }
    
    public func withSectionViewFactory(sectionViewFactory: SectionViewFactoryType) -> TableSection {
        self.sectionViewFactory = sectionViewFactory
        
        return self
    }
}
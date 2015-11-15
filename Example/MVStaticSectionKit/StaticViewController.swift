//
//  StaticViewController.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 11/12/2015.
//  Copyright (c) 2015 Michael Voong. All rights reserved.
//

import UIKit
import MVStaticSectionKit

class StaticViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: StaticTableDataSource!
    
    let cellFactory: TableCellFactoryType = { tableView, indexPath, object in
        return tableView.dequeueReusableCellWithIdentifier("Cell" , forIndexPath: indexPath)
    }
    
    let configureCellFactory: TableConfigureCellType = { cell, object in
        cell.textLabel?.text = object as? String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = StaticTableDataSource(tableView: self.tableView)
        self.dataSource
            .addSection("Section 1")
            .withCellFactory(self.cellFactory, configureCell:self.configureCellFactory)
            .withItems([ "Test", "Test2", "Test3" ])
        
        self.dataSource
            .addSection("Section 2")
            .withCellFactory(self.cellFactory, configureCell:self.configureCellFactory)
            .withItems([ "Test"])
    }
}


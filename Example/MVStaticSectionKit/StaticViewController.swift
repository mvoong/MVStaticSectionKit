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
    
    let configureCell: TableConfigureCellType = { cell, object in
        cell.textLabel?.text = object as? String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = StaticTableDataSource(tableView: self.tableView)
        self.dataSource
            .addSection("Section 1")
            .withReuseIdentifier("Cell")
            .withConfigureCell(self.configureCell)
            .withItems([ "Test", "Test2", "Test3" ])
        
        self.dataSource
            .addSection("Section 2")
            .withReuseIdentifier("Cell")
            .withConfigureCell(self.configureCell)
            .withItems([ "Test"])
    }
}


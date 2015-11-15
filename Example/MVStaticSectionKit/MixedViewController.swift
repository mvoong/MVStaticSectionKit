//
//  MixedViewController.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 15/11/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import MVStaticSectionKit
import AlecrimCoreData
import CoreData

class MixedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: StaticTableDataSource!
    let dataContext = DataContext()
    
    let cellFactory: TableCellFactoryType = { tableView, indexPath, object in
        return tableView.dequeueReusableCellWithIdentifier("Cell" , forIndexPath: indexPath)
    }
    
    let configureCell: TableConfigureCellType = { cell, object in
        if let person = object as? Person {
            cell.textLabel?.text = (object as? Person)?.name
        } else {
            cell.textLabel?.text = object as? String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTestData()
        
        self.dataSource = StaticTableDataSource(tableView: self.tableView)
        
        // Static section
        self.dataSource
            .addSection("Static Section")
            .withItems([ "Static 1", "Static 2" ])
            .withCellFactory(self.cellFactory, configureCell: self.configureCell)
        
        // Section driven from fetched results controller
        let resultsController = self.dataContext.people.sortByAttributeName("name").toFetchedResultsController()
        try! resultsController.performFetch()
        
        self.dataSource
            .addSection("Fetched Results Controller Section")
            .withResultsController(resultsController)
            .withCellFactory(self.cellFactory, configureCell: self.configureCell)
    }
    
    func createTestData() {
        for person in self.dataContext.people {
            person.delete()
        }
        
        for name in ["Michael", "Alison", "Heidi", "Carolyn", "Helen"] {
            let person = self.dataContext.people.createEntity()
            person.name = name
        }
    }

    @IBAction func addTapped(sender: AnyObject) {
        let person = self.dataContext.people.createEntity()
        let names = ["George", "Grace", "Maya", "Theo", "Jayden"]
        person.name = names[Int(arc4random() % UInt32(names.count))]
    }
}

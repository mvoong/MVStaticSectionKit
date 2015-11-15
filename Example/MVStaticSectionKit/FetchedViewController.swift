//
//  FetchedViewController.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 15/11/2015.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import MVStaticSectionKit
import AlecrimCoreData
import CoreData

class FetchedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: FetchedDataSource?
    let dataContext = DataContext()

    let configureCell: TableConfigureCellType = { cell, object in
        cell.textLabel?.text = (object as? Person)?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTestData()
        
        let resultsController = self.dataContext.people.sortByAttributeName("name").toFetchedResultsController()
        try! resultsController.performFetch()
        
        self.dataSource = FetchedTableDataSource(tableView: self.tableView, resultsController: resultsController)
            .withReuseIdentifier("Cell")
            .withConfigureCell(self.configureCell)
    }
    
    func createTestData() {
        for person in dataContext.people {
            person.delete()
        }
        
        for name in ["Michael", "Alison", "Heidi", "Carolyn", "Helen"] {
            let person = dataContext.people.createEntity()
            person.name = name
        }
    }
}

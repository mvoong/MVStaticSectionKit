//
//  TableDelegate.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 12/11/2015.
//  Copyright © 2015 Michael Voong. All rights reserved.
//

import UIKit

public class TableDelegate : NSObject, UITableViewDelegate {
    weak var tableView: UITableView?
    weak var dataSource: DataSource?
    weak var viewController: UIViewController?
    
    public init(tableView: UITableView, dataSource: DataSource, viewController: UIViewController) {
        super.init()
        
        self.tableView = tableView
        self.dataSource = dataSource
        self.viewController = viewController
        
        tableView.delegate = self
    }
    
    deinit {
        if self.tableView?.delegate === self {
            self.tableView?.delegate = nil
        }
    }
}

// Mark: UITableViewDelegate

extension TableDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let item = self.dataSource?.objectAtIndexPath(indexPath) as? Item {
            if let segueIdentifier = item.segueIdentifier {
                viewController?.performSegueWithIdentifier(segueIdentifier, sender: self)
            } else if let action = item.action {
                action()
            }
        }
    }
}
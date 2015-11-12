//
//  TableDelegate.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 12/11/2015.
//  Copyright © 2015 Michael Voong. All rights reserved.
//

import UIKit

public class TableDelegate : NSObject, UITableViewDelegate {
    weak var dataSource: TableDataSource?
    weak var viewController: UIViewController?
    
    public init(dataSource: TableDataSource, viewController: UIViewController) {
        super.init()
        
        self.dataSource = dataSource
        self.viewController = viewController
        
        dataSource.tableView?.delegate = self
    }
    
    deinit {
        if self.dataSource?.tableView?.delegate === self {
            self.dataSource?.tableView?.delegate = nil
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
//
//  Item.swift
//  MVStaticSectionKit
//
//  Created by Michael Voong on 12/11/2015.
//  Copyright © 2015 Michael Voong. All rights reserved.
//

import Foundation

public class Item {
    public typealias ItemAction = () -> Void
    
    public var object: AnyObject?
    public var title: String?
    
    var action: ItemAction?
    var segueIdentifier: String?
    var hidden: Bool = false
    
    public init() {
        
    }
    
    public init(object: AnyObject, action: ItemAction? = nil) {
        self.object = object
        self.action = action
    }
    
    public init(_ title: String) {
        self.title = title
    }
    
    public init(_ title: String, action: ItemAction) {
        self.title = title
        self.action = action
    }
    
    public init(_ title: String, segueIdentifier: String) {
        self.title = title
        self.segueIdentifier = segueIdentifier
    }
}
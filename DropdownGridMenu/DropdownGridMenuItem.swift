//
//  DropdownGridMenuItem.swift
//  DropdownGridMenu
//
//  Created by Oleg Chornenko on 11/21/17.
//  Copyright © 2017 Oleg Chornenko. All rights reserved.
//

import UIKit

/// The dropdown grid menu item
public class DropdownGridMenuItem {
    /// The text of the item
    public var text: String
    /// The attributed text of the item
    public var attributedText: NSAttributedString
    /// The image of the item
    public var image: UIImage
    /// Defines if item is selected
    public var isSelected = false
    
    /**
     Creates a new instance of dropdown item
     - parameters:
       - text: The text of the item
       - image: The image of the item
       - selected: Defines if item is selected
     */
    public init(text: String, image: UIImage, selected: Bool) {
        
        self.text = text
        self.attributedText = NSAttributedString()
        self.image = image
        self.isSelected = selected
    }
    
    /**
     Creates a new instance of dropdown item
     - parameters:
       - attributedText: The attributed text of the item
       - image: The image of the item
       - selected: Defines if item is selected
     */
    public init(attributedText: NSAttributedString, image: UIImage, selected: Bool) {
        
        self.text = String()
        self.attributedText = attributedText
        self.image = image
        self.isSelected = selected
    }
}

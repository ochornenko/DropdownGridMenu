//
//  DropdownGridMenuItem.swift
//  DropdownGridMenu
//
//  Created by Oleg Chornenko on 11/21/17.
//  Copyright © 2017 Oleg Chornenko. All rights reserved.
//

import UIKit

class DropdownGridMenuItem {
    public var text: String
    public var attributedText: NSAttributedString
    public var image: UIImage
    public var isSelected = false
    
    init(text: String, image: UIImage, selected: Bool) {
        
        self.text = text
        self.attributedText = NSAttributedString()
        self.image = image
        self.isSelected = selected
    }
    
    init(attributedText: NSAttributedString, image: UIImage, selected: Bool) {
        
        self.text = String()
        self.attributedText = attributedText
        self.image = image
        self.isSelected = selected
    }
}

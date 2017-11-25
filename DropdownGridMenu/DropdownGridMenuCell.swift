//
//  DropdownGridMenuCell.swift
//  DropdownGridMenu
//
//  Created by Oleg Chornenko on 11/21/17.
//  Copyright © 2017 Oleg Chornenko. All rights reserved.
//

import UIKit

class DropdownGridMenuCell: UICollectionViewCell {
    var textLabel: UILabel!
    var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textLabel = UILabel()
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        self.textLabel.adjustsFontSizeToFitWidth = false
        self.textLabel.textAlignment = NSTextAlignment.center
        self.textLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self.textLabel.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.textLabel)
        
        self.button = UIButton()
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.button)
        
        self.backgroundColor = UIColor.clear
        self.selectedBackgroundView = UIView()
        
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.button.isSelected = true
                let len = (self.textLabel.attributedText?.length)!
                if len > 0 {
                    let attrText = self.textLabel.attributedText?.mutableCopy() as! NSMutableAttributedString
                    attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: tintColor(), range: NSMakeRange(0, len))
                    self.textLabel.attributedText = attrText
                }
            } else {
                self.button.isSelected = false
            }
        }
    }
    
    func configureCell() {
        let metrics = ["margin": 4]
        let vfsV = "V:|-margin-[button]-margin-[text]-margin-|"
        let vfsH = "H:|->=margin-[text]->=margin-|"
        let views = ["text": self.textLabel, "button": self.button] as [String : Any]
        
        // horizontal centering
        for (_, view) in views as [String : Any] {
            let constraint = NSLayoutConstraint(item: self.contentView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            
            self.contentView.addConstraint(constraint)
        }
        
        self.button.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.vertical)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vfsV, options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vfsH, options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
    
    func tintColor() -> UIColor {
        var white: CGFloat = 0, alpha: CGFloat = 0
        
        self.tintColor.getWhite(&white, alpha: &alpha)
        
        return UIColor(white:1.2 - white, alpha: alpha)
    }
}

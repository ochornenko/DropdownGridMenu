//
//  ViewController.swift
//  DropdownGridMenuDemo
//
//  Created by Oleg Chornenko on 11/25/17.
//  Copyright © 2017 Oleg Chornenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let items: [DropdownGridMenuItem] = [
        DropdownGridMenuItem(text: "Retail", image: UIImage(named: "retail")!, selected: false),
        DropdownGridMenuItem(text: "Handy", image: UIImage(named: "home_services")!, selected: false),
        DropdownGridMenuItem(text: "Bars", image: UIImage(named: "nightlife")!, selected: false),
        DropdownGridMenuItem(text: "Movers", image: UIImage(named: "movers")!, selected: false),
        DropdownGridMenuItem(text: "Food", image: UIImage(named: "resturant_cafe")!, selected: false),
        DropdownGridMenuItem(text: "Tech", image: UIImage(named: "creative_tech")!, selected: false),
        DropdownGridMenuItem(text: "Auto", image: UIImage(named: "mechanic")!, selected: false),
        DropdownGridMenuItem(text: "Desk", image: UIImage(named: "office_admin")!, selected: false),
        DropdownGridMenuItem(text: "Hotel", image: UIImage(named: "hotel")!, selected: false),
        DropdownGridMenuItem(text: "Tutor", image: UIImage(named: "tutoring")!, selected: false)
    ]
    
    var menu: DropdownGridMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(presentPopover(sender:)))
        leftBarButtonItem.tintColor = UIColor.gray
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(presentMenu(sender:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func presentPopover(sender: UIBarButtonItem) {
        let timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(action), userInfo: nil, repeats: false)
        
        let itemSize = CGSize(width: self.view.frame.size.width / 6, height: 70)
        let contentSize = CGSize(width: self.view.frame.width / 1.3, height: self.view.frame.height / 2)
        menu = DropdownGridMenu.presentPopover(self, appear: .fromTop, sender: sender, items: items, itemSize: itemSize, contentSize: contentSize, action: { item in
            if item.isSelected {
                print("item selected at index \(self.items.index(where: {$0 === item})!)")
            } else {
                print("item deselected at index \(self.items.index(where: {$0 === item})!)")
            }
        }, completion: {
            timer.invalidate()
            print("completed")
        } )
    }
    
    @objc func presentMenu(sender: UIBarButtonItem) {
        let timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(action), userInfo: nil, repeats: false)
        
        let itemSize = CGSize(width: self.view.frame.size.width / 6, height: 70)
        menu = DropdownGridMenu.present(self, appear: .fromRight, leftBarButtonItem: nil, rightBarButtonItem: sender, items: items, itemSize: itemSize, action: { item in
            if item.isSelected {
                print("item selected at index \(self.items.index(where: {$0 === item})!)")
            } else {
                print("item deselected at index \(self.items.index(where: {$0 === item})!)")
            }
        }, completion: {
            timer.invalidate()
            print("completed")
        } )
    }
    
    @objc func action() {
        menu?.dismiss()
    }
}

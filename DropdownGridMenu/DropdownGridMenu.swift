//
//  DropdownGridMenu.swift
//  DropdownGridMenu
//
//  Created by Oleg Chornenko on 11/27/17.
//

import UIKit

public class DropdownGridMenu {
    
    /**
     Defines direction from which menu appears
     - fromTop: Appears from the Top
     - fromLeft: Appears from the Left
     - fromRight: Appears from the Right
     */
    public enum DropdownGridMenuAppear: Int {
        case fromTop
        case fromLeft
        case fromRight
    }
    
    /**
     Defines direction to which menu disappears
     - toBottom: Disappears to the Bottom
     - toLeft: Disappears to the Left
     - toRight: Disappears to the Right
     */
    public enum DropdownGridMenuDismiss: Int {
        case toBottom
        case toLeft
        case toRight
    }
    
    /**
     Present view controller with navigation controller from view controller
     - parameters:
     - fromViewController: View controller from which menu view controller is presented
     - appear: Defines direction from which menu appears
     - leftBarButtonItem: Bar button item from which menu is presented
     - rightBarButtonItem: Bar button item from which menu is presented
     - items: Array of menu items
     - itemSize: Size of menu item (width and height)
     - action: The action handler, occurs when item is selected
     - completion: The completion handler, will be invoked after menu dismissing
     */
    public static func present(_ fromViewController: UIViewController, appear: DropdownGridMenuAppear, leftBarButtonItem: UIBarButtonItem?, rightBarButtonItem: UIBarButtonItem?, items: [DropdownGridMenuItem], itemSize: CGSize, action: ((DropdownGridMenuItem) -> Swift.Void)? = nil, completion: (() -> Swift.Void)? = nil) {
        let menuController = DropdownGridMenuController()
        menuController.items = items
        menuController.itemSize = itemSize
        menuController.appear = appear
        menuController.action = action
        menuController.completion = completion
        
        if let menuImage = leftBarButtonItem?.image {
            let leftBarButtonItem = UIBarButtonItem(image: menuImage, style: UIBarButtonItemStyle.plain, target: menuController.self, action: #selector(menuController.dismissMenu(sender:)))
            menuController.navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        
        if let menuImage = rightBarButtonItem?.image {
            let rightBarButtonItem = UIBarButtonItem(image: menuImage, style: UIBarButtonItemStyle.plain, target: menuController.self, action: #selector(menuController.dismissMenu(sender:)))
            menuController.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
        let navigationController = UINavigationController(rootViewController: menuController)
        navigationController.transitioningDelegate = menuController.self
        navigationController.modalPresentationStyle = UIModalPresentationStyle.custom
        
        fromViewController.present(navigationController, animated: true)
    }
    
    /**
     Present popover from view controller
     - parameters:
     - fromViewController: View controller from which popover is presented
     - appear: Defines direction from which menu appears
     - sender: Bar button item from which popover is presented
     - items: Array of menu items
     - itemSize: Size of menu item (width and height)
     - contentSize: Size of popover content view (width and height)
     - action: The action handler, occurs when item is selected
     - completion: The completion handler, will be invoked after popover menu dismissing
     */
    public static func presentPopover(_ fromViewController: UIViewController, appear: DropdownGridMenuAppear, sender: UIBarButtonItem, items: [DropdownGridMenuItem], itemSize: CGSize, contentSize: CGSize, action: ((DropdownGridMenuItem) -> Swift.Void)? = nil, completion: (() -> Swift.Void)? = nil) {
        let menuController = DropdownGridMenuController()
        menuController.items = items
        menuController.itemSize = itemSize
        menuController.appear = appear
        menuController.isPopover = true
        menuController.action = action
        menuController.completion = completion
        
        menuController.modalPresentationStyle = UIModalPresentationStyle.popover
        menuController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        menuController.popoverPresentationController?.delegate = menuController.self
        menuController.popoverPresentationController?.barButtonItem = sender
        menuController.preferredContentSize = contentSize
        
        fromViewController.present(menuController, animated: true)
    }
}

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
    
    /// private grid menu controller
    private var controller : DropdownGridMenuController
    
    /// private init to use only fabric methods
    private init() {
        self.controller = DropdownGridMenuController()
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
    @discardableResult
    public static func present(_ fromViewController: UIViewController, appear: DropdownGridMenuAppear, leftBarButtonItem: UIBarButtonItem?, rightBarButtonItem: UIBarButtonItem?, items: [DropdownGridMenuItem], itemSize: CGSize, action: ((DropdownGridMenuItem) -> Swift.Void)? = nil, completion: (() -> Swift.Void)? = nil) -> DropdownGridMenu {
        
        let menu = DropdownGridMenu()
        menu.controller.items = items
        menu.controller.itemSize = itemSize
        menu.controller.appear = appear
        menu.controller.action = action
        menu.controller.completion = completion
        
        if let menuImage = leftBarButtonItem?.image {
            let leftBarButtonItem = UIBarButtonItem(image: menuImage, style: UIBarButtonItem.Style.plain, target: menu.controller.self, action: #selector(menu.controller.dismissMenu(sender:)))
            menu.controller.navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        
        if let menuImage = rightBarButtonItem?.image {
            let rightBarButtonItem = UIBarButtonItem(image: menuImage, style: UIBarButtonItem.Style.plain, target: menu.controller.self, action: #selector(menu.controller.dismissMenu(sender:)))
            menu.controller.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
        let navigationController = UINavigationController(rootViewController: menu.controller)
        navigationController.transitioningDelegate = menu.controller.self
        navigationController.modalPresentationStyle = UIModalPresentationStyle.custom
        
        fromViewController.present(navigationController, animated: true)
        
        return menu
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
    @discardableResult
    public static func presentPopover(_ fromViewController: UIViewController, appear: DropdownGridMenuAppear, sender: UIBarButtonItem, items: [DropdownGridMenuItem], itemSize: CGSize, contentSize: CGSize, action: ((DropdownGridMenuItem) -> Swift.Void)? = nil, completion: (() -> Swift.Void)? = nil) -> DropdownGridMenu {
        
        let menu = DropdownGridMenu()
        menu.controller.items = items
        menu.controller.itemSize = itemSize
        menu.controller.appear = appear
        menu.controller.isPopover = true
        menu.controller.action = action
        menu.controller.completion = completion
        menu.controller.modalPresentationStyle = UIModalPresentationStyle.popover
        menu.controller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        menu.controller.popoverPresentationController?.delegate = menu.controller.self
        menu.controller.popoverPresentationController?.barButtonItem = sender
        menu.controller.preferredContentSize = contentSize
        
        fromViewController.present(menu.controller, animated: true)
        
        return menu
    }
    
    /**
     Dismiss view controller
     - parameters:
     - animated: Dismiss view with animation if true
     **/
    public func dismiss(animated flag: Bool = true) {
        self.controller.dismiss(animated: flag)
    }
}

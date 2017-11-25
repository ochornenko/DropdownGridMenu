//
//  DropdownGridMenuTransitionController.swift
//  DropdownGridMenu
//
//  Created by Oleg Chornenko on 11/21/17.
//  Copyright © 2017 Oleg Chornenko. All rights reserved.
//

import UIKit

class DropdownGridMenuTransitionController: NSObject {
    var isPresenting = false
}

// MARK: - UIViewControllerAnimatedTransitioning

extension DropdownGridMenuTransitionController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        if self.isPresenting {
            let navigationController = toViewController as! UINavigationController
            let menuController = navigationController.topViewController as! DropdownGridMenuController
            
            navigationController.view.frame = containerView.bounds
            containerView.addSubview(navigationController.view)
            
            OperationQueue.main.addOperation({
                menuController.enterTheStage({
                    transitionContext.completeTransition(true)
                })
            })
        } else {
            let navigationController = fromViewController as! UINavigationController
            let menuController = navigationController.topViewController as! DropdownGridMenuController
            
            menuController.leaveTheStage({
                navigationController.view.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
}

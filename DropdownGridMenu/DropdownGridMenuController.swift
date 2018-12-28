//
//  DropdownGridMenuController.swift
//  DropdownGridMenu
//
//  Created by Oleg Chornenko on 11/21/17.
//  Copyright © 2017 Oleg Chornenko. All rights reserved.
//

import UIKit

class DropdownGridMenuController: UIViewController {

    private static let cell = "DropdownGridMenuCell"
    
    private var collectionView: UICollectionView!
    private var backgroundView: UIView!
    public var isPresented = false
    public var isPopover = false
    public var appear = DropdownGridMenu.DropdownGridMenuAppear.fromTop
    public var dismiss = DropdownGridMenu.DropdownGridMenuDismiss.toBottom
    public var items = [DropdownGridMenuItem]()
    public var itemSize = CGSize(width: 0, height: 0)
    public var action: ((DropdownGridMenuItem) -> Void)?
    public var completion: (() -> Void)?
    
    private lazy var transitionController = DropdownGridMenuTransitionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        self.backgroundView = UIView(frame: self.view.frame)
        self.backgroundView.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        self.backgroundView.alpha = 0
        self.view.insertSubview(self.backgroundView, at: 0)
        self.backgroundView.bindFrameToSuperviewBounds()
        
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.clipsToBounds = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(DropdownGridMenuCell.self, forCellWithReuseIdentifier: DropdownGridMenuController.cell)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.isHidden = true
        self.view.addSubview(self.collectionView)
        self.collectionView.bindFrameToSuperviewBounds()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.collectionView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.collectionView.addGestureRecognizer(swipeRight)
    }
    
    func transformItemAtIndex(_ index: Int, negative: Bool) -> CGAffineTransform {
        let maxTranslation = self.view.frame.width / 2
        let minTranslation = self.view.frame.width / 3
        var translation = maxTranslation - (maxTranslation - minTranslation) * (CGFloat(index) / CGFloat(self.items.count))
        if negative {
            translation = -translation

            switch self.dismiss {
            case .toRight:
                return CGAffineTransform(translationX: -translation, y: 0)
                
            case .toLeft:
                return CGAffineTransform(translationX: translation, y: 0)
                
            case .toBottom:
                return CGAffineTransform(translationX: 0, y: -translation)
            }
        } else {
            switch self.appear {
            case .fromRight:
                return CGAffineTransform(translationX: translation, y: 0)
                
            case .fromLeft:
                return CGAffineTransform(translationX: -translation, y: 0)
                
            case .fromTop:
                return CGAffineTransform(translationX: 0, y: -translation)
            }
        }
    }
    
    func enterTheStage(_ completion: (() -> Swift.Void)? = nil) {
        self.isPresented = true
        for index in 0..<self.items.count {
            let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0))
            cell?.transform = transformItemAtIndex(index, negative: false)
            cell?.alpha = 0
        }
        
        self.collectionView.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 1.0
        }
        
        for index in 0..<self.items.count {
            let delay = 0.02 * CGFloat(index)
            UIView.animate(withDuration: 0.8, delay: TimeInterval(delay), usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: UIView.AnimationOptions(rawValue: 0), animations: {
                let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0))
                cell?.transform = CGAffineTransform.identity
                cell?.alpha = 1.0
            }, completion: { _ in
                if index + 1 == self.items.count {
                    completion?()
                }
            })
        }
    }
    
    func leaveTheStage(_ completion: (() -> Swift.Void)? = nil) {
        self.isPresented = false
        for index in 0..<self.items.count {
            UIView.animate(withDuration: 0.3, delay: 0.02, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                let cell = self.collectionView.cellForItem(at: IndexPath(row: self.items.count - index - 1, section: 0))
                cell?.transform = self.transformItemAtIndex(index, negative: true)
                cell?.alpha = 0
                if index + 1 == self.items.count {
                    self.backgroundView.alpha = 0
                }
            }, completion: { _ in
                if index + 1 == self.items.count {
                    completion?()
                }
            })
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.left:
            self.dismiss = .toLeft
        case UISwipeGestureRecognizer.Direction.right:
            self.dismiss = .toRight
        default:
            break
        }
        
        if self.isPopover {
            self.leaveTheStage {
                self.dismiss(animated: true, completion: {
                    self.completion?()
                })
            }
        } else {
            self.dismiss(animated: true, completion: {
                self.completion?()
            })
        }
    }
    
    @objc func dismissMenu(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {
            self.completion?()
        })
    }
    
    @objc func dismiss(animated flag: Bool) {
        if self.isPresented {
            if self.isPopover {
                if flag {
                    self.leaveTheStage {
                        self.dismiss(animated: flag, completion: {
                            self.completion?()
                        })
                    }
                } else {
                    self.dismiss(animated: flag, completion: {
                        self.completion?()
                    })
                }
            } else {
                self.dismiss(animated: flag, completion: {
                    self.completion?()
                })
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension DropdownGridMenuController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DropdownGridMenuController.cell, for: indexPath) as! DropdownGridMenuCell
        
        let item = self.items[indexPath.row]
        if !item.text.isEmpty {
            cell.textLabel.text = item.text
        } else if item.attributedText.length > 0 {
            cell.textLabel.attributedText = item.attributedText
        }

        cell.toggleSelection(item: item)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension DropdownGridMenuController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as!  DropdownGridMenuCell
        let item = self.items[indexPath.row]
        item.isSelected = !item.isSelected
        cell.toggleSelection(item: item)
        
        self.action?(item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DropdownGridMenuController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 5, left: 0, bottom: 5, right: 0)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension DropdownGridMenuController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionController.isPresenting = true
        
        return self.transitionController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionController.isPresenting = false
        
        return self.transitionController
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension DropdownGridMenuController: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        OperationQueue.main.addOperation({
            self.enterTheStage()
        })
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        self.leaveTheStage {
            self.completion?()
        }
        
        return true
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
}

// MARK: - UIView

extension UIView {
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
}

// MARK: - UIImage

extension UIImage {
    func tint(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        self.draw(in: rect)
        color.set()
        UIRectFillUsingBlendMode(rect, CGBlendMode.sourceAtop)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

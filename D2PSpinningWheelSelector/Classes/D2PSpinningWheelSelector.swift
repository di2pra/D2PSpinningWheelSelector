//
//  D2PSpinningWheelSelector.swift
//  D2PSpinningWheelSelector
//
//  Created by Pradheep Rajendirane on 23/04/2018.
//

import UIKit

@objc public protocol D2PSpinningWheelSelectorDelegate: class {
    @objc optional func didSelectedItemsChanges(selectedItems: [Int])
    @objc optional func didSelectedItemChanges(selectedItem: Int)
    @objc optional func selectorDidOpen()
    @objc optional func selectorDidClose()
}

public final class D2PSpinningWheelSelector: UIViewController {
    
    /// Default selector height. Default value is 200.
    public static var DEFAULT_HEIGHT:CGFloat = 200
    
    /// Default item size. Default value is 80.
    public static var DEFAULT_ITEM_SIZE:CGFloat = 80
    
    /// Default Selector background color. Default value is white.
    public static var DEFAULT_BG_COLOR:UIColor = .white
    
    /// Default Item color. Default value is #2C3E50.
    public static var DEFAULT_ITEM_COLOR:UIColor = UIColor(red:0.64, green:0.61, blue:1.00, alpha:1.0) // #2C3E50
    
    /// Default Item selected color. Default value is #6c5ce7.
    public static var DEFAULT_ITEM_SELECTED_COLOR:UIColor = UIColor(red:0.42, green:0.36, blue:0.91, alpha:1.0) // #6c5ce7
    
    /// Default item size. Default value is 80.
    public static var DEFAULT_BTN_SIZE:CGFloat = 100
    
    
    
    
    /* =======================
     Data Properties
     ======================= */
    fileprivate var data = [D2PItem]()
    
    public var allowsMultipleSelection: Bool = false {
        didSet {
            self.collectionView.allowsMultipleSelection = self.allowsMultipleSelection
        }
    }
    
    public var closesAutomatically: Bool = false // if single selector, this option to true if you want to dismiss the selector automatically
    
    public var delegate: D2PSpinningWheelSelectorDelegate?
    
    // value for multiple selection
    public var selectedItems: [Int]? {
        didSet {
            
            // Trigger the delegate if the selectedItems changes
            if let selectedItems = selectedItems, let oldValue = oldValue, oldValue != selectedItems, let delegate = self.delegate, let didSelectedItemsChanges = delegate.didSelectedItemsChanges {
                didSelectedItemsChanges(selectedItems)
            }
            
        }
    }
    
    // value for single selection
    public var selectedItem: Int? {
        didSet {
            
            // Trigger the delegate if the selectedItem changes
            if let selectedItem = selectedItem, let oldValue = oldValue, oldValue != selectedItem, let delegate = self.delegate, let didSelectedItemChanges = delegate.didSelectedItemChanges {
                didSelectedItemChanges(selectedItem)
            }
            
        }
    }
    /* =======================
     ======================= */
    
    
    
    /* =======================
     UI Properties
     ======================= */
    var height: CGFloat = D2PSpinningWheelSelector.DEFAULT_HEIGHT
    var bgColor:UIColor = D2PSpinningWheelSelector.DEFAULT_BG_COLOR
    var itemSize: CGFloat = D2PSpinningWheelSelector.DEFAULT_ITEM_SIZE
    var btnSize: CGFloat = D2PSpinningWheelSelector.DEFAULT_BTN_SIZE
    
    static var itemColor: UIColor = D2PSpinningWheelSelector.DEFAULT_ITEM_COLOR
    static var itemSelectedColor: UIColor = D2PSpinningWheelSelector.DEFAULT_ITEM_SELECTED_COLOR
    
    private lazy var collectionViewRadius: CGFloat = {
        return ((self.view.bounds.width - self.btnSize) * 0.5 + self.btnSize)/2
    }()
    
    fileprivate let animInitScale: CGFloat = 0.001
    fileprivate let animDuration: TimeInterval = 0.3
    
    private var btnIsAnimating:Bool = false // button animation flag
    /* =======================
     ======================= */
    
    
    /* =======================
     UI Objects
     ======================= */
    fileprivate var containerView: UIView = UIView()
    fileprivate var collectionView: UICollectionView = D2PCollectionView(frame: .zero, collectionViewLayout: CircularLayout())
    fileprivate var circularBg: UIView = UIView()
    var maskView: UIView = UIView()
    fileprivate var btnContainer: UIView = UIView()
    fileprivate var mainBtn: CircularButton = CircularButton()
    fileprivate lazy var customTransitioningDelegate:PresentationManager = {
        [unowned self] in
        
        var totalHeight = self.view.bounds.width * 0.5
        
        // workaround for iPhone X safe Area
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            totalHeight += (window?.safeAreaInsets.bottom)!
        }
        
        return PresentationManager(withHeight: totalHeight)
        }()
    /* =======================
     ======================= */
    
    
    /* =======================
     Intializers
     ======================= */
    public convenience init(items: [D2PItem], bgColor: UIColor? = nil, itemColor: UIColor? = nil, itemSelectedColor: UIColor? = nil) {
        self.init()
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = customTransitioningDelegate
        
        self.data = items
        
        self.bgColor = bgColor ?? D2PSpinningWheelSelector.DEFAULT_BG_COLOR
        type(of: self).itemColor = itemColor ?? D2PSpinningWheelSelector.DEFAULT_ITEM_COLOR
        type(of: self).itemSelectedColor = itemSelectedColor ?? D2PSpinningWheelSelector.DEFAULT_ITEM_COLOR
        
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /* =======================
     ======================= */
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override public func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .clear
        self.view.clipsToBounds = true
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.backgroundColor = .clear
        
        
        self.collectionView.clipsToBounds = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = CircularLayout(radius: collectionViewRadius, itemSize: itemSize)
        
        self.circularBg.translatesAutoresizingMaskIntoConstraints = false
        self.circularBg.backgroundColor = bgColor
        self.circularBg.clipsToBounds = true
        
        self.btnContainer.translatesAutoresizingMaskIntoConstraints = false
        self.btnContainer.clipsToBounds = true
        
        
        self.maskView.backgroundColor = .black
        self.view.mask = maskView
        
        
        self.view.addSubview(circularBg)
        self.view.insertSubview(containerView, aboveSubview: circularBg)
        self.containerView.addSubview(collectionView)
        self.containerView.insertSubview(btnContainer, aboveSubview: collectionView)
        self.btnContainer.addSubview(mainBtn)
        
        self.mainBtn.setState(.Close, animated: false)
        self.mainBtn.addTarget(self, action: #selector(self.mainBtnPressed), for: .touchUpInside)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutMaskView()
        layoutCircularBg()
        layoutContainerView()
        layoutBtnContainer()
        layoutCollectionView()
        layoutMainBtn()
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if allowsMultipleSelection {
            
            guard let selectedItems = selectedItems else {
                return
            }
            
            if !selectedItems.isEmpty {
                self.mainBtn.setState(.Submit, animated: false)
            }
            
            for item in selectedItems {
                self.collectionView.selectItem(at: IndexPath(item: item, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }
            
        } else {
            
            guard let selectedItem = selectedItem else {
                return
            }
            
            self.collectionView.selectItem(at: IndexPath(item: selectedItem, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            
            self.mainBtn.setState(.Submit, animated: false)
        }
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // execute only once
        _ = didAppearInit
        
    }
    
    lazy var didAppearInit: Void = {
        
        // execute the delegate didOpen
        if let delegate = self.delegate, let didOpen = delegate.selectorDidOpen {
            didOpen()
        }
        
        // if not a multiple selector, if an item is initially selected, then scroll the collectionview to center the selected item
        if !self.allowsMultipleSelection {
            guard let selectedItem = self.selectedItem else {
                return
            }
            
            let contentOffsetX = CGFloat(selectedItem) * (self.collectionView.bounds.width*0.5)
            let contentOffset = CGPoint(x: contentOffsetX, y: 0)
            
            self.collectionView.setContentOffset(contentOffset, animated: true)
            
        }
    }()
    
    func layoutCircularBg() {
        
        self.view.addConstraints([
            NSLayoutConstraint(item: circularBg, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: circularBg, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: circularBg, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: circularBg, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.bounds.height * 2)
            ])
        
        self.circularBg.layer.cornerRadius = self.circularBg.bounds.width * 0.5
    }
    
    
    func layoutMaskView() {
        
        maskView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width)
        maskView.layer.cornerRadius = self.view.bounds.width * 0.5
        
    }
    
    func layoutBtnContainer() {
        self.view.addConstraints([
            NSLayoutConstraint(item: btnContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: btnSize * 0.5),
            NSLayoutConstraint(item: btnContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: btnSize),
            NSLayoutConstraint(item: btnContainer, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: btnContainer, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1, constant: 0)
            ])
    }
    
    func layoutMainBtn() {
        
        self.view.addConstraints([
            NSLayoutConstraint(item: mainBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: btnSize),
            NSLayoutConstraint(item: mainBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: btnSize),
            NSLayoutConstraint(item: mainBtn, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mainBtn, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1, constant: 0)
            
            ])
        
    }
    
    func layoutCollectionView() {
        
        self.view.addConstraints([
            NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: collectionViewRadius*2)
            ])
        
    }
    
    func layoutContainerView() {
        
        self.view.addConstraints([
            NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
            ])
        
    }
    
    func animateMaskView(open: Bool, completion: ((_ result: Bool) -> Void)? = nil) {
        
        if open {
            
            self.maskView.transform = .init(scaleX: animInitScale, y: animInitScale)
            
            UIView.animate(withDuration: animDuration, animations: {
                self.maskView.transform = .identity
            }, completion: { (terminated) in
                
                if let com = completion {
                    com(terminated)
                }
                
            })
            
        } else {
            
            UIView.animate(withDuration: animDuration, animations: {
                self.maskView.transform = .init(scaleX: self.animInitScale, y: self.animInitScale)
            }, completion: { (terminated) in
                
                if let com = completion {
                    com(terminated)
                }
                
            })
            
        }
        
        
    }
    
    @objc private func mainBtnPressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        // execute the delegate willClose
        if let delegate = self.delegate, let didClose = delegate.selectorDidClose {
            didClose()
        }
    }
    
    func hideVisibleCells() {
        
        for cell in self.collectionView.visibleCells {
            cell.alpha = 0.0
        }
        
    }
    
    func showVisibleCells() {
        for cell in self.collectionView.visibleCells {
            cell.alpha = 1.0
        }
    }
    
    
    func hideMainButton() {
        self.mainBtn.alpha = 0.0
    }
    
    func showMainButton() {
        self.mainBtn.alpha = 1.0
    }
    
}

extension D2PSpinningWheelSelector: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let itemData = self.data[indexPath.item]
        
        if let icon = itemData.icon {
            
            
            // icon with label item
            if let text = itemData.label {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconTextCell", for: indexPath) as? IconTextCell else {
                    return UICollectionViewCell()
                }
                
                cell.updateUIToNewState()
                
                cell.iconImage.image = icon
                cell.textLabel.text = text
                
                return cell
                
            }
            
            // icon only item
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as? IconCell else {
                return UICollectionViewCell()
            }
            
            cell.updateUIToNewState()
            
            cell.iconImage.image = icon
            
            return cell
            
            
        } else {
            
            // label only item
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as? TextCell else {
                return UICollectionViewCell()
            }
            
            cell.updateUIToNewState()
            
            cell.textLabel.text = itemData.label
            
            return cell
        }
        
    }
    
}

extension D2PSpinningWheelSelector: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // if the selected cell is visible and not animating
        if let cell = collectionView.cellForItem(at: indexPath) as? CircularCell, cell.isAnimating {
            return
        }
        
        // get indexpaths of selected items
        guard let indexPaths = collectionView.indexPathsForSelectedItems else {
            
            // if empty, then update the main button to close state and return
            self.mainBtn.setState(.Close, animated: true)
            return
        }
        
        // update the main button state
        self.mainBtn.setState(indexPaths.isEmpty ? .Close : .Submit, animated: !self.closesAutomatically)
        
        
        // if the selected cell is visible
        if let cell = collectionView.cellForItem(at: indexPath) as? CircularCell {
            
            // update the cell UI state
            cell.updateUIToNewState(animated: true) {
                if self.closesAutomatically && !self.allowsMultipleSelection {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            
        }
        
        
        // update the selector value for multiple selector if you select an item
        if allowsMultipleSelection {
            selectedItems = indexPaths.map({ (indexPath) -> Int in
                return indexPath.item
            })
            
            // update the selector value for single selector if you select an item
        } else {
            selectedItem = indexPaths[0].item
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        // if the selected cell is visible and not animating
        if let cell = collectionView.cellForItem(at: indexPath) as? CircularCell, cell.isAnimating {
            return
        }
        
        // get indexpaths of selected items
        guard let indexPaths = collectionView.indexPathsForSelectedItems else {
            
            // if empty, then update the main button to close state and return
            self.mainBtn.setState(.Close, animated: true)
            return
        }
        
        // if it's a multiple selector, then update the button state depending the numbers of items selected
        if allowsMultipleSelection {
            self.mainBtn.setState(indexPaths.isEmpty ? .Close : .Submit, animated: true)
        }
        
        // if the deselected cell is visible
        if let cell = collectionView.cellForItem(at: indexPath) as? CircularCell {
            
            // update the ui of the cell with animation
            cell.updateUIToNewState(animated: true)
        }
        
        
        // update the selector value for multiple selector if you deselect an item
        if allowsMultipleSelection {
            
            selectedItems = indexPaths.map({ (indexPath) -> Int in
                return indexPath.item
            })
            
        }
        
    }
    
}

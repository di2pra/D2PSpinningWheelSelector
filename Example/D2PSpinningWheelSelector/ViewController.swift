//
//  ViewController.swift
//  D2PSpinningWheelSelector
//
//  Created by di2pra on 04/23/2018.
//  Copyright (c) 2018 di2pra. All rights reserved.
//

import UIKit
import D2PSpinningWheelSelector

class ViewController: UIViewController {
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    var selectedItem: Int = 2 {
        didSet {
            self.countryLabel.text = "Country: \(countryValues[selectedItem].label!)"
        }
    }
    
    var selectedItems:[Int] = [0,1,2,5] {
        didSet {
            /*let selectedValues = sizeValues.enumerated().filter { (index, item) -> Bool in
             return selectedItems.contains(index)
             }*/
            
            self.sizeLabel.text = "Size: "
        }
    }
    
    var sizeValues:[D2PItem] = [D2PItem(label: "XS"), D2PItem(label: "S"), D2PItem(label: "M"), D2PItem(label: "L"), D2PItem(label: "XL"), D2PItem(label: "XXL")]
    
    var countryValues:[D2PItem] = [D2PItem(label: "FR", icon: UIImage(named: "fr")), D2PItem(label: "US", icon: UIImage(named: "us")), D2PItem(label: "UK", icon: UIImage(named: "uk")), D2PItem(label: "DE", icon: UIImage(named: "de")), D2PItem(label: "IT", icon: UIImage(named: "it")), D2PItem(label: "ES", icon: UIImage(named: "es")), D2PItem(label: "JP", icon: UIImage(named: "jp")), D2PItem(label: "CN", icon: UIImage(named: "cn"))]
    
    let shareValues:[D2PItem] = [D2PItem(UIImage(named: "facebook")), D2PItem(UIImage(named: "twitter")), D2PItem(UIImage(named: "instagram")), D2PItem(UIImage(named: "youtube")), D2PItem(UIImage(named: "linkedin")), D2PItem(UIImage(named: "vimeo")), D2PItem(UIImage(named: "google_plus"))]
    
    @IBAction func openSizeSelector(_ sender: Any) {
        
        let vc = D2PSpinningWheelSelector(items: sizeValues, itemColor: UIColor(red:0.54, green:0.77, blue:0.96, alpha:1.0), itemSelectedColor: UIColor(red:0.15, green:0.45, blue:0.66, alpha:1.0))
        //vc.closesAutomatically = true
        vc.allowsMultipleSelection = true
        //vc.selectedItems = selectedItems
        vc.delegate = self
        present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func openCountrySelector(_ sender: Any) {
        
        let vc = D2PSpinningWheelSelector(items: countryValues, itemColor: UIColor(red:0.54, green:0.77, blue:0.96, alpha:1.0), itemSelectedColor: UIColor(red:0.15, green:0.45, blue:0.66, alpha:1.0))
        //vc.closesAutomatically = true
        vc.selectedItem = selectedItem
        vc.delegate = self
        present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func openShareSelector(_ sender: Any) {
        
        let vc = D2PSpinningWheelSelector(items: shareValues, itemColor: UIColor(red:0.54, green:0.77, blue:0.96, alpha:1.0), itemSelectedColor: UIColor(red:0.15, green:0.45, blue:0.66, alpha:1.0))
        vc.delegate = self
        vc.closesAutomatically = true
        present(vc, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.86, green:0.78, blue:0.88, alpha:1.0) // #DCC6E0
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController : D2PSpinningWheelSelectorDelegate {
    
    /*func didSelectedItemsChanges(selectedItems: [Int]) {
        self.selectedItems = selectedItems
    }
    
    func didSelectedItemChanges(selectedItem: Int) {
        self.selectedItem = selectedItem
    }*/
    
}


//
//  SelectRadiusViewController.swift
//  AirportsFinder
//
//  Created by CHERNANDER04 on 06/06/21.
//

import UIKit

class SelectRadiusViewController: UIViewController {

    
    @IBOutlet weak var lblRadius: UILabel!
    @IBOutlet weak var sliderRadius: UISlider!
    
    var refreshMap = { (radius: Int) -> () in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Singleton.sharedInstance.isRadiusSelected = true
        self.sliderRadius.value = 50
    }
    
    // MARK: - Actions

    @IBAction func changeRadius(_ sender: UISlider) {
        self.lblRadius.text = "\(Int(sliderRadius.value)) km"
    }
    
    @IBAction func findAirportsAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.refreshMap(Int(self.sliderRadius.value))
        }
    }
}

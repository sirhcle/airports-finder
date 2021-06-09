//
//  AirportsListViewController.swift
//  AirportsFinder
//
//  Created by CHERNANDER04 on 07/06/21.
//

import UIKit

class AirportsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var airports: AirportsModel = AirportsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print(airports.items?.count)
        self.tableView.reloadData()
    }
}

extension AirportsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airports.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAirports", for: indexPath) as! CellAirports
        
        let item = (self.airports.items?[indexPath.row] ?? Item())
        
        cell.setupCell(airport: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 162
    }
}

class CellAirports: UITableViewCell {
    
    var airport: Item = Item()
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblShortName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    override func prepareForReuse() {
        self.lblName.text = ""
        self.lblShortName.text = ""
        self.lblCity.text = ""
    }
    
    func setupCell(airport: Item) {
        self.airport = airport
        
        self.lblName.text = "Nombre: \(self.airport.name ?? "")"
        self.lblShortName.text = "Nombre corto: \(self.airport.shortName ?? "")"
        self.lblCity.text = "Ciudad: \(self.airport.municipalityName ?? "")"
        
        self.lblName.adjustsFontSizeToFitWidth = true
        self.lblShortName.adjustsFontSizeToFitWidth = true
        self.lblCity.adjustsFontSizeToFitWidth = true
    }
    
    
}

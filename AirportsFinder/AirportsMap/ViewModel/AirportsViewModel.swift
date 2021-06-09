//
//  AirportsViewModel.swift
//  AirportsFinder
//
//  Created by CHERNANDER04 on 08/06/21.
//

import Foundation

class AirportsViewModel {
    var refresData = { () -> () in }
    
    var airportsModel: AirportsModel = AirportsModel() {
        didSet{
            self.refresData()
        }
    }
    
    func getAirportsList(lat: String, long: String, radius: String) {
        
        let strUrl = "https://aerodatabox.p.rapidapi.com/airports/search/location/\(lat)/\(long)/km/\(radius)/16"
        guard let url = URL(string: strUrl) else { return }
        
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.addValue("b540cdde7dmsh09bbba1c2bc4285p1f5f5bjsn454d7d321d4c", forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("aerodatabox.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")

        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let json = data else { return }
            
            do {
                let decoder = JSONDecoder()
                self.airportsModel = try decoder.decode(AirportsModel.self, from: json)
            } catch let error {
                print("Ha ocurrido un error: \(error.localizedDescription)")
            }
        }.resume()
    }
     
}

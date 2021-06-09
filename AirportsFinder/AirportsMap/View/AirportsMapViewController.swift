//
//  AirportsMapViewController.swift
//  AirportsFinder
//
//  Created by CHERNANDER04 on 07/06/21.
//

import UIKit
import GoogleMaps

class AirportsMapViewController: UIViewController {

    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D! = CLLocationCoordinate2D()
    
    var airportsViewModel: AirportsViewModel = AirportsViewModel()
    
    var airports: AirportsModel = AirportsModel() {
        didSet{
            self.activityIndicator.stopAnimating()
            self.tabBarController?.tabBar.items?[1].isEnabled = true
            guard let secondVC = self.tabBarController?.viewControllers?[1] as? AirportsListViewController else {
                return
            }
            secondVC.airports = self.airports
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.tabBarController?.tabBar.items?[1].isEnabled = false
    }
    
    // MARK: - Button actions
    
    @IBAction func actionNewSearch(_ sender: Any) {
        Singleton.sharedInstance.isRadiusSelected = false
        self.getRadius()
    }
    
}

extension AirportsMapViewController {
    
    func getRadius() {
        if !Singleton.sharedInstance.isRadiusSelected {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "SelectRadiusViewController") as! SelectRadiusViewController
            destVC.modalPresentationStyle = .fullScreen
            
            self.present(destVC, animated: true) {
                destVC.refreshMap = {(radius: Int) in
                    self.activityIndicator.startAnimating()
                    self.findMapsRadius(radius: radius)
                }
            }
        }
    }
    
    func findMapsRadius(radius: Int) {
        
        let _radius = radius * 10000
        
        let zoomLevel = self.callZoomLevel(coordenadas: self.coordinate, radius: Float(_radius))
        
        let camera = GMSCameraPosition.camera(withLatitude: self.coordinate.latitude, longitude: self.coordinate.longitude, zoom: Float(zoomLevel))
        let mapView = GMSMapView.map(withFrame: self.mapView.frame, camera: camera)
        
        
        /************MARKER IN MY POSITION**********/
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        
        marker.title = "Your position"
        marker.icon = UIImage(named: "placeholder")
        marker.map = mapView
        
        /********************/
        
        
        self.mapView.addSubview(mapView)
        
        self.airportsViewModel.getAirportsList(lat: "\(self.coordinate.latitude)", long: "\(self.coordinate.longitude)", radius: "\(radius)")
        
        self.airportsViewModel.refresData = { () in
            
            DispatchQueue.main.async {
                
                self.airports = self.airportsViewModel.airportsModel
                
                guard let airports: [Item] = self.airports.items else {
                    return
                }
                
                airports.forEach { (airport: Item) in
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: airport.location?.lat ?? self.coordinate.latitude, longitude: airport.location?.lon ?? self.coordinate.longitude)
                    marker.title = airport.name
                    marker.snippet = airport.shortName
                    marker.map = mapView
                }
            }
        }
    }
    
    func callZoomLevel(coordenadas: CLLocationCoordinate2D, radius: Float) -> Double{
        
        let equatorLength: Double  = 40075004.0
        let earthRadius: Double = 6371229
        
        let heightView = self.mapView.frame.size.height
        let widthView = self.mapView.frame.size.width
        
        let numerator: Double  = Double(1 + pow(heightView/widthView, 2))
        let denominator: Double  =  Double(pow(radius, 2))
        let distance: Double = sqrt(denominator/numerator)

        let longitudeDelta: Double = (180 * distance)/(Double.pi * earthRadius * cos(coordenadas.latitude * Double.pi/180));

        let width = self.mapView.frame.size.width;

        let tt: Double = longitudeDelta * equatorLength * Double.pi / (180.0 * Double(width))
        
        
        let zoom: Double = (21 - log(tt)/log(2.0))
        
        return zoom;
    }
}

extension AirportsMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //manager.requestLocation()
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
        guard status == .authorizedWhenInUse else {
            return
        }
        
        self.locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        //self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        self.coordinate = location.coordinate
        self.locationManager.stopUpdatingLocation()
        
        self.getRadius()
    }
}

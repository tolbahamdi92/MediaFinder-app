//
//  MapVC.swift
//  MediaFinder
//
//  Created by Tolba on 28/05/1444 AH.
//

import MapKit

protocol HandleMapSearch: AnyObject {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class MapVC: UIViewController {
    
    // MARK:- IBOutlet
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK:- Properities
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    private let locationManager = CLLocationManager()
    var delegate: AddressDelegate?
    
    // MARK:- ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkLocationService()
        centerMapOnCurrentLocation()
        createSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        centerMapOnCurrentLocation()
    }
    
    // MARK: - IBAction
    @IBAction func confrmBtnTapped(_ sender: UIButton) {
        confirmBtnAction()
    }
}

// MARK:- HandleMapSearch
extension MapVC: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark){
        //mapView.removeAnnotations(mapView.annotations)
        let region = MKCoordinateRegion(center: placemark.coordinate,
                                      latitudinalMeters: 10000,
                                      longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        setAddress(from: placemark.location!)
    }
}

// MARK:- CLLocationManagerDelegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        setAddress(from: location)
    }
}

// MARK:- Private Methods
extension MapVC {
    private func setupUI() {
        mapView.delegate = self
        navigationItem.hidesBackButton = true
    }
    
    private func checkLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            showAlert(title: Alerts.sorryTitle, message: Alerts.disableLocation)
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            centerMapOnCurrentLocation()
            //centerMapOnSpecifiedLocation()
        case .restricted, .denied:
            showAlert(title: Alerts.sorryTitle, message: Alerts.deniedLocationService)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            showAlert(title: Alerts.sorryTitle, message: Alerts.tryAgain)
        }
    }
    
    private func centerMapOnSpecifiedLocation() {
        let location = CLLocation(latitude: 30.0444, longitude: 31.2357)
        let region = MKCoordinateRegion(center: location.coordinate,
                                          latitudinalMeters: 10000,
                                          longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        setAddress(from: location)
    }
    
    private func centerMapOnCurrentLocation() {
        if let location = locationManager.location {
            let region = MKCoordinateRegion(center: location.coordinate,
                                          latitudinalMeters: 10000,
                                          longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
            setAddress(from: location)
        }
    }
    
    private func createSearchController() {
        let locationSearchTable = UIStoryboard.init(name: StoryBoard.main, bundle: nil).instantiateViewController(identifier: ViewController.locationSearchTVC) as! LocationSearchTVC
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = PlaceholderText.searchMap
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    private func setAddress(from location: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placeMarks, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let firstPlaceMark = placeMarks?.first {
                self.addressLabel.text = firstPlaceMark.compactAddress
            }
        }
    }
    
    private func confirmBtnAction () {
        let address = addressLabel.text ?? ""
        delegate?.setAddress(address: address)
        navigationController?.popViewController(animated: true)
    }
}

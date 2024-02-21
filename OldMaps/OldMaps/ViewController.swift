//
//  ViewController.swift
//  OldMaps
//
//  Created by Cenk Bilgen on 2024-02-16.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!

    let mapDelegate = OldMapDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = mapDelegate

        mapView.showsCompass = true
        mapView.showsUserLocation = true
    }

    let toronto = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.65, longitude: -79.38),
        latitudinalMeters: 100,
        longitudinalMeters: 100)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.setRegion(toronto, animated: true)

        mapView.setUserTrackingMode(.follow, animated: true)

        mapView.addAnnotations([
            BurgerKing(openingTime: 9, closingTime: 11, coordinate: CLLocationCoordinate2D(latitude: 43.65, longitude: -79.38)),
            BurgerKing(openingTime: 12, closingTime: 2, coordinate: CLLocationCoordinate2D(latitude: 43.80, longitude: -79.3)),
        ])

    }

}

class BurgerKing: NSObject, MKAnnotation {
    let openingTime, closingTime: Int
    let coordinate: CLLocationCoordinate2D

    init(openingTime: Int, closingTime: Int, coordinate: CLLocationCoordinate2D) {
        self.openingTime = openingTime
        self.closingTime = closingTime
        self.coordinate = coordinate
    }
}

class OldMapDelegate: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) 
    {
        print("Region Changed. center latitude: \(mapView.region.center.latitude.description)")
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let burgerKingAnnotation = annotation as? BurgerKing {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.image = UIImage(systemName: "fork.knife")
            view.canShowCallout = true
            view.detailCalloutAccessoryView = {
                let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 30)))
                label.text = "Open at \(burgerKingAnnotation.openingTime)"
                return label
            }()

            return view
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        print("Selected")
    }
}


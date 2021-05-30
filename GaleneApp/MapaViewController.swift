//
//  MapaViewController.swift
//  GaleneApp
//
//  Created by user186969 on 5/8/21.
//
import UIKit
import MapKit
import CoreLocation
import Firebase
import Foundation

class MapaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    @IBOutlet weak var telefono: UILabel!
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var direccionLabel: UILabel!
    let direccion="http://martinmolina.com.mx/202111/equipo3/data/ubicaciones.json"
    var nuevoArray:[[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate=self
        mapa.delegate = self
        locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        let db = Firestore.firestore()
        db.collection("ubicaciones").getDocuments()	 { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.nuevoArray.append(document.data())
                }
                self.setMapInfo()
            }
        }

    }
    
    func setMapInfo() {
        var index=0
        for location  in nuevoArray {
            print(location)
            let objeto = location as [String: Any]
            let s:String = objeto["nombre"] as! String
            guard let numStr1 = objeto["latitud"]! as? Double else {
                 return
            }
            guard let numStr2 = objeto["longitud"]! as? Double else {
                return
            }
            let c1 : Double = numStr1 as Double
            let c2 : Double = numStr2 as Double
            print(c1, c2)
            let dir:String = objeto["direccion"] as! String
            let tel:String = objeto["telefono"] as! String
            let cl=CLLocationCoordinate2D(latitude: c1 , longitude: c2 )
            let pointAnnotation = Annotation()
            pointAnnotation.index = index
            pointAnnotation.coordinate = cl
            pointAnnotation.title = s
            pointAnnotation.subtitle = dir
            pointAnnotation.telefono = tel
            pointAnnotation.info = dir

            mapa.addAnnotation(pointAnnotation)
            index+=1
        }
        mapa.showsCompass=true
        mapa.showsScale=true
        mapa.isZoomEnabled=true
        mapa.mapType = MKMapType.hybrid
        let punto = CLLocationCoordinate2DMake(16.782412,-93.1277864)
        mapa.region = MKCoordinateRegion(center: punto, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse{
                locationManager.startUpdatingLocation()
                mapa.showsUserLocation = true
            }
            else{
                locationManager.stopUpdatingLocation()
                mapa.showsUserLocation = false
            }
        }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
        {
            if let customAnnotation = view.annotation as? Annotation {
                    direccionLabel.text = customAnnotation.info
                    telefono.text = customAnnotation.telefono
                
            }
        }
   
    }



//
//  MapaViewController.swift
//  GaleneApp
//
//  Created by user186969 on 5/8/21.
//
import UIKit
import MapKit
import CoreLocation

class MapaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    @IBOutlet weak var telefono: UILabel!
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var direccionLabel: UILabel!
    let direccion="http://martinmolina.com.mx/202111/equipo3/data/ubicaciones.json"
    var nuevoArray:[Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: direccion) {
                //let contents = try String(contentsOf: url)
                //print(contents)
                let datosCrudos = try? Data(contentsOf: url)
                nuevoArray = try! JSONSerialization.jsonObject(with: datosCrudos!) as? [Any]
            
        } else {
            // the URL was bad!
            print("the URL was bad!")
        }
        
        //where do i look for my methods, in self
        locationManager.delegate=self
        mapa.delegate = self
        //which is the accuracy you want
        locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        var index=0
        for location  in nuevoArray! {
            
            let objeto = location as! [String: Any]
            //let annotation = MKPointAnnotation()
            let s:String = objeto["nombre"] as! String
            let s2:Double = objeto["longitud"]  as! Double
            let s3:Double = objeto["latitud"]  as! Double
            let dir:String = objeto["direccion"] as! String
            let tel:String = objeto["telefono"] as! String
            let cl=CLLocationCoordinate2D(latitude: s3 , longitude: s2 )
            //annotation.title = s
            //annotation.coordinate = cl
            //annotation.subtitle = objeto["direccion"]! as! String
            let pointAnnotation = Annotation()
            pointAnnotation.index = index
            pointAnnotation.coordinate = cl
            pointAnnotation.title = s
            pointAnnotation.subtitle = dir
            pointAnnotation.telefono = tel
            pointAnnotation.info = dir

            mapa.addAnnotation(pointAnnotation)
            //direccionLabel.text = objeto["direccion"]! as! String
            //telefono.text = objeto["telefono"]! as! String
            index+=1
        }
        
        mapa.showsCompass=true
        mapa.showsScale=true
        mapa.isZoomEnabled=true
        mapa.mapType = MKMapType.hybrid
        let punto = CLLocationCoordinate2DMake(16.782412,-93.1277864)
        mapa.region = MKCoordinateRegion(center: punto, latitudinalMeters: 10000, longitudinalMeters: 10000)

 
        
        // Do any additional setup after loading the view.

    }

    //user authorizario
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



//
//  YjiMapVc.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/05/31.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit
import GoogleMaps

class YjiMapVc: UIViewController {
    
    var mYjiLocationManager: YjiLocationManager?
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        mYjiLocationManager = YjiLocationManager.sharedInstance
        let camera = GMSCameraPosition.camera(withLatitude: 48.857165, longitude: 2.354613, zoom: 8.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 48.857165, longitude: 2.354613)
        marker.title = "Tokyo"
        marker.snippet = "Japan"
        marker.map = mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

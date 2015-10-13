//
//  ViewController.swift
//  Current Location
//
//  Created by Nicolas Emery on 8/8/15.
//  Copyright © 2015 Nicolas Emery. All rights reserved.
//

import UIKit
// location services
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate
{
    // create the variable manager to monitor the user
    var manager:CLLocationManager!
    
    // declare all the labels that will be updated as location changes
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var courseLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var altitudeLabel: UILabel!
    @IBOutlet var nearestAreaLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set up manager to monitor the users location
        manager = CLLocationManager();
        manager.delegate = self;
        manager.desiredAccuracy - kCLLocationAccuracyBest;
        manager.requestWhenInUseAuthorization();
        manager.startUpdatingLocation();
    }//end of viewDidLoad

    // this function is called each time the location changes (AnyObject is now called CLLocation"
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations);
        
        // convert the users location into a CLLocation variable to do manupliation
        var userLocation:CLLocation = locations[0] as! CLLocation;
        
        // extract the lat and long from the users location and set equal to the labels
        self.latitudeLabel.text = String(userLocation.coordinate.latitude);
        self.longitudeLabel.text = String(userLocation.coordinate.longitude);
        
        // get the users course
        self.courseLabel.text = String(userLocation.course);
        // get the speed
        self.speedLabel.text = String(userLocation.speed);
        // get the altitude
        self.altitudeLabel.text = String(userLocation.altitude);
        // take a location and convert to an address
        // data in the CLGeocoder().  is an array
        CLGeocoder().reverseGeocodeLocation(userLocation)
        { (data, error) -> Void in
            //check for an error
            if( error != nil)
            {
                print(error);
            }// end of if error
            else
            {
                // create a placemark (use the ! becuase we have to make sure it exisits)
                let placeMarks = data as [CLPlacemark]!
                // create a variable called location so that we can extract the location data from it rather than the raw data
                let location:CLPlacemark = placeMarks[0];
                print(location)
                
                // check for a subThoroughfare if there is a value add it to local var
                var subThoroughfare:String = "";
                if(location.subThoroughfare != nil)
                {
                   subThoroughfare = location.subThoroughfare!
                }//end of if subThoroughfare
                
                // print to the app the data on nearest location (found from the reverseGeocodeLocation
                // use the actual name ID that was printed to the logs .country .postalCode ect.
                self.nearestAreaLabel.text = "\(subThoroughfare) \(location.thoroughfare) \n \(location.subLocality) \n \(location.subAdministrativeArea) \n \(location.postalCode) \n \(location.country)";
            }//end of else no error statment
        }//end of CLGeocoder
        
        /*
        // zooming in
        var latDelta:CLLocationDegrees = 0.005;
        var longDelta:CLLocationDegrees = 0.005;
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta);
        
        // create a location
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(usersLatitude, usersLongitude);
        
        // create a region
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span);
        self.map.setRegion(region, animated: true);
            */

    }//end of locationManager
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }//end of didReceiveMemoryWarning


}//end of view controller


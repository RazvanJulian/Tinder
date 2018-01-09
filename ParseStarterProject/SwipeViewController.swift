//
//  SwipeViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Razvan  Julian on 07/12/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class SwipeViewController: UIViewController {
    
    var displayedUserID = ""
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBAction func logout(_ sender: Any) {
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.swipped(gestureRecognizer:)))
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        
        
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in
            if let geoPoint  = geoPoint {
                PFUser.current()?["location"] = geoPoint
                
                PFUser.current()?.saveInBackground()
                
            }
            
            
            
        }
        
        
        updateImage()
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logout" {
            
            PFUser.logOut()
            
        }
        
        
        
        
    }
    
    
    func swipped(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        let imageView = gestureRecognizer.view!
        
        let xFromCenter = imageView.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale = min(abs(50 / xFromCenter), 1)
        
        var strechAndRotation = rotation.scaledBy(x: scale, y:scale )
        
        imageView.transform = strechAndRotation
        
        imageView.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            var acceptedOrRejected = ""
            
            if imageView.center.x < 100 {
                acceptedOrRejected = "rejected"
                
                
                
            } else if imageView.center.x > self.view.bounds.width - 100 {
                
                acceptedOrRejected = "accepted"
                
            }
            
            if acceptedOrRejected != "" && displayedUserID != "" {
                
                PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: acceptedOrRejected)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    
                    print(PFUser.current())
                    
                    self.updateImage()
                })
                
                
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            strechAndRotation = rotation.scaledBy(x: 1, y: 1)
            
            imageView.transform = strechAndRotation
            
            imageView.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            
        }
        
    }
    
    
    
    
    func updateImage() {
        
        let query = PFUser.query()
        query?.whereKey("isFemale", equalTo: (PFUser.current()?["isInterestedInWomen"])!)
        
        query?.whereKey("isInterestedInWomen", equalTo: (PFUser.current()?["isFemale"])!)
        
        var ignoredUsers = [""]
        
        if let acceptedUsers = PFUser.current()?["accepted"] {
            ignoredUsers += acceptedUsers as! Array
        }
        
        if let rejectedUsers = PFUser.current()?["rejected"] {
            
            ignoredUsers += rejectedUsers as! Array
        }
        
        query?.whereKey("objectId", notContainedIn: ignoredUsers)
        
        if let latitude = (PFUser.current()?["location"] as AnyObject).latitude  {
            
            if let longitude = (PFUser.current()?["location"] as AnyObject).longitude {
                query?.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast: PFGeoPoint(latitude: latitude + 1, longitude: longitude + 1))
            }
        }
        
        query?.limit = 1
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if let users = objects {
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.displayedUserID = user.objectId!
                    
                        let imageFile = user["photo"] as! PFFile
                        imageFile.getDataInBackground(block: { (data, error) in
                            
                            if let imageData = data {
                                
                                self.imageView.image = UIImage(data: imageData)
                            }
                            
                        })
                    }
                }
            }
            
        })
        
        
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

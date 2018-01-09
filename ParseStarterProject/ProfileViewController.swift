//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Razvan  Julian on 06/12/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var updateProfileImageButton: UIButton!
    
    @IBOutlet var genderSwitch: UISwitch!
    
    @IBOutlet var interestedInSwitch: UISwitch!
    
    @IBAction func updateProfileImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet var updateButton: UIButton!
    
    @IBAction func updateProfile(_ sender: Any) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.bounds.width/2, y: self.view.bounds.height/2, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        PFUser.current()?["isInterestedInWomen"] = interestedInSwitch.isOn
        
        let imageData = UIImagePNGRepresentation(imageView.image!)
        PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                
                
                var displayErrorMesage = "Please try again later!"
                if let errorMessage = (error! as NSError).userInfo["error"] as? String {
                    displayErrorMesage = errorMessage
                    self.errorLabel.text = displayErrorMesage
                }
                
                
                self.createAlert(title: "Update Error", message: displayErrorMesage)
                
            }else{
                
                print("Updated")
                
                self.performSegue(withIdentifier: "showSwipe", sender: self)

                
            }
            
            
        })
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateButton.layer.cornerRadius = 10
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            genderSwitch.setOn(isFemale, animated: false)
            
        }
        
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            genderSwitch.setOn(isInterestedInWomen, animated: false)
            
        }
        
        
        
        if let photo = PFUser.current()?["photo"] as? PFFile {
            photo.getDataInBackground(block: { (data, error) in
                
                if let imageData = data {
                    
                    if let downloadedImage = UIImage(data: imageData){
                        self.imageView.image = downloadedImage
                    }
                }
            })
            
            
        }
        
        
//        let urlArray = ["https://i.pinimg.com/474x/2d/6f/8e/2d6f8ef1a4c976ce5e2a9eea5980ec92--female-golden-retriever-golden-retriever-rescue.jpg", "http://www.yourpurebredpuppy.com/dogbreeds/photos-EFGH/goldenretrieversf4.jpg", "http://www.goldenretrieverforum.com/attachment.php?attachmentid=120141&stc=1&d=1350083623", "http://www.bestfrienddogtraining.com/wp-content/uploads/2016/11/Nora-one-year-old-female-Golden-Retriever-2.jpg", "https://vetstreet-brightspot.s3.amazonaws.com/94/84/6c5e5b2f421589e951451632b546/golden-retriever-ap-0johoo-335.jpg", "https://cdn.pixabay.com/photo/2017/09/18/23/22/dog-2763566_960_720.jpg", "http://maxpixel.freegreatpicture.com/static/photo/1x/Female-Dog-Tongue-Golden-Retriever-Pet-Animal-2872988.jpg"]
//
//
//        var counter = 0
//
//        for urlString in urlArray {
//
//            counter += 1
//
//            let url = URL(string: urlString)
//
//            do {
//
//                let data = try Data(contentsOf: url!)
//
//                let imageFile = PFFile(name: "photo.png", data: data)
//
//                let user = PFUser()
//
//                user["photo"] = imageFile
//
//                user.username = String(counter)
//
//                user.password = "password"
//
//                user["isInterestedInWomen"] = false
//
//                user["isFemale"] = true
//
//                let acl = PFACL()
//                acl.getPublicReadAccess = true
//                user.acl = acl
//
//                user.signUpInBackground(block: { (success, error) in
//
//                    if success {
//
//                        print("user signed up")
//
//                    }
//
//
//                })
//
//
//            } catch {
//
//                print("Could not get data")
//            }
//
//
//
//        }
        
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

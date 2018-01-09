//
//  MatchesViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Razvan  Julian on 07/12/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class MatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var images = [UIImage]()
    var userIDs = [String]()
    
    var acceptedUsersArray = Array<String>()
    var matches = Array<String>()
    var IDs = Array<String>()
    var messages = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        
        
        let query = PFUser.query()
        
        query?.whereKey("accepted", contains: PFUser.current()?.objectId) // who accepted out user
        
        query?.whereKey("objectId", containedIn: PFUser.current()?["accepted"] as! [String]) // where our user accepted other
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        let imageFile = user["photo"] as! PFFile
                        
                        imageFile.getDataInBackground(block: { (data, error) in
                            
                            if let imageData = data {
                                
                                self.userIDs.append(user.objectId!)
                                
                                self.images.append(UIImage(data: imageData)!)
                                
                                self.tableView.reloadData()
                                
                                let messageQuery = PFQuery(className: "Message")
                                
                                messageQuery.whereKey("recipient", equalTo: PFUser.current()?.objectId!)
                                messageQuery.whereKey("sender", equalTo: user.objectId!)
                                
                                messageQuery.findObjectsInBackground(block: { (objects, error) in
                                    
                                    var messageText = "No message from the user."
                                    
                                    if let objects = objects {
                                        for massage in objects {
                                            
                                            
                                            if let messageContent = massage["content"] as? String {
                                                    messageText = messageContent
                                                }
                                                
                                            
                                        }
                                        
                                    }
                                    
                                    self.messages.append(messageText)
                                    
                                    self.userIDs.append(user.objectId!)
                                    
                                    self.images.append(UIImage(data: imageData)!)
                                    
                                    self.tableView.reloadData()
                                    
                                })
                                
                                
                                
                            }
                            
                            
                        })
                        
                    }
                    
                }
            }
            
        })
    }
    
    
 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MatchesTableViewCell
        
        cell.matchesImageView.image = images[indexPath.row]
        
        cell.userIDLabel.text = userIDs[indexPath.row]
        
        cell.messageLabel.text  = "You havenn't received a message yet"
        
        cell.messageLabel.text = messages[indexPath.row]
        
        return cell
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 150
        } else {
            return 150
        }
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

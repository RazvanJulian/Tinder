//
//  MatchesTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by Razvan  Julian on 07/12/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class MatchesTableViewCell: UITableViewCell {
    
    @IBOutlet var matchesImageView: UIImageView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var userIDLabel: UILabel!
    
    @IBOutlet var sendButton: UIButton!
    @IBAction func send(_ sender: Any) {
        
        print(userIDLabel.text)
        print(messageTextField.text)
        
        let message = PFObject(className: "Message")
        message["sender"] = PFUser.current()?.objectId
        message["recipient"] = userIDLabel.text
        message["content"] = messageTextField.text
        message.saveInBackground()
        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

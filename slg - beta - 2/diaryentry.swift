//
//  diaryentry.swift
//  slg - beta - 2
//
//  Created by Sean Keenan on 9/5/16.
//  Copyright © 2016 Christina li. All rights reserved.
//

import UIKit

class diaryEntry {
    var location: String
    var photo: UIImage?
    var text: String

//MARK: Initialization

    init?(location: String, photo: UIImage?, text: String){
        //Initialize stored properties
        self.location = location
        self.photo = photo
        self.text = text
    
        if location.isEmpty || text.isEmpty {
            return nil
        }
    }
}

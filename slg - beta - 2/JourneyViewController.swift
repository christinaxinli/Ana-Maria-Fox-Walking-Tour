//
//  JourneyViewController.swift
//  slg - beta - 2
//
//  Created by Sean Keenan on 7/31/16.
//  Copyright © 2016 Christina li. All rights reserved.
//

import Foundation
import UIKit

class JourneyViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: Variables
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var currentFox: String = "NA"
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("View controller for \(currentFox)")
        
        //MARK: Switching between storyboards
        
        let storyboard = UIStoryboard(name:"Main",bundle:nil)

        
        switch currentFox {
        case "Fox1":
            let svc=storyboard.instantiateViewController(withIdentifier: "Fox1") as! Fox1
            self.present(svc,animated: true, completion: nil)
            
        case "Fox2":
            let svc=storyboard.instantiateViewController(withIdentifier: "Fox2") as! Fox2
            self.present(svc,animated: true, completion: nil)
        
        case "Fox3":
            let svc=storyboard.instantiateViewController(withIdentifier: "Fox3") as! Fox3
            self.present(svc,animated: true, completion: nil)
            
        default:
            let svc=storyboard.instantiateViewController(withIdentifier: "Instructions") as! InstructionsViewController
            self.present(svc,animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

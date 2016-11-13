//
//  InstructionsViewController.swift
//  slg - beta - 2
//
//  Created by Sean Keenan on 9/5/16.
//  Copyright © 2016 Christina li. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    //MARK: Variables
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

         //Do any additional setup after loading the view.
        
                if self.revealViewController() != nil {
                    menuButton.target = self.revealViewController()
                    menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

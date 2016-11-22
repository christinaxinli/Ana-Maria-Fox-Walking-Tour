//
//  SocialMediaPhoto.swift
//  slg - beta - 2
//
//  Created by Sean Keenan on 11/14/16.
//  Copyright © 2016 Christina li. All rights reserved.
//

import Foundation
import UIKit

class SocialMediaPhoto: UIViewController {
    
    @IBOutlet weak var Image1: UIImageView!
    @IBOutlet weak var Image6: UIImageView!
    @IBOutlet weak var Image5: UIImageView!
    @IBOutlet weak var Image4: UIImageView!
    @IBOutlet weak var Image3: UIImageView!
    @IBOutlet weak var Image2: UIImageView!
    func loadMeals() -> [Diary]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Diary.ArchiveURL.path) as? [Diary]
    }
    
    func unwrapPhotos() -> [UIImage] {
        let collection: [Diary] = loadMeals()!
        var images: [UIImage] = []
        for i in 0..<collection.count {
            images.append(collection[i].photo)
        }
        return images
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        if self.revealViewController() != nil {
        //            menuButton.target = self.revealViewController()
        //            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        //            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //        }
        if let collection: [UIImage] =  unwrapPhotos() {
            let size: Int =  collection.count
            switch size {
            case 0:
                Image1 = UIImageView(image: collection[0])
            case 1:
                Image1 = UIImageView(image: collection[0])
                Image2 = UIImageView(image: collection[1])
            case 2:
                Image1 = UIImageView(image: collection[0])
                Image2 = UIImageView(image: collection[1])
                Image3 = UIImageView(image: collection[2])
            case 3:
                Image1 = UIImageView(image: collection[0])
                Image2 = UIImageView(image: collection[1])
                Image3 = UIImageView(image: collection[2])
                Image4 = UIImageView(image: collection[3])
            case 4:
                Image1 = UIImageView(image: collection[0])
                Image2 = UIImageView(image: collection[1])
                Image3 = UIImageView(image: collection[2])
                Image4 = UIImageView(image: collection[3])
                Image5 = UIImageView(image: collection[4])
            case 5:
                Image1 = UIImageView(image: collection[0])
                Image2 = UIImageView(image: collection[1])
                Image3 = UIImageView(image: collection[2])
                Image4 = UIImageView(image: collection[3])
                Image5 = UIImageView(image: collection[4])
                Image6 = UIImageView(image: collection[6])
            default:
                return
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//var bottomImage = UIImage(named: "bottom.png")
//var topImage = UIImage(named: "top.png")
//
//var size = CGSize(width: 300, height: 300)
//UIGraphicsBeginImageContext(size)
//
//let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//bottomImage!.drawInRect(areaSize)
//
//topImage!.drawInRect(areaSize, blendMode: kCGBlendModeNormal, alpha: 0.8)
//
//var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
//UIGraphicsEndImageContext()



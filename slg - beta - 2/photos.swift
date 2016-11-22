//
//  photos.swift
//  slg - beta - 2
//
//  Created by Sean Keenan on 7/10/16.
//  Copyright © 2016 Christina li. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class photos: UIViewController, UIImagePickerControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate {
    
    //MARK: Variables
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var photoImageView: UIImageView!
    //@IBOutlet weak var diaryText: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var identifier: UITextField!
    /*
     This value is either passed by `DiaryTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new meal.
     */
    var entry: diaryEntry?
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            //diaryText.delegate = self
        }
        
        imagePicker.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:Navigation
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender is UIButton{
            let location = identifier.text ?? ""
            let photo = photoImageView.image
            //let text = diaryText.text
            
            //set entry to be passed after unwind segue
            entry = diaryEntry(location: location, photo: photo/*, text: text!*/)
        }
    }
    
    //MARK: Actions
    //MARK: photolibrary
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func useCamera(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    // MARK: - UIImagePickerControllerDelegate Methods
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.contentMode = .scaleAspectFit
            photoImageView.image = pickedImage
        }
    
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //  MARK: UI Text Field editing
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            diaryText.resignFirstResponder()
//            return false
//        }
//        return true
//    }
//    @IBAction func identifierTextView(_ sender: UITextField) {
//        identifier.resignFirstResponder()
//    }
//
//    private func textViewDidEndEditing(textView: UITextView){
//        diaryText.resignFirstResponder()
//    }
    

}



import UIKit

class DiaryViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    let imagePickerController = UIImagePickerController()

    var entry: Diary?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing entry.
        if let entry = entry {
            navigationItem.title = entry.name
            nameTextField.text = entry.name
            photoImageView.image = entry.photo
            //ratingControl.rating = meal.rating
        }
        checkValidEntryName()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(DiaryViewController.imageTapped))
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(tapGestureRecognizer)
        
        imagePickerController.delegate = self
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidEntryName()
        navigationItem.title = textField.text
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func checkValidEntryName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
    
    // MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        if (nameTextField.text! == "") {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    

    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        
        // Set the entry to be passed to DiaryListTableViewController after the unwind segue.
        entry = Diary(name: name, photo: photo!)
        
        
        //navigationController?.pushViewController(DiaryTableViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "AddNew" {
            //segue.destination as! DiaryTableViewController
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            
            // Set the entry to be passed to DiaryListTableViewController after the unwind segue.
            entry = Diary(name: name, photo: photo!)
        //}
    }
    
    
    // MARK: Actions
    
    func imageTapped()
    {
        // Your action
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        
        
        imagePickerController.allowsEditing = true
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    @nonobjc internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            photoImageView.contentMode = .scaleAspectFit
            photoImageView.image = selectedImage
        } else {
            print("something went wrong with imagepicker")
        }
        
        // Set photoImageView to display the selected image.
        
        
        // Dismiss the picker.
        self.dismiss(animated: true, completion: nil)
    }
    

}


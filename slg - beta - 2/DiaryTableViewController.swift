//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 5/27/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information.
//

import UIKit

class DiaryTableViewController: UITableViewController {
    // MARK: Properties
    
    var entries = [Diary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedMeals = loadMeals() {
            entries += savedMeals
        } else {
            // Load the sample data.
            loadSampleMeals()
        }
    }
    
    func loadSampleMeals() {
        let photo1 = UIImage(named: "falmouth1")!
        let entry1 = Diary(name: "Caprese Salad", photo: photo1)!
        
        let photo2 = UIImage(named: "Falmouth2")!
        let entry2 = Diary(name: "Chicken and Potatoes", photo: photo2)!
        
        let photo3 = UIImage(named: "Falmouth3")!
        let entry3 = Diary(name: "Pasta with Meatballs", photo: photo3)!
        
        entries += [entry1, entry2, entry3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DiaryTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let diary = entries[(indexPath as NSIndexPath).row]
        
        cell.nameLabel.text = diary.name
        cell.photoImageView.image = diary.photo
        //cell.ratingControl.rating = meal.rating
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            entries.remove(at: (indexPath as NSIndexPath).row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let mealDetailViewController = segue.destination as! DiaryViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? DiaryTableViewCell {
                let indexPath = tableView.indexPath(for: selectedMealCell)!
                let selectedMeal = entries[(indexPath as NSIndexPath).row]
                mealDetailViewController.entry = selectedMeal
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new entry.")
        }
    }
    

    @IBAction func unwindToMealList(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DiaryViewController, let meal = sourceViewController.entry {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                entries[(selectedIndexPath as NSIndexPath).row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: entries.count, section: 0)
                entries.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            // Save the meals.
            saveMeals()
        }
    }
    
    // MARK: NSCoding
    
    func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(entries, toFile: Diary.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }
    
    func loadMeals() -> [Diary]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Diary.ArchiveURL.path) as? [Diary]
    }
}

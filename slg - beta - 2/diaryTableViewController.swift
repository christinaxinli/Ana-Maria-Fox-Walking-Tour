//
//  diaryTableViewController.swift
//  slg - beta - 2
//
//  Created by Sean Keenan on 9/5/16.
//  Copyright © 2016 Christina li. All rights reserved.
//

import UIKit

class diaryTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var entries = [diaryEntry]()
    
    func loadSampleEntries() {
        let photo1 = UIImage(named: "Image-1")!
        let entry1 = diaryEntry(location: "first", photo: photo1, text: "onetwothreefour")!
        
        let photo2 = UIImage(named:"Image-2")!
        let entry2 = diaryEntry(location: "second", photo: photo2, text: "onetwothreefour")!
        
        let photo3 = UIImage(named:"Image-3")!
        let entry3 = diaryEntry(location: "third", photo: photo3, text: "onetwothreefour")!
        
        entries+=[entry1, entry2, entry3]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleEntries()
        print (entries)
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        func numberOfSectionsInTableView(tableView: UITableView)-> Int {
            return 1
        }
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return entries.count
        }
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell{
            //table view cells are reused and should be dequeued using a cell identifier
            let cellIdentifier = "diaryEntryTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! diaryEntryTableViewCell
            
            
            let entry = entries[indexPath.row]
            
            cell.locationName.text = entry.location
            cell.diaryPhoto.image = entry.photo
            cell.diaryText.text = entry.text
            
            print (cell)
            
            return cell
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    @IBAction func unwindToEntryList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? photos, entry = sourceViewController.entry {
            //add new entry
            let newIndexPath = NSIndexPath(row: entries.count,section:0)
            entries.append(entry)
            tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

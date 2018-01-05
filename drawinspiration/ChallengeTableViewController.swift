//
//  ChallengeTableViewController.swift
//  drawinspiration
//
//  Created by Mark Danforth on 14/08/2017.
//  Copyright © 2017 Mark Danforth. All rights reserved.
//

import UIKit
import os.log

class ChallengeTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var challenges = [Challenge]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        challenges = NSKeyedUnarchiver.unarchiveObject(withFile: Challenge.ArchiveURL.path) as! [Challenge]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return challenges.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeTableViewCell", for: indexPath) as? ChallengeTableViewCell else {
            fatalError("The dequeued cell is not an instance of ChallengeTableViewCell.")
        }
        // Configure the cell...
        
        let challenge = challenges[indexPath.row]
        
        cell.challengeDetails.text = "\(challenge.medium) -> \(challenge.subject) -> \(String(format: "%.0f", challenge.timeLimit / 60)) minutes"
        cell.challengeImage.image = challenge.image
        
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        cell.challengeDate.text = "\(dateFormat.string(from: challenge.created!))"

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "showChallenge":
            (segue.destination as! GoDrawViewController).challenge = challenges[(tableView.indexPath(for: (sender as? ChallengeTableViewCell)!)?.row)!]
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "unfound identifier")")
        }
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
            challenges.remove(at: indexPath.row)
            saveChallenges()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    private func saveChallenges() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(challenges, toFile: Challenge.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Challengess successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save challenges...", log: OSLog.default, type: .error)
        }
    }
}

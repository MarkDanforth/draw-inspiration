//
//  GoDrawViewController.swift
//  drawinspiration
//
//  Created by Mark Danforth on 12/08/2017.
//  Copyright © 2017 Mark Danforth. All rights reserved.
//

import UIKit
import Social
import os.log

class GoDrawViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    var challenge: Challenge?
    var timer: Timer?
    var timerCurrent: Double?
    var isPaused: Bool = true
    
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var timeLimitLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var finishedImage: UIImageView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerStackView: UIStackView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var saveStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleLabel.text = styleLabel.text! + (challenge?.medium)!
        subjectLabel.text = subjectLabel.text! + (challenge?.subject)!
        timeLimitLabel.text = timeLimitLabel.text! + String(format:"%.0f minutes", (challenge?.timeLimit)! / 60)
        timerCurrent = (challenge?.timeLimit)!
        countdownLabel.text = String(format: "%02.0f : %02.0f", floor(timerCurrent! / 60), timerCurrent!.truncatingRemainder(dividingBy: 60))
        
        // Do any additional setup after loading the view.
        tweetButton.isEnabled = SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
        
        // if the challenge has a date we are in 'view' mode
        if challenge?.created != nil {
            timerStackView.isHidden = true
            photoButton.isHidden = true
            saveStackView.isHidden = false
        }
        
        if challenge?.image != nil {
            finishedImage.image = challenge?.image
        }
    }

    @IBAction func startClicked(_ sender: UIButton) {
        if (timer == nil) {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
        }
        
        isPaused = !isPaused
        startButton.setTitle(isPaused ? "Start" : "Pause", for: .normal)
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil)
        
        finishedImage.image = selectedImage

        dismiss(animated: true, completion: nil)
        
        timerStackView.isHidden = true
        photoButton.isHidden = true
        saveStackView.isHidden = false
    }
    
    // MARK: Actions
    
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {

    }
    
    @IBAction func photoButtonClick(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveChallenge(_ sender: UIButton) {
        // load list from storage
        var challenges = NSKeyedUnarchiver.unarchiveObject(withFile: Challenge.ArchiveURL.path) as? [Challenge]
        
        os_log("Challenges loaded.", log: OSLog.default, type: .debug)
        // add new challenge
        if (challenges == nil) {
            challenges = [Challenge]()
        }
        
        challenge?.image = finishedImage.image
        
        challenges?.append(challenge!)
        
        // save list back to storage
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(challenges!, toFile: Challenge.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Challenges successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save challenges...", log: OSLog.default, type: .error)
        }
    }
    
    @IBAction func stopClick(_ sender: Any) {
        if timerCurrent != nil {
            timer?.invalidate()
        }
        
        timerStackView.isHidden = true
        photoButton.isHidden = false
    }

    @IBAction func tweetClick(_ sender: UIButton) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetSheet?.setInitialText("Share on Twitter")
            tweetSheet?.add(finishedImage.image)
            self.present(tweetSheet!, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private methods
    @objc private func timerUpdate() {
        if timerCurrent! <= 0 {
            timer?.invalidate()
        }
        countdownLabel.text = String(format: "%02.0f : %02.0f", floor(timerCurrent! / 60), timerCurrent!.truncatingRemainder(dividingBy: 60))
        
        if !isPaused {
            timerCurrent! -= 1
        }
    }

}

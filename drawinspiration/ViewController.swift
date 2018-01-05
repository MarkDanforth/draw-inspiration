//
//  ViewController.swift
//  drawinspiration
//
//  Created by Mark Danforth on 06/08/2017.
//  Copyright © 2017 Mark Danforth. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var stylePicker: UIPickerView = UIPickerView()
    var subjectPicker: UIPickerView = UIPickerView()
    var timePicker: UIDatePicker = UIDatePicker()
    
    @IBOutlet weak var styleInput: UITextField!
    @IBOutlet weak var subjectInput: UITextField!
    @IBOutlet weak var timeInput: UITextField!

    
    var styleData: [String] = [String]()
    var subjectData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stylePicker.delegate = self
        self.stylePicker.dataSource = self
        self.subjectPicker.delegate = self
        self.subjectPicker.dataSource = self
        
        timePicker.datePickerMode = .countDownTimer
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        
        styleData = ["Pencil", "Ink", "Paint", "Manga"]
        subjectData = ["Human(ish)", "Animal", "Plant", "Natural object", "Man made object"]
        
        styleInput.inputView = stylePicker
        subjectInput.inputView = subjectPicker
        timeInput.inputView = timePicker
        
        rollChoices()
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === stylePicker {
            return styleData.count
        } else {
            return subjectData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === stylePicker {
            return styleData[row]
        } else {
            return subjectData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === stylePicker {
            styleInput.text = styleData[row]
            styleInput.resignFirstResponder()
        } else {
            subjectInput.text = subjectData[row]
            subjectInput.resignFirstResponder()
        }
    }
    
    func timeChanged(sender: UIDatePicker) {
        timeInput.text = String(format:"%.0f", timePicker.countDownDuration / 60)
        timeInput.resignFirstResponder()
    }
    
    @IBAction func rollClicked(_ sender: Any) {
        rollChoices()
        updateUI()
    }
    
    @IBAction func goClicked(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "History":
            os_log("Heading for the history screen", log: OSLog.default, type: .debug)
        case "GoDraw":
            (segue.destination as! GoDrawViewController).challenge = Challenge(medium: styleInput.text!, subject: subjectInput.text!, timeLimit: timePicker.countDownDuration)
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "unfound identifier")")
        }
    }

    
    //MARK: Private functions
    
    private func rollChoices() {
        stylePicker.selectRow(Int(arc4random_uniform(UInt32(styleData.count))), inComponent: 0, animated: false)
        subjectPicker.selectRow(Int(arc4random_uniform(UInt32(subjectData.count))), inComponent: 0, animated: false)
        timePicker.countDownDuration = TimeInterval(arc4random_uniform(13) * 300)
    }
    
    private func updateUI() {
        styleInput.text = styleData[stylePicker.selectedRow(inComponent: 0)]
        subjectInput.text = subjectData[subjectPicker.selectedRow(inComponent: 0)]
        timeInput.text = String(format:"%.0f", timePicker.countDownDuration / 60)
    }
}


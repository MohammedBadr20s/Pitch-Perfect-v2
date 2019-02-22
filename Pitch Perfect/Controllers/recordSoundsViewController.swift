//
//  recordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mohammed Badr on 2019-01-31.
//  Copyright © 2019 Mohammed Badr. All rights reserved.
//

import UIKit
import AVFoundation

class recordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    // Mark: Properties
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordAndStopAndLabelUIs( recordButtn: true, isHideRecordB: false, isHideStopB: true, stopButtn: false, recordLabel: "Tap to Record Audio")
    }

    @IBAction func recordAudio(_ sender: Any) {

        recordAndStopAndLabelUIs(recordButtn: false, isHideRecordB: true, isHideStopB: false, stopButtn: true, recordLabel: "Recording is in Progress")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "RecordedAudio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    @IBAction func stopAudio(_ sender: Any) {
        recordAndStopAndLabelUIs(recordButtn: true, isHideRecordB: false, isHideStopB: true, stopButtn: false, recordLabel: "Recording had Stopped")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording wasn't Successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! playSoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudio = recordedAudioURL
        }
    }
    private func recordAndStopAndLabelUIs(recordButtn: Bool,isHideRecordB: Bool, isHideStopB: Bool, stopButtn: Bool, recordLabel: String ) {
        recordingLabel.text = recordLabel
        recordingButton.isEnabled = recordButtn
        stopRecordingButton.isEnabled = stopButtn
        recordingButton.isHidden = isHideRecordB
        stopRecordingButton.isHidden = isHideStopB
    }
}


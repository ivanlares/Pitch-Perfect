//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by ivan lares on 11/21/14.
//  Copyright (c) 2014 ivan. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    
    override func viewWillAppear(animated: Bool){
        stopButton.hidden = true
        recordButton.enabled = true
        recordingLabel.hidden = false
        recordingLabel.text = "Tap to record"
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordingLabel.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingLabel.text = "Recording"
        stopButton.hidden = false
        recordButton.enabled = false
        // Create File path for audio file
        let filePath =
            NSURL.fileURLWithPath(NSTemporaryDirectory() + "PitchPerfect")
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let data: RecordedAudio = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successfull")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    

}


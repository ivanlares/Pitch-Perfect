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
  
  var audioRecorder: AVAudioRecorder?
  var recordedAudio: RecordedAudio?
  
  override func viewWillAppear(animated: Bool){
    stopButton.hidden = true
    recordButton.enabled = true
    recordingLabel.hidden = false
    recordingLabel.text = "Tap to record"
  }
  
  @IBAction func stopRecording(sender: UIButton) {
    recordingLabel.hidden = true
    audioRecorder?.stop()
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setActive(false)
    } catch let error as NSError{
      print(error.localizedDescription)
    }
  }
  
  @IBAction func recordAudio(sender: UIButton) {
    recordingLabel.text = "Recording"
    stopButton.hidden = false
    recordButton.enabled = false
    
    let filePath =
    NSURL.fileURLWithPath(NSTemporaryDirectory() + "PitchPerfect")
    let session = AVAudioSession.sharedInstance()
    do {
      try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
    } catch let error as NSError {
      print(error.localizedDescription)
    }
    do {
      audioRecorder =
      try AVAudioRecorder(URL: filePath, settings: [String:AnyObject]())
    } catch let error as NSError {
      print(error.localizedDescription)
      audioRecorder = nil
    }
    audioRecorder?.delegate = self
    audioRecorder?.meteringEnabled = true
    audioRecorder?.prepareToRecord()
    audioRecorder?.record()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "stopRecording"{
      let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
      let data: RecordedAudio = sender as! RecordedAudio
      playSoundsVC.receivedAudio = data
    }
  }
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
    if(flag){
      recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
      self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    } else {
      print("Recording was not successfull")
      recordingLabel.attributedText = NSAttributedString(string: "Recording was not successfull", attributes: [NSForegroundColorAttributeName:UIColor.redColor()])
      recordingLabel.hidden = false
      recordButton.enabled = true
      stopButton.hidden = true
    }
  }
  
}
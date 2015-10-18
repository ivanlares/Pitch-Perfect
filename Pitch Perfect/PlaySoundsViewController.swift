//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by ivan lares on 11/22/14.
//  Copyright (c) 2014 ivan. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
  
  var audioPlayer: AVAudioPlayer!
  var receivedAudio: RecordedAudio!
  var audioEngine: AVAudioEngine!
  var audioFile:AVAudioFile!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    do {
      audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
    } catch let error as NSError{
      print(error.localizedDescription)
    }
    audioPlayer.enableRate = true
    audioEngine = AVAudioEngine()
    do {
      audioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl)
    } catch let error as NSError {
      print(error.localizedDescription)
    }
    
  }
  
  @IBAction func playSoundSlow(sender: UIButton) {
    audioEngine.stop()
    audioEngine.reset()
    audioPlayer.stop()
    audioPlayer.rate = 0.5
    audioPlayer.currentTime = 0.0
    audioPlayer.play()
  }

  @IBAction func playSoundFast(sender: UIButton) {
    audioEngine.stop()
    audioEngine.reset()
    audioPlayer.stop()
    audioPlayer.rate = 1.5
    audioPlayer.currentTime = 0.0
    audioPlayer.play()
  }
  
  @IBAction func playChipmunkAudio(sender: UIButton) {
    playAudioWithVariablePitch(1000)
  }
  
  @IBAction func playDarthvaderAudio(sender: UIButton) {
    playAudioWithVariablePitch(-1000)
  }
  
  @IBAction func stopAllSounds(sender: UIButton) {
    if audioPlayer.playing == true {
      audioPlayer.stop()
    } else {
      audioEngine.stop()
    }
  }
  
  func playAudioWithVariablePitch(pitch: Float){
    audioPlayer.stop()
    audioEngine.stop()
    audioEngine.reset()
    let audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attachNode(audioPlayerNode)
    let changePitchEffect = AVAudioUnitTimePitch()
    changePitchEffect.pitch = pitch
    audioEngine.attachNode(changePitchEffect)
    audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
    audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    do {
      try audioEngine.start()
    } catch let error as NSError {
      print(error.localizedDescription)
    }
    audioPlayerNode.play()
  }
}

//
//  SoundVC.swift
//  Sound Board
//
//  Created by YAUHENI IVANIUK on 11/4/16.
//  Copyright © 2016 be connected club. All rights reserved.
//

import UIKit
import AVFoundation

class SoundVC: UIViewController {
    
    
    @IBOutlet weak var recordBtnOutlet: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var playBtnOutlet: UIButton!

    @IBOutlet weak var addBtnOutlet: UIButton!
    
    
    var audioRecorderr: AVAudioRecorder?
    var audioPlayer:  AVAudioPlayer?
    var audioURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecorder()
        playBtnOutlet.isEnabled = false
        addBtnOutlet.isEnabled = false
        
    
    }
    
    func setupRecorder() {
        do {
            // Create an audio sission
            
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            // Create URL for the audio
            
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            
            // Create settings for the audio recorder
            
            var settings: [String:Any] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            // Create AudioRecorder object
            
            audioRecorderr = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorderr!.prepareToRecord()
        
        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func recordBtn(_ sender: Any) {
        
        if audioRecorderr!.isRecording {
            // Stop to recording
            audioRecorderr?.stop()
            
            // Change button title to record
            recordBtnOutlet.setTitle("Record", for: .normal)
            
            playBtnOutlet.isEnabled = true
            addBtnOutlet.isEnabled = true
            
        } else {
            // Start the recording
            audioRecorderr?.record()
            
            // Change button title to stop
            recordBtnOutlet.setTitle("Stop", for: .normal)
            
        }
        
    }
    
    @IBAction func playBtn(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch {
            
        }
    }
    
    @IBAction func addBtn(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
    }
    
}

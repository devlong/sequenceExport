//
//  SequenceExport.swift
//  Beat
//
//  Created by long on 8/2/21.
//  Copyright © 2021 admaster. All rights reserved.
//

import UIKit
import AudioKit
import AVFoundation

class SequenceExport: NSObject {
    static let shared = SequenceExport.init()
    private override init(){}
    
    var mixer = Mixer();
    var sequencer : AppleSequencer?
    var engine  = AudioEngine()
    var currentMidiSample:MIDISampler?
    var track : MusicTrackManager?
    
    func setCurrentSequencer() {

        let instrumentName = "edm-kit"
        currentMidiSample = MIDISampler.init(name: instrumentName)
        engine.output = currentMidiSample;
        
        
        do {
            try engine.start()
        } catch {
            Log("AudioKit did not start \(error)")
        }

        let directory = "Sounds/\(instrumentName)"
        let resetPath = Bundle.main.path(forResource:instrumentName, ofType: "aupreset", inDirectory: directory)
        do{
            try currentMidiSample!.loadPath(resetPath!)
        }catch let error  {
            print("************load resetPath error!!!!!!:\(error)")
        }

        sequencer = AppleSequencer(filename: "tracks")

        track = sequencer!.newTrack()
        for index in 0...4 {
            track!.add(
                 noteNumber:MIDINoteNumber(5+index),
                 velocity: 100, //调节单个音符声音
                position: Duration.init(beats: Double(index)),
                duration: Duration.init(seconds: 0.5))
        }
        sequencer!.setGlobalMIDIOutput(currentMidiSample!.midiIn)
        sequencer!.setTempo(120)
        sequencer!.setLength(Duration.init(beats: 4))
        sequencer!.enableLooping()
        sequencer!.play()
    }
    
    
    
    func exportM4a() {

        guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("audio_file_new.m4a") else { return }
        
        print("outputURL !!!!!!:\(outputURL)")
        
        guard let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 44100, channels: 0, interleaved: true) else {
            fatalError("Failed to create format")
        }
        let file = try! AVAudioFile(forWriting: outputURL, settings: format.settings)
        do{
            try engine.renderToFile(file, maximumFrameCount: 1_096, duration: 5) {
                self.sequencer!.play()
            } progress: { progress in
//                print("progress !!!!!!:\(progress)")
            }
        }catch  let error  {
            print("export !!!!!!:\(error)")
        }
        
    }
}

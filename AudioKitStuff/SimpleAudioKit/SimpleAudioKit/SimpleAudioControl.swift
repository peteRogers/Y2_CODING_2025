//
//  SimpleAudioControl.swift
//  AudioKit_Sampler
//
//  Created by Peter Rogers on 21/10/2025.
//

import AudioKit
import AudioKitEX
import AVFoundation
import SoundpipeAudioKit
import DunneAudioKit
import Observation


@Observable
final class SimpleAudioControl {
    private let engine = AudioEngine()
    private let mixer = Mixer()
    private let player = AudioPlayer()
    private var reverb:ZitaReverb?
    private var chorus: Chorus?
    
    

    func setup() {
        print("restarting audio engine")
        do {
            let url = Bundle.main.url(forResource: "tropBird", withExtension: "wav")
            try player.load(url: url!, buffered: true)
            player.isLooping = true
            reverb = ZitaReverb(player)
            reverb?.dryWetMix = 0
            chorus = Chorus(reverb!)
            chorus?.dryWetMix = 0
            chorus?.depth = 1
            chorus?.frequency = 5.0
            mixer.addInput(chorus!)
            engine.output = mixer
            freopen("/dev/null", "w", stderr)
            try engine.start()
            print("🎧 Engine started.")
        } catch {
            print("❌ Failed to start engine: \(error)")
        }
    }

    func play() {
        print("trying to play")
        player.stop()
        player.play()
        
    }

    func stop() {
       print("trying to stop")
       player.stop()
    }
    
    func setVolume(value: Float) {
        player.volume = AUValue(value)
      
    }
    
    func setReverbMix(value: Float) {
        guard let reverb = reverb else { return } // <-- prevent invalid parameter call
        reverb.dryWetMix = value
    }
    
    func setChorusMix(value: Float) {
        guard let chorus = chorus else { return } // <-- prevent invalid parameter call
        chorus.dryWetMix = value
    }
    
    func stopEngine() {
        engine.stop()
        print("🛑 Engine stopped.")
    }
}

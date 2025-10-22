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

    func setup() {
        print("restarting audio engine")
        do {
            let url = Bundle.main.url(forResource: "crow", withExtension: "wav")
            try player.load(url: url!, buffered: true)
            player.isLooping = true
            reverb = ZitaReverb(player)
            reverb?.dryWetMix = 0
            mixer.addInput(reverb!)
            engine.output = mixer
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

    func stopEngine() {
        engine.stop()
        print("🛑 Engine stopped.")
    }
}

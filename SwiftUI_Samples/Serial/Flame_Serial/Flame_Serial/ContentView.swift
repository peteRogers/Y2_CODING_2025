//
//  ContentView.swift
//  Flame_Serial
//
//  Created by Peter Rogers on 17/10/2025.
//

import SwiftUI

struct FlameControlPanel: View {
    @Binding var v1: Float
    @Binding var v2: Float
    var serial: SerialManager
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("v1: \(v1, specifier: "%.2f")")
                    .foregroundStyle(.white).padding(10)
                Slider(value: $v1, in: 0.0...0.3)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
            }
            .background(
                Color.white.opacity(0.6)
                    .cornerRadius(10)
            )
            
            VStack(alignment: .leading) {
                Text("v2: \(v2, specifier: "%.2f")")
                    .foregroundStyle(.white).padding(10)
                Slider(value: $v2, in: 0.0...0.6)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
            }
            .background(
                Color.white.opacity(0.6)
                    .cornerRadius(10)
            )
            
            HStack {
                Text("Serial \(serial.lastLine)")
                    .foregroundStyle(.white)
                Spacer()
            }
        }
        .frame(width: 400)
    }
}

struct ContentView: View {
   
    // @Bindable var serial: SerialManager
    var serial: SerialManager

    private let date = Date()
    @State var v1:Float = 0.26
    @State var v2:Float = 0.60
    @State var showPanel:Bool = false
    var body: some View {
        ZStack{
            
            Color.black.ignoresSafeArea()
            
            TimelineView(.animation) { timeline in
                let time = date.timeIntervalSince1970 - timeline.date.timeIntervalSince1970
                
                Rectangle()
                    .colorEffect(
                        ShaderLibrary.candleFlame(
                            .boundingRect,
                            .float(time),
                            .float(0.02),//bloom
                            .float2(0.07, 0.1),//hoz and vert flutter
                            .float3((v1), v2, (try? serial.mapRange(index: 0, inMin: 0, inMax: 1000, outMin: 0.3, outMax: 0.0)) ?? 0.0),
                            .float((try? serial.mapRange(index: 0, inMin: 0, inMax: 1000, outMin: 1.5, outMax: 0)) ?? 0.0)
                            
                        )
                    )
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)
                // .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            if(showPanel){
                HStack {
                    FlameControlPanel(v1: $v1, v2: $v2, serial: serial)
                    Spacer()
                }
                .padding(50)
            }
        }
    }
}

#Preview {
    ContentView(serial: MockSerialManager())
}

//
//  RKTemplateView.swift
//  RealityView
//
//  Created by Peter Rogers on 21/10/2025.
//

import SwiftUI
import RealityKit

struct ObjectView: View {
    @State var posY:Float = 2.0
    @State private var cameraEntity: PerspectiveCamera?
    @State private var modelEntity: ModelEntity?
    @State private var rotationAngle: Float = 0.0
    @State private var rotSpeed: Float = 0.0
    
    var body: some View {
        ZStack{
            RealityView { content in
                let anchor = AnchorEntity(world: .init(1))
                content.add(anchor)
                let camera = PerspectiveCamera()
                camera.position = [0, posY, 3]
                camera.look(at: [0, 0, 0], from: camera.position, relativeTo: nil)
                anchor.addChild(camera)
                cameraEntity = camera
                if let model = try? await ModelEntity(named: "shell-full") {
                    model.scale = [50, 50, 50]
                    model.position = [0, 0, 0]
                    anchor.addChild(model)
                    modelEntity = model   // ✅ store the reference
                    DispatchQueue.main.async {
                        Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
                            rotationAngle += rotSpeed
                            if let model = modelEntity {
                                model.orientation = simd_quatf(angle: rotationAngle, axis: [0, 1, 0])
                            }
                        }
                    }
                }
            } update: { content in
                if let camera = cameraEntity {
                    camera.position = [0, posY, 3]
                    camera.look(at: [0, 0, 0], from: camera.position, relativeTo: nil)
                }
            }
            .background(Color.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack{
                Spacer()
                Slider(value: $posY, in: -4...4)
                    .padding(.horizontal, 100)
                    .padding(.bottom, 20)
                Slider(value: $rotSpeed, in: -0.1...0.1)
                    .padding(.horizontal, 100)
                    .padding(.bottom, 50)
                
            }
        }.ignoresSafeArea()
    }
}

#Preview { ObjectView() }

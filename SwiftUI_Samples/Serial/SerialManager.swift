import Foundation
import SwiftUI

enum SerialManagerError: Error {
    case noValueAtIndex
}

@MainActor
@Observable
class SerialManager {
    // MARK: - Public properties
    var availablePorts: [String] = []
    var connectedPort: String?
    var isConnected: Bool { handle != nil }
    var receivedText: String = ""
    var lastLine: String = ""
    var latestValueFromArduino: String = ""
    var latestValuesFromArduino: [Float] = []   // Stores values as array of Floats
    var errorMessage: String?
    
    // MARK: - Private properties
    private var handle: FileHandle?
    private var readerTask: Task<Void, Never>?
    
    // MARK: - Port management
    init() {
        refreshPorts()
        if let lastPort = availablePorts.last {
            connect(to: lastPort)
        }
    }
    
    deinit {
        let disconnectCopy = self.disconnect
        Task.detached { @MainActor in
            print("💀 SerialManager deinitialized — closing connection.")
            disconnectCopy()
        }
    }
    
    func refreshPorts() {
        // macOS serial ports are usually under /dev/cu.*
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: "/dev")
            availablePorts = contents
                .filter { $0.hasPrefix("cu.") }
                .map { "/dev/" + $0 }
                .sorted()
        } catch {
            errorMessage = "Could not list serial ports: \(error.localizedDescription)"
        }
    }
    
    func connect(to path: String, baudRate: Int = 9600) {
        print("🔧 Attempting connection to \(path)...")
        
        // Prevent multiple connections
        if isConnected {
            print("⚠️ Already connected to \(connectedPort ?? path), skipping reconnect.")
            return
        }
        
        print("🔌 Disconnecting any previous connection before reconnect...")
        disconnect()
        
        let file = FileHandle(forUpdatingAtPath: path)
        guard let file else {
            errorMessage = "Failed to open \(path)"
            print("❌ Could not open \(path)")
            return
        }
        
        handle = file
        connectedPort = path
        print("✅ Connected to \(path), waiting for Arduino to reset...")
        
        // Wait briefly for Arduino reset before reading
        Task {
            try? await Task.sleep(for: .seconds(1))
            self.startReading()
        }
    }
    
    func disconnect() {
        print("🔻 Disconnect called — closing serial port.")
        readerTask?.cancel()
        readerTask = nil
        try? handle?.close()
        handle = nil
        connectedPort = nil
    }
    
    // MARK: - Reading and writing
    
    private func startReading() {
        guard readerTask == nil else {
            print("⚠️ Already reading — skipping new task")
            return
        }
        guard let handle else { return }
        
        print("🚀 Starting serial read loop...")
        
        readerTask = Task { [weak self] in
            guard let self else { return }
            
            var buffer = Data()
            let newline: UInt8 = 10 // '\n'
            
            do {
                for try await chunk in handle.bytes {
                    buffer.append(chunk)
                    
                    while let newlineIndex = buffer.firstIndex(of: newline) {
                        let lineData = buffer[..<newlineIndex]
                        buffer.removeSubrange(..<buffer.index(after: newlineIndex))
                        
                        if let line = String(data: lineData, encoding: .utf8)?
                            .trimmingCharacters(in: .whitespacesAndNewlines),
                           !line.isEmpty {
                            await MainActor.run {
                                self.receivedText += line + "\n"
                                self.lastLine = line
                                // 💡 Detect and share Arduino values
                                if line.contains("V") && line.contains(":") {
                                    // Parse multiple values, e.g. VAL1:20>VAL2:30
                                    let pairs = line.split(separator: ">")
                                    var values: [Float] = []
                                    for pair in pairs {
                                        let parts = pair.split(separator: ":")
                                        if parts.count == 2,
                                           let value = Float(parts[1]) {
                                            values.append(value)
                                        }
                                    }
                                    self.latestValuesFromArduino = values
                                    print("📡 Updated values from Arduino: \(self.latestValuesFromArduino)")
                                    // Optionally set the first as latestValueFromArduino for compatibility:
                                    self.latestValueFromArduino = values.first.map { String($0) } ?? ""
                                }
                                // self.commandHandler?.handleCommand(line)
                            }
                        }
                    }
                    
                    if buffer.count > 4096 {
                        print("⚠️ Discarding oversized buffer of \(buffer.count) bytes")
                        buffer.removeAll()
                    }
                }
                
                print("🛑 Serial stream ended.")
            } catch {
                await MainActor.run {
                    self.errorMessage = "Read error: \(error.localizedDescription)"
                }
                print("❌ Serial read error: \(error.localizedDescription)")
            }
            
            await MainActor.run {
                self.readerTask = nil
                print("🔚 Reader task cleaned up.")
            }
        }
    }
    
    func send(_ string: String) {
        guard let handle else { return }
        guard let data = (string + "\n").data(using: .utf8) else { return }
        do {
            try handle.write(contentsOf: data)
        } catch {
            errorMessage = "Write failed: \(error.localizedDescription)"
        }
    }
    
    // Map using value at given index in latestValuesFromArduino, throws if missing
    func mapRange(index: Int, inMin: Float, inMax: Float, outMin: Float, outMax: Float) throws -> Float {
        guard latestValuesFromArduino.indices.contains(index) else {
            throw SerialManagerError.noValueAtIndex
        }
        let value = latestValuesFromArduino[index]
        let clampedValue = min(max(value, inMin), inMax)
        let inRange = inMax - inMin
        let outRange = outMax - outMin
        let scaled = (clampedValue - inMin) / inRange
        return outMin + (scaled * outRange)
    }
    
    // Optionally keep the old function for direct mapping
    func mapRange(value: Float, inMin: Float, inMax: Float, outMin: Float, outMax: Float) -> Float {
        let clampedValue = min(max(value, inMin), inMax)
        let inRange = inMax - inMin
        let outRange = outMax - outMin
        let scaled = (clampedValue - inMin) / inRange
        return outMin + (scaled * outRange)
    }
}


@MainActor
@Observable
final class MockSerialManager: SerialManager {
    var x = 0
    var inc = 1
    override init() {
        super.init()
        simulateIncomingValues()
    }
    
    func simulateIncomingValues() {
        Task {
            while true {
                try? await Task.sleep(for: .seconds(0.005))
                x+=inc
                if(x > 5000 || x < -5000){
                    inc = inc * -5
                }
                self.latestValueFromArduino = String(x)
                // Also update the array for simulation:
                self.latestValuesFromArduino = [Float(x)]
            }
        }
    }
}
        
        


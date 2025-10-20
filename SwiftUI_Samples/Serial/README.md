# 🌀 Serial Connection 

**`Serial Manager`** is a Swift class that you can add to your app to allow for serial connections in your SwiftUI app. It uses @observable to bind data to your swiftUI views


---

## ✨ Adding to code
For a single point of truth, it’s best to create the SerialManager in the app’s entry point so it’s initialized once and accessible to all views.
```swift
    import SwiftUI
@main
struct YourApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var serial = SerialManager()
    //@State private var serial = MockSerialManager()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(serial: serial)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background || newPhase == .inactive {
                print("🛑 App moving to background — closing serial.")
                serial.disconnect()
            }
        }
    }
}
```

---

## ⚙️ Parameters

| Parameter | Type | Description |
|------------|------|-------------|
| **`text`** | `String` | The text to display. Can be multiline — automatically wraps to fit the column width. |
| **`amplitude`** | `CGFloat` | Vertical displacement of the sine wave (in points). Larger values produce a stronger wobble. |
| **`frequency`** | `CGFloat` | Controls how many waves appear across the text horizontally. Higher = tighter waves. |
| **`speed`** | `CGFloat` | Speed of wave motion. Increasing makes the wave animate faster. |
| **`columnWidth`** | `CGFloat` | Fixed width (in points) of the column; text wraps automatically at this width. |
| **`fontSize`** | `CGFloat` | Size of the rendered text. |
| **`fillColor`** | `Color` | Color used to fill the text shapes. |

---

## 🧩 Example Usage

```swift
DistortedTextColumn(
    text: """
    This is a sample multiline text that wraps inside a fixed column width.
    It ripples and moves using a sine-wave animation.
    """ ,
    amplitude: 40,
    frequency: 0.03,
    speed: 2,
    columnWidth: 300,
    fontSize: 60,
    fillColor: .black
)
.frame(maxWidth: .infinity, maxHeight: .infinity)
.background(Color.white)
```

---

## 🪄 How It Works
`DistortedTextColumn`:
1. Uses **Core Text** to generate properly wrapped glyph paths.  
2. Applies a **time-based sine offset** to every path element via a `distortPath` function.  
3. Draws the result in a SwiftUI **Canvas** for smooth GPU rendering.  
4. Animates continuously using a `TimelineView(.animation)`.

---

## 💡 Tips
- For subtle motion, use low amplitude (10–30) and low frequency (0.01–0.03).  
- For liquid or surreal effects, increase amplitude and lower frequency.  
- Combine with gradient fills or masks for more experimental visuals.  

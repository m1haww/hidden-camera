import Foundation

struct ToolItem: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    // Add specific properties for each tool type if needed
    // For Blinking Devices Scanner
    var filterOptions: [String]?
    // For Compass Visual
    var signalDescription: String?
}

struct ToolsData: Decodable {
    let blinkingDevicesScanner: [ToolItem]
    let compassVisual: [ToolItem]
}

let toolsJsonData = """
{
  "blinkingDevicesScanner": [
    {
      "title": "Filter Options",
      "description": "Adjust sensitivity and frequency filters to isolate specific types of blinking lights.",
      "imageName": "slider.horizontal.3",
      "filterOptions": ["Low Frequency", "Medium Frequency", "High Frequency"]
    },
    {
      "title": "Repositioning Guide",
      "description": "Move your device slowly around the area, changing angles to detect concealed devices.",
      "imageName": "arrow.triangle.2.circlepath"
    },
    {
      "title": "Interference Tips",
      "description": "Minimize interference from other light sources for accurate scanning results.",
      "imageName": "lightbulb"
    }
  ],
  "compassVisual": [
    {
      "title": "Electromagnetic Signals",
      "description": "Electronic devices emit electromagnetic fields that can be detected.",
      "imageName": "antenna.radiowaves.left.and.right"
    },
    {
      "title": "Signal Strength Indicator",
      "description": "The visual compass will indicate the direction and relative strength of detected signals.",
      "imageName": "chart.bar.fill"
    },
    {
      "title": "Usage Tips",
      "description": "Hold the device steady and move slowly to pinpoint signal sources.",
      "imageName": "hand.point.up.braille"
    }
  ]
}
""" 
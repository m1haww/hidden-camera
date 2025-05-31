import Foundation

struct GuideItem: Identifiable, Decodable {
    var id = UUID()
    let title: String
    let description: String
    let imageName: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        imageName = try container.decode(String.self, forKey: .imageName)
        id = UUID()
    }
}

struct GuideData: Decodable {
    let indoor: [GuideItem]
    let outdoor: [GuideItem]
}

let jsonData = """
{
  "indoor": [
    {
      "title": "Common Household Objects",
      "description": "Look for devices hidden in everyday items like clocks, smoke detectors, and power adapters.",
      "imageName": "house.fill"
    },
    {
      "title": "Furniture and Decor",
      "description": "Check inside cushions, behind mirrors, and within decorative items.",
      "imageName": "couch.fill"
    },
    {
      "title": "Electronics",
      "description": "Examine TVs, gaming consoles, computers, and other electronic devices for added components.",
      "imageName": "tv.fill"
    },
    {
      "title": "Vents and Fixtures",
      "description": "Inspect air vents, light fixtures, and electrical outlets.",
      "imageName": "fan.and.wifitoolbar"
    },
    {
      "title": "Toys and Stuffed Animals",
      "description": "Some devices can be hidden inside children's toys.",
      "imageName": "figure.seated.child"
    }
  ],
  "outdoor": [
    {
      "title": "Trees and Bushes",
      "description": "Watch for wires or strange objects in the foliage. Cameras could be hidden among the branches or leaves",
      "imageName": "tree.fill"
    },
    {
      "title": "Outdoor Furniture",
      "description": "Look over chairs, tables, and other outdoor pieces carefully. Hidden cameras might be placed in cushions, legs, or beneath surfaces",
      "imageName": "chair.fill"
    },
    {
      "title": "Garden Decorations",
      "description": "Statues, gnomes, and decorative items often have intricate details and varied construction. Observing these features can give insight into their design.",
      "imageName": "leaf.fill"
    },
    {
      "title": "Garage Doors and Eaves",
      "description": "Pay attention to small openings or reflective surfaces in various areas, as these are common design features in many devices.",
      "imageName": "door.garage.open.right.fill"
    },
    {
      "title": "Mailboxes",
      "description": "Observe the inside and exterior of mailboxes for design features or components that may be part of their construction.",
      "imageName": "envelope.fill"
    }
  ]
}
""" 

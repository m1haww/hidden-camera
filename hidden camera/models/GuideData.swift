import Foundation

struct GuideItem: Identifiable, Decodable {
    var id = UUID()
    let title: String
    let description: String
    let imageName: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageName
        case content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        imageName = try container.decode(String.self, forKey: .imageName)
        content = try container.decode(String.self, forKey: .content)
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
      "description": "Learn about common household items and their typical electronic components.",
      "imageName": "house.fill",
      "content": "Common household objects often contain electronic components as part of their normal functionality. Understanding these can help with general awareness:\\n\\n• Digital Clocks: Modern clocks contain LCD displays, circuit boards, and sometimes wireless receivers for time synchronization. They typically have small openings for sound or sensors.\\n\\n• Smoke Detectors: These safety devices contain photoelectric or ionization sensors, alarm speakers, and test buttons. They're required by law in most jurisdictions and should be tested regularly.\\n\\n• Power Adapters and USB Chargers: These convert AC power to DC and contain transformers, rectifiers, and voltage regulators. Quality chargers have safety certifications printed on them.\\n\\n• Air Fresheners: Electronic air fresheners use timers, fans, or heating elements to disperse fragrance. They may have LED indicators and controls for intensity settings.\\n\\n• Picture Frames: Digital frames contain LCD screens, memory card readers, and control buttons. They're designed to display rotating photo collections.\\n\\nGeneral Tips:\\n- Understand the normal functions of household electronics\\n- Check product manuals for feature explanations\\n- Learn about standard electronic components\\n- Be aware of your home's electronic ecosystem"
    },
    {
      "title": "Furniture and Decor",
      "description": "Explore furniture construction and common decorative elements in homes.",
      "imageName": "sofa.fill",
      "content": "Furniture and home decor come in many forms and understanding their construction can be educational:\\n\\n• Mirrors: Standard mirrors consist of glass with a reflective coating on the back. Antique mirrors may have silver backing, while modern ones use aluminum. The fingernail test can distinguish mirror types.\\n\\n• Decorative Items: Vases, sculptures, and ornaments are made from various materials like ceramic, glass, metal, or resin. Each material has different properties affecting weight and appearance.\\n\\n• Cushions and Pillows: These contain various fill materials like foam, feathers, or synthetic fibers. Quality items have durable covers and even fill distribution.\\n\\n• Books and Bookshelves: Books vary in size and weight based on page count and paper quality. Decorative books are sometimes used purely for aesthetic purposes.\\n\\n• Wall Decorations: Paintings and prints are mounted on various backings. Canvas prints stretch over wooden frames, while posters may use lightweight materials.\\n\\n• Lamps and Light Fixtures: These contain electrical components including sockets, switches, and wiring. Modern lamps may include USB ports or wireless charging pads.\\n\\nHome Decor Knowledge:\\n- Learn about different furniture materials\\n- Understand basic furniture construction\\n- Recognize quality craftsmanship\\n- Know standard furniture dimensions\\n- Appreciate design elements and styles"
    },
    {
      "title": "Electronics",
      "description": "Understand the components and features of common electronic devices.",
      "imageName": "tv.fill",
      "content": "Modern electronics contain various components and understanding them helps with general tech literacy:\\n\\n• Televisions and Monitors: Smart TVs include processors, memory, network interfaces, and various sensors for features like voice control or ambient light adjustment. They have ventilation slots for cooling.\\n\\n• Cable/Satellite Boxes: These decode broadcast signals and contain tuners, processors, and storage for recording. They connect to TVs via HDMI or component cables.\\n\\n• Gaming Consoles: Modern consoles are sophisticated computers with GPUs, cooling systems, and various wireless technologies. Motion sensors use infrared or visual tracking.\\n\\n• Computers and Webcams: Laptops integrate webcams for video calls. Desktop users often add external webcams. Privacy shutters are becoming standard features.\\n\\n• Speakers and Sound Systems: These contain amplifiers, drivers, and increasingly, smart assistants with microphones for voice commands. Bluetooth speakers include batteries and wireless chips.\\n\\n• Routers and Modems: Network equipment processes data traffic and includes antennas for WiFi. Modern routers have multiple bands and advanced security features.\\n\\nElectronics Knowledge:\\n- Understand basic electronic components\\n- Learn about standard device features\\n- Recognize normal operating temperatures\\n- Know typical cable connections\\n- Understand LED indicator meanings\\n\\nBest Practices:\\n- Read device manuals thoroughly\\n- Keep firmware updated\\n- Use privacy settings appropriately\\n- Maintain devices properly"
    },
    {
      "title": "Vents and Fixtures",
      "description": "Learn about home infrastructure and common fixture types.",
      "imageName": "fan.desk",
      "content": "Home infrastructure includes various fixtures and systems essential for comfort and functionality:\\n\\n• Air Vents and Grilles: HVAC systems distribute heated or cooled air through ducts and vents. Proper ventilation is crucial for air quality and temperature control.\\n\\n• Ceiling Light Fixtures: Overhead lighting comes in many styles including flush mount, pendant, and recessed. Modern fixtures may include dimming capabilities or smart controls.\\n\\n• Electrical Outlets: Standard outlets in the US provide 120V power. GFCI outlets in bathrooms and kitchens provide shock protection. USB outlets are increasingly common.\\n\\n• Switch Plates: Light switches control circuits and come in various types: toggle, rocker, dimmer, and smart switches. Three-way switches control lights from multiple locations.\\n\\n• Ceiling Fans: These improve air circulation and can reduce energy costs. Modern fans include remote controls and reversible motors for seasonal use.\\n\\n• Bathroom Fixtures: Exhaust fans remove moisture to prevent mold. Heated towel rails provide comfort. Modern showerheads offer various spray patterns and water-saving features.\\n\\nHome Maintenance Tips:\\n- Clean vents regularly for efficiency\\n- Test GFCI outlets monthly\\n- Replace light bulbs with appropriate wattage\\n- Ensure exhaust fans vent outside\\n- Check fixtures for secure mounting\\n\\nUnderstanding Your Home:\\n- Know your electrical panel layout\\n- Understand HVAC system basics\\n- Learn about energy efficiency\\n- Regular maintenance prevents issues"
    },
    {
      "title": "Toys and Stuffed Animals",
      "description": "Explore the technology and safety features in modern toys.",
      "imageName": "figure.stand",
      "content": "Modern toys incorporate various technologies and safety features worth understanding:\\n\\n• Stuffed Animals: Quality plush toys use hypoallergenic materials and meet safety standards. Eyes and noses are typically embroidered or securely attached plastic pieces.\\n\\n• Electronic Toys: Interactive toys may include speakers, LED lights, sensors, and educational programming. They often feature volume controls and automatic shut-off for battery conservation.\\n\\n• Dolls and Action Figures: Modern toys may include articulation points, sound effects, or interactive features. Safety standards ensure small parts are appropriate for age groups.\\n\\n• Building Blocks and Models: Construction toys develop spatial skills and creativity. Electronic versions may include motors, lights, or programmable elements for STEM learning.\\n\\n• Board Games and Puzzles: Classic games promote social skills and strategic thinking. Modern versions may include app integration or electronic components for enhanced gameplay.\\n\\n• Baby Monitors: These essential safety devices use secure encrypted signals. Features include two-way audio, temperature sensors, and night vision for infant safety.\\n\\nToy Safety Knowledge:\\n- Check age recommendations\\n- Look for safety certification marks\\n- Understand battery safety\\n- Know recall information sources\\n- Regular toy maintenance\\n\\nSmart Toy Features:\\n- Educational content delivery\\n- Progress tracking for learning\\n- Parental control options\\n- Safe online interactions\\n- Age-appropriate challenges"
    }
  ],
  "outdoor": [
    {
      "title": "Trees and Bushes",
      "description": "Learn about outdoor landscaping elements and natural features.",
      "imageName": "tree.fill",
      "content": "Understanding outdoor landscaping helps appreciate your property's natural features:\\n\\n• Tree Branches: Trees provide shade, privacy, and habitat for wildlife. Different species have unique growth patterns and seasonal changes. Proper pruning maintains health and appearance.\\n\\n• Hollow Trees: Natural cavities in older trees provide homes for birds, squirrels, and other wildlife. These ecological features should be preserved when safe.\\n\\n• Dense Bushes: Shrubs offer privacy screening, wind protection, and aesthetic appeal. Native species require less maintenance and support local ecosystems.\\n\\n• Garden Features: Trellises, arbors, and plant supports help maximize growing space. Materials range from natural wood to weather-resistant metals.\\n\\n• Bird Houses and Feeders: These attract beneficial wildlife to your garden. Proper placement and maintenance ensures they serve their intended purpose effectively.\\n\\n• Garden Stakes: Decorative elements and plant markers help organize and beautify gardens. Solar-powered versions provide gentle nighttime illumination.\\n\\nLandscaping Knowledge:\\n- Understand plant growth patterns\\n- Learn about native species\\n- Know seasonal maintenance needs\\n- Recognize signs of plant health\\n- Plan for wildlife habitat\\n\\nGarden Planning:\\n- Consider sunlight patterns\\n- Account for mature plant sizes\\n- Plan efficient irrigation\\n- Create visual interest\\n- Support local ecosystems"
    },
    {
      "title": "Outdoor Furniture",
      "description": "Discover outdoor furniture materials and maintenance considerations.",
      "imageName": "chair.fill",
      "content": "Outdoor furniture comes in various materials and styles, each with unique characteristics:\\n\\n• Chair and Table Legs: Materials include aluminum, steel, teak, and resin. Hollow legs reduce weight while maintaining strength. End caps protect floors and prevent water entry.\\n\\n• Cushions and Pillows: Outdoor fabrics resist fading, mildew, and water. Quality cushions use quick-dry foam and have zippered covers for washing.\\n\\n• Umbrella Poles and Bases: Market umbrellas provide shade and UV protection. Bases must be properly weighted for stability. Crank mechanisms allow easy opening and tilting.\\n\\n• Table Surfaces: Materials range from tempered glass to natural stone, each requiring specific care. Some tables include built-in lazy Susans or ice buckets.\\n\\n• Construction Details: Quality furniture uses stainless steel hardware to prevent rust. Joints should be welded or properly reinforced for durability.\\n\\n• Built-in Features: Modern outdoor furniture may include fire pits with safety features, built-in coolers with drainage, or storage compartments for cushions.\\n\\nFurniture Care:\\n- Clean regularly with appropriate products\\n- Store or cover during harsh weather\\n- Tighten hardware periodically\\n- Apply protective treatments as needed\\n- Check weight limits and stability\\n\\nSelection Tips:\\n- Consider climate and usage\\n- Choose appropriate materials\\n- Measure space before purchasing\\n- Plan for storage needs\\n- Invest in quality for longevity"
    },
    {
      "title": "Garden Decorations",
      "description": "Statues, gnomes, and decorative items often have intricate details and varied construction. Observing these features can give insight into their design.",
      "imageName": "leaf.fill",
      "content": "Garden decorations add personality and visual interest to outdoor spaces:\\n\\n• Garden Statues: Available in materials like concrete, resin, metal, or ceramic. Classical figures, animals, and abstract designs create focal points in landscaping.\\n\\n• Garden Gnomes: These whimsical decorations have a long tradition. Modern versions may include solar lights or be made from weather-resistant materials.\\n\\n• Decorative Rocks: Natural and artificial rocks serve as landscape accents. Some hollow versions hide spare keys or irrigation controls.\\n\\n• Water Features: Fountains and birdbaths attract wildlife while providing soothing sounds. Solar-powered pumps eliminate the need for electrical connections.\\n\\n• Solar Lights: Path lighting improves safety and ambiance. Modern solar technology provides reliable illumination with automatic dusk-to-dawn operation.\\n\\n• Wind Chimes and Spinners: These kinetic decorations add movement and sound to gardens. Materials range from bamboo to metal, each producing unique tones.\\n\\nDecoration Tips:\\n- Choose weather-appropriate materials\\n- Consider scale relative to space\\n- Create visual balance\\n- Group items for impact\\n- Plan for seasonal changes\\n\\nMaintenance Advice:\\n- Clean decorations seasonally\\n- Check stability after storms\\n- Replace solar batteries as needed\\n- Protect delicate items in winter\\n- Refresh arrangements periodically"
    },
    {
      "title": "Garage Doors and Eaves",
      "description": "Understand garage and exterior home features and their maintenance.",
      "imageName": "door.garage.double.bay.closed.trianglebadge.exclamationmark",
      "content": "Understanding your home's exterior features helps with maintenance and improvements:\\n\\n• Garage Door Frames: Proper weatherstripping prevents drafts and pests. Frames should be checked annually for rot, damage, or gaps that affect insulation.\\n\\n• Eaves and Soffits: These protect walls from rain and provide attic ventilation. Regular cleaning prevents pest infestations and ensures proper airflow.\\n\\n• Downspouts and Gutters: Proper drainage protects foundations from water damage. Clean gutters twice yearly and ensure downspouts direct water away from the house.\\n\\n• Exterior Light Fixtures: Outdoor lighting enhances safety and curb appeal. Motion sensors, timers, and smart controls add convenience and energy efficiency.\\n\\n• Garage Windows: These provide natural light and ventilation. Frosted or decorative glass offers privacy while maintaining brightness.\\n\\n• Ventilation Openings: Proper ventilation prevents moisture buildup and extends roof life. Ensure vents remain unobstructed and properly screened.\\n\\nMaintenance Schedule:\\n- Inspect weatherstripping annually\\n- Clean gutters spring and fall\\n- Check exterior lights monthly\\n- Examine soffits for damage\\n- Test garage door safety features\\n\\nHome Improvement Ideas:\\n- Upgrade to LED lighting\\n- Install gutter guards\\n- Add decorative trim details\\n- Improve garage organization\\n- Enhance curb appeal"
    },
    {
      "title": "Mailboxes",
      "description": "Learn about mailbox types and postal service requirements.",
      "imageName": "envelope.fill",
      "content": "Mailboxes serve as the connection point between homes and postal services:\\n\\n• Mailbox Interior: USPS-approved mailboxes meet specific size requirements. Interior dimensions accommodate standard mail and small packages. Some include mail indicators.\\n\\n• Mailbox Posts: Posts must be sturdy and positioned at regulation height (41-45 inches). Materials include wood, metal, or decorative stone/brick structures.\\n\\n• Decorative Mailbox Surrounds: Enhance curb appeal while meeting postal regulations. These structures often include planting areas or address displays.\\n\\n• Newspaper Boxes: Separate receptacles keep publications dry. Many homeowners now use them for package deliveries from various carriers.\\n\\n• Address Markers: Clear, visible house numbers are required by emergency services. Reflective numbers improve nighttime visibility for deliveries and first responders.\\n\\n• Package Drop Boxes: Secure delivery solutions have become popular with increased online shopping. Some feature electronic locks or notification systems.\\n\\nPostal Regulations:\\n- Follow USPS placement guidelines\\n- Maintain clear access for carriers\\n- Keep numbers visible and current\\n- Repair damage promptly\\n- Clear snow and obstacles\\n\\nMailbox Enhancements:\\n- Add solar address lights\\n- Install anti-theft features\\n- Create attractive landscaping\\n- Consider package security\\n- Coordinate with neighborhood style"
    }
  ]
}
""" 
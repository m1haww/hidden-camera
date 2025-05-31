import SwiftUI

struct CompassVisualDetailView: View {
    let toolItems: [ToolItem]

    init() {
        let decoder = JSONDecoder()
        do {
            let toolsData = try decoder.decode(ToolsData.self, from: toolsJsonData.data(using: .utf8)!)
            toolItems = toolsData.compassVisual
        } catch {
            print("Failed to decode compass visual data: \(error)")
            toolItems = []
        }
    }

    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(toolItems) { item in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: item.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.customButton)

                                Text(item.title)
                                    .font(.title2)
                                    .foregroundColor(.customText)

                                Spacer()
                            }

                            Text(item.description)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(nil)

                            if let signalDescription = item.signalDescription {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Signal Description:")
                                        .font(.headline)
                                        .foregroundColor(.customText)
                                    Text(signalDescription)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 5)
                            }
                        }
                        .padding()
                        .background(Color(hex: "1c2021"))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
        .navigationTitle("Compass Visual")
        .navigationBarTitleDisplayMode(.inline)
    }
}

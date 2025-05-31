import SwiftUI

struct OutdoorGuideDetailView: View {
    let outdoorGuideItems: [GuideItem]

    init() {
        let decoder = JSONDecoder()
        do {
            let guideData = try decoder.decode(GuideData.self, from: jsonData.data(using: .utf8)!)
            outdoorGuideItems = guideData.outdoor
        } catch {
            print("Failed to decode outdoor guide data: \(error)")
            outdoorGuideItems = []
        }
    }

    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(outdoorGuideItems) { item in
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
        .navigationTitle("Outdoor Guide")
        .navigationBarTitleDisplayMode(.inline)
    }
}

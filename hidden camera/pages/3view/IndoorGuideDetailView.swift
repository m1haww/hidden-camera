import SwiftUI

struct IndoorGuideDetailView: View {
    let indoorGuideItems: [GuideItem]

    init() {
        let decoder = JSONDecoder()
        do {
            let guideData = try decoder.decode(GuideData.self, from: jsonData.data(using: .utf8)!)
            indoorGuideItems = guideData.indoor
        } catch {
            print("Failed to decode indoor guide data: \(error)")
            indoorGuideItems = [] 
        }
    }

    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 20) { // Use VStack for vertical layout
                    ForEach(indoorGuideItems) { item in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: item.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30) // Adjust size as needed
                                    .foregroundColor(.customButton)

                                Text(item.title)
                                    .font(.title2)
                                    .foregroundColor(.customText)

                                Spacer()
                            }

                            Text(item.description)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(nil) // Allow multiple lines for description
                        }
                        .padding()
                        .background(Color(hex: "1c2021")) // Background color for each item card
                        .cornerRadius(12) // Rounded corners for the item card
                    }
                }
                .padding(.horizontal) // Add horizontal padding to the VStack
                .padding(.top) // Add top padding to the VStack
            }
        }
        .navigationTitle("Indoor Guide")
        .navigationBarTitleDisplayMode(.inline)
    }
}

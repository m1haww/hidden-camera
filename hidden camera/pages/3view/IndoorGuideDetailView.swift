import SwiftUI

struct IndoorGuideDetailView: View {
    let indoorGuideItems: [GuideItem]
    @State private var selectedGuide: GuideItem?

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
                VStack(spacing: 20) {
                    ForEach(indoorGuideItems) { item in
                        Button(action: {
                            selectedGuide = item
                        }) {
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
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))
                                }

                                Text(item.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .background(Color(hex: "1c2021"))
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal) // Add horizontal padding to the VStack
                .padding(.top) // Add top padding to the VStack
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Indoor Guide")
                    .foregroundStyle(.white)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedGuide) { guide in
            NavigationView {
                GuideDetailView(guideItem: guide)
            }
        }
    }
}

import SwiftUI

struct SecondView: View {
    var body: some View {
        ZStack { // Use ZStack for main background
            Color.customBackground.edgesIgnoringSafeArea(.all) // Set custom background color for the whole view

            ScrollView { // Make content scrollable if needed
                VStack(spacing: 20) { // Arrange cards vertically
                    // Blinking Devices Scanner Card
                    NavigationLink(destination: BlinkingDevicesScannerDetailView()) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "scope") // Blinking Devices Scanner Icon (using scope as it looks similar)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.customButton)

                                Spacer()

                                Image(systemName: "arrow.up.right") // Navigation Arrow
                                    .foregroundColor(.gray)
                                    .padding(5)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                            }

                            Text("Blinking Devices Scanner")
                                .font(.title2)
                                .foregroundColor(.customText)

                            Text("Choose a filter and reposition to locate unknown flashing devices")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                        .padding()
                        .background(Color(hex: "1c2021")) // Background color for the card
                        .cornerRadius(12) // Rounded corners
                    }
                    .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove default button appearance

                    // Compass Visual Card
                    NavigationLink(destination: CompassVisualDetailView()) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "compass.drawing") // Compass Visual Icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.customButton)

                                Spacer()

                                Image(systemName: "arrow.up.right") // Navigation Arrow
                                    .foregroundColor(.gray)
                                    .padding(5)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                            }

                            Text("Compass Visual")
                                .font(.title2)
                                .foregroundColor(.customText)

                            Text("Electronic devices may emit normal electromagnetic signals.")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                        .padding()
                        .background(Color(hex: "1c2021")) // Background color for the card
                        .cornerRadius(12) // Rounded corners
                    }
                    .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove default button appearance
                }
                .padding(.horizontal) // Add horizontal padding to the VStack
                .padding(.top) // Add top padding to the VStack
            }
        }
        .navigationTitle("Tools") // Set navigation title
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { // Add toolbar items
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    // Action for clock button
                } label: {
                    Image(systemName: "clock") // Clock Icon
                        .foregroundColor(.customButton)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Action for hexagon button
                } label: {
                    Image(systemName: "hexagon.fill") // Hexagon Icon
                        .foregroundColor(.customButton)
                }
            }
        }
    }
}

#Preview {
    // Need to embed in a NavigationView for previewing navigation elements
    NavigationView {
        SecondView()
    }
} 
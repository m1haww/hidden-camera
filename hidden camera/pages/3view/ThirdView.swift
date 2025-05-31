import SwiftUI

struct ThirdView: View {
    @State private var showIndoorGuide = false
    @State private var showOutdoorGuide = false
    
    var body: some View {
        ZStack { // Use ZStack for main background
            Color.customBackground.edgesIgnoringSafeArea(.all) // Set custom background color for the whole view

            VStack(spacing: 20) {
                // Indoor Places Card
                Button {
                    showIndoorGuide = true
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            // Indoor Icon (Placeholder - replace with your asset if needed)
                            Image(systemName: "chair.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.customButton) // Apply custom color
                            
                            Spacer()
                            
                            // Navigation Arrow
                            Image(systemName: "arrow.up.right")
                                .foregroundColor(.gray)
                                .padding(5)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                        
                        Text("Indoor Places")
                            .font(.title2)
                            .foregroundColor(.customText)
                        
                        Text("Learn about common indoor objects that may contain small electronic components and explore general tips for environmental awareness.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(3)
                    }
                    .padding()
                    .background(Color(hex: "1c2021")) // Background color for the card
                    .cornerRadius(12) // Rounded corners
                }
                .buttonStyle(PlainButtonStyle()) // Remove default button styling
                
                // Outdoor Places Card
                Button {
                    showOutdoorGuide = true
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            // Outdoor Icon (Placeholder - replace with your asset if needed)
                            Image(systemName: "tree.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.customButton) // Apply custom color
                            
                            Spacer()
                            
                            // Navigation Arrow
                            Image(systemName: "arrow.up.right")
                                .foregroundColor(.gray)
                                .padding(5)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                        
                        Text("Outdoor Places")
                            .font(.title2)
                            .foregroundColor(.customText)
                        
                        Text("Surveillance devices may be concealed in outdoor areas such as trees, fences, or public fixtures. Discover typical hiding methods and how to spot these devices during your inspection")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(4)
                    }
                    .padding()
                    .background(Color(hex: "1c2021")) // Background color for the card
                    .cornerRadius(12) // Rounded corners
                }
                .buttonStyle(PlainButtonStyle()) // Remove default button styling
                
                Spacer() // Push content to the top
            }
            .padding(.horizontal)
            .padding(.top) // Add padding at the top
        }
        .navigationTitle("Guides") // Set the navigation bar title
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { // Add toolbar items (like AppBar actions)
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                } label: {
                    Image(systemName: "arrow.clockwise") // System image for refresh
                        .foregroundColor(.customButton) // Apply custom color
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "hexagon.fill") // System image for a filled hexagon
                        .foregroundColor(.customButton) // Apply custom color
                }
            }
        }
        .sheet(isPresented: $showIndoorGuide) {
            NavigationView {
                IndoorGuideDetailView()
            }
        }
        .sheet(isPresented: $showOutdoorGuide) {
            NavigationView {
                OutdoorGuideDetailView()
            }
        }
    }
}

import SwiftUI

struct FeatureCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let isPremium: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(iconColor)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(.gray)
                        .padding(5)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                
                Text(title)
                    .font(.title2)
                    .foregroundColor(.customText)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
            .padding()
            .background(Color(hex: "1c2021"))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

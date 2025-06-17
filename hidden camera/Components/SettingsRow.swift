import SwiftUI

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let iconBackgroundColor: Color
    let title: String
    let showChevron: Bool
    let action: () -> Void
    
    init(icon: String, iconColor: Color, iconBackgroundColor: Color, title: String, showChevron: Bool = true, action: @escaping () -> Void) {
        self.icon = icon
        self.iconColor = iconColor
        self.iconBackgroundColor = iconBackgroundColor
        self.title = title
        self.showChevron = showChevron
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                ZStack {
                    Circle()
                        .fill(iconBackgroundColor)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 18))
                }
                
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 10) {
        SettingsRow(
            icon: "heart.fill",
            iconColor: .red,
            iconBackgroundColor: .red.opacity(0.2),
            title: "Premium",
            action: {}
        )
        
        SettingsRow(
            icon: "square.and.arrow.up",
            iconColor: .blue,
            iconBackgroundColor: .blue.opacity(0.2),
            title: "Share App",
            action: {}
        )
    }
    .padding()
    .background(Color.black)
}
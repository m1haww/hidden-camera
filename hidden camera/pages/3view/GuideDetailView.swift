import SwiftUI

struct GuideDetailView: View {
    let guideItem: GuideItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    HStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.customButton.opacity(0.2))
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: guideItem.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.customButton)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(guideItem.title)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.customText)
                            
                            Text(guideItem.description)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 20) {
                        Text(guideItem.content)
                            .font(.system(size: 16))
                            .foregroundColor(.customText)
                            .lineSpacing(8)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Guide Details")
                    .foregroundStyle(.white)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 22))
            }
        )
    }
}

import SwiftUI

struct IndoorGuideDetailView: View {
    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)
            VStack {
                Image(systemName: "house.fill")
                    .imageScale(.large)
                    .foregroundColor(.customButton)
                Text("Indoor Guide Details")
                    .font(.title)
                    .foregroundColor(.customText)
            }
        }
        .navigationTitle("Indoor Guide")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IndoorGuideDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IndoorGuideDetailView()
        }
    }
} 
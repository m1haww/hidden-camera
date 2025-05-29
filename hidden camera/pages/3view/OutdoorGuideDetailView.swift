import SwiftUI

struct OutdoorGuideDetailView: View {
    var body: some View {
        ZStack {
            Color.customBackground.edgesIgnoringSafeArea(.all)
            VStack {
                Image(systemName: "leaf.fill")
                    .imageScale(.large)
                    .foregroundColor(.customButton)
                Text("Outdoor Guide Details")
                    .font(.title)
                    .foregroundColor(.customText)
            }
        }
        .navigationTitle("Outdoor Guide")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OutdoorGuideDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OutdoorGuideDetailView()
        }
    }
} 
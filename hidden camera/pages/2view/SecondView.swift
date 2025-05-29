import SwiftUI

struct SecondView: View {
    var body: some View {
        VStack {
            Image(systemName: "2.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.green)
            Text("Second Page")
                .font(.title)
        }
        .padding()
    }
}

#Preview {
    SecondView()
} 
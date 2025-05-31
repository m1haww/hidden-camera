import Foundation

struct IPInfo: Decodable {
    let ip: String
}

final class DeviceInfoProvider: ObservableObject {
    @Published var ipInfo: IPInfo? = nil
    @Published var error: Error? = nil
    
    static let shared = DeviceInfoProvider()
    
    private let apiURL = URL(string: "https://api.ipify.org/?format=json")!
    
    func fetchIPInfo() async {
        do {
            let (data, response) = try await URLSession.shared.data(from: apiURL)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decodedInfo = try JSONDecoder().decode(IPInfo.self, from: data)
            
            DispatchQueue.main.async {
                self.ipInfo = decodedInfo
            }
        } catch {
            print("Error fetching api info: \(error)")
            DispatchQueue.main.async {
                self.error = error
            }
        }
    }
}

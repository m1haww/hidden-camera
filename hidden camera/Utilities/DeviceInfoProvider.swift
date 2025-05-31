import Foundation

struct GeoIPInfo: Decodable {
    let query: String
    let mobile: Bool
}

final class DeviceInfoProvider: ObservableObject {
    @Published var geoIPInfo: GeoIPInfo? = nil
    @Published var error: Error? = nil
    
    static let shared = DeviceInfoProvider()
    
    func fetchIPInfo() async {
        guard let apiURL = URL(string: "http://ip-api.com/json?fields=status,message,query,country,city,mobile") else {
            print("Invalid API URL.")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: apiURL)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decodedInfo = try JSONDecoder().decode(GeoIPInfo.self, from: data)
            
            DispatchQueue.main.async {
                self.geoIPInfo = decodedInfo
            }
        } catch {
            print("Error fetching api info: \(error)")
            DispatchQueue.main.async {
                self.error = error
            }
        }
    }
}

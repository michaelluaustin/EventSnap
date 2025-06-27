import Foundation

struct OpenAIRequest: Codable {
    let model: String
    let messages: [Message]
    let temperature: Double
}

struct Message: Codable {
    let role: String
    let content: String
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct EventDetails: Codable {
    let title: String
    let startDate: String?
    let endDate: String?
    let location: String
    let description: String?
    let rsvpLink: String?
}

class OpenAIService {
    static let shared = OpenAIService()
    
    // Replace with your actual OpenAI API key
    private let apiKey = "***REMOVED***"
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    // Custom URLSession with connectivity waiting
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = 60.0
        return URLSession(configuration: config)
    }()
    
    
    private init() {}
    
    func extractEventDetails(from text: String, completion: @escaping (EventDetails?) -> Void) {
        let prompt = """
        Extract event details from the following text. Return ONLY a JSON object with these fields:
        - title: The event title
        - startDate: Start date and time (ISO format if possible, or descriptive text)
        - endDate: End date and time (ISO format if possible, or descriptive text)  
        - location: The event location
        - description: Event description (optional)
        - rsvpLink: RSVP link if found (optional)
        
        If a field cannot be determined, use null or empty string.
        
        Text to analyze:
        \(text)
        """
        
        let request = OpenAIRequest(
            model: "gpt-4o-mini",
            messages: [
                Message(role: "system", content: "You are an expert at extracting event details from text. Return only valid JSON."),
                Message(role: "user", content: prompt)
            ],
            temperature: 0.1
        )
        
        guard let url = URL(string: baseURL) else {
            completion(nil)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            print("Error encoding request: \(error)")
            completion(nil)
            return
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                let content = openAIResponse.choices.first?.message.content ?? ""
                
                // Extract JSON from the response
                if let jsonData = content.data(using: .utf8),
                   let eventDetails = try? JSONDecoder().decode(EventDetails.self, from: jsonData) {
                    completion(eventDetails)
                } else {
                    print("Failed to parse JSON response: \(content)")
                    completion(nil)
                }
            } catch {
                print("Error decoding response: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

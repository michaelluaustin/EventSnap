import Foundation

struct OpenAIVisionRequest: Codable {
    let model: String
    let messages: [VisionMessage]
    let temperature: Double
    let max_tokens: Int
}

struct VisionMessage: Codable {
    let role: String
    let content: [VisionContent]
}

struct VisionContent: Codable {
    let type: String
    let text: String?
    let image_url: ImageURL?
}

struct ImageURL: Codable {
    let url: String
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let role: String
    let content: String
}

struct EventDetails: Codable {
    let eventTitle: String
    let startTime: String
    let endTime: String
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
    
    private func extractJSONFromResponse(_ response: String) -> String {
        // Remove markdown code blocks if present
        var jsonString = response.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove ```json and ``` markers
        if jsonString.hasPrefix("```json") {
            jsonString = String(jsonString.dropFirst(7)) // Remove "```json"
        } else if jsonString.hasPrefix("```") {
            jsonString = String(jsonString.dropFirst(3)) // Remove "```"
        }
        
        if jsonString.hasSuffix("```") {
            jsonString = String(jsonString.dropLast(3)) // Remove trailing "```"
        }
        
        return jsonString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func extractEventDetailsFromImage(_ imageDataUri: String, completion: @escaping (EventDetails?) -> Void) {
        let prompt = """
        You are an AI assistant designed to extract event details from an image of a flyer, brochure, or email. Analyze the provided image and extract the following information:

        - Event Title: The title of the event.
        - Start Date & Time: The start date and time of the event in ISO format (YYYY-MM-DDTHH:mm).
        - End Date & Time: The end date and time of the event in ISO format (YYYY-MM-DDTHH:mm).
        - Location: The location of the event.
        - Description: A description of the event, if available.
        - RSVP Link: An RSVP link for the event, if available.

        If any information is not present, leave the corresponding field blank.

        Return the result as a JSON object with keys: eventTitle, startTime, endTime, location, description, rsvpLink.
        """
        
        let request = OpenAIVisionRequest(
            model: "gpt-4o",
            messages: [
                VisionMessage(
                    role: "user",
                    content: [
                        VisionContent(type: "text", text: prompt, image_url: nil),
                        VisionContent(type: "image_url", text: nil, image_url: ImageURL(url: imageDataUri))
                    ]
                )
            ],
            temperature: 0.1,
            max_tokens: 1000
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
                
                // Extract JSON from the response (handle markdown formatting)
                let jsonString = self.extractJSONFromResponse(content)
                if let jsonData = jsonString.data(using: .utf8),
                   let eventDetails = try? JSONDecoder().decode(EventDetails.self, from: jsonData) {
                    completion(eventDetails)
                } else {
                    print("Failed to parse JSON response: \(content)")
                    print("Extracted JSON string: \(jsonString)")
                    completion(nil)
                }
            } catch {
                print("Error decoding response: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    // Legacy method for backward compatibility (can be removed later)
    func extractEventDetails(from text: String, completion: @escaping (EventDetails?) -> Void) {
        // This method is now deprecated - use extractEventDetailsFromImage instead
        print("Warning: extractEventDetails(from:) is deprecated. Use extractEventDetailsFromImage instead.")
        completion(nil)
    }
}

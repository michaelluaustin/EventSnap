import EventKit
import Foundation

class CalendarManager {
    static let shared = CalendarManager()
    
    private let eventStore = EKEventStore()
    
    private init() {}
    
    func addEventToCalendar(title: String, location: String, startDate: Date, endDate: Date, completion: @escaping (Bool, Error?) -> Void) {
        // Use the new API for iOS 17+
        if #available(iOS 17.0, *) {
            eventStore.requestWriteOnlyAccessToEvents { [weak self] granted, error in
                guard granted else {
                    completion(false, error ?? NSError(domain: "CalendarManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Calendar access denied"]))
                    return
                }
                
                self?.createEvent(title: title, location: location, startDate: startDate, endDate: endDate, completion: completion)
            }
        } else {
            // Fallback for older iOS versions
            eventStore.requestAccess(to: .event) { [weak self] granted, error in
                guard granted else {
                    completion(false, error ?? NSError(domain: "CalendarManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Calendar access denied"]))
                    return
                }
                
                self?.createEvent(title: title, location: location, startDate: startDate, endDate: endDate, completion: completion)
            }
        }
    }

    private func createEvent(title: String, location: String, startDate: Date, endDate: Date, completion: @escaping (Bool, Error?) -> Void) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.location = location
        event.startDate = startDate
        event.endDate = endDate
        event.notes = "Created with EventSnap"
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
}

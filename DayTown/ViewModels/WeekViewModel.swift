import SwiftUI
import Combine

class WeekViewModel: ObservableObject {
    let today = Date()
    let calendar = Calendar.current
    
    @Published var pickedDate: String = "Initial Content"
    @Published var week: [String] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    func updateWeek() {
        let today = Date()
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
        var weekDates: [Date] = []
        (1...7).forEach{ day in
            if let weekDate = calendar.date(byAdding: .day, value: day, to: startOfWeek){
                weekDates.append(weekDate)
            }
        }
        
        let weekDatesString = dateToString(weekDate: weekDates)
        Future<[String], Never> { promise in
            DispatchQueue.main.async {
                promise(.success(weekDatesString))
            }
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.week, on: self)
        .store(in: &cancellables)        
    }
    
    func dateToString(weekDate: [Date]) -> [String] {
        var formattedDates: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        for date in weekDate {
            formattedDates.append(dateFormatter.string(from: date))
        }
        return formattedDates
    }
}

import SwiftUI
import Combine

class WeekViewModel: ObservableObject {
    private let today = Date()
    private let calendar = Calendar.current
    var startOfWeek = Date()
    
    @Published var pickedDate: String = "Initial Content"
    @Published var week: [String] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    func initStartOfWeek() {
        startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        calculateWeek()
    }
    
    func updateStartOfWeek(by: Int) {
        if let newStartOfWeek = calendar.date(byAdding: .day, value: 7*by, to: startOfWeek) {
            startOfWeek = newStartOfWeek
        }
        calculateWeek()
    }
    
    
    func calculateWeek() {
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

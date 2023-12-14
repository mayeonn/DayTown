import SwiftUI
import Combine

class WeekViewModel: ObservableObject {
    @Published var week: [String] = []
    @Published var pickedDate: Date = Date()
    @Published var pickedDateIdx: Int = 0
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var today = Date()
    private let calendar = Calendar.current
    var startOfWeek = Date()

    func initWeek() {
        let localTimeZone = TimeZone.current
        today = today.addingTimeInterval(TimeInterval(localTimeZone.secondsFromGMT(for: today)))
        pickedDateIdx = calendar.component(.weekday, from: today) - 1
        let daysToSubtract = (pickedDateIdx - calendar.firstWeekday + 7) % 7
        startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: today)!
        
        calculateWeek()
    }
    
    func updateStartOfWeek(by: Int) {
        if let newStartOfWeek = calendar.date(byAdding: .day, value: 7*by, to: startOfWeek) {
            startOfWeek = newStartOfWeek
        }
        calculateWeek()
    }
    
    
    func calculateWeek() {
        var weekDatesString: [String] = []
        
        (0...6).forEach{ day in
            if let weekDate = calendar.date(byAdding: .day, value: day, to: startOfWeek){
                let str = dateToString(date: weekDate)
                weekDatesString.append(str)
            }
        }
        
        Future<[String], Never> { promise in
            DispatchQueue.main.async {
                promise(.success(weekDatesString))
            }
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.week, on: self)
        .store(in: &cancellables)
    }
    
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = calendar.timeZone
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: date)
    }
    
    func updatePickedDate(index: Int) {
        Future<Date, Never> { promise in
            DispatchQueue.main.async {
                if let newPickedDate = self.calendar.date(byAdding: .day, value: index, to: self.startOfWeek) {
                    promise(.success(newPickedDate))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.pickedDate, on: self)
        .store(in: &cancellables)
    }
    
            
}

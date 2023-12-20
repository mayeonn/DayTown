import SwiftUI
import Combine

class WeekViewModel: ObservableObject {
    @Published var pickedDate: String = ""
    @Published var pickedDateIdx: Int = 0
    @Published var week: [String] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    var today = Date()
    private var calendar = Calendar.current
    var startOfWeek = Date()
    let dateFormatter = DateFormatter()
    
    func initWeek() {
        let localTimeZone = TimeZone.current
        dateFormatter.timeZone = localTimeZone
        dateFormatter.dateFormat = "M/d"
        
        let localizedToday = today.addingTimeInterval(TimeInterval(localTimeZone.secondsFromGMT(for: today)))
        today = calendar.startOfDay(for: localizedToday)
        
        let todayWeekDay = calendar.component(.weekday, from: today) - calendar.firstWeekday
        let daysToSubtract = (todayWeekDay - calendar.firstWeekday + 7) % 7
        startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: today)!
        pickedDate = dateToString(date: today)
        pickedDateIdx = todayWeekDay - 1
        
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
        return dateFormatter.string(from: date)
    }
    
    func updatePickedDate(index: Int) {
        Future<String, Never> { promise in
            DispatchQueue.main.async {
                if let newPickedDate = self.calendar.date(byAdding: .day, value: index, to: self.startOfWeek) {
                    let str = self.dateToString(date: newPickedDate)
                    promise(.success(str))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.pickedDate, on: self)
        .store(in: &cancellables)
    }
}

import SwiftUI
import Combine

class WeekViewModel: ObservableObject {
    @Published var pickedDate: String = ""
    @Published var pickedDateIdx: Int = 0
    @Published var week: [String] = []
    
    private var cancellables: Set<AnyCancellable> = []

    private var calendar = Calendar.current
    let dateFormatter = DateFormatter()
    var today: Date
    var startOfWeek: Date
    
    init() {
        dateFormatter.timeZone = TimeZone.current   // DateFormatter convert the time zone from UTC to the current time zone
        dateFormatter.dateFormat = "M/d"
        
        today = Date()
        pickedDate = dateFormatter.string(from: today)
        
        let todayWeekDay = calendar.component(.weekday, from: today) - calendar.firstWeekday
        let daysToSubtract = (todayWeekDay - calendar.firstWeekday + 7) % 7
        startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: today)!
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
                let str = dateFormatter.string(from: weekDate)
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
    
    func updatePickedDate(index: Int) {
        Future<String, Never> { promise in
            DispatchQueue.main.async {
                if let newPickedDate = self.calendar.date(byAdding: .day, value: index, to: self.startOfWeek) {
                    let str = self.dateFormatter.string(from: newPickedDate)
                    promise(.success(str))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.pickedDate, on: self)
        .store(in: &cancellables)
    }
}

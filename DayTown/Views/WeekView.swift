import SwiftUI

struct WeekView: View {
    @ObservedObject var viewModel: WeekViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(viewModel.week.enumerated()), id: \.element) { index, item in
                let stringToday = viewModel.dateToString(date: viewModel.today)
                let isPickedDate: Bool = viewModel.pickedDate == item
                let isToday: Bool = stringToday == item
                VStack(spacing: 4) {
                    Text(item)
                        .font(.system(size: 12))
                        .tint(.gray)
                        .fontWeight(isToday ? .bold : .regular)
                    ZStack {
                        Circle()
                            .foregroundColor(isPickedDate ? .blue : .white)
                        Text(K.weekDays[index])
                            .font(.system(size: 16))
                            .foregroundStyle(isPickedDate ? .white : index==6 ? .red : index==5 ? .blue : .black)
                    }
                    .gesture(
                        TapGesture()
                            .onEnded{ _ in
                                viewModel.updatePickedDate(index: index)
                                viewModel.pickedDateIdx = index
                            }
                    )
                }
            }
        }
        .padding(8)
        .background(Rectangle().fill(.gray.opacity(0.2)))
        .onAppear{
            viewModel.initWeek()
        }
    }
}

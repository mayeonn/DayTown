import SwiftUI

struct WeekView: View {
    @ObservedObject var viewModel: WeekViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(viewModel.week.enumerated()), id: \.element) { index, item in
                VStack(spacing: 4) {
                    Text(item)
                        .font(.system(size: 12))
                        .tint(.gray)
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                        Text(K.weekDays[index])
                            .font(.system(size: 16))
                    }
                }
            }
        }
        .padding(8)
        .background(Rectangle().fill(.gray.opacity(0.2)))
        .onAppear{
            viewModel.initStartOfWeek()
        }
    }
}

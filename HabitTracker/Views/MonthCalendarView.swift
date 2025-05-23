import SwiftUI

struct MonthCalendarView: View {
    @Binding var selectedDate: Date
    private let calendar = Calendar.current
    private let daysOfWeek = ["Mån", "Tis", "Ons", "Tor", "Fre", "Lör", "Sön"]
    
    private var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "sv_SE")
        return formatter.string(from: selectedDate).capitalized
    }
    
    var body: some View {
        VStack {
            // Månads- och årshuvud med navigeringsknappar
            HStack {
                Button {
                    changeMonth(by: -1) // Föregående månad
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                }
                
                Spacer()
                
                Text(monthName)
                    .font(.headline)
                
                Spacer()
                
                Button {
                    changeMonth(by: 1) // Nästa månad
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.headline)
                }
            }
            .padding(.bottom, 8)
            
            // Veckodagar
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                }
            }
            
            // Datumrutor
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(daysInMonth(), id: \.self) { date in
                    CalendarDayView(date: date, isSelected: calendar.isDate(date, inSameDayAs: selectedDate))
                        .onTapGesture {
                            selectedDate = date
                        }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func daysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else { return [] }
        
        var dates: [Date] = []
        let firstDayOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let daysToSubtract = (firstWeekday + 5) % 7
        
        // Lägg till föregående månads dagar för att fylla ut veckan
        if daysToSubtract > 0 {
            if let previousMonthDays = calendar.date(byAdding: .day, value: -daysToSubtract, to: firstDayOfMonth) {
                for i in 0..<daysToSubtract {
                    if let date = calendar.date(byAdding: .day, value: i, to: previousMonthDays) {
                        dates.append(date)
                    }
                }
            }
        }
        
        // Lägg till aktuella månadens dagar
        var currentDate = firstDayOfMonth
        while currentDate < monthInterval.end {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
}

#Preview {
    @Previewable @State var selectedDate = Date()
    return MonthCalendarView(selectedDate: $selectedDate)
        .modelContainer(for: Habit.self, inMemory: true)
}

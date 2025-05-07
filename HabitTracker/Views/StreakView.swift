
import SwiftUI

struct StreakView: View {
    var streak: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
                .foregroundColor(streak > 0 ? .orange : .gray)
            Text("\(streak)")
                .font(.subheadline.monospacedDigit())
        }
    }
}

#Preview {
    StreakView(streak: 5)
        .modelContainer(for: Habit.self, inMemory: true)
}

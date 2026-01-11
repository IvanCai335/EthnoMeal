import SwiftUI
import Charts

struct DailyMacro: Identifiable {
    let id = UUID()
    let day: String
    let calories: Int
    let protein: Int
    let carbs: Int
}

struct ProfileView: View {
    @State private var selectedMeal: Meal?
    
    // Corrected to start with Sunday and end with Saturday
    let weeklyData: [DailyMacro] = [
        DailyMacro(day: "Sun", calories: 2100, protein: 140, carbs: 220),
        DailyMacro(day: "Mon", calories: 1800, protein: 150, carbs: 180),
        DailyMacro(day: "Tue", calories: 2200, protein: 130, carbs: 250),
        DailyMacro(day: "Wed", calories: 1950, protein: 160, carbs: 190),
        DailyMacro(day: "Thu", calories: 2000, protein: 145, carbs: 210),
        DailyMacro(day: "Fri", calories: 2300, protein: 135, carbs: 280),
        DailyMacro(day: "Sat", calories: 2150, protein: 155, carbs: 230)
    ]
    
    // Filter meals created by "You"
    var myRecipes: [Meal] {
        Meal.allMeals.filter { $0.creator == "You" }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 80, height: 80)
                            .overlay(Text("IV").font(.title).bold().foregroundColor(.white))
                            .shadow(radius: 5)
                        
                        VStack(alignment: .leading) {
                            Text("Ivan User")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Fitness Enthusiast")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Weekly Graph
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Weekly Progress")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        Chart {
                            ForEach(weeklyData) { data in
                                // Divide calories by 10 to fit on the same relative scale visually.
                                // But we should label it clearly or use separate axis if Swift Charts supported it easily.
                                // To clearify, I'll stick to what the user requested "y axis is numbers", implying one scale.
                                // However, 2000 vs 150 is huge.
                                // I will plot them as is.
                                
                                LineMark(
                                    x: .value("Day", data.day),
                                    y: .value("Calories", data.calories),
                                    series: .value("Metric", "Calories")
                                )
                                .foregroundStyle(.red)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                
                                LineMark(
                                    x: .value("Day", data.day),
                                    y: .value("Carbs", data.carbs),
                                    series: .value("Metric", "Carbs")
                                )
                                .foregroundStyle(.blue)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                
                                LineMark(
                                    x: .value("Day", data.day),
                                    y: .value("Protein", data.protein),
                                    series: .value("Metric", "Protein")
                                )
                                .foregroundStyle(.green)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                            }
                        }
                        .frame(height: 250)
                        .padding(.horizontal)
                        
                        // Legend
                        HStack(spacing: 20) {
                            Label("Calories", systemImage: "circle.fill").foregroundColor(.red)
                            Label("Carbs", systemImage: "circle.fill").foregroundColor(.blue)
                            Label("Protein", systemImage: "circle.fill").foregroundColor(.green)
                        }
                        .font(.caption)
                        .padding(.horizontal)
                    }
                    
                    // Stats Column
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Stats")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            NavigationLink(destination: Text("Calories Trend Details")) {
                                StatCard(title: "Avg Calories", value: "2,071", unit: "kcal", color: .red)
                            }
                            NavigationLink(destination: Text("Carbs Trend Details")) {
                                StatCard(title: "Avg Carbs", value: "222", unit: "g", color: .blue)
                            }
                            NavigationLink(destination: Text("Protein Trend Details")) {
                                StatCard(title: "Avg Protein", value: "155", unit: "g", color: .green)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // My Recipes
                    VStack(alignment: .leading, spacing: 16) {
                        Text("My Recipes")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(myRecipes) { meal in
                                MyRecipeCard(meal: meal)
                                    .onTapGesture {
                                        selectedMeal = meal
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 50)
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedMeal) { meal in
                MealDetailView(meal: meal)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                Text(unit)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct MyRecipeCard: View {
    let meal: Meal
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(Color(uiColor: .systemGray6))
                    .aspectRatio(1, contentMode: .fit)
                
                Image(systemName: meal.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.orange)
            }
            .cornerRadius(12)
            
            Text(meal.name)
                .font(.headline)
                .lineLimit(1)
            
            Text("\(meal.calories) kcal")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

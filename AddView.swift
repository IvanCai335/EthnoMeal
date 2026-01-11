import SwiftUI

struct AddView: View {
    @State private var date = Date()
    @State private var isShowingFoodPicker = false
    @State private var selectedMeal: Meal?
    @State private var addedFoods: [Meal] = [
        Meal(name: "Grilled Chicken", imageName: "flame", creator: "You", calories: 350, protein: 40, carbs: 5, ethnicity: "American", description: "Herb-marinated grilled chicken breast served with steamed vegetables."),
        Meal(name: "Steamed Rice", imageName: "circle.fill", creator: "You", calories: 200, protein: 4, carbs: 44, ethnicity: "Asian", description: "Steamed jasmine rice.")
    ]
    
    // Mock Data for Progress
    let currentCalories = 1200
    let goalCalories = 2000
    let currentProtein = 90
    let goalProtein = 160
    let currentCarbs = 150
    let goalCarbs = 250
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        Text("Log Food")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        // Progress Section
                        VStack(spacing: 16) {
                            MacroProgressBar(label: "Calories", current: Double(currentCalories), goal: Double(goalCalories), unit: "kcal", color: .red)
                            MacroProgressBar(label: "Protein", current: Double(currentProtein), goal: Double(goalProtein), unit: "g", color: .green)
                            MacroProgressBar(label: "Carbs", current: Double(currentCarbs), goal: Double(goalCarbs), unit: "g", color: .blue)
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // Date Picker Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date & Time")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            DatePicker("", selection: $date)
                                .datePickerStyle(.graphical)
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .cornerRadius(16)
                                .padding(.horizontal)
                        }
                        
                        // Added Items Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Added Items")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if addedFoods.isEmpty {
                                Text("No items added yet.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                            } else {
                                ForEach(addedFoods) { food in
                                    AddedFoodCard(food: food)
                                        .onTapGesture {
                                            selectedMeal = food
                                        }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
                
                    }
                }
                
                // Add Button
                Button(action: {
                    isShowingFoodPicker = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Food")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.vertical)
                .background(Color(uiColor: .systemBackground))
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isShowingFoodPicker) {
                FoodPickerView()
            }
            .sheet(item: $selectedMeal) { meal in
                MealDetailView(meal: meal)
            }
        }
    }
}

struct AddedFoodCard: View {
    let food: Meal
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: food.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.orange)
                .padding(10)
                .background(Color(uiColor: .tertiarySystemGroupedBackground))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                HStack(spacing: 12) {
                    Text("\(food.calories) kcal")
                    Text("\(food.protein)g prot")
                    Text("\(food.carbs)g carbs")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(14)
        .padding(.horizontal)
        .contentShape(Rectangle()) // Make the whole area tappable
    }
}

struct MacroProgressBar: View {
    let label: String
    let current: Double
    let goal: Double
    let unit: String
    let color: Color
    
    var progress: Double {
        min(current / goal, 1.0)
    }
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text("\(Int(current)) / \(Int(goal)) \(unit)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(color.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}

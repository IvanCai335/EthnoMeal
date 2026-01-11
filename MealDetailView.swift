import SwiftUI

struct MealDetailView: View {
    let meal: Meal
    @Environment(\.presentationMode) var presentationMode
    
    @State private var eatenWeight: Double = 100

    // Base fat for the default serving size
    var baseFat: Int {
        let proteinCal = meal.protein * 4
        let carbsCal = meal.carbs * 4
        let remaining = meal.calories - (proteinCal + carbsCal)
        return max(0, remaining / 9)
    }
    
    // Dynamic calculations
    var weightRatio: Double {
        guard meal.servingWeight > 0 else { return 0 }
        return eatenWeight / Double(meal.servingWeight)
    }
    
    var currentCalories: Int { Int(Double(meal.calories) * weightRatio) }
    var currentProtein: Int { Int(Double(meal.protein) * weightRatio) }
    var currentCarbs: Int { Int(Double(meal.carbs) * weightRatio) }
    var currentFat: Int { Int(Double(baseFat) * weightRatio) }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top Image Section (approx 1/4 screen is generic, we'll use a fixed height or ratio)
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .fill(Color(uiColor: .secondarySystemBackground))
                        .frame(height: geometry.size.height * 0.35) // slightly larger than 1/4 for impact
                        .overlay(
                            Image(systemName: meal.imageName)
                                .resizable()
                                .scaledToFit()
                                .padding(40)
                                .foregroundColor(.orange)
                        )
                    
                    // Close Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.gray.opacity(0.8))
                            .padding()
                            .padding(.top, 40) // Status bar padding if needed, sheets usually handle this
                    }
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Title and Ethnicity
                        VStack(alignment: .leading, spacing: 8) {
                            Text(meal.ethnicity.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            
                            Text(meal.name)
                                .font(.system(size: 34, weight: .bold, design: .serif)) // Apple News style roughly
                                .foregroundColor(.primary)
                        }
                        
                        // Description
                        Text(meal.description)
                            .font(.body)
                            .lineSpacing(4)
                            .foregroundColor(.secondary)
                        
                        // Weight Input
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Serving Size")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack {
                                Slider(value: $eatenWeight, in: 0...500, step: 1)
                                    .accentColor(.orange)
                                
                                Text("\(Int(eatenWeight))g")
                                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                                    .frame(width: 80)
                                    .padding(.vertical, 8)
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.vertical, 5)
                        
                        // Detailed Macros Grid (Optional extra detail before the bar)
                        HStack(spacing: 20) {
                            MacroDetail(value: "\(currentCalories)", unit: "kcal", label: "Energy")
                            MacroDetail(value: "\(currentProtein)", unit: "g", label: "Protein")
                            MacroDetail(value: "\(currentCarbs)", unit: "g", label: "Carbs")
                            MacroDetail(value: "\(currentFat)", unit: "g", label: "Fat")
                        }
                        .padding(.vertical)
                        
                        Spacer()
                    }
                    .padding(24)
                }
                
                // Bottom Macro Bar
                VStack(alignment: .leading, spacing: 12) {
                    Text("Macro Composition")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    MacroCompositionBar(protein: currentProtein, carbs: currentCarbs, fat: currentFat)
                        .frame(height: 24)
                        .padding(.horizontal)
                        .padding(.bottom, 30) // Bottom safe area offset
                }
                .padding(.top, 20)
                .background(Color(uiColor: .systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
            }
            .edgesIgnoringSafeArea(.top)
        }
        .onAppear {
            eatenWeight = Double(meal.servingWeight)
        }
    }
}

struct MacroDetail: View {
    let value: String
    let unit: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct MacroCompositionBar: View {
    let protein: Int
    let carbs: Int
    let fat: Int
    
    var total: Int {
        protein + carbs + fat
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                if total > 0 {
                    // Protein (Green)
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: geometry.size.width * (Double(protein) / Double(total)))
                    
                    // Carbs (Blue)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * (Double(carbs) / Double(total)))
                    
                    // Fat (Orange/Red)
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: geometry.size.width * (Double(fat) / Double(total)))
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
            }
            .cornerRadius(12)
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(meal: Meal.allMeals.first!)
    }
}

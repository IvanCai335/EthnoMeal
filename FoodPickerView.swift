import SwiftUI

struct FoodPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedSegment = 0
    @State private var searchText = ""
    @State private var selectedMeal: Meal?
    
    let segments = ["My Recipes", "Friends", "Search"]
    
    // Filtered data
    var myRecipes: [Meal] {
        Meal.allMeals.filter { $0.creator == "You" }
    }
    
    var friendRecipes: [Meal] {
        Meal.allMeals.filter { $0.creator != "You" } // Simplified logic
    }
    
    var searchResults: [Meal] {
        if searchText.isEmpty {
            return Meal.allMeals
        } else {
            return Meal.allMeals.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Segmented Control
                Picker("Source", selection: $selectedSegment) {
                    ForEach(0..<segments.count, id: \.self) { index in
                        Text(segments[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Content
                if selectedSegment == 0 {
                    // My Recipes
                    List(myRecipes) { meal in
                        FoodRow(meal: meal)
                            .onTapGesture {
                                selectedMeal = meal
                            }
                    }
                    .listStyle(PlainListStyle())
                } else if selectedSegment == 1 {
                    // Friends
                    List(friendRecipes) { meal in
                        FoodRow(meal: meal, showCreator: true)
                            .onTapGesture {
                                selectedMeal = meal
                            }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    // Search
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search", text: $searchText)
                        }
                        .padding()
                        .background(Color(uiColor: .systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        List(searchResults) { meal in
                            FoodRow(meal: meal)
                                .onTapGesture {
                                    selectedMeal = meal
                                }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationTitle("Add Food")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(item: $selectedMeal) { meal in
                MealDetailView(meal: meal)
            }
        }
    }
}

struct FoodRow: View {
    let meal: Meal
    var showCreator: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: meal.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.orange)
                .padding(6)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(.headline)
                
                HStack {
                    if showCreator {
                        Text("by \(meal.creator) •")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    Text("\(meal.calories) kcal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("• \(meal.ethnicity)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            
            Button(action: {
                // Add action placeholder
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.orange)
                    .imageScale(.large)
            }
        }
        .padding(.vertical, 4)
    }
}

struct FoodPickerView_Previews: PreviewProvider {
    static var previews: some View {
        FoodPickerView()
    }
}

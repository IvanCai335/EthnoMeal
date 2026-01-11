import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedMeal: Meal?
    
    var filteredMeals: [Meal] {
        if searchText.isEmpty {
            return Meal.allMeals
        } else {
            return Meal.allMeals.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    TextField("Search for food or recipes", text: $searchText)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(10)
                .padding()
                
                // Results
                List(filteredMeals) { meal in
                    HStack(alignment: .center, spacing: 16) {
                        Image(systemName: meal.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.orange)
                            .padding(8)
                            .background(Color(uiColor: .systemGray6))
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(meal.name)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(meal.ethnicity)
                                .font(.caption)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.orange.opacity(0.1))
                                .foregroundColor(.orange)
                                .cornerRadius(4)
                            
                            HStack(spacing: 4) {
                                Text("\(meal.calories) kcal")
                                    .fontWeight(.medium)
                                Text("•")
                                Text("Protein: \(meal.protein)g")
                                Text("•")
                                Text("Carbs: \(meal.carbs)g")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedMeal = meal
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Search")
            .navigationBarHidden(true)
            .sheet(item: $selectedMeal) { meal in
                MealDetailView(meal: meal)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

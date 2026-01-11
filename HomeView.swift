import SwiftUI

struct HomeView: View {
    @State private var selectedMeal: Meal?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header
                    Text("EthnoMeal")
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Previous Meals Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Previous Meals")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(Meal.samplePrevious) { meal in
                                    MealCard(meal: meal, color: .orange)
                                        .onTapGesture {
                                            selectedMeal = meal
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Recommended Meals Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recommended Meals")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(Meal.sampleRecommended) { meal in
                                    MealCard(meal: meal, color: .green)
                                        .onTapGesture {
                                            selectedMeal = meal
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Friends Tab (Section)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Friends Activity")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            ForEach(FriendActivity.sample) { activity in
                                FriendActivityRow(activity: activity)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .onTapGesture {
                                        selectedMeal = activity.meal
                                    }
                                Divider()
                                    .padding(.leading)
                            }
                        }
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(16)
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

struct MealCard: View {
    let meal: Meal
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(color.opacity(0.1))
                    .frame(height: 120)
                
                Image(systemName: meal.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(color)
            }
            .cornerRadius(12)
            
            Text(meal.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(meal.ethnicity.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
                .padding(.top, 1)

            Text("\(meal.calories) kcal")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(width: 140)
    }
}

struct FriendActivityRow: View {
    let activity: FriendActivity
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(Text(activity.meal.creator.prefix(1)).bold().foregroundColor(.blue))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.meal.creator)
                    .font(.headline)
                Text("created \(activity.meal.name)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(activity.timeAgo)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

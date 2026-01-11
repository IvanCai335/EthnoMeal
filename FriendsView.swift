import SwiftUI

struct FriendsView: View {
    @State private var selectedMeal: Meal?
    
    // Generate some random friends activities for the demo
    let promotedActivities: [FriendActivity] = FriendActivity.sample + [
        FriendActivity(meal: Meal.allMeals[0], timeAgo: "1h ago"),
        FriendActivity(meal: Meal.allMeals[4], timeAgo: "3h ago")
    ]
    
    let recentActivities: [FriendActivity] = [
        FriendActivity(meal: Meal.allMeals[1], timeAgo: "6h ago"),
        FriendActivity(meal: Meal.allMeals[2], timeAgo: "8h ago"),
        FriendActivity(meal: Meal.allMeals[3], timeAgo: "1d ago"),
        FriendActivity(meal: Meal.allMeals[5], timeAgo: "1d ago"),
        FriendActivity(meal: Meal.allMeals[6], timeAgo: "2d ago"),
        FriendActivity(meal: Meal.allMeals[7], timeAgo: "2d ago")
    ]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header
                    Text("Friends")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Horizontal Carousel
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(promotedActivities) { activity in
                                FriendHighlightCard(activity: activity)
                                    .onTapGesture {
                                        selectedMeal = activity.meal
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Recent Activity Grid
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Activity")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(recentActivities) { activity in
                                ActivityGridItem(activity: activity)
                                    .onTapGesture {
                                        selectedMeal = activity.meal
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

struct FriendHighlightCard: View {
    let activity: FriendActivity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Profile Header
            HStack {
                Circle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(Text(activity.meal.creator.prefix(1)).bold().foregroundColor(.orange))
                
                VStack(alignment: .leading) {
                    Text(activity.meal.creator)
                        .font(.headline)
                    Text("shared a recipe")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
            
            // Recipe Content
            VStack(alignment: .leading, spacing: 8) {
                Text(activity.meal.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(activity.meal.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(height: 40, alignment: .topLeading)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            // Image
            ZStack {
                Color.gray.opacity(0.1)
                Image(systemName: activity.meal.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding()
                    .foregroundColor(.orange)
            }
            .frame(height: 150)
            .frame(maxWidth: .infinity)
        }
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(width: 280)
    }
}

struct ActivityGridItem: View {
    let activity: FriendActivity
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .fill(Color(uiColor: .secondarySystemBackground))
                    .aspectRatio(1, contentMode: .fit)
                
                Image(systemName: activity.meal.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.orange)
            }
            .cornerRadius(12)
            
            Text(activity.meal.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(activity.meal.creator)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Text(activity.meal.ethnicity)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                Spacer()
                Text("\(activity.meal.calories) kcal")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.top, 2)
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}

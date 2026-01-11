import SwiftUI

struct Meal: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let creator: String
    let calories: Int
    let protein: Int
    let carbs: Int
    let ethnicity: String
    let description: String
    var servingWeight: Int = 100 // Default to 100g for base calculation
}

struct FriendActivity: Identifiable {
    let id = UUID()
    let meal: Meal
    let timeAgo: String
}

extension Meal {
    static let samplePrevious: [Meal] = [
        Meal(name: "Spicy Ramen", imageName: "bowl.fill", creator: "You", calories: 550, protein: 20, carbs: 65, ethnicity: "Japanese", description: "A rich pork broth ramen with spicy chili oil, soft-boiled egg, and bamboo shoots."),
        Meal(name: "Tacos", imageName: "takeoutbag.and.cup.and.straw.fill", creator: "You", calories: 420, protein: 18, carbs: 45, ethnicity: "Mexican", description: "Street-style soft tacos with pastor pork, pineapple, cilantro, and onions."),
        Meal(name: "Sushi Set", imageName: "fish.fill", creator: "You", calories: 380, protein: 25, carbs: 50, ethnicity: "Japanese", description: "Assorted nigiri sushi including salmon, tuna, and yellowtail."),
        Meal(name: "Burger", imageName: "carrot.fill", creator: "You", calories: 650, protein: 35, carbs: 55, ethnicity: "American", description: "Juicy beef patty with sharp cheddar, lettuce, tomato, and house sauce on a brioche bun.")
    ]
    
    static let sampleRecommended: [Meal] = [
        Meal(name: "Pad Thai", imageName: "fork.knife", creator: "Chef Len", calories: 600, protein: 15, carbs: 70, ethnicity: "Thai", description: "Classic stir-fried rice noodles with egg, peanuts, bean sprouts, and tangy tamarind sauce."),
        Meal(name: "Curry", imageName: "flame.fill", creator: "Spice House", calories: 750, protein: 22, carbs: 60, ethnicity: "Indian", description: "Aromatic chicken curry simmered in coconut milk with turmeric, cumin, and coriander."),
        Meal(name: "Pasta", imageName: "drop.fill", creator: "Bella Italia", calories: 800, protein: 25, carbs: 90, ethnicity: "Italian", description: "Homemade fettuccine with a rich and creamy mushroom alfredo sauce."),
        Meal(name: "Salad", imageName: "leaf.fill", creator: "Green & Go", calories: 320, protein: 10, carbs: 20, ethnicity: "Mediterranean", description: "Fresh garden salad with feta cheese, olives, cucumbers, and lemon vinaigrette.")
    ]
    
    // Combine all for search
    static let allMeals: [Meal] = samplePrevious + sampleRecommended + [
        Meal(name: "Grilled Chicken", imageName: "flame", creator: "You", calories: 350, protein: 40, carbs: 5, ethnicity: "American", description: "Herb-marinated grilled chicken breast served with steamed vegetables."),
        Meal(name: "Oatmeal", imageName: "circle.fill", creator: "You", calories: 250, protein: 8, carbs: 40, ethnicity: "Western", description: "Steel-cut oats topped with fresh berries, walnuts, and a drizzle of honey."),
        Meal(name: "Steak", imageName: "hare.fill", creator: "Restaurant", calories: 700, protein: 50, carbs: 0, ethnicity: "American", description: "Perfectly seared ribeye steak with a side of garlic mashed potatoes."),
        Meal(name: "Apple Pie", imageName: "circle.grid.cross.fill", creator: "Baker", calories: 400, protein: 3, carbs: 60, ethnicity: "Western", description: "Classic apple pie with a flaky crust and cinnamon-spiced apple filling.")
    ]
}

extension FriendActivity {
    static let sample: [FriendActivity] = [
        FriendActivity(meal: Meal(name: "Homemade Pizza", imageName: "circle.grid.cross.fill", creator: "Alice", calories: 450, protein: 18, carbs: 55, ethnicity: "Italian", description: "Hand-tossed pizza with marinara sauce, fresh mozzarella, and basil."), timeAgo: "2h ago"),
        FriendActivity(meal: Meal(name: "BBQ Ribs", imageName: "flame", creator: "Bob", calories: 950, protein: 45, carbs: 15, ethnicity: "American", description: "Slow-cooked pork ribs slathered in tangy tea-infused BBQ sauce."), timeAgo: "4h ago"),
        FriendActivity(meal: Meal(name: "Smoothie Bowl", imageName: "cup.and.saucer.fill", creator: "Charlie", calories: 280, protein: 5, carbs: 45, ethnicity: "Western", description: "Acai base topped with granola, banana slices, and coconut flakes."), timeAgo: "5h ago")
    ]
}

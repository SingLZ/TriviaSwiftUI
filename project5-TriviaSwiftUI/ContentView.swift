import SwiftUI

struct ContentView: View {
    @State private var numberOfQuestions: Int = 10
    @State private var selectedDifficulty: String = "easy"
    @State private var selectedCategory: String = "9" // Default category ID for General Knowledge
    @State private var selectedType: String = "multiple" // Default type is multiple choice
    @State private var selectedTime: Int = 30 // Default time is 30 seconds
    
    @State private var showingTriviaGame = false
    @State private var questions: [QuizQuestion] = []
    
    var body: some View {
        NavigationView{
            VStack(spacing: 90) {
                Text("Trivia Game")
                    .font(.headline)
                    .padding()
                
                HStack() {
                    VStack(alignment: .leading) {
                        Text("Number Question:")
                        Stepper(value: $numberOfQuestions, in: 1...50) {
                            Text("\(numberOfQuestions)")
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("Difficulty Level:")
                        Picker(selection: $selectedDifficulty, label: Text("")) {
                            Text("Easy").tag("easy")
                            Text("Medium").tag("medium")
                            Text("Hard").tag("hard")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Category:")
                        Picker(selection: $selectedCategory, label: Text("")) {
                            Text("General Knowledge").tag("9")
                                Text("Entertainment: Books").tag("10")
                                Text("Entertainment: Film").tag("11")
                                Text("Entertainment: Music").tag("12")
                                Text("Entertainment: Musicals & Theatres").tag("13")
                                Text("Entertainment: Television").tag("14")
                                Text("Entertainment: Video Games").tag("15")
                                Text("Entertainment: Board Games").tag("16")
                                Text("Science: Computers").tag("18")
                                Text("Science: Mathematics").tag("19")
                                Text("Science: Gadgets").tag("30")
                                Text("Science: Gadgets").tag("31")
                                Text("Science: Gadgets").tag("32")
                                Text("Mythology").tag("20")
                                Text("Sports").tag("21")
                                Text("Geography").tag("22")
                                Text("History").tag("23")
                                Text("Politics").tag("24")
                                Text("Art").tag("25")
                                Text("Celebrities").tag("26")
                                Text("Animals").tag("27")
                                Text("Vehicles").tag("28")
                                Text("Comics").tag("29")
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("Question Type:")
                        Picker(selection: $selectedType, label: Text("")) {
                            Text("Multiple Choice").tag("multiple")
                            Text("True/False").tag("boolean")
                            // Add more question types as needed
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Time Limit (seconds):")
                        Stepper(value: $selectedTime, in: 10...300, step: 10) {
                            Text("\(selectedTime)")
                        }
                    }
                    .padding(.horizontal)
                }
                
                Button(action: {
                    fetchQuestions(category: selectedCategory, difficulty: selectedDifficulty, type: selectedType, numberOfQuestions: numberOfQuestions)
                    print("showingTriviaGame: \(showingTriviaGame)")
                }) {
                    Text("Start Trivia")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                NavigationLink(destination: TriviaGameView(questions: questions, selectedTime: .constant(selectedTime)), isActive: $showingTriviaGame) {
                    EmptyView()
                }
                .onChange(of: showingTriviaGame) { newValue in
                    print("NavigationLink is \(newValue ? "showing" : "not showing")")
                }
                
                Spacer()
            }
            
            .padding()
        }
    }
    
    private func fetchQuestions(category: String, difficulty: String, type: String, numberOfQuestions: Int) {
        // Construct the base URL
        var urlString = "https://opentdb.com/api.php"
        
        // Initialize an array to store query parameters
        var queryParams: [URLQueryItem] = []
        
        // Add query parameters for number of questions, difficulty, category, and type
        queryParams.append(URLQueryItem(name: "amount", value: "\(numberOfQuestions)"))
        queryParams.append(URLQueryItem(name: "difficulty", value: difficulty))
        queryParams.append(URLQueryItem(name: "category", value: category))
        queryParams.append(URLQueryItem(name: "type", value: type))
        
        // Append query parameters to the URL
        let query = queryParams.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        urlString.append("?\(query)")
        
        // Create the URL object
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Fetch data asynchronously
        Task {
            do {

                let (data, _) = try await URLSession.shared.data(from: url)
                
                // Print the raw JSON data
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response: \(jsonString)")
                }
                
                let decodedData = try JSONDecoder().decode(QuizData.self, from: data)
                
                print(showingTriviaGame)
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self.questions = decodedData.results
                    showingTriviaGame = true
                }
                print(showingTriviaGame)
                showingTriviaGame = true
                print(showingTriviaGame)
            } catch {
                print("Error fetching quiz data: \(error)")
            }
        }
    }
}


#Preview {
    ContentView()
}

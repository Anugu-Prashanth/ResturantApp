//
//  MealDetailsView.swift
//  ResturantApp
//
//  Created by Anugu Prashanth on 6/4/23.
//

import SwiftUI

struct MealDetailsView: View {
    @State var mealID: String
    @State var mealDetils: [String: String] = [:]
    
    @State var isLoading = false
    
    var mealDetailsViewModel = MealDetailsViewModel()
    
    var body: some View {
        
        ZStack {
            ProgressView()
                .hidden(isLoading)
            List {
                ForEach(mealDetils.sorted(by: <), id: \.key) { item in
                    ListItemView(key: item.key, websiteLink: item.value)
                }
            }.hidden(mealDetils.isEmpty)
        }.onAppear {
            fetchMealDetails()
        }
    }
    
    private func fetchMealDetails() {
        isLoading = true
        mealDetailsViewModel.fetchMealDetails(mealID: mealID) { result in
            isLoading = false
            if case .success(let mealDetails) = result {
                let mm = mealDetails.filter({ $0.value != nil })
                
                var results: [String: String] = [:]
                
                _ = mm.map { (key, value) in
                    results[key] = value ?? ""
                }
                self.mealDetils = results
            }
        }
    }
    
}

struct ListItemView: View{
    let key:String
    let websiteLink:String
    
    var body: some View {
        HStack {
            Text(key)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: UIScreen.main.bounds.width / 3)
            if websiteLink.contains("https") {
                TextWithLink(websiteLink:websiteLink)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }else{
                Text(websiteLink)
                .frame(maxWidth: .infinity, alignment: .leading)                        }
        }
    }
}

struct TextWithLink: View {
    
    let websiteLink: String
    
    var body: some View {
        HStack(spacing: 5){
            if let url = URL(string: websiteLink) {
                Text("Please visit")
                    .font(.body)
                Link(destination: url, label: {
                    Text("website")
                        .bold()
                })
            } else {
                Text("Invalid website link")
                    .foregroundColor(.red)
            }
        }
    }
}


struct MealDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailsView(mealID: "abcd",
                        mealDetils: ["key1": "Value1",
                                     "key2": "Value2"])
    }
}

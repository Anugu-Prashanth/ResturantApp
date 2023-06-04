//
//  ContentView.swift
//  ResturantApp
//
//  Created by Anugu Prashanth on 6/4/23.
//

import SwiftUI

struct ContentView: View {
    var mealListViewModel = MealListViewModel()
    @State var models: [Meal] = []
    
    var body: some View {
        NavigationView {
            VStack {
                List(models) { model in
                    HStack {
                        AsyncImageView(url: URL(string: model.icon ?? ""))
                            .frame(width: 50, height: 50)
                        Text(model.name ?? "")
                        NavigationLink(destination: MealDetailsView(mealID: model.id ?? "") ) {
                        }
                    }
                }.hidden(models.isEmpty)
            }.onAppear(){
                self.mealListViewModel.refreshMealList { result in
                    if case .success(let mealsList) = result {
                        models = mealsList.sorted(by: { $0.name ?? "" < $1.name ?? "" })
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LoaderView: View {
    var body: some View {
        ProgressView()
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

struct AsyncImageView: View {
    let url: URL?
    @StateObject private var imageCache = ImageCache.shared
    
    var body: some View {
        if let url = url {
            if let cachedImage = imageCache.cache[url] {
                cachedImage
                    .resizable()
            } else {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onAppear {
                            cacheImage(image)
                        }
                } placeholder: {
                    ProgressView()
                }
            }
        } else {
            Color.clear
        }
    }
    
    private func loadImage() {
        guard let url = url else { return }
        imageCache.getImage(url: url) { _ in }
    }
    
    private func cacheImage(_ image: Image) {
        guard let url = url else { return }
        imageCache.cache[url] = image
    }
}



class ImageCache: ObservableObject {
    static let shared = ImageCache()
    
    var cache: [URL: Image] = [:]
    private let queue = DispatchQueue(label: "com.example.imagecache", attributes: .concurrent)
    
    func getImage(url: URL, completion: @escaping (Image?) -> Void) {
        queue.async {
            if let cachedImage = self.cache[url] {
                DispatchQueue.main.async {
                    completion(cachedImage)
                }
            } else {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        let image = Image(uiImage: UIImage(data: data)!)
                        self.queue.async(flags: .barrier) {
                            self.cache[url] = image
                        }
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }.resume()
            }
        }
    }
    
    func clearCache() {
        queue.async(flags: .barrier) {
            self.cache.removeAll()
        }
    }
}


//
//  ContentView.swift
//  PassingJSONDataThroughGitHubLinks
//
//  Created by Ramill Ibragimov on 08.02.2020.
//  Copyright © 2020 Ramill Ibragimov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var insta = instaData()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(insta.instas, id: \.id) { inst in
                    VStack {
                        Image(inst.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width - 34,
                                   height: 200)
                            .cornerRadius(12)
                        
                        Text(inst.names)
                            .bold()
                            .font(.subheadline)
                            .foregroundColor(.primary)
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

struct Instagram: Decodable, Identifiable {
    var id: Int
    var names: String
    var image: String
    
    enum CodinKey: String, CodingKey {
        case id = "id"
        case names = "names"
        case image = "image"
    }
}

public class instaData: ObservableObject {
    @Published var instas = [Instagram]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        let url = URL(string: "https://raw.githubusercontent.com/ram4ik/PassingJSONDataThroughGitHubLinks/master/PassingJSONDataThroughGitHubLinks/text.txt")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let dt = data {
                    let decode = try JSONDecoder().decode([Instagram].self, from: dt)
                    
                    DispatchQueue.main.async {
                        self.instas = decode
                    }
                } else { print("Data not found") }
            } catch { print(error.localizedDescription) }
        }.resume()
    }
}

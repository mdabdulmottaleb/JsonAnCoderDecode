//
//  ContentView.swift
//  CallingApi
//
//  Created by MacBook Pro on 9/2/22.
//

import SwiftUI

struct PostModel: Identifiable, Codable {
    let userId: Int
    let id : Int
    let title: String
    let body: String
    
    
}

class DownloadWithEscapingViewModel: ObservableObject {
    
    @Published var posts: [PostModel] = []
    
    init() {
        getPost()
    }
    func getPost() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                print("No data")
                return
            }
            
            guard error == nil else {
                print("Error: \(String(describing: error))")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                print("Status code\(response.statusCode)")
                return
            }
            
            print("Successfully Downloaded Data")
            print(data)
            
            let jsonString = String(data: data, encoding: .utf8)
            print(jsonString)

            guard let newPost = try? JSONDecoder().decode(PostModel.self, from: data) else { return }
            DispatchQueue.main.async { [weak self] in
                self?.posts.append(newPost)
            }
            

            
        }.resume()
    }
}

struct ContentView: View {
    
    @StateObject var vm = DownloadWithEscapingViewModel()
    
    var body: some View {
        List {
            
            ForEach(vm.posts) { post in
                VStack(alignment: .leading){
                    
                    Text(post.title).font(.headline)
                    Text(post.body).foregroundColor(Color.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

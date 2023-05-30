//
//  MainMovieView.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 29/05/2023.
//

import SwiftUI

struct MainMovieView: View {
    
    @StateObject var movieViewModel = MovieDBViewModel()
    
    @State private var isLoading = true
    
    @State var searchText = ""
    
    var body: some View {
        NavigationStack{
            ScrollView{
                if searchText.isEmpty {
                    if movieViewModel.moviesList.isEmpty {
                        Text("No Results")
                    } else {
                        HStack{
                            Text("Trending")
                                .font(.title)
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(movieViewModel.moviesList) { result in
                                    NavigationLink(destination: DetailsView(movieItem: result)) {
                                        TrendingCard(trendingItem: result)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    
                } else {
                    LazyVStack {
                        ForEach(movieViewModel.searchResults) { result in
                            NavigationLink(destination: DetailsView(movieItem: result)) {
                                HStack {
                                    AsyncImage(url: result.backdropURL) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 120)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 80, height: 120)
                                    }
                                    .clipped()
                                    .cornerRadius(10)
                                    
                                    VStack(alignment: .leading) {
                                        Text(String(result.title.prefix(15)) + (result.title.count > 20 ? "..." : ""))
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        Text(result.releaseYear)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        
                                        HStack {
                                            Image(systemName: "hand.thumbsup.fill")
                                            Text(String(format: "%.1f", result.vote_average))
                                            
                                            Spacer()
                                        }
                                        .foregroundColor(.yellow)
                                        .fontWeight(.heavy)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(Color(red:61/255,green:61/255,blue:88/255))
                                .cornerRadius(20)
                                .padding(.horizontal)
                                
                            }
                        }
                        
                        
                    }
                    
                    
                }
                
                
            }
            .background(Color(red:39/255,green:40/255,blue:59/255).ignoresSafeArea())
            
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) {newValue in
            if newValue.count > 2 {
                movieViewModel.searchMovies(query: newValue)
            }
            
        }
        
        .onAppear{
            movieViewModel.fetchTrendingMovies()
            isLoading = false // Data loading is complete
            //            movieViewModel.searchMovies(query: "deadpool")
        }
    }
}



struct MainMovieView_Previews: PreviewProvider {
    static var previews: some View {
        MainMovieView()
    }
}

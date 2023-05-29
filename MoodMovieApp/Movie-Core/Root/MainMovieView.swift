//
//  MainMovieView.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 29/05/2023.
//

import SwiftUI

struct MainMovieView: View {
    
    @StateObject var movieViewModel = MovieDBViewModel()
    
    var body: some View {
        VStack{
            if movieViewModel.trending.isEmpty == true {
                Text("No Results to show")
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
                        ForEach(movieViewModel.trending) { result in
                            TrendingCard(trendingItem: result)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            Spacer()
        }
        .background(Color(red:39/255,green:40/255,blue:59/255).ignoresSafeArea())
        .onAppear{
            movieViewModel.loadTrending()
        }
    }
}



struct MainMovieView_Previews: PreviewProvider {
    static var previews: some View {
        MainMovieView()
    }
}

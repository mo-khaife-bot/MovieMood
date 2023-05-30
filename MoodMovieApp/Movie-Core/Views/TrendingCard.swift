//
//  TrendingCard.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 29/05/2023.
//

import SwiftUI

struct TrendingCard: View {
    
    let trendingItem : MovieItem
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: trendingItem.backdropURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 340, height: 240)
            } placeholder: {
                Rectangle().fill(Color(red:61/255,green:61/255,blue:88/255))
                    .frame(width: 340, height: 240)
            }
            
            VStack {
                HStack {
                    Text(String(trendingItem.title.prefix(20)) + (trendingItem.title.count > 20 ? "..." : ""))
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                    Spacer()
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                    Text(String(format: "%.1f", trendingItem.vote_average))
                    Spacer()
                }
                .foregroundColor(.yellow)
                .fontWeight(.heavy)
            }
            .padding()
            .background(Color(red:61/255,green:61/255,blue:88/255))
        }
        .cornerRadius(10)
        .padding(5)
    }
}


struct TrendingCard_Previews: PreviewProvider {
    static var previews: some View {
        let sampleItem = MovieItem(
                    adult: false,
                    id: 1,
                    poster_path: "/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg",
                    title: "Sample Trending Item",
                    vote_average: 8.5,
                    backdrop_path: "/h8gHn0OzBoaefsYseUByqsmEDMY.jpg",
                    overview: "words",
                    release_date: "2006-12-12"
                    
                    
                )
        TrendingCard(trendingItem: sampleItem)
    }
}

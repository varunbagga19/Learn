//
//  Model.swift
//  Learn
//
//  Created by Varun Bagga on 15/10/23.
//

import Foundation


struct Profile :Identifiable {
    var id = UUID()
    var userName : String
    var profilePicture : String
    var lastMessage : String
}


var profiles = [
    Profile(userName: "IJustine", profilePicture: "pic1", lastMessage: "Love to make tech videos"),
    Profile(userName: "Nemo", profilePicture: "pic2", lastMessage: "Love to make chess video, My laugh is the best"),
    Profile(userName: "Hikaru", profilePicture: "pic3", lastMessage: "Most savage GM Ever, King of expressions"),
    Profile(userName: "Anna", profilePicture: "pic4", lastMessage: "An wfm with the most weird Voice")
]

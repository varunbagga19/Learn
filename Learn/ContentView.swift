//
//  ContentView.swift
//  Learn
//
//  Created by Varun Bagga on 15/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var allProfiles: [Profile] = profiles
    @State private var selectedProfile: Profile?
    @State private var showDetail: Bool = false
    @State private var heroProgree: CGFloat = 0
    @State private var showHeroView: Bool = true
    var body: some View {
        NavigationStack{
            List(allProfiles) { profile in
                HStack(spacing: 12){
                    Image(profile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50,height: 50)
                        .clipShape(Circle())
                        .anchorPreference(key: AnchorKey.self, value: .bounds) { anchor in
                            return [profile.id.uuidString: anchor]
                        }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(profile.userName)
                            .fontWeight(.semibold)
                        
                        Text(profile.lastMessage)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                }
                .contentShape(.rect)
                .onTapGesture {
                    selectedProfile = profile
                    showDetail = true
                    
                    withAnimation(.snappy(duration: 0.35,extraBounce: 0), completionCriteria: .logicallyComplete) {
                        heroProgree = 1.0
                    } completion: {
                        Task {
                            try? await Task.sleep(for: .seconds(0.1))
                            showHeroView = false
                        }
                    }
                }
            }
            .navigationTitle("Progress Effect")
        }
        .overlay{
            if(showDetail) {
                DetailView(
                    seletedProfile: $selectedProfile,
                    heroProgree:$heroProgree,
                    showHeroView: $showHeroView,
                    showDetail: $showDetail
                )
                .transition(.identity)
            }
        }
        .overlayPreferenceValue(AnchorKey.self,{ value in
            GeometryReader(content: { geometry in
                if let selectedProfile,
                   let source = value[selectedProfile.id.uuidString],
                   let destination = value["Destination"]{
                    let sourceRect = geometry[source]
                    let radius = sourceRect.height / 2
                    let destinationRect = geometry[destination]
                    
                    let diffSize = CGSize(
                        width: destinationRect.width - sourceRect.width,
                        height:  destinationRect.height - sourceRect.height)
                    let diffOrigin = CGPoint(
                        x: destinationRect.minX - sourceRect.minX,
                        y:  destinationRect.minY - sourceRect.minY)
                    
                    Image(selectedProfile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: sourceRect.width + (diffSize.width * heroProgree),
                            height: sourceRect.height + (diffSize.height * heroProgree)
                        )
                        .clipShape(.rect(cornerRadius: radius - (radius * heroProgree)))
                        .offset(
                            x: sourceRect.minX + (diffOrigin.x * heroProgree),
                            y: sourceRect.minY + (diffOrigin.y * heroProgree)
                        )
                        .opacity(showHeroView ? 1 : 0)
                }
            })
        })
    }
}


struct DetailView: View {
    
    @Binding var seletedProfile : Profile?
    @Binding var heroProgree: CGFloat
    @Binding var showHeroView : Bool
    @Binding var showDetail: Bool
    @Environment(\.colorScheme) private var scheme
    /// Gesture Properties
    @GestureState private var isDragging: Bool = false
    @State private var offset : CGFloat = .zero
    var body : some View {
        if let seletedProfile, showDetail {
            GeometryReader{
                let size =  $0.size
                
                ScrollView(.vertical){
                    
                    Rectangle()
                        .fill(.clear)
                        .overlay {
                            if !showHeroView{
                                Image(seletedProfile.profilePicture)
                                     .resizable()
                                     .aspectRatio(contentMode: .fill)
                                     .frame(width: size.width, height:400)
                                     .clipShape(.rect(cornerRadius: 25))
                                     .transition(.identity)
                            }
                         
                        }
                        .frame(height: 400)
                        .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                            return ["Destination":anchor]
                        })
                        .visualEffect { content, geometryProxy in
                            content.offset(y:geometryProxy.frame(in: .scrollView).minY > 0 ? -geometryProxy.frame(in: .scrollView).minY : 0)
                        }
                }
                .scrollIndicators(.hidden)
                .ignoresSafeArea()
                .frame(width: size.width, height: size.height)
                .background{
                    Rectangle()
                        .fill(scheme == .dark ? .black : .white)
                        .ignoresSafeArea()
                }
                .overlay(alignment: .topLeading) {
                    Button {
                        showHeroView = true
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                            heroProgree = 0.0
                        } completion: {
                            showDetail = false
                            self.seletedProfile = nil
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .imageScale(.medium)
                            .contentShape(.rect)
                            .foregroundStyle(.bar)
                    }
                    .buttonStyle(.plain)
                    .padding()
                    .opacity(showHeroView ? 0 : 1)
                    .animation(.smooth, value: showHeroView)
                }
                .offset(x:size.width - (size.width * heroProgree))
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 10)
                        .contentShape(.rect)
                        .gesture(
                            DragGesture()
                                .updating($isDragging,body: { _, out, _ in
                                    out = true
                                })
                                .onChanged({ value in
                                    var translation = value.translation.width
                                    translation = isDragging ? translation : .zero
                                    translation = translation > 0 ? translation : 0
                                    
                                    let dragProgress = 1.0 - (translation/size.width)
                                    
                                    let cappedProgress = min(max(0,dragProgress), 1)
                                    heroProgree = cappedProgress
                                    if !showHeroView {
                                        showHeroView = true
                                    }
                                })
                                .onEnded({ value in
                                    let velocity = value.velocity.width
                                    
                                    if(offset + velocity) > (size.width * 0.8) {
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                                            heroProgree = .zero
                                        } completion: {
                                            offset = .zero
                                            showDetail = false
                                            showHeroView = true
                                            self.seletedProfile = nil
                                        }
                                    }else{
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                                            heroProgree = 1.0
                                            offset = .zero
                                        } completion: {
                                            showHeroView = false
                                        }

                                    }
                                })
                        )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

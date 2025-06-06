import SwiftUI
import AVKit
import Foundation
import UIKit

struct Comment: Identifiable, Hashable {
    let id = UUID()
    let username: String
    let text: String
    let pfpFilename: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.id == rhs.id
    }
}

typealias CommentPool = [String: [String]]

struct VideosView: View {
    @State private var videoNames: [String] = (1...25).map { "video\($0)" }

    @State private var currentPlayingVideoId: String?

    let fullCommentPool: CommentPool = [
        "Sara Landry": [
            "Wow this is so sigma, you guys would rave so hard at my show",
            "You're invited to my after party",
            "Dark techno couple goals 🖤",
            "This love is more intense than a warehouse drop",
            "You two better show up front row next time",
            "Certified b2b couple of the year",
            "If love had a BPM, you’d both be 140+",
            "Relationship energy: distorted and beautiful",
            "This belongs in a Berlin basement",
            "This edit gave me flashbacks to 5AM sets"
        ],
        "Peter G": [
            "Freakin' sweet!",
            "Lois, look! They’re doing couple stuff!",
            "You guys are so cute it's making me hungry",
            "This makes me wanna call Joe and cry",
            "I haven’t seen love like this since my second sandwich",
            "If this was a movie, I'd watch it. Twice. On VHS.",
            "Meg wishes she had this kind of chemistry",
            "You guys are like the peanut butter and jelly of TikTok",
            "This made me believe in love again… then I remembered my credit card bill",
            "Honestly, I’m rooting for you two harder than I root against Cleveland"
        ],
        "Eric C": [
            "You guys think you're better than me huh?",
            "Ugh. Whatever. You’re kinda cute I guess",
            "I’m not jealous. Shut up, Kyle!",
            "If I had a girlfriend I wouldn’t be this cringe. Probably.",
            "You guys better not break up or I’m suing",
            "This made me feel emotions and I don’t like that",
            "Okay fine. You win. You’re adorable. Are you happy now?",
            "This is the kind of stuff that makes me hate Valentine's Day",
            "I’m not crying. I just got spicy Cheetos in my eye",
            "I showed this to Butters and now he wants a girlfriend too"
        ],
        "The Power Rangers RPM": [
            "Confirmed: strongest duo in the grid",
            "Venjix couldn’t even corrupt this love",
            "This much chemistry should be monitored",
            "Zord-level connection detected 💛",
            "Alert: 100% compatibility match found",
            "Love power at maximum RPM",
            "Even Dr. K smiled. That’s rare.",
            "If you two break up, the timeline collapses",
            "This is what the Morphin Grid was made for",
            "Enemies to lovers? More like legends to lifers"
        ],
        "Ken": [
            "Mmph mmph mmph! (Translation: This is so sweet!)",
            "Mmph mmph mmmph mmph! (Translation: You guys are awesome!)",
            "Mmph mmph mmph mmph mmph! (Translation: I'm so happy for you!)",
            "Mmph mmph mmph mmph mmph mmph! (Translation: This video is amazing!)",
            "Mmph mmph mmph mmph mmph mmph mmph! (Translation: Totally worth dying for!)",
            "Mmph mmph mmph mmph mmph mmph mmph mmph! (Translation: I wish I had this!)",
            "Mmph mmph mmph mmph mmph mmph mmph mmph mmph! (Translation: Don't tell Cartman!)",
            "Mmph mmph mmph mmph mmph mmph mmph mmph mmph mmph! (Translation: This is better than Cheesy Poofs!)",
            "Mmph mmph mmph mmph mmph mmph mmph mmph mmph mmph mmph! (Translation: Oh my God, they're so cute!)",
            "Mmph mmph mmph mmph mmph mmph mmph mmph mmph mmph mmph mmph! (Translation: You're all going to hell!)"
        ],
        "Obama": [
            "Let me be clear, this is a beautiful moment.",
            "Hope and change, right here in this video.",
            "This is not just a video, it's a testament to unity.",
            "I've always believed in the power of connection, and this proves it.",
            "Folks, this is what progress looks like.",
            "We are the ones we've been waiting for, and you two embody it.",
            "Don't underestimate the power of a shared smile.",
            "This video reminds me of the American spirit.",
            "Yes, we can, and you two certainly are.",
            "A moment like this truly inspires."
        ],
        "Andrés Manuel López Obrador": [
            "Con el pueblo todo, sin el pueblo nada. ¡Qué viva el amor!",
            "Esto es parte de la transformación de nuestras vidas.",
            "La felicidad es un derecho del pueblo, y aquí se ve.",
            "No hay nada más importante que el bienestar de la pareja.",
            "Desde Palacio Nacional, les mando un abrazo fraterno.",
            "Esto es un ejemplo de honestidad y amor verdadero.",
            "Mi pecho no es bodega, y mi corazón está lleno de alegría por ustedes.",
            "La austeridad republicana también aplica al derroche de amor.",
            "Un mensaje de esperanza para todos los mexicanos.",
            "¡Felicidades, pueblo! Esto es amor."
        ],
        "Enrique Peña Nieto": [
            "Mover a México es también mover los corazones.",
            "Lo bueno casi no se cuenta, pero esto hay que contarlo.",
            "Les deseo lo mejor en esta etapa de su vida.",
            "Un gran video, con grandes momentos.",
            "Gracias por compartir esta alegría.",
            "Esto es un claro ejemplo de que cuando se quiere, se puede.",
            "Mi compromiso es con la felicidad de las familias.",
            "La reforma energética también trae luz a sus vidas.",
            "Un honor ser testigo de un amor tan grande.",
            "Que sigan construyendo un futuro juntos."
        ],
        "Kanye West": [
            "This video is genius. Undeniable.",
            "Y'all sleepin' on this. This is art.",
            "I literally invented love, so I know. This is it.",
            "This love is gonna change the culture.",
            "They ain't got the answers, Sway! But this video does.",
            "My creative process is exactly like this energy.",
            "This needs to be played at the next Sunday Service.",
            "I'm just here to bring the truth, and the truth is, this is perfect.",
            "God's work right here. Pure inspiration.",
            "They tried to tell me I couldn't be happy. Look at this. Manifest it."
        ],
        "The Rock": [
            "Finally, love has come back to the internet!",
            "Can you smell what The Rock is cookin'? It's pure romance!",
            "Know your role and admire this amazing couple!",
            "The most electrifying love in all of entertainment!",
            "Layeth the smack down on loneliness with this kind of connection!",
            "This video is like a perfectly executed People's Elbow of affection!",
            "It doesn't matter what your name is, just that you're happy!",
            "This love is stronger than a Brahma Bull!",
            "Just bring it! Bring all the love!",
            "This is the jabroni-beating, pie-eating, trail-blazin', eyebrow-raisin' love!"
        ],
        "Joe Rogan": [
            "That's wild, man. You ever think about how crazy that is?",
            "Dude, this is like, next-level connection. Have you tried DMT?",
            "This is why you gotta stay humble and keep training. For moments like this.",
            "It's entirely possible that this is the most wholesome thing on the internet.",
            "Jamie, pull up that video of the chimps holding hands. It's similar energy.",
            "You gotta appreciate the small things, man. Like this. This is a small thing, but it's huge.",
            "This is what it's all about. Just two human beings, vibing.",
            "Imagine being this happy. What's their secret? Probably cold showers and elk meat.",
            "This is a powerful display of human bonding. It's fascinating.",
            "Look into it, man. This kind of love is rare."
        ]
    ]

    let pfpMapping: [String: String] = [
        "Sara Landry": "saraLandryPfp",
        "The Power Rangers RPM": "rpmPfp",
        "Eric C": "ericPfp",
        "Peter G": "peterPfp",
        "Ken": "kenPfp",
        "Obama": "obamaPfp",
        "Andrés Manuel López Obrador": "amloPfp",
        "Enrique Peña Nieto": "eprPfp",
        "The Rock": "rockPfp",
        "Joe Rogan": "joePfp",
        "Kanye West":"kanyePfp"
    ]


    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(videoNames, id: \.self) { videoName in
                    VideoPlayerCell(videoName: videoName, currentPlayingVideoId: $currentPlayingVideoId, fullCommentPool: fullCommentPool, pfpMapping: pfpMapping)
                        .id(videoName)
                        .containerRelativeFrame([.horizontal, .vertical])
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $currentPlayingVideoId)
        .ignoresSafeArea()
        .onAppear {
            videoNames.shuffle()
            currentPlayingVideoId = videoNames.first
        }
        .onChange(of: currentPlayingVideoId) { oldValue, newValue in
        }
    }
}

struct VideoPlayerCell: View {
    let videoName: String
    @Binding var currentPlayingVideoId: String?
    let fullCommentPool: CommentPool
    let pfpMapping: [String: String]

    @State private var player: AVQueuePlayer?
    @State private var playerLooper: AVPlayerLooper?
    @State private var showComments: Bool = false

    @State private var likes: Int = 0
    @State private var isLiked: Bool = false

    @State private var floatingHeartOpacity: Double = 0.0
    @State private var floatingHeartScale: CGFloat = 0.5
    @State private var tapLocation: CGPoint?

    @State private var isPaused: Bool = false
    @State private var showPlaybackIcon: Bool = false
    @State private var playbackIconSystemName: String = "play.fill"
    @State private var playbackIconOpacity: Double = 0.0
    @State private var playbackIconScale: CGFloat = 0.5

    @State private var isSaved: Bool = false
    @State private var floatingSaveOpacity: Double = 0.0
    @State private var floatingSaveScale: CGFloat = 0.5
    @State private var saveTapLocation: CGPoint?
    @State private var comments: [Comment] = []

    var formattedLikes: String {
        if likes >= 1000 {
            let kLikes = Double(likes) / 1000.0
            return String(format: "%.1fK", kLikes).replacingOccurrences(of: ".0K", with: "K")
        } else {
            return "\(likes)"
        }
    }

    var body: some View {
        ZStack {
            if let activePlayer = player {
                VideoPlayer(player: activePlayer)
                    .onAppear {
                        if comments.isEmpty {
                            generateRandomComments()
                        }
                        if likes == 0 {
                            likes = Int.random(in: 1024...100_000)
                        }

                        if currentPlayingVideoId == videoName {
                            activePlayer.play()
                            isPaused = false
                        } else {
                            activePlayer.pause()
                            isPaused = true
                        }
                    }
                    .onChange(of: currentPlayingVideoId) { oldValue, newValue in
                        if newValue == videoName {
                            activePlayer.play()
                            isPaused = false
                        } else {
                            activePlayer.pause()
                            isPaused = true
                        }
                    }
            } else {
                Color.black
                    .overlay(
                        Text("Video '\(videoName)' Not Found")
                            .foregroundColor(.white)
                            .font(.headline)
                    )
                    .onAppear {
                        if comments.isEmpty {
                            generateRandomComments()
                        }
                        loadVideoPlayer()
                        if likes == 0 {
                            likes = Int.random(in: 1024...100_000)
                        }
                    }
            }

            Color.clear
                .contentShape(Rectangle())
                .onTapGesture(count: 1) {
                    if let activePlayer = player {
                        if activePlayer.rate == 0 {
                            activePlayer.play()
                            isPaused = false
                            playbackIconSystemName = "play.fill"
                        } else {
                            activePlayer.pause()
                            isPaused = true
                            playbackIconSystemName = "pause.fill"
                        }

                        playbackIconOpacity = 1.0
                        playbackIconScale = 1.2
                        withAnimation(.easeOut(duration: 0.15)) {
                            playbackIconScale = 1.0
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeOut(duration: 0.2)) {
                                playbackIconOpacity = 0.0
                                playbackIconScale = 0.5
                            }
                        }
                    }
                }
                .onTapGesture(count: 2) { location in
                    tapLocation = location
                    toggleLike()
                }

            Image(systemName: playbackIconSystemName)
                .font(.system(size: 80))
                .foregroundColor(.white)
                .opacity(playbackIconOpacity)
                .scaleEffect(playbackIconScale)
                .animation(.default, value: playbackIconOpacity)
                .animation(.default, value: playbackIconScale)

            if let safeTapLocation = tapLocation {
                Image(systemName: "heart.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.pink)
                    .opacity(floatingHeartOpacity)
                    .scaleEffect(floatingHeartScale)
                    .position(safeTapLocation)
                    .animation(.easeOut(duration: 0.2), value: floatingHeartOpacity)
                    .animation(.easeOut(duration: 0.2), value: floatingHeartScale)
            }

            if floatingSaveOpacity > 0.0 {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.yellow)
                    .opacity(floatingSaveOpacity)
                    .scaleEffect(floatingSaveScale)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                    .animation(.easeOut(duration: 0.2), value: floatingSaveOpacity)
                    .animation(.easeOut(duration: 0.2), value: floatingSaveScale)
            }

            VStack {
                Spacer()
                VStack(spacing: 25) {
                    Button {
                        toggleLike()
                    } label: {
                        VStack {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 30))
                                .foregroundColor(isLiked ? .pink : .white)
                                .shadow(radius: 2)
                            Text(formattedLikes)
                                .font(.caption)
                                .foregroundColor(.white)
                                .shadow(radius: 1)
                        }
                    }

                    Button {
                        showComments.toggle()
                    } label: {
                        VStack {
                            Image(systemName: "text.bubble.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                            Text("\(comments.count)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .shadow(radius: 1)
                        }
                    }

                    Button {
                        toggleSave()
                    } label: {
                        VStack {
                            Image(systemName: "bookmark.fill")
                                .font(.system(size: 30))
                                .foregroundColor(isSaved ? .yellow : .white)
                                .shadow(radius: 2)
                            Text("Save")
                                .font(.caption)
                                .foregroundColor(.white)
                                .shadow(radius: 1)
                                .padding(.bottom, 5)
                        }
                    }
                }
                .padding(.trailing, 15)
                .padding(.bottom, 100)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

            if showComments {
                CommentOverlayView(comments: $comments, isShowing: $showComments)
                    .transition(.move(edge: .bottom))
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
            playerLooper = nil
            player?.pause()
            player?.seek(to: .zero)
            player = nil
        }
    }

    private func generateRandomComments() {
        var generatedComments: [Comment] = []
        let allUsernames = Array(fullCommentPool.keys)

        let numberOfUsersToInclude = Int.random(in: 2...allUsernames.count)
        let selectedUsernames = allUsernames.shuffled().prefix(numberOfUsersToInclude)

        for username in selectedUsernames {
            if let possibleTexts = fullCommentPool[username], let pfp = pfpMapping[username] {
                if let randomText = possibleTexts.randomElement() {
                    generatedComments.append(Comment(username: username, text: randomText, pfpFilename: pfp))
                }
            }
        }
        comments = generatedComments.shuffled()
    }

    private func toggleLike() {
        isLiked.toggle()
        if isLiked {
            likes += 1

            floatingHeartOpacity = 1.0
            floatingHeartScale = 1.2

            withAnimation(.easeOut(duration: 0.2)) {
                floatingHeartScale = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeIn(duration: 0.3)) {
                    floatingHeartOpacity = 0.0
                    floatingHeartScale = 0.5
                }
                tapLocation = nil
            }
        } else {
            likes -= 1
            floatingHeartOpacity = 0.0
            floatingHeartScale = 0.5
            tapLocation = nil
        }
    }

    private func toggleSave() {
        isSaved.toggle()
        if isSaved {
            floatingSaveOpacity = 1.0
            floatingSaveScale = 1.2
            withAnimation(.easeOut(duration: 0.2)) {
                floatingSaveScale = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.easeIn(duration: 0.3)) {
                    floatingSaveOpacity = 0.0
                    floatingSaveScale = 0.5
                }
            }
        } else {
            floatingSaveOpacity = 0.0
            floatingSaveScale = 0.5
        }
    }

    private func loadVideoPlayer() {
        let possibleExtensions = ["mp4", "MP4", "mov", "MOV", "m4v", "M4V"]
        var foundURL: URL? = nil

        for ext in possibleExtensions {
            if let url = Bundle.main.url(forResource: videoName, withExtension: ext) {
                foundURL = url
                break
            }
        }

        if let url = foundURL {
            let playerItem = AVPlayerItem(url: url)
            let newPlayer = AVQueuePlayer(playerItem: playerItem)
            self.player = newPlayer

            playerLooper = AVPlayerLooper(player: newPlayer, templateItem: playerItem)

        } else {
        }
    }
}


struct CommentOverlayView: View {
    @Binding var comments: [Comment]
    @Binding var isShowing: Bool

    @GestureState private var dragOffset: CGFloat = 0
    @State private var viewOffset: CGFloat = 0

    @State private var newCommentText: String = ""

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.6).ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    isShowing = false
                }

            VStack(spacing: 0) {
                HStack {
                    Text("Comments")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        UIApplication.shared.endEditing()
                        isShowing = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .padding([.horizontal, .top])
                .padding(.bottom, 5)

                Divider()

                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(comments) { commentItem in
                            HStack(alignment: .top, spacing: 10) {
                                Image(commentItem.pfpFilename)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))

                                VStack(alignment: .leading) {
                                    Text(commentItem.username)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    Text(commentItem.text)
                                        .font(.body)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                    }
                }

                VStack(spacing: 0) {
                    Divider()
                    HStack {
                        TextField("Add a comment...", text: $newCommentText)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(20)
                            .foregroundColor(.black)
                            .tint(.black)

                        Button {
                            if !newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                let newComment = Comment(username: "user", text: newCommentText, pfpFilename: "userPfp")
                                comments.append(newComment)
                                newCommentText = ""
                                UIApplication.shared.endEditing()
                            }
                        } label: {
                            Text("Post")
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 8)
                        .disabled(newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .padding(.bottom, 85)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(15)
            .containerRelativeFrame(.vertical) { length, axis in
                length * 0.5
            }
            .offset(y: max(0, viewOffset + dragOffset))
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        let totalDrag = value.translation.height + viewOffset
                        if totalDrag > 100 {
                            withAnimation(.easeOut(duration: 0.2)) {
                                isShowing = false
                            }
                        } else {
                            withAnimation(.spring()) {
                                viewOffset = 0
                            }
                        }
                        UIApplication.shared.endEditing()
                    }
            )
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear {
                viewOffset = 0
            }
        }
    }
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    VideosView()
}

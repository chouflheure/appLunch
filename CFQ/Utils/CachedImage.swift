import Lottie
import SwiftUI
import Foundation

private class ImageCache {
    static private var cache: [URL: Image] = [:]
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}

private struct CachedAsyncImage<Content>: View where Content: View {

    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    /// Loads, displays and caches a modifiable image from the specified URL in phases.
    ///
    /// - Parameters:
    ///   - url: The URL of the image to display.
    ///   - scale: The scale to use for the image. The default is `1`. Set a
    ///     different value when loading images designed for higher resolution
    ///     displays. For example, set a value of `2` for an image that you
    ///     would name with the `@2x` suffix if stored in a file on disk.
    ///   - transaction: The transaction to use when the phase changes.
    ///   - content: A closure that takes the load phase as an input, and
    ///     returns the view to display for the specified phase.
    public init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    public var body: some View {
        if let url, let cached = ImageCache[url] {
            content(.success(cached))
        } else {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }

    private func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase, let url {
            ImageCache[url] = image
        }
        return content(phase)
    }
}

internal enum PictureCacheDesignType {
    case scaledToFill_Circle
    case scaledToFill_Clipped
    case fullScreenImageTurn
    case fullScreenImageTurnDetail
    case scaledToFill_Circle_CFQFeed
    case scaledToFill_Circle_CFQMessage
    case scaleImageMessageProfile
    case scaleImageTeam
    case scaleImagePreviewUsers
    
}

struct CachedAsyncImageView: View {
    let urlString: String
    let designType: PictureCacheDesignType
    let animation = LottieView(animation: .named(StringsToken.Animation.loaderPicture))

    var body: some View {
        CachedAsyncImage(url: URL(string: urlString) ?? URL(string: "")) {
            phase in
            switch phase {
            case .empty:
                switch designType {
                    
                case .scaledToFill_Circle_CFQFeed:
                    ZStack {
                        animation
                            .playing()
                            .looping()

                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 60, height: 60)
                    }
                    
                case .scaledToFill_Circle_CFQMessage:
                    ZStack {
                        animation
                            .playing()
                            .looping()

                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 30, height: 30)
                    }

                case .scaledToFill_Circle:
                    ZStack {
                        animation
                            .playing()
                            .looping()

                        Circle()
                            .foregroundColor(.gray)
                    }

                case .fullScreenImageTurn, .fullScreenImageTurnDetail, .scaledToFill_Clipped:
                    animation
                        .playing()
                        .looping()
                
                case .scaleImageMessageProfile:
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 42, height: 42)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 44, height: 44)
                        }
                case .scaleImageTeam:
                    ZStack {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 90, height: 90)
                        
                        animation
                            .playing()
                            .looping()
                    }
                    
                case .scaleImagePreviewUsers:
                    ZStack {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 38, height: 38)
                        
                        animation
                            .playing()
                            .looping()
                    }
                }

            case .success(let image):
                switch designType {
                    
                case .scaledToFill_Circle_CFQFeed:
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 60, height: 60)
                    
                case .scaledToFill_Circle_CFQMessage:
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)

                case .scaledToFill_Circle:
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())

                case .scaledToFill_Clipped:
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipped()

                case .fullScreenImageTurn:
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .frame(width: UIScreen.main.bounds.width)
                        .contentShape(Rectangle())
                        .clipped()
                    
                case .fullScreenImageTurnDetail:
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .frame(width: UIScreen.main.bounds.width)
                        .contentShape(Rectangle())
                        .clipped()
                
                case .scaleImageMessageProfile:
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 42, height: 42)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 44, height: 44)
                        }
                case .scaleImageTeam:
                    image
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.white)
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())

                case .scaleImagePreviewUsers:
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 38, height: 38)
                }

            case .failure(_):
                switch designType {
                    
                case .scaledToFill_Circle_CFQFeed:
                    ZStack {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 60, height: 60)
                        
                        animation
                            .playing()
                            .looping()
                    }

                case .scaledToFill_Circle_CFQMessage:
                    ZStack {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 40, height: 40)
                        
                        animation
                            .playing()
                            .looping()
                    }
                    
                case .scaledToFill_Circle:
                    ZStack {
                        animation
                            .playing()
                            .looping()

                        Circle()
                            .foregroundColor(.gray)
                    }

                case .fullScreenImageTurn, .fullScreenImageTurnDetail, .scaledToFill_Clipped:
                    animation
                        .playing()
                        .looping()
                    
                case .scaleImageMessageProfile:
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 34, height: 34)
                        }
                case .scaleImageTeam:
                    ZStack {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 90, height: 90)
                        
                        animation
                            .playing()
                            .looping()
                    }
                case .scaleImagePreviewUsers:
                    ZStack {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 38, height: 38)
                        
                        animation
                            .playing()
                            .looping()
                    }
                }

            @unknown default:
                switch designType {
                    
                case .scaledToFill_Circle_CFQFeed:
                    ZStack {
                        animation
                            .playing()
                            .looping()

                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 60, height: 60)
                    }

                case .scaledToFill_Circle_CFQMessage:
                    ZStack {
                        animation
                            .playing()
                            .looping()

                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 40, height: 40)
                    }

                case .scaledToFill_Circle:
                    ZStack {
                        animation
                            .playing()
                            .looping()

                        Circle()
                            .foregroundColor(.gray)
                    }

                case .fullScreenImageTurn, .fullScreenImageTurnDetail, .scaledToFill_Clipped:
                    animation
                        .playing()
                        .looping()
                    
                case .scaleImageMessageProfile:
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 42, height: 42)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 44, height: 44)
                        }
                    
                case .scaleImageTeam:
                    ZStack {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 90, height: 90)
                        
                        animation
                            .playing()
                            .looping()
                    }
                case .scaleImagePreviewUsers:
                    ZStack {
                        animation
                            .playing()
                            .looping()
                        
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 38, height: 38)
                    }
                }
            }
        }
    }
}

// MARK: - Gestionnaire de cache d'images
class ImageCacheManager: ObservableObject {
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        // Configuration du cache en mémoire
        cache.countLimit = 100 // Limite de 100 images
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
        
        // Création du répertoire de cache sur disque
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesDirectory.appendingPathComponent("ImageCache")
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    // MARK: - Méthodes publiques
    func getImage(for url: String) -> UIImage? {
        let key = NSString(string: url)
        
        // Vérifier d'abord le cache mémoire
        if let cachedImage = cache.object(forKey: key) {
            return cachedImage
        }
        
        // Vérifier ensuite le cache disque
        if let diskImage = loadImageFromDisk(url: url) {
            cache.setObject(diskImage, forKey: key)
            return diskImage
        }
        
        return nil
    }
    
    func cacheImage(_ image: UIImage, for url: String) {
        let key = NSString(string: url)
        
        // Sauvegarder en mémoire
        cache.setObject(image, forKey: key)
        
        // Sauvegarder sur disque
        saveImageToDisk(image, url: url)
    }
    
    func clearCache() {
        cache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    // MARK: - Méthodes privées
    private func loadImageFromDisk(url: String) -> UIImage? {
        let filename = url.hash
        let fileURL = cacheDirectory.appendingPathComponent("\(filename).jpg")
        
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
    
    private func saveImageToDisk(_ image: UIImage, url: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        
        let filename = url.hash
        let fileURL = cacheDirectory.appendingPathComponent("\(filename).jpg")
        
        try? data.write(to: fileURL)
    }
}

// MARK: - Version optimisée avec AsyncImage (iOS 15+)
struct ModernCachedAsyncImage: View {
    let url: String
    let placeholder: Image
    
    @StateObject private var cacheManager = ImageCacheManager.shared
    @State private var cachedImage: UIImage?
    
    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.url = url
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let cachedImage = cachedImage {
                Image(uiImage: cachedImage)
                    .resizable()
            } else {
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .onAppear {
                                // Cache l'image téléchargée
                                Task {
                                    await cacheDownloadedImage(image)
                                }
                            }
                    case .failure(_):
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.red)
                            Text("Erreur de chargement")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    case .empty:
                        VStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Chargement...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    @unknown default:
                        placeholder
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .onAppear {
            cachedImage = cacheManager.getImage(for: url)
        }
    }
    
    // Méthode pour mettre en cache l'image téléchargée
    @MainActor
    private func cacheDownloadedImage(_ image: Image) async {
        // Créer une UIImage à partir de l'image téléchargée
        if let data = await downloadImageData(),
           let uiImage = UIImage(data: data) {
            cacheManager.cacheImage(uiImage, for: url)
            cachedImage = uiImage
        }
    }
    
    // Télécharger les données de l'image pour le cache
    private func downloadImageData() async -> Data? {
        guard let imageURL = URL(string: url) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            return data
        } catch {
            print("Erreur lors du téléchargement pour le cache: \(error)")
            return nil
        }
    }
}

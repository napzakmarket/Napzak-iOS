//
//  ProfileEditView.swift
//  Napzak-iOS
//
//  Created by 어진 on 4/24/25.
//

import SwiftUI
import Combine
import os

final class ProfileEditViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var profileDescription: String = ""
    @Published var selectedGenres: [GenreNameModel] = []
    @Published var isPrimaryButtonEnabled: Bool = false
    @Published var validationState: UsernameValidation = .empty
    private var isRequesting: Bool = false
    
    @Published var profileImageURL: String = ""
    @Published var coverImageURL: String = ""
    @Published var selectedProfileImage: UIImage? = nil
    @Published var selectedCoverImage: UIImage? = nil
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isSuccess: Bool = false
    
    private let storeService: StoreServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Napzak", category: "ProfileEdit")
    
    private var initialNickname: String = ""
    private var initialProfileDescription: String = ""
    private var initialGenres: [GenreNameModel] = []
    private var initialProfileImageURL: String = ""
    private var initialCoverImageURL: String = ""
    
    init(storeService: StoreServiceProtocol = StoreService()) {
        self.storeService = storeService
        setupSubscriptions()
        fetchCurrentProfile()
    }

    func validateUsername(_ username: String) async {
        isRequesting = true
        let request = NicknameRequestDTO(nickname: username)
        let result = await storeService.validateNickname(request: request)
        isRequesting = false
        
        switch result {
        case .success:
            validationState = .valid
            isPrimaryButtonEnabled = true
            
        case .failure(let error):
            validationState = .serverError(error.errorDescription ?? "")
            isPrimaryButtonEnabled = false
        }
    }

    func fetchCurrentProfile() {
        isLoading = true
        errorMessage = nil
        
        Task {
            let myPageResult = await storeService.getMyPageInfo()
            
            await MainActor.run {
                switch myPageResult {
                case .success(let response):
                    if let storeId = response.data?.storeId {
                        Task {
                            let detailResult = await storeService.getStoreDetail(storeId: storeId)
                            
                            await MainActor.run {
                                isLoading = false
                                switch detailResult {
                                case .success(let detailResponse):
                                    if let storeDetail = detailResponse.data {
                                        self.nickname = storeDetail.storeNickName ?? "납자기"
                                        self.initialNickname = self.nickname
                                        
                                        self.profileDescription = storeDetail.storeDescription ?? "안녕 난 \(self.nickname)야"
                                        self.initialProfileDescription = self.profileDescription
                                        
                                        self.profileImageURL = storeDetail.storePhoto ?? "profile_market"
                                        self.initialProfileImageURL = self.profileImageURL
                                        
                                        self.coverImageURL = storeDetail.storeCover ?? "profile_market"
                                        self.initialCoverImageURL = self.coverImageURL
                                        
                                        self.selectedGenres = storeDetail.genrePreferences.map {
                                            GenreNameModel(id: $0.genreId, name: $0.genreName)
                                        }
                                        self.initialGenres = self.selectedGenres
                                    }
                                case .failure(let error):
                                    self.errorMessage = error.errorDescription
                                }
                            }
                        }
                    } else {
                        isLoading = false
                        errorMessage = "스토어 ID를 가져오는데 실패했습니다."
                    }
                case .failure(let error):
                    isLoading = false
                    errorMessage = error.errorDescription
                }
            }
        }
    }

    func saveProfile() {
        isLoading = true
        errorMessage = nil

        Task {
            if let selectedImage = selectedProfileImage {
                let imageName = UUID().uuidString + ".jpg"
                let presignedResult = await NetworkService.shared.presignedService.getPresignedURL(imageNameList: [imageName])

                switch presignedResult {
                case .success(let response):
                    guard let uploadURL = response.data?.productPresignedUrls[imageName],
                          let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
                        self.errorMessage = "이미지 데이터 생성 혹은 Presigned URL 파싱 실패"
                        self.isLoading = false
                        return
                    }

                    let uploadResult = await NetworkService.shared.presignedService.putPresignedURL(url: uploadURL, imageData: imageData)

                    switch uploadResult {
                    case .success:
                        self.logger.info("✅ 프로필 이미지 업로드 성공")
                        let finalImageURL = uploadURL.components(separatedBy: "?").first ?? uploadURL
                        self.profileImageURL = finalImageURL
                        // 이후 커버 이미지 업로드 체크
                        await uploadCoverImageIfNeeded()
                    case .failure(let error):
                        self.logger.error("❌ 프로필 이미지 업로드 실패: \(error.localizedDescription)")
                        self.errorMessage = "이미지 업로드에 실패했습니다."
                        self.isLoading = false
                    }

                case .failure(let error):
                    self.logger.error("❌ Presigned URL 요청 실패: \(error.localizedDescription)")
                    self.errorMessage = "이미지 업로드 URL 요청 실패"
                    self.isLoading = false
                }
            } else {
                await uploadCoverImageIfNeeded()
            }
        }
    }
    
    private func uploadCoverImageIfNeeded() async {
        if let selectedCoverImage = selectedCoverImage {
            let imageName = UUID().uuidString + ".jpg"
            let presignedResult = await NetworkService.shared.presignedService.getPresignedURL(imageNameList: [imageName])

            switch presignedResult {
            case .success(let response):
                guard let uploadURL = response.data?.productPresignedUrls[imageName],
                      let imageData = selectedCoverImage.jpegData(compressionQuality: 0.8) else {
                    self.errorMessage = "커버 이미지 데이터 생성 혹은 Presigned URL 파싱 실패"
                    self.isLoading = false
                    return
                }

                let uploadResult = await NetworkService.shared.presignedService.putPresignedURL(url: uploadURL, imageData: imageData)

                switch uploadResult {
                case .success:
                    self.logger.info("✅ 커버 이미지 업로드 성공")
                    let finalImageURL = uploadURL.components(separatedBy: "?").first ?? uploadURL
                    self.coverImageURL = finalImageURL
                    continueProfileUpdate()
                case .failure(let error):
                    self.logger.error("❌ 커버 이미지 업로드 실패: \(error.localizedDescription)")
                    self.errorMessage = "커버 이미지 업로드에 실패했습니다."
                    self.isLoading = false
                }

            case .failure(let error):
                self.logger.error("❌ Presigned URL 요청 실패: \(error.localizedDescription)")
                self.errorMessage = "커버 이미지 업로드 URL 요청 실패"
                self.isLoading = false
            }
        } else {
            continueProfileUpdate()
        }
    }

    private func continueProfileUpdate() {
        logger.info("프로필 업데이트 요청 시작")

        let request = StoreModifyProfileRequestDTO(
            storeCover: coverImageURL,
            storePhoto: profileImageURL,
            storeNickName: nickname,
            storeDescription: profileDescription,
            preferredGenreList: selectedGenres.map { $0.id }
        )

        Task {
            let result = await storeService.modifyProfile(request: request)

            await MainActor.run {
                isLoading = false

                switch result {
                case .success:
                    isSuccess = true
                    logger.info("✅ 프로필 업데이트 성공")
                case .failure(let error):
                    errorMessage = error.errorDescription
                    logger.error("❌ 프로필 업데이트 실패: \(error.errorDescription ?? "알 수 없음")")
                }
            }
        }
    }
}

extension ProfileEditViewModel {
    private func setupSubscriptions() {
        Publishers.CombineLatest4($nickname, $profileDescription, $selectedGenres, $validationState)
            .sink { [weak self] (nickname, description, genres, validation) in
                self?.checkForChanges()
            }
            .store(in: &cancellables)
    }
    
    
    func checkForChanges() {
        let hasNicknameChanged = nickname != initialNickname
        let hasDescriptionChanged = profileDescription != initialProfileDescription
        let hasGenresChanged = selectedGenres != initialGenres
        let hasProfileImageChanged = selectedProfileImage != nil
        let hasCoverImageChanged = selectedCoverImage != nil
        
        print("변경 상태: nickname=\(hasNicknameChanged), description=\(hasDescriptionChanged), genres=\(hasGenresChanged), profileImage=\(hasProfileImageChanged), coverImage=\(hasCoverImageChanged)")
        
        let hasAnyChange = hasNicknameChanged || hasDescriptionChanged ||
        hasGenresChanged || hasProfileImageChanged || hasCoverImageChanged
        
        if hasAnyChange {
            if hasNicknameChanged {
                if validationState == .valid {
                    isPrimaryButtonEnabled = true
                } else if validationState == .empty {
                    isPrimaryButtonEnabled = false
                }
            } else {
                isPrimaryButtonEnabled = true
            }
        } else {
            isPrimaryButtonEnabled = false
        }
        
        print("버튼 상태: \(isPrimaryButtonEnabled)")
    }
}

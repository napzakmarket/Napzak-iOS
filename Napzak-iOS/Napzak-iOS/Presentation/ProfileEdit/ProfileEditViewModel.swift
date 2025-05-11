//
//  ProfileEditViewModel.swift
//  Napzak-iOS
//
//  Created by 어진 on 5/6/25.
//

import SwiftUI
import Combine

final class ProfileEditViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var profileDescription: String = ""
    @Published var selectedGenres: [GenreNameModel] = []
    @Published var isPrimaryButtonEnabled: Bool = false
    @Published var validationState: UsernameValidation = .empty
    private var isRequesting: Bool = false
    
    // Profile image and cover
    @Published var profileImageURL: String = ""
    @Published var coverImageURL: String = ""
    
    // API states
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isSuccess: Bool = false
    
    private let storeService: StoreServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(storeService: StoreServiceProtocol = StoreService()) {
        self.storeService = storeService
            
        // Fetch the current profile data
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
            // Get store ID first
            let myPageResult = await storeService.getMyPageInfo()
            
            await MainActor.run {
                switch myPageResult {
                case .success(let response):
                    if let storeId = response.data?.storeId {
                        // Get store details
                        Task {
                            let detailResult = await storeService.getStoreDetail(storeId: storeId)
                            
                            await MainActor.run {
                                isLoading = false
                                
                                switch detailResult {
                                case .success(let detailResponse):
                                    if let storeDetail = detailResponse.data {
                                        // Fill in the current profile data
                                        self.nickname = storeDetail.storeNickName
                                        self.profileDescription = storeDetail.storeDescription
                                        self.profileImageURL = storeDetail.storePhoto
                                        self.coverImageURL = storeDetail.storeCover
                                        
                                        // Convert GenreDTO to GenreNameModel
                                        self.selectedGenres = storeDetail.genrePreferenceList.map { dto in
                                            GenreNameModel(id: dto.genreId, name: dto.genreName)
                                        }
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
        
        // 닉네임 디버그 출력
        print("저장 시도: 닉네임=\(nickname), 설명=\(profileDescription), 장르 개수=\(selectedGenres.count)")
        
        // 필드명 수정: genrePreferenceList → preferredGenreList
        let request = StoreModifyProfileRequestDTO(
            storeCover: coverImageURL,
            storePhoto: profileImageURL,
            storeNickName: nickname,
            storeDescription: profileDescription,
            preferredGenreList: selectedGenres.map { $0.id }
        )
        
        Task {
            print("API Request: \(request)")
            
            let result = await storeService.modifyProfile(request: request)
            
            await MainActor.run {
                isLoading = false
                
                switch result {
                case .success:
                    isSuccess = true
                    // 디버깅 로그 추가
                    print("프로필 업데이트 성공")
                case .failure(let error):
                    errorMessage = error.errorDescription
                    // 에러 디버깅을 위해 로깅
                    print("API Error: \(error.errorDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    // 이미지 업로드 기능 (구현 필요)
    func uploadProfileImage() {
        // TODO: 이미지 업로드 구현
    }
    
    func uploadCoverImage() {
        // TODO: 이미지 업로드 구현
    }
}

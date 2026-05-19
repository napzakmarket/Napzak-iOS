//
//  DefaultPhoneVerificationRepository.swift
//  Napzak-iOS
//
//  Created by 조호근 on 4/26/26.
//

import Foundation

struct DefaultPhoneVerificationRepository: PhoneVerificationRepository {
    private let remoteDataSource: PhoneVerificationRemoteDataSource

    private enum VerificationOperation {
        case fetchStatus
        case requestCode
        case verifyCode
    }

    init(remoteDataSource: PhoneVerificationRemoteDataSource = DefaultPhoneVerificationRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchStatus() async -> Result<PhoneVerificationStatus, PhoneVerificationError> {
        let result = await remoteDataSource.fetchStatus()

        switch result {
        case .success(let response):
            guard let data = response.data else {
                return .failure(.unknown("번호 인증 상태 응답 데이터가 비어 있습니다."))
            }

            return .success(
                PhoneVerificationStatus(isPhoneVerified: data.isPhoneVerified)
            )

        case .failure(let error):
            return .failure(mapError(error, operation: .fetchStatus))
        }
    }

    func requestCode(for phoneNumber: String) async -> Result<PhoneVerificationCodeSendResult, PhoneVerificationError> {
        let result = await remoteDataSource.sendCode(phoneNumber: phoneNumber)

        switch result {
        case .success(let response):
            guard let data = response.data else {
                return .failure(.unknown("인증번호 발송 응답 데이터가 비어 있습니다."))
            }

            return .success(
                PhoneVerificationCodeSendResult(
                    remainingRequestCount: data.remainingRequestCount
                )
            )

        case .failure(let error):
            return .failure(mapError(error, operation: .requestCode))
        }
    }

    func verifyCode(_ code: String, phoneNumber: String) async -> Result<PhoneVerificationCodeVerificationResult, PhoneVerificationError> {
        let result = await remoteDataSource.verifyCode(
            phoneNumber: phoneNumber,
            code: code
        )

        switch result {
        case .success(let response):
            guard let data = response.data else {
                return .failure(.unknown("인증번호 검증 응답 데이터가 비어 있습니다."))
            }

            return .success(
                PhoneVerificationCodeVerificationResult(
                    isCodeMatched: data.isCodeMatched,
                    remainingRequestCount: data.remainingRequestCount
                )
            )

        case .failure(let error):
            return .failure(mapError(error, operation: .verifyCode))
        }
    }
}

private extension DefaultPhoneVerificationRepository {
    private func mapError(_ error: NetworkError, operation: VerificationOperation) -> PhoneVerificationError {
        switch error {
        case .conflict:
            switch operation {
            case .requestCode:
                return .alreadyRegisteredPhoneNumber
            case .fetchStatus, .verifyCode:
                return .unknown(error.errorDescription ?? "알 수 없는 번호 인증 오류가 발생했습니다.")
            }

        case .tooManyRequests:
            switch operation {
            case .requestCode:
                return .requestLimitExceeded
            case .verifyCode:
                return .tooManyVerificationAttempts
            case .fetchStatus:
                return .unknown(error.errorDescription ?? "알 수 없는 번호 인증 오류가 발생했습니다.")
            }

        case .unauthorized:
            return .unauthorized

        case .networkFail:
            return .networkDisconnected

        case .apiError(let message):
            if message.contains("이미 가입된 번호입니다.") {
                return .alreadyRegisteredPhoneNumber
            }

            if message.contains("이미 번호 인증이 완료된 회원입니다.") {
                return .alreadyVerifiedMember
            }

            if message.contains("가입을 진행할 수 없습니다. 문의사항은 고객센터로 연락해주세요.") {
                return .blockedPhoneNumber
            }

            if message.contains("오늘 인증번호 요청 가능 횟수를 초과했습니다.") {
                return .requestLimitExceeded
            }

            if message.contains("인증번호가 만료되었거나 존재하지 않습니다. 다시 요청해주세요.") {
                return .expiredOrMissingSession
            }

            if message.contains("인증번호를 여러 번 잘못 입력하셨습니다. 인증번호를 재요청해주세요.") {
                return .tooManyVerificationAttempts
            }

            if message.contains("필수 데이터가 누락되었습니다.")
                || message.contains("잘못된 데이터 형식입니다.")
                || message.contains("잘못된 요청 형식입니다.") {
                return .invalidRequest(message)
            }

            return .unknown(message)

        default:
            return .unknown(error.errorDescription ?? "알 수 없는 번호 인증 오류가 발생했습니다.")
        }
    }
}

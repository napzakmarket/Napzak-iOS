//
//  OnboardingManagerTests.swift
//  Napzak-iOSTests
//
//  Created by 조호근 on 8/30/25.
//

import Testing
@testable import Napzak_iOS
import Foundation

@MainActor
struct OnboardingManagerTests {

    private func makeTestDefaults(suiteName: String = UUID().uuidString) -> UserDefaults {
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }

    private func cleanupUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "onboarding_Checkpoint")
        defaults.removeObject(forKey: "onboarding_LastActive")
    }

    @Test("시나리오 1: 온보딩 완료 후 24시간이 경과한 경우, 상태가 유지되어야 한다")
    func getLastCheckpoint_whenCompletedAndOver24Hours() throws {
        // given
        cleanupUserDefaults()
        let twentyFiveHoursAgo = Calendar.current.date(byAdding: .hour, value: -30, to: Date())!
        UserDefaults.standard.set(OnboardingStep.completed.rawValue, forKey: "onboarding_Checkpoint")
        UserDefaults.standard.set(twentyFiveHoursAgo, forKey: "onboarding_LastActive")

        // when
        let checkpoint = OnboardingManager.shared.getLastCheckpoint()

        // then
        #expect(checkpoint == .completed, "온보딩을 완료한 사용자는 24시간이 지나도 .completed 상태가 유지되어야 합니다.")
        
        // teardown
        cleanupUserDefaults()
    }

    @Test("시나리오 2: 온보딩 미완료 상태로 24시간이 경과한 경우, 정보가 초기화되어야 한다")
    func getLastCheckpoint_whenNotCompletedAndOver24Hours() throws {
        // given
        cleanupUserDefaults()
        let twentyFiveHoursAgo = Calendar.current.date(byAdding: .hour, value: -25, to: Date())!
        UserDefaults.standard.set(OnboardingStep.username.rawValue, forKey: "onboarding_Checkpoint")
        UserDefaults.standard.set(twentyFiveHoursAgo, forKey: "onboarding_LastActive")

        // when
        let checkpoint = OnboardingManager.shared.getLastCheckpoint()

        // then
        #expect(checkpoint == nil, "온보딩을 완료하지 않은 사용자는 24시간이 지나면 nil을 반환해야 합니다.")
        
        let isKeyRemoved = UserDefaults.standard.string(forKey: "onboarding_Checkpoint") == nil
        #expect(isKeyRemoved, "24시간이 지난 온보딩 데이터는 UserDefaults에서 삭제되어야 합니다.")
        
        // teardown
        cleanupUserDefaults()
    }
    
    @Test("시나리오 3: 온보딩 미완료 상태이고 24시간 이내인 경우, 마지막 단계가 유지되어야 한다")
    func getLastCheckpoint_whenNotCompletedAndWithin24Hours() throws {
        // given
        cleanupUserDefaults()
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: Date())!
        UserDefaults.standard.set(OnboardingStep.username.rawValue, forKey: "onboarding_Checkpoint")
        UserDefaults.standard.set(oneHourAgo, forKey: "onboarding_LastActive")
        
        // when
        let checkpoint = OnboardingManager.shared.getLastCheckpoint()
        
        // then
        #expect(checkpoint == .username, "24시간이 지나지 않았을 경우, 마지막 온보딩 단계가 유지되어야 합니다.")
        
        // teardown
        cleanupUserDefaults()
    }
    
    @Test("시나리오 4: 저장된 온보딩 정보가 없는 경우, nil을 반환해야 한다")
    func getLastCheckpoint_whenNoCheckpointSaved() throws {
        // given
        cleanupUserDefaults()
        
        // when
        let checkpoint = OnboardingManager.shared.getLastCheckpoint()
        
        // then
        #expect(checkpoint == nil, "저장된 온보딩 정보가 없으면 nil을 반환해야 합니다.")
    }

    @Test("시나리오 5: 마지막 체크포인트에 맞춰 이전 온보딩 화면 스택이 복원되어야 한다")
    func restorationPath_matchesExpectedOnboardingStack() throws {
        #expect(OnboardingStep.terms.restorationPath == [.terms])
        #expect(OnboardingStep.phoneVerification.restorationPath == [.terms, .phoneVerification])
        #expect(OnboardingStep.username.restorationPath == [.terms, .phoneVerification, .username])
        #expect(OnboardingStep.genre.restorationPath == [.terms, .phoneVerification, .username, .genre])
        #expect(OnboardingStep.completed.restorationPath == [.completed])
    }

    @Test("시나리오 6: 앱 첫 실행으로 판단되면 Keychain 정리 로직이 한 번 실행되어야 한다")
    func clearKeychainIfNeededOnFirstLaunch_whenMarkerMissing() throws {
        let defaults = makeTestDefaults()
        var clearCallCount = 0
        let manager = AppInstallStateManager(
            defaults: defaults,
            keychainClearAction: {
                clearCallCount += 1
                return .success(())
            }
        )

        let result = manager.clearKeychainIfNeededOnFirstLaunch()

        switch result {
        case .success(let didClear):
            #expect(didClear)
        case .failure(let error):
            Issue.record("Expected success but received \(error)")
        }

        #expect(clearCallCount == 1, "첫 실행 시 Keychain 정리 로직이 정확히 한 번 호출되어야 합니다.")
        #expect(
            defaults.bool(forKey: "app_HasLaunchedBefore"),
            "첫 실행 처리 후에는 다음 실행을 구분할 수 있도록 마커가 저장되어야 합니다."
        )
    }

    @Test("시나리오 7: 이미 실행 마커가 있으면 Keychain 정리 로직이 다시 호출되지 않아야 한다")
    func clearKeychainIfNeededOnFirstLaunch_whenMarkerExists() throws {
        let defaults = makeTestDefaults()
        defaults.set(true, forKey: "app_HasLaunchedBefore")
        var clearCallCount = 0
        let manager = AppInstallStateManager(
            defaults: defaults,
            keychainClearAction: {
                clearCallCount += 1
                return .success(())
            }
        )

        let result = manager.clearKeychainIfNeededOnFirstLaunch()

        switch result {
        case .success(let didClear):
            #expect(didClear == false)
        case .failure(let error):
            Issue.record("Expected success but received \(error)")
        }

        #expect(clearCallCount == 0, "재실행에서는 Keychain 정리 로직이 호출되지 않아야 합니다.")
    }

    @Test("시나리오 8: Keychain 정리에 실패하면 실행 마커를 저장하지 않아야 한다")
    func clearKeychainIfNeededOnFirstLaunch_whenCleanupFails() throws {
        let defaults = makeTestDefaults()
        let manager = AppInstallStateManager(
            defaults: defaults,
            keychainClearAction: {
                .failure(.keychainError)
            }
        )

        let result = manager.clearKeychainIfNeededOnFirstLaunch()

        switch result {
        case .success:
            Issue.record("Expected failure but received success")
        case .failure(let error):
            if case .keychainError = error {
                break
            } else {
                Issue.record("Expected keychainError but received \(error)")
            }
        }

        #expect(
            defaults.object(forKey: "app_HasLaunchedBefore") == nil,
            "정리에 실패한 경우에는 다음 실행에서 재시도할 수 있도록 마커가 저장되면 안 됩니다."
        )
    }
}

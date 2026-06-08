//
//  MicrophonePermissionManager.swift
//  Shandi
//

import AVFoundation
import UIKit
import Observation

@Observable
final class MicrophonePermissionManager {

    /// Set to true to surface the "go to Settings" alert in the UI.
    var showDeniedAlert: Bool = false

    // MARK: - Public API

    /// Call this when the mic button is tapped.
    /// - Parameter onGranted: Closure executed only when access is confirmed.
    func requestPermission(onGranted: @escaping () -> Void) {
        if #available(iOS 17.0, *) {
            handlePermission(
                current: AVAudioApplication.shared.recordPermission,
                request: { completion in
                    AVAudioApplication.requestRecordPermission(completionHandler: completion)
                },
                onGranted: onGranted
            )
        } else {
            handlePermission(
                current: mapLegacyPermission(AVAudioSession.sharedInstance().recordPermission),
                request: { completion in
                    AVAudioSession.sharedInstance().requestRecordPermission(completion)
                },
                onGranted: onGranted
            )
        }
    }

    /// Opens the app's page in iOS Settings so the user can change the permission.
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    // MARK: - Private helpers

    private func handlePermission(
        current: AVAudioApplication.recordPermission,
        request: @escaping (@escaping (Bool) -> Void) -> Void,
        onGranted: @escaping () -> Void
    ) {
        switch current {
        case .granted:
            onGranted()
        case .undetermined:
            request { [weak self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        onGranted()
                    } else {
                        self?.showDeniedAlert = true
                    }
                }
            }
        case .denied:
            showDeniedAlert = true
        @unknown default:
            showDeniedAlert = true
        }
    }

    /// Maps the legacy `AVAudioSession.RecordPermission` to the modern type so we share one code path.
    @available(iOS, deprecated: 17.0)
    private func mapLegacyPermission(_ perm: AVAudioSession.RecordPermission) -> AVAudioApplication.recordPermission {
        switch perm {
        case .granted:      return .granted
        case .denied:       return .denied
        case .undetermined: return .undetermined
        @unknown default:   return .undetermined
        }
    }
}


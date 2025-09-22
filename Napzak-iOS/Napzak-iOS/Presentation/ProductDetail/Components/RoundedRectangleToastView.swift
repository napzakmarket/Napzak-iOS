//
//  RoundedRectangleToastView.swift
//  Napzak-iOS
//
//  Created by 조혜린 on 5/8/25.
//

import SwiftUI

enum ToastType {
    case productStatusChanged(statusString: String)
    case productDeleted
    case productEdited
    case chatRoomExited
    case userBlocked
    case userUnblocked
    
    var icon: Image? {
        switch self {
        case .productDeleted: return Image(.iconDeleteToast)
        case .chatRoomExited: return nil
        case .userBlocked: return Image(.iconBlockToast)
        case .userUnblocked: return Image(.iconUnblockToast)
        default: return Image(.iconStatusToast)
        }
    }
    
    var message: String {
        switch self {
        case .productStatusChanged(let string): return "상품 상태를 \"\(string)\"으로 변경하였습니다."
        case .productDeleted: return "상품이 삭제되었습니다."
        case .productEdited: return "수정이 완료되었습니다."
        case .chatRoomExited: return "해당 채팅방을 나간 상태입니다."
        case .userBlocked: return "마켓을 차단했어요."
        case .userUnblocked: return "마켓 차단을 해제했어요."
        }

    }
}

struct RoundedRectangleToastView: View {
    
    //MARK: - Properties

    let type: ToastType
    
    //MARK: - Body
    
    var body: some View {
        HStack(spacing: 6) {
            type.icon
            Text(type.message)
                .applyNapzakFont(.body5SemiBold14)
                .foregroundStyle(Color.napzakGrayScale(.white))
                .frame(height: 18)
        }
        .padding(.vertical, 13)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.napzakTransparency(.transBlack))
        )
        .padding(.horizontal, 37)
    }
}

#Preview {
    RoundedRectangleToastView(type: .productStatusChanged(statusString: "판매중"))
}

//
//  ReportView.swift
//  Napzak-iOS
//
//  Created by OneTen on 4/18/25.
//

import SwiftUI

enum ReportType {
    case product
    case market
    
    var title: String {
        switch self {
        case .product:
            return "상품"
        case .market:
            return "마켓"
        }
    }
    
    var reportReasons: [String] {
        switch self {
        case .product:
            return [
                "거래 금지 상품을 판매하고 있어요",
                "부적절한 콘텐츠를 포함하고 있어요",
                "허위/과장 정보 및 광고를 포함하고 있어요",
                "욕설/비속어 등 불쾌한 표현을 사용했어요",
                "거래 과정에서 분쟁이 발생했어요",
                "기타 문제가 있어요"
            ]
        case .market:
            return [
                "비매너 마켓이에요",
                "사기 행위가 의심돼요",
                "거래 과정에서 분쟁이 발생했어요",
                "욕설/비속어 등 불쾌한 표현을 사용했어요",
                "기타 문제가 있어요"
            ]
        }
    }
}

struct ReportView: View {
    @Binding var reportType: ReportType
    @State private var reasonExpanded: Bool = false
    @State private var selectedReason: String = ""
    @State private var reportDescription: String = ""
    @State private var contactAddress: String = ""
    @State private var showToast: Bool = false
    
    private let reportDescriptionPlaceholder = "어떤 일이 있었나요? 💬 \n\n자세한 설명일수록 빠른 해결에 도움이 됩니다. \n신고 내용은 비공개로 안전하게 처리되니 안심하세요. \n안전한 거래 공간을 함께 만들어가요!"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            reportHeader
            ScrollView {
                selectReportReason
                separator
                reportDescriptionSection
                separator
                contactAddressSection
            }
            submitReportButton
        }
        .overlay(
            Group {
                if showToast {
                    toastView
                }
            },
            alignment: .bottom
        )
        .animation(.easeInOut(duration: 0.3), value: showToast)
        .ignoresSafeArea()
    }
}

extension ReportView {
    private var reportHeader: some View {
        VStack(alignment: .leading) {
            Image(.iconBack)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 16, height: 10)
                .padding(.top, 62)
                .padding(.bottom, 22)
                .padding(.leading, 28)
                .onTapGesture {
                    print("backButton tapped")
                }
            
            Divider()
        }
        .frame(height: 100)
    }
    
    private var selectReportReason: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(reportType.title)을 신고하는 이유를 알려주세요")
                .applyNapzakFont(.title2Bold20)
                .foregroundStyle(Color.napzakGrayScale(.black))
                .frame(height: 27)
                .padding(.bottom, 30)
            
            Text("신고 사유")
                .applyNapzakFont(.body5SemiBold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    Text(selectedReason)
                        .applyNapzakFont(.caption1SemiBold12)
                        .foregroundStyle(Color.napzakGrayScale(.gray300))
                        .frame(height: 15)
                    
                    Spacer()
                    
                    Image(systemName: reasonExpanded ? "chevron.up" : "chevron.down")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 10, height: 6)
                        .foregroundColor(Color.napzakGrayScale(.gray200))
                }
                .padding(.leading, 16)
                .padding(.trailing, 20)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.napzakGrayScale(.gray200))
                )
                .onTapGesture {
                    reasonExpanded.toggle()
                }
                .onAppear {
                    selectedReason = reportType.reportReasons.first ?? ""
                }
                
                if reasonExpanded {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(
                            reportType.reportReasons,
                            id: \.self
                        ) { reason in
                            Button(action: {
                                selectedReason = reason
                                reasonExpanded = false
                            }) {
                                Text(reason)
                                    .applyNapzakFont(
                                        reason == selectedReason ? .caption1SemiBold12 : .caption2Medium12)
                                    .foregroundColor(reason == selectedReason ? Color
                                        .napzakPrimary(.purple500) : Color
                                        .napzakGrayScale(.gray300))
                                    .frame(height: 15)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 17)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.napzakGrayScale(.gray200))
            )
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 30)
        .padding(.top, 40)
    }
    
    private var separator: some View {
        Rectangle()
            .fill(Color.napzakGrayScale(.gray10))
            .frame(height: 4)
            .padding(.bottom, 30)
    }
    
    private var reportDescriptionSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("상세 내용")
                .applyNapzakFont(.body5SemiBold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .padding(.bottom, 16)
            
            ZStack(alignment: .topLeading){
                TextEditor(text: $reportDescription)
                    .maxLength(200, text: $reportDescription)
                    .applyNapzakFont(.caption1SemiBold12)
                    .foregroundStyle(Color.napzakGrayScale(.gray400))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 7)
                
                if reportDescription.isEmpty {
                    Text(reportDescriptionPlaceholder)
                        .applyNapzakFont(.caption1SemiBold12)
                        .foregroundStyle(Color.napzakGrayScale(.gray200))
                        .lineLimit(5)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                }
            }
            .frame(height: 180)
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.napzakGrayScale(.gray100), lineWidth: 1)
            }
            
            HStack(spacing: 0) {
                Spacer()
                Text(reportDescription.count.description)
                    .applyNapzakFont(.caption1SemiBold10)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
                
                Text("/430")
                    .applyNapzakFont(.caption1SemiBold10)
                    .foregroundStyle(Color.napzakGrayScale(.gray300))
            }
            .padding(.top, 8)
            .frame(height: 13)
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 8)
    }
    
    private var contactAddressSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("연락처 입력")
                .applyNapzakFont(.body5SemiBold14)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .frame(height: 18)
                .padding(.bottom, 16)
            
            TextField("신고 검토결과를 받아볼 이메일 또는 전화번호를 알려주세요", text: $contactAddress)
                .applyNapzakFont(.caption2Medium12)
                .foregroundStyle(Color.napzakGrayScale(.gray500))
                .padding(.horizontal, 16)
                .padding(.vertical, 17)
                .frame(height: 50)
                .background {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.napzakGrayScale(.gray50))
                }
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 30)

    }
    
    private var submitReportButton: some View {
        Button {
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                showToast = false
            }
        } label: {
            Text("제출하기")
                .applyNapzakFont(.body4Bold14)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 50)
        }
        .background(Color.napzakGrayScale(.gray100))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 28)
        .padding(.top, 18)
        .padding(.bottom, 68)
    }
    
    private var toastView: some View {
        VStack {
            Spacer()
            Text("소중한 신고 감사합니다! 🙏\n\n신고 내용을 꼼꼼히 검토하여 \n입력하신 연락처로 결과를 안내해드릴게요.\n추가 정보가 필요할 경우 동일한 연락처로 문의드릴 수 있어요.")
                .applyNapzakFont(.caption1SemiBold12)
                .foregroundColor(Color.napzakGrayScale(.white))
                .multilineTextAlignment(.center)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.6))
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 143)
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var reportType: ReportType = .market
        
        var body: some View {
            ReportView(reportType: $reportType)
        }
    }
    
    return PreviewContainer()
}

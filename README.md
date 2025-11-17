# 메디루트 (MediRoute) 🏥🗺️

AI 증상 분석으로 내 주변 최적의 병원 찾기

갑자기 몸이 아플 때, 어느 병원에 가야 할지 막막했던 경험이 있으신가요? 메디루트는 사용자가 입력한 증상을 Gemini AI로 분석하여 가장 적합한 진료과와 주변 병원을 추천하고, 카카오맵을 통해 위치를 바로 확인할 수 있도록 돕는 모바일 앱입니다.

---

### 📸 주요 화면 (Screenshots)
| 증상 입력 | 분석 결과 | 지도 |
|:---:|:---:|:---:|
| <img src="https://raw.githubusercontent.com/your-repo/mediroute/main/screenshots/symptom.png" width="250"> | <img src="https://raw.githubusercontent.com/your-repo/mediroute/main/screenshots/result.png" width="250"> | <img src="https://raw.githubusercontent.com/your-repo/mediroute/main/screenshots/map.png" width="250"> |

### ▶️ 시연 영상 (Demo Video)

---

### ✨ 주요 기능 (Features)
- **🤖 AI 증상 분석**: 사용자가 자신의 증상을 자유롭게 입력하면, Gemini AI가 내용을 분석하여 관련성이 높은 진료과를 추천합니다.
- **🏥 주변 병원 검색**: 분석된 진료과를 기반으로, 공공데이터 API를 통해 사용자 주변에 있는 병원 목록을 카카오 지도로 제공합니다.
- **🗺️ 지도 기반 위치 확인**: 검색된 병원들의 위치를 카카오맵 위에 마커로 표시하여 사용자가 시각적으로 쉽게 위치를 파악할 수 있도록 돕습니다.
- **📜 진료 기록 관리**: 과거에 검색했던 증상과 추천받았던 병원 기록을 조회하여 언제든지 다시 확인 및 주위 병원 조회를 할 수 있습니다.

---

### 🛠️ 기술 스택 및 아키텍처 (Tech Stack & Architecture)
이 프로젝트는 최신 iOS 앱 개발 트렌드를 따르며, 확장성과 유지보수성을 중심으로 설계되었습니다.

#### 아키텍처 (Architecture)
- **Clean Architecture**: Presentation - Domain - Data 3개의 계층으로 역할을 명확히 분리하여 의존성을 최소화하고 테스트 용이성을 높였습니다.
- **MVVM (Model-View-ViewModel)**: Presentation Layer에서 UI의 상태 관리와 비즈니스 로직을 분리하기 위해 사용했습니다.
- **Repository Pattern**: 데이터 소스를 추상화하여 데이터 접근 방식을 일원화하고, 데이터 출처가 변경되어도 Domain 계층이 영향을 받지 않도록 설계했습니다.
- **Dependency Injection (DI)**: `DIContainer`를 통해 각 계층의 의존성을 외부에서 주입하여 모듈 간의 결합도를 낮추고 유연성을 확보했습니다.

#### 사용된 기술 (Tech Stack)
- **Language**: Swift
- **UI**: SwiftUI
- **Asynchronicity**: Swift Concurrency (async/await)
- **Architecture**: ViewModel, Lifecycle
- **DI**: Manual Dependency Injection
- **AI**: Google Generative AI SDK (Gemini)
- **Map**: Kakao Maps SDK
- **Networking**: URLSession

---

### 📁 파일 구조 (Directory Structure)
프로젝트는 Clean Architecture의 3계층 구조를 기반으로 구성되어 있습니다.
```
.
└── mediroute/
    ├── 📂 Core
    │   └── 📂 Di              (의존성 주입 컨테이너)
    │
    ├── 📂 Data
    │   ├── 📂 RemoteDataSource (API 통신 등 외부 데이터 소스)
    │   └── 📂 Repository      (Data 계층의 Repository 구현체)
    │
    ├── 📂 Domain
    │   ├── 📂 Model           (핵심 비즈니스 모델)
    │   ├── 📂 Repository     (Domain 계층의 Repository 인터페이스)
    │   └── 📂 UseCase         (비즈니스 로직 캡슐화)
    │
    ├── 📂 Presentation
    │   ├── 📂 Views           (SwiftUI로 작성된 화면)
    │   └── 📂 ViewModels      (View의 상태 관리 및 로직 처리)
    │
    ├── 📂 Services             (위치 서비스 등 앱 전역 서비스)
    └── 📂 Resources           (Asset, 이미지 등 리소스)
```

---

본 프로젝트는 SwiftUI, Clean Architecture, Swift Concurrency 등 최신 iOS 기술 스택을 학습하고, Gemini AI와 같은 외부 서비스를 통합하는 전체 개발 프로세스를 경험하기 위해 제작된 개인 포트폴리오용 앱입니다.

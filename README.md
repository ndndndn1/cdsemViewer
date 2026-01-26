# Track-based CD-SEM Data Viewer (v2.5)

본 프로그램은 Track-based CD-SEM 장비에서 추출된 웨이퍼 Top View 데이터를 효율적으로 관리하고 분석하기 위해 개발된 독립적인 연구용 소프트웨어입니다. 복잡한 계층 구조를 가진 계측 데이터(cond.txt)를 자동으로 통합하여 시각화 및 통계적 통찰을 제공합니다.

## 🎯 Aim
    반도체 웨이퍼 Top View 이미지의 체계적 분류 및 정리
    계측 로그 분석을 통한 웨이퍼 내 공간적 분포 시각화

## 🛠 Target & Environment

    대상 장비: Track-based CD-SEM
    개발 환경:
        Python 3.9+ 기반
        패키지 관리: uv (추천)

    필수 의존성:
    pip install numpy PyQt5 xlsxwriter matplotlib pyyaml Pillow pywin32

## 📂 데이터 구조 (Required Directory Structure)

장비에서 추출된 데이터는 아래와 같은 표준 구조를 유지해야 정상적으로 로드됩니다.

Project_Folder
├── ImageName_0001.jpg
├── ImageName_0001.jpg_cnd
│   └── cond.txt (계측 정보 로그)
├── ImageName_0002.jpg
└── ImageName_0002.jpg_cnd
    └── cond.txt

    Option: 레시피 레이아웃이 단일 레이어인 경우, 테이블 형식의 분석 기능을 추가로 활용할 수 있습니다.

## ⚙️ 설정 (Configuration)

    환경 설정: C:\Users\USER\AppData\Local\uv\uv.toml 환경이 클린한 상태에서 최적의 성능을 발휘합니다.
    임계값 설정: subgroups_config.yaml을 통해 계측값(CD)의 범위별 하위 그룹(Subgroup)을 사용자 정의할 수 있습니다.

## 🚀 빌드 가이드 (Release to EXE)

Windows 환경에서 단독 실행 파일(.exe)을 생성
pyinstaller --onefile --windowed --icon=cdsemViewer/ico/cdsem.ico cdsemViewer/cdsem_viewer.py

## 📖 사용 방법 (How to Use)

    실행: cdsemViewer.exe를 구동합니다.
    데이터 로드: 분석할 데이터가 담긴 최상위 폴더를 프로그램 창 위로 드래그 앤 드롭(Drag & Drop)합니다.
    데이터 분석:
        Wafer View: 웨이퍼 맵상의 좌표를 클릭하여 해당 지점의 상세 이미지와 정보를 확인합니다.
        Chip Group View: 동일 칩 번호 내의 이미지들을 그룹화하여 평균 및 편차 통계를 확인합니다.
    리포트 생성: File > Export to Excel 메뉴로 분석 결과(피벗 테이블 포함)를 저장합니다.

## ⚠️ 면책 조항 (Disclaimer)

본 소프트웨어는 연구 목적으로 개발된 독립 도구이며, 특정 장비 제조사와 공식적인 관계가 없습니다. 데이터 파싱 결과에 대한 최종 검증 책임은 사용자에게 있습니다.

## 라이선스


이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

# Docker Container Snapshot & Push Automation (WSL2 Friendly)

이 저장소는 로컬에서 실행 중인 Docker 컨테이너를 자동으로 저장하고,  
Docker Hub에 푸시하며, 동일 환경을 재실행할 수 있는 `.sh` 스크립트를 생성하는 자동화 도구입니다.

> ✅ WSL2 + Docker + Docker Hub 기반 개발 환경에 최적화됨

---

## 📦 주요 기능

- 실행 중인 컨테이너 상태를 이미지로 저장 (`docker commit`)
- Docker Hub에 자동 태깅 및 푸시
- 실행 환경을 복제할 수 있는 `.sh` 실행 스크립트 자동 생성
- 컨테이너 이름을 스크립트 파일명(`snapshot_*.sh`)에서 자동 인식

---

## 🛠 사용 방법

### 1. 사전 준비

- Docker Hub 계정 (`jeonjt` 등)
- 실행 중인 컨테이너 (예: `2lwd_dev`)
- WSL2 환경 또는 리눅스 환경 (줄바꿈: LF)

### 2. 스크립트 복사 및 이름 지정

```bash
cp snapshot_template.sh snapshot_2lwd_dev.sh
chmod +x snapshot_2lwd_dev.sh
```

### 3. 실행

```bash
./snapshot_2lwd_dev.sh
```

실행하면 다음이 자동으로 수행됩니다:
- 컨테이너 상태 저장
- Docker Hub에 `jeonjt/via_test:<컨테이너명>_tag_<날짜>` 형식으로 푸시
- 실행 스크립트 생성: `run_<컨테이너명>_tag_<날짜>.sh`

---

## 📁 예시 결과

```bash
[2lwd_dev] → 이미지 커밋 중 (2lwd_dev_tag_20250326)...
태그 설정: jeonjt/via_test:2lwd_dev_tag_20250326
푸시 중...
실행 스크립트 생성 완료: ./run_2lwd_dev_tag_20250326.sh
```

생성된 실행 스크립트를 통해 동일한 환경을 다음과 같이 재사용할 수 있습니다:

```bash
./run_2lwd_dev_tag_20250326.sh
```

---

## 📜 스크립트 구조 요약

- `snapshot_*.sh`: 컨테이너를 이미지로 저장 및 업로드
- 내부 태그 형식: `<container_name>_tag_<yyyyMMdd>`
- 실행 스크립트: `run_<container_name>_tag_<yyyyMMdd>.sh`

---

## 🧩 커스터마이징

- 실행 스크립트 내 `-v ~/your/data/path:/data` 부분은 실제 경로로 수정 필요
- Docker Hub 레포 이름(`jeonjt/via_test`)도 사용자 환경에 맞게 변경 가능
- GPU 미사용 환경에서는 `--gpus all` 제거 가능

---

## ⚠️ 주의사항

- Windows에서 작성한 `.sh` 파일은 **줄바꿈(LF)** 로 저장되어야 합니다
  - `dos2unix` 명령어 또는 VS Code에서 CRLF → LF로 변경
- Docker Hub 로그인 시 `docker login` 필요 (권한 설정 포함)

---

## 📌 환경 정보

- OS: Windows 11 + WSL2 (Ubuntu 20.04)
- Docker Engine: WSL2 backend
- Shell: Bash (`#!/usr/bin/env bash` 사용)

---

## 📂 예시 디렉토리 구조

```
.
├── snapshot_2lwd_dev.sh
├── run_2lwd_dev_tag_20250326.sh
└── README.md
```

---

## 👨‍💻 Author

- **via@VIA-2102**
- Researcher @ VIA Lab  
- Focused on Vision-Based Autonomous Agricultural Systems

---

## 📜 License

MIT License (또는 연구실 내부용이면 선택 안 함)

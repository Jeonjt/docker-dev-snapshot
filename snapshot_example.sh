#!/usr/bin/env bash

##############################################
# 사용자 정의 영역 - 아래 변수들을 수정하세요
##############################################

# 커밋할 컨테이너 이름 (현재 실행 중인 컨테이너)
CONTAINER_NAME="your_container_name"  # 예: my_dev_container

# Docker Hub에 업로드할 계정/저장소 이름
BASE_IMAGE="your_dockerhub_id/your_repo_name"  # 예: jeonjt/via_test

# 데이터 마운트 경로 (호스트 → 컨테이너)
HOST_DATA_PATH="~/your/data/path"
CONTAINER_DATA_PATH="/data"

##############################################

# 스크립트 자동 처리 영역
DATETIME=$(date +%Y%m%d)
TAG="${CONTAINER_NAME}_tag_${DATETIME}"
LOCAL_IMAGE="${BASE_IMAGE}_${TAG}"
REMOTE_IMAGE="${BASE_IMAGE}:${TAG}"

echo "[${CONTAINER_NAME}] → 이미지 커밋 중 (${TAG})..."
docker commit "${CONTAINER_NAME}" "${LOCAL_IMAGE}" || { echo "커밋 실패"; exit 1; }

echo "태그 설정: ${REMOTE_IMAGE}"
docker tag "${LOCAL_IMAGE}" "${REMOTE_IMAGE}"

echo "Docker Hub 로그인..."
docker login -u $(echo $BASE_IMAGE | cut -d'/' -f1) || { echo "로그인 실패"; exit 1; }

echo "푸시 중..."
docker push "${REMOTE_IMAGE}" || { echo "푸시 실패"; exit 1; }

# 실행 스크립트 자동 생성
RUN_SCRIPT="run_${TAG}.sh"
cat <<EOF > ${RUN_SCRIPT}
#!/bin/bash
docker run -it --rm \
  --name ${CONTAINER_NAME} \
  --gpus all \
  -v ${HOST_DATA_PATH}:${CONTAINER_DATA_PATH} \
  -e DISPLAY=\$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  ${REMOTE_IMAGE}
EOF

chmod +x ${RUN_SCRIPT}
echo "✅ 실행 스크립트 생성 완료: ./${RUN_SCRIPT}"

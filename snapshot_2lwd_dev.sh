#!/usr/bin/env bash

SCRIPT_NAME=$(basename "$0")   # snapshot_*.sh
CONTAINER_NAME=$(echo "$SCRIPT_NAME" | sed -E 's/^snapshot_([^.]+)\.sh$/\1/')

BASE_IMAGE="jeonjt/via_test"
DATETIME=$(date +%Y%m%d)
TAG="${CONTAINER_NAME}_tag_${DATETIME}"
LOCAL_IMAGE="${BASE_IMAGE}_${TAG}"
REMOTE_IMAGE="${BASE_IMAGE}:${TAG}"

echo "[${CONTAINER_NAME}] → 이미지 커밋 중 (${TAG})..."
docker commit "${CONTAINER_NAME}" "${LOCAL_IMAGE}" || { echo "커밋 실패"; exit 1; }

echo "태그 설정: ${REMOTE_IMAGE}"
docker tag "${LOCAL_IMAGE}" "${REMOTE_IMAGE}"

echo "Docker Hub 로그인..."
docker login -u jeonjt || { echo "로그인 실패"; exit 1; }

echo "푸시 중..."
docker push "${REMOTE_IMAGE}" || { echo "푸시 실패"; exit 1; }

RUN_SCRIPT="run_${TAG}.sh"
cat <<EOF > ${RUN_SCRIPT}
#!/bin/bash
docker run -it --rm \\
  --name ${CONTAINER_NAME} \\
  --gpus all \\
  -v ~/your/data/path:/data \\
  -e DISPLAY=\$DISPLAY \\
  -v /tmp/.X11-unix:/tmp/.X11-unix \\
  ${REMOTE_IMAGE}
EOF

chmod +x ${RUN_SCRIPT}
echo "실행 스크립트 생성 완료: ./${RUN_SCRIPT}"


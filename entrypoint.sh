#!/bin/bash

set -e

echo "🚀 Forge WebUI 컨테이너 시작 중..."

cd /workspace/stable-diffusion-webui-forge || {
  echo "❌ WebUI 디렉토리가 없습니다."
  exit 1
}

# root 실행 제한 우회
echo "🔧 webui.sh root 제한 우회 처리 중..."
sed -i '/EUID -eq 0/,/exit 1/s/^/#/' webui.sh
sed -i 's/^\s*echo\s\+-e\s\+"\\?[*A-Za-z0-9_[:space:]]*root[[:space:]]*[^"]*"$/#&/g' webui.sh
sed -i 's/^\s*printf\s\+.*root.*abort.*$/#&/g' webui.sh
sed -i 's/^\s*exit\s\+1/#&/g' webui.sh

# 🔄 JupyterLab 백그라운드 실행
echo "📚 JupyterLab을 포트 8888에서 백그라운드로 실행합니다..."
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser &

# 🌐 WebUI 실행
echo "🌐 WebUI를 포트 7860에서 실행합니다..."
bash webui.sh --listen --port 7860 --xformers

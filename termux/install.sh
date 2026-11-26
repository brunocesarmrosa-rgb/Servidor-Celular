#!/data/data/com.termux/files/usr/bin/bash
# Instala tudo no Termux. Rodar em ~/taikazet
set -e
cd "$(dirname "$0")/.."
source ./config.env

# Espelho oficial (o espelho chinês do aparelho não tem llama-cpp)
echo 'deb https://packages-cf.termux.dev/apt/termux-main stable main' > $PREFIX/etc/apt/sources.list
rm -f $PREFIX/etc/termux/chosen_mirrors 2>/dev/null
yes | pkg update && yes | pkg upgrade
pkg install -y python wget curl openssh termux-api jq
# llama.cpp empacotado pelo Termux (mais rápido que compilar)
pkg install -y llama-cpp || {
  echo "Pacote llama-cpp indisponível, compilando..."
  pkg install -y git cmake clang
  git clone --depth 1 https://github.com/ggml-org/llama.cpp ~/llama.cpp
  cmake -S ~/llama.cpp -B ~/llama.cpp/build -DLLAMA_CURL=OFF
  cmake --build ~/llama.cpp/build --config Release -j"$(nproc)" --target llama-server
  ln -sf ~/llama.cpp/build/bin/llama-server "$PREFIX/bin/llama-server"
}

mkdir -p models logs
[ -f "models/$MODEL_FILE" ] || wget -c -O "models/$MODEL_FILE" "$MODEL_URL"

mkdir -p ~/.termux/boot
cp termux/boot.sh ~/.termux/boot/taikazet.sh && chmod +x ~/.termux/boot/taikazet.sh
chmod +x termux/*.sh
echo "OK: instalação concluída. Modelo: models/$MODEL_FILE"

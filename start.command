#!/bin/sh
# آرمینگرام - اجرای سرور روی macOS با دابل‌کلیک (Finder)
# اگر macOS اجازه نداد: راست‌کلیک > Open. نیازمند Node.js 22.13+ (پیشنهاد: 24 LTS)
cd "$(dirname "$0")"
export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"
if ! command -v node >/dev/null 2>&1; then echo "Node.js نصب نیست. فایل node-v24.x.pkg را نصب کنید."; read _; exit 1; fi
[ -d node_modules ] || npm install --omit=dev
echo "آدرس این Mac در شبکهٔ Wi-Fi:"
ipconfig getifaddr en0 2>/dev/null; ipconfig getifaddr en1 2>/dev/null
PORT="${PORT:-3000}" node src/server.js

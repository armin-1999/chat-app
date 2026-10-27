#!/bin/sh
# اجرای آرمینگرام بدون Docker (لینوکس/مک). نیازمند Node.js 22.13 یا جدیدتر (پیشنهاد: 24 LTS)
cd "$(dirname "$0")"
[ -d node_modules ] || npm install --omit=dev
PORT="${PORT:-3000}" exec node src/server.js

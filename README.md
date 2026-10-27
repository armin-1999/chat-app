# آرمینگرام (Armingram)

پیام‌رسان سبک و خودمیزبان شبیه تلگرام، مخصوص زمانی که **اینترنت بین‌الملل قطع است**.
همه‌چیز روی سرور خودتان اجرا می‌شود (لپ‌تاپ/Mac در شبکهٔ محلی یا یک VPS ایرانی) و در زمان اجرا **به هیچ سرویس خارجی وابسته نیست**: بدون CDN، بدون فونت گوگل، بدون Firebase، بدون پیامک.

## امکانات

- ثبت‌نام و ورود با **شماره موبایل + رمز ثابت** (بدون پیامک). شماره‌هایی مثل `09123456789`، `+989123456789` و ارقام فارسی `۰۹۱۲...` خودکار یکسان می‌شوند.
- رمزها با **bcrypt** ذخیره می‌شوند؛ نشست با کوکی امن `httpOnly` (JWT). تغییر رمز، همهٔ نشست‌های دیگر را باطل می‌کند.
- پروفایل (نام نمایشی)، جستجوی کاربر با شماره
- گفتگوی خصوصی، **گروه** (ساخت، افزودن عضو، تغییر نام، ترک گروه)
- پیام‌رسانی **لحظه‌ای با WebSocket**، تیک خوانده‌شدن (✓ / ✓✓)، «در حال نوشتن…»
- نشانگر **پیام‌های خوانده‌نشده**، وضعیت **آنلاین** و «آخرین بازدید»
- ارسال **عکس و فایل** (ذخیره روی دیسک خود سرور؛ فقط اعضای گفتگو دسترسی دارند)
- ذخیرهٔ تاریخچه در **SQLite** (داخلی Node.js؛ بدون ماژول native)
- رابط کاربری **فارسی و راست‌به‌چپ** با فونت **وزیرمتن** (لایسنس OFL، داخل برنامه)، واکنش‌گرا برای موبایل، حالت تیره خودکار
- قابل نصب به‌صورت **PWA** (روی HTTPS)

## پیش‌نیاز

- **Node.js نسخهٔ 22.13 یا جدیدتر** (پیشنهاد: **24 LTS**). هیچ ابزار کامپایل، Python یا Xcode لازم نیست.
- یا Docker (برای VPS)

> همهٔ وابستگی‌ها **JavaScript خالص** هستند (`express`, `ws`, `bcryptjs`, `jsonwebtoken`, `multer`, `cookie-parser`) و دیتابیس از `node:sqlite` داخلی Node می‌آید.
> یعنی پوشهٔ `node_modules` بدون تغییر روی **macOS (Intel و Apple Silicon)**، ویندوز و لینوکس کار می‌کند؛ مشکل ناسازگاری معماری که ماژول‌هایی مثل `sqlite3` یا `bcrypt` دارند، این‌جا وجود ندارد.

---

## بخش ۱: شبکهٔ محلی (Wi-Fi) با یک Mac به‌عنوان سرور — مرحله‌به‌مرحله

سناریو: Mac در خانه/محل کار روشن است، ۲–۳ نفر با گوشی به همان Wi-Fi وصل می‌شوند و با مرورگر وارد آرمینگرام می‌شوند. به اینترنت نیازی نیست، فقط به شبکهٔ محلی (مودم/روتر).

### ۱-۱. «قبل از» قطعی اینترنت آماده کنید

روی هر سیستمی که اینترنت دارد:

1. نصب‌کنندهٔ Node.js برای Mac را دانلود کنید: از `https://nodejs.org` فایل **macOS Installer (.pkg)** نسخهٔ **24 LTS** (مثلاً `node-v24.x.x.pkg`). این فایل Universal است و روی Mac‌های Intel و M1/M2/M3 کار می‌کند.
2. بستهٔ برنامه را **همراه با node_modules** آماده کنید (یکی از دو روش):
   - روی خود Mac در پوشهٔ برنامه: `npm install --omit=dev` (یک‌بار، وقتی اینترنت هست)
   - یا روی هر سیستم دیگری: `./scripts/make-offline-node-bundle.sh` ← خروجی `armingram-offline-node.zip` که `node_modules` را دارد.
3. فایل `.pkg` و پوشه/zip برنامه را روی Mac (یا فلش) نگه دارید.

### ۱-۲. نصب Node.js روی Mac (آفلاین)

1. روی `node-v24.x.x.pkg` دابل‌کلیک کنید و مراحل نصب را جلو بروید (رمز کاربر Mac را می‌خواهد).
2. برنامهٔ **Terminal** را باز کنید (Spotlight: `⌘ + Space` و تایپ Terminal) و بررسی کنید:
   ```sh
   node -v      # باید v24... یا حداقل v22.13 باشد
   ```

### ۱-۳. اجرای سرور

zip را باز کنید (مثلاً در `~/armingram`) و در Terminal:

```sh
cd ~/armingram
npm install --omit=dev   # فقط اگر node_modules وجود ندارد (نیاز به اینترنت یا کش npm)
node src/server.js
```

یا ساده‌تر: در Finder روی فایل **`start.command`** دابل‌کلیک کنید. (اگر macOS گفت «از توسعه‌دهندهٔ ناشناس است»: راست‌کلیک ← **Open** ← Open. اگر اجرا نشد، یک‌بار در Terminal بزنید: `chmod +x start.command`)

خروجی چیزی شبیه این است:

```
آرمینگرام (armingram) listening on 0.0.0.0:3000, data dir: /Users/armin/armingram/data
  local:   http://localhost:3000
  network: http://192.168.1.105:3000
```

آدرس خط `network` همان آدرسی است که گوشی‌ها باید باز کنند. **پنجرهٔ Terminal را نبندید** (بستن آن = خاموش شدن سرور).

### ۱-۴. پیدا کردن IP شبکهٔ Mac

- از خروجی بالا (خط `network:`)، یا
- **System Settings ← Wi-Fi ← Details…** کنار شبکهٔ وصل‌شده ← بخش **TCP/IP** ← «IP Address»، یا
- در Terminal: `ipconfig getifaddr en0` (اگر خالی بود: `ipconfig getifaddr en1`)

نکته: بهتر است در تنظیمات مودم برای Mac یک **IP ثابت (DHCP Reservation)** تعریف کنید تا آدرس عوض نشود.

### ۱-۵. فایروال macOS

- بار اول که سرور اجرا می‌شود، ممکن است پنجرهٔ «Do you want the application **node** to accept incoming network connections?» ظاهر شود ← **Allow** را بزنید.
- اگر اشتباهی Deny زدید یا گوشی‌ها وصل نمی‌شوند: **System Settings ← Network ← Firewall ← Options…**، `node` را پیدا کنید و روی **Allow incoming connections** بگذارید (یا موقتاً فایروال را خاموش کنید).
- برای اینکه Mac به خواب نرود و سرور قطع نشود: **System Settings ← Battery/Energy** ← جلوگیری از خواب هنگام وصل بودن شارژر، یا در Terminal دوم: `caffeinate -dimsu`

### ۱-۶. اتصال گوشی‌ها

1. گوشی را به **همان Wi-Fi** که Mac به آن وصل است وصل کنید.
2. در مرورگر (Chrome یا Safari) آدرس را تایپ کنید، مثلاً: `http://192.168.1.105:3000`
3. «ثبت‌نام» ← شماره موبایل، نام، رمز ← وارد شوید. بقیه هم همین کار را می‌کنند.
4. برای گفتگو: دکمهٔ ✏️ ← شمارهٔ طرف مقابل را جستجو کنید. برای گروه: منوی ☰ ← «گروه جدید».
5. برای دسترسی سریع: در Safari «Share ← Add to Home Screen» یا در Chrome «Add to Home screen» (یک میانبر روی صفحه ساخته می‌شود).

اگر وصل نشد: ① IP و پورت را چک کنید ② فایروال Mac ③ بعضی مودم‌ها «AP/Client Isolation» یا «Guest network» دارند که اجازهٔ ارتباط دستگاه‌ها با هم را نمی‌دهد؛ آن را خاموش کنید یا از شبکهٔ اصلی استفاده کنید ④ روی Mac در مرورگر `http://localhost:3000` را امتحان کنید.

### ۱-۷. محدودیت HTTP در شبکهٔ محلی (PWA)

مرورگرها **Service Worker، نصب PWA و اعلان (Notification)** را فقط روی **HTTPS** یا `localhost` فعال می‌کنند. روی `http://192.168.x.x`:

- ✅ همهٔ امکانات اصلی کار می‌کند: ورود، چت خصوصی و گروهی، ارسال فایل، آنلاین بودن، WebSocket
- ❌ نصب واقعی PWA و کش آفلاین رابط و اعلان سیستمی کار نمی‌کند (فقط «میانبر» روی صفحهٔ اصلی)

برای فعال‌کردن این‌ها در شبکهٔ محلی، HTTPS داخلی خود برنامه را روشن کنید:

```sh
./scripts/self-signed-cert.sh 192.168.1.105        # IP خود Mac
TLS_CERT=deploy/certs/cert.pem TLS_KEY=deploy/certs/key.pem COOKIE_SECURE=true node src/server.js
# حالا: https://192.168.1.105:3000
```

اما گواهی خودامضا در گوشی «نامعتبر» است: مرورگر هشدار می‌دهد (با «Advanced ← Proceed» می‌شود ادامه داد و پیام‌رسانی کار می‌کند)، ولی **Service Worker/PWA فقط وقتی فعال می‌شود که گواهی مورد اعتماد باشد**. برای این کار باید `cert.pem` را روی هر گوشی به‌عنوان گواهی مورد اعتماد نصب کنید (iOS: نصب پروفایل و سپس Settings ← General ← About ← Certificate Trust Settings؛ Android: Settings ← Security ← Install certificate ← CA certificate). برای ۳ نفر در شبکهٔ محلی، معمولاً همان HTTP کافی است.

### ۱-۸. پشتیبان در حالت Mac

همهٔ داده‌ها در پوشهٔ `data/` کنار برنامه است (دیتابیس `messenger.db`، فایل‌ها در `uploads/`، و `jwt_secret`). ساده‌ترین پشتیبان: سرور را با `Ctrl+C` متوقف کنید و پوشهٔ `data` را کپی کنید. یا حین اجرا: `./scripts/backup.sh`

---

## بخش ۲: اجرای بدون Docker روی لینوکس/ویندوز

```sh
npm install --omit=dev
node src/server.js           # یا ./start.sh (لینوکس) / start.bat (ویندوز)
```

### بستهٔ آفلاین بدون Docker

```sh
./scripts/make-offline-node-bundle.sh    # روی سیستم دارای اینترنت ← armingram-offline-node.zip
```

zip را به سیستم مقصد ببرید، باز کنید و `node src/server.js` بزنید. (نصب‌کنندهٔ Node.js مناسب سیستم‌عامل مقصد را هم همراه داشته باشید.) چون ماژول native نداریم، `node_modules` ساخته‌شده روی لینوکس روی Mac و ویندوز هم کار می‌کند.

### تنظیمات (متغیرهای محیطی)

| متغیر | پیش‌فرض | توضیح |
|---|---|---|
| `PORT` | `3000` | پورت |
| `HOST` | `0.0.0.0` | آدرس گوش‌دادن (برای فقط-محلی: `127.0.0.1`) |
| `DATA_DIR` | `./data` | محل دیتابیس و فایل‌ها |
| `MAX_UPLOAD_MB` | `25` | حداکثر حجم هر فایل |
| `ALLOW_REGISTRATION` | `true` | با `false` ثبت‌نام جدید بسته می‌شود (بعد از ساخت حساب همه) |
| `SESSION_DAYS` | `30` | مدت اعتبار ورود |
| `JWT_SECRET` | خودکار | اگر خالی باشد، تصادفی ساخته و در `data/jwt_secret` ذخیره می‌شود |
| `COOKIE_SECURE` | `false` | پشت HTTPS حتماً `true` |
| `TRUST_PROXY` | `false` | پشت Caddy/nginx: `true` |
| `TLS_CERT` / `TLS_KEY` | — | مسیر گواهی PEM برای HTTPS داخلی بدون پروکسی |

---

## بخش ۳: VPS ایرانی (مثلاً ابرآروان) برای ~۲۵ کاربر

یک VPS کوچک (۱ هستهٔ CPU، ۱ گیگ RAM، ۲۰ گیگ دیسک) برای ۲۵ کاربر کاملاً کافی است. حجم دیسک را بر اساس فایل‌های ارسالی در نظر بگیرید.

> **مهم:** سرور باید **داخل ایران** باشد تا هنگام قطع اینترنت بین‌الملل از شبکهٔ داخلی در دسترس بماند. دامنهٔ `.ir` و DNS داخلی (مثلاً DNS ابرآروان) هم انتخاب امن‌تری است، چون DNSهای خارجی ممکن است در دسترس نباشند. اگر دامنه ندارید، با IP هم کار می‌کند.

### ۳-۱. نصب Docker و اجرا

```sh
# روی VPS (Ubuntu/Debian) - تا وقتی اینترنت هست
sudo apt update && sudo apt install -y docker.io docker-compose-v2   # یا طبق مستندات Docker / میرورهای داخلی
sudo mkdir -p /opt/armingram && cd /opt/armingram
# فایل‌های پروژه را این‌جا کپی کنید (scp یا unzip)
cp .env.example .env && nano .env      # DOMAIN=chat.example.ir
docker compose up -d --build
docker compose logs -f armingram
```

دسترسی: `https://chat.example.ir`

برای اجرای ساده بدون HTTPS (فقط تست): `docker compose -f docker-compose.simple.yml up -d --build` ← `http://IP:3000`

### ۳-۲. HTTPS

سه گزینه در `deploy/Caddyfile` آمده:

1. **دامنه + Let's Encrypt خودکار** (پیش‌فرض): DNS دامنه را به IP سرور بدهید. ⚠️ صدور/تمدید گواهی به اینترنت بین‌الملل نیاز دارد؛ گواهی را **قبل از قطعی** بگیرید (تا ۹۰ روز معتبر است و Caddy آن را ذخیره می‌کند).
2. **`tls internal`**: گواهی خودامضا توسط Caddy، کاملاً آفلاین (مرورگر هشدار می‌دهد).
3. **گواهی خودتان**: `./scripts/self-signed-cert.sh chat.example.ir` (یا گواهی از یک CA داخلی) در `deploy/certs/`.

اگر nginx را ترجیح می‌دهید: نمونهٔ کامل با پشتیبانی WebSocket در `deploy/nginx.conf`.

### ۳-۳. نصب آفلاین Docker image (بدون دسترسی سرور به Docker Hub)

روی سیستمی با اینترنت:

```sh
./scripts/make-offline-bundle.sh
# معادل دستی:
docker build -t armingram:latest .
docker pull caddy:2-alpine
docker save armingram:latest caddy:2-alpine | gzip > armingram-images.tar.gz
```

انتقال به سرور (`scp`) و روی سرور:

```sh
gunzip -c armingram-images.tar.gz | docker load      # یا ./scripts/install-offline.sh
docker compose up -d --no-build
```

### ۳-۴. پشتیبان‌گیری

```sh
./scripts/backup.sh                    # ← backups/armingram-YYYYMMDD-HHMMSS.tar.gz (۱۴ نسخهٔ آخر نگه داشته می‌شود)
./scripts/restore.sh backups/armingram-....tar.gz
```

پشتیبان شامل دیتابیس (کپی سازگار با `VACUUM INTO`، حین اجرا)، فایل‌های آپلودی و کلید نشست است. کرون روزانه:

```
0 3 * * * cd /opt/armingram && ./scripts/backup.sh >> backups/backup.log 2>&1
```

پشتیبان‌ها را مرتب به جای دیگری هم منتقل کنید (سرور دیگر یا سیستم شخصی).

### ۳-۵. انتقال از Mac به VPS

پوشهٔ `data/` روی Mac را (پس از توقف سرور) به `/opt/armingram/data` روی VPS کپی کنید؛ همهٔ حساب‌ها، گفتگوها و فایل‌ها منتقل می‌شوند.

---

## امنیت

- رمزها bcrypt (cost 11)، محدودیت تعداد تلاش ورود، کوکی `httpOnly` و `SameSite=Lax`
- Content-Security-Policy سخت‌گیرانه (فقط منابع خود سرور)
- فایل‌ها فقط برای اعضای همان گفتگو قابل دانلودند؛ فایل‌های غیرتصویری همیشه به‌صورت دانلود ارسال می‌شوند (جلوگیری از XSS)
- پشت HTTPS حتماً `COOKIE_SECURE=true` (در docker-compose.yml پیش‌فرض است)
- پیام‌ها روی سرور رمزنگاری سرتاسری (E2E) **ندارند**؛ مدیر سرور به دیتابیس دسترسی دارد.

## محدودیت‌ها

- تماس صوتی/تصویری، ویرایش/حذف پیام، ریپلای و پیام صوتی هنوز پیاده نشده است.
- اعلان Push وقتی برنامه بسته است وجود ندارد (Web Push به سرورهای خارجی گوگل/اپل وابسته است). اعلان فقط وقتی تب باز است (روی HTTPS).
- بازیابی رمز فراموش‌شده بدون پیامک ممکن نیست؛ مدیر می‌تواند با اسکریپت زیر رمز را عوض کند:
  ```sh
  node -e "const {DatabaseSync}=require('node:sqlite');const b=require('bcryptjs');new DatabaseSync('data/messenger.db').prepare('UPDATE users SET password_hash=?, token_version=token_version+1 WHERE phone=?').run(b.hashSync('NEW_PASSWORD',11),'09123456789')"
  ```
- برای چند صد کاربر هم کافی است؛ برای مقیاس خیلی بزرگ‌تر معماری دیگری لازم است.

## ساختار پروژه

```
src/server.js        سرور Express + WebSocket + API
src/db.js            طرح دیتابیس SQLite
public/              رابط کاربری (HTML/CSS/JS ساده، فونت وزیرمتن، آیکن‌ها، manifest، service worker)
test/e2e.js          تست سرتاسری: BASE=http://localhost:3000 node test/e2e.js
deploy/              Caddyfile، nginx.conf، certs/
scripts/             پشتیبان، بازگردانی، گواهی خودامضا، بسته‌های آفلاین
start.command        اجرا با دابل‌کلیک روی macOS
start.sh / start.bat اجرا روی لینوکس / ویندوز
```

فونت وزیرمتن: © Saber Rastikerdar، تحت لایسنس SIL Open Font License 1.1 (`public/fonts/OFL.txt`).

// js/global_alert.js

document.addEventListener("DOMContentLoaded", function () {
    initGlobalAlertSystem();
});

let lastAlertId = null;
let bannerTimeout = null; // ตัวแปรเก็บเวลาปิดแถบ

function initGlobalAlertSystem() {
    // 1. สร้าง Tag เสียง
    if (!document.getElementById("alertSound")) {
        const audio = document.createElement("audio");
        audio.id = "alertSound";
        audio.src = "alert.mp3";
        audio.preload = "auto";
        document.body.appendChild(audio);
    }

    // 2. สร้างแถบแจ้งเตือนลอย (Banner)
    if (!document.getElementById("global-alert-banner")) {
        const banner = document.createElement("div");
        banner.id = "global-alert-banner";
        banner.className = "fixed top-0 left-0 right-0 bg-red-600 text-white p-4 shadow-xl z-[9999] hidden translate-y-[-100%] transition-transform duration-500 flex items-center justify-between";
        banner.innerHTML = `
            <div class="flex items-center gap-4 container mx-auto px-4">
                <div class="p-2 bg-white/20 rounded-full animate-pulse">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2l4 7h6l-5 4 6 7-6-1-5 7-2-6-5-6 8-1 2-7z"></path></svg>
                </div>
                <div>
                    <h3 class="font-bold text-lg" id="gab-title">แจ้งเตือนฉุกเฉิน!</h3>
                    <p class="text-sm opacity-90" id="gab-detail">รายละเอียด...</p>
                </div>
                <button onclick="closeGlobalBanner()" class="p-2 hover:bg-white/20 rounded-lg text-white/80 hover:text-white">✕</button>
            </div>
        `;
        document.body.appendChild(banner);
    }

    // 3. เริ่มทำงาน
    checkSOS();
    setInterval(checkSOS, 3000);
}

// ฟังก์ชันปิดแถบแจ้งเตือน
window.closeGlobalBanner = function () {
    const banner = document.getElementById("global-alert-banner");
    if (banner) {
        banner.classList.add("translate-y-[-100%]"); // เลื่อนขึ้น
        setTimeout(() => banner.classList.add("hidden"), 500); // รอ animation จบแล้วซ่อน
    }
}

// ฟังก์ชันเล่นเสียง
function playAlertSound() {
    const audio = document.getElementById("alertSound");
    if (audio) {
        audio.currentTime = 0;
        audio.play().catch(e => console.log("Sound blocked until interaction"));
    }
}

// ฟังก์ชันแสดง Popup Browser
function showBrowserNotification(title, body) {
    if ("Notification" in window && Notification.permission === "granted") {
        new Notification(title, {
            body: body,
            icon: "https://cdn-icons-png.flaticon.com/512/564/564619.png",
            requireInteraction: false // เปลี่ยนเป็น false เพื่อให้มันหายไปเองได้เหมือนกัน
        });
    }
}

// ฟังก์ชันหลักเช็คสถานะ
async function checkSOS() {
    try {
        const res = await fetch('api/get_sos_status.php');
        const alerts = await res.json();

        // อัปเดตหน้า notifications.html (ถ้าเปิดอยู่)
        const feed = document.getElementById('sos-feed');
        if (feed) updateNotificationPageUI(alerts, feed);

        // --- ส่วนจัดการ Global Banner ---
        const banner = document.getElementById("global-alert-banner");
        const gabTitle = document.getElementById("gab-title");
        const gabDetail = document.getElementById("gab-detail");

        if (alerts.length > 0) {
            const latest = alerts[0];
            const latestId = parseInt(latest.id);

            // เช็ค ID ใหม่ -> เพื่อแจ้งเตือน (เสียง + แถบแดง)
            if (lastAlertId === null) {
                lastAlertId = latestId;
            } else if (latestId > lastAlertId) {
                // 🔥 มีเหตุใหม่!
                console.log("🔥 New Alert!");
                playAlertSound();
                showBrowserNotification("🚨 " + latest.message, latest.detail);

                // แสดงแถบแดง
                if (banner) {
                    gabTitle.innerText = "🚨 " + latest.message;
                    gabDetail.innerText = latest.detail + " (" + latest.time + ")";

                    banner.classList.remove("hidden");
                    // Delay นิดนึงเพื่อให้ Animation ทำงาน
                    setTimeout(() => banner.classList.remove("translate-y-[-100%]"), 10);

                    // ⏰ ตั้งเวลาปิดอัตโนมัติ 5 วินาที (Auto Hide)
                    if (bannerTimeout) clearTimeout(bannerTimeout); // ล้างเวลาเก่าก่อน
                    bannerTimeout = setTimeout(() => {
                        closeGlobalBanner();
                    }, 5000); // 5000 ms = 5 วินาที (แก้เลขตรงนี้ได้)
                }

                lastAlertId = latestId;
            }
        }
    } catch (e) { console.error(e); }
}

function updateNotificationPageUI(alerts, feed) {
    if (alerts.length === 0) {
        feed.innerHTML = `<div class="bg-slate-50 border border-slate-200 rounded-xl p-8 flex items-center gap-6"><div class="w-16 h-16 rounded-full bg-emerald-100 flex items-center justify-center text-emerald-600"><i data-lucide="shield-check" class="w-8 h-8"></i></div><div><h2 class="text-xl font-bold text-slate-800">เหตุการณ์ปกติ</h2><p class="text-slate-500 mt-1">ไม่มีการแจ้งเตือน</p></div></div>`;
    } else {
        feed.innerHTML = alerts.map(alert => `
            <div class="bg-red-50 border border-red-200 rounded-xl p-6 flex items-start gap-5 shadow-sm animate-fade-in-down mb-3">
                <div class="w-12 h-12 rounded-full bg-red-100 flex-shrink-0 flex items-center justify-center text-red-600 animate-pulse"><i data-lucide="alert-triangle" class="w-6 h-6"></i></div>
                <div class="flex-1">
                    <div class="flex justify-between">
                        <h2 class="text-lg font-bold text-red-700">${alert.message}</h2>
                        <span class="text-xs font-bold text-red-500 bg-white px-2 py-1 rounded border border-red-100">${alert.time}</span>
                    </div>
                    <p class="text-red-600 mt-1 text-sm">${alert.detail}</p>
                </div>
            </div>`).join('');
    }
    if (window.lucide) window.lucide.createIcons();
}
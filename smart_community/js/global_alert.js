// ไฟล์: js/global_alert.js

document.addEventListener('DOMContentLoaded', () => {

    // --- 1. เตรียมไฟล์เสียง ---
    if (!document.getElementById('sosSound')) {
        const audio = document.createElement('audio');
        audio.id = 'sosSound';
        audio.src = 'alert.mp3'; // ตรวจสอบว่าไฟล์ alert.mp3 อยู่ที่ root folder
        audio.preload = 'auto';
        document.body.appendChild(audio);
    }

    // ปลดล็อกเสียงสำหรับ Browser (ต้องคลิก 1 ครั้งถึงจะเริ่มดังได้)
    document.addEventListener('click', () => {
        const audio = document.getElementById('sosSound');
        if (audio) {
            audio.play().then(() => {
                audio.pause();
                audio.currentTime = 0;
            }).catch(() => { });
        }
    }, { once: true });

    // --- 2. ฟังก์ชันแสดงแถบแจ้งเตือน (Toast) ---
    function showToast(title, message) {
        // สร้าง Div กล่องข้อความ
        const toast = document.createElement('div');

        // ใช้ Tailwind จัดแต่งทรง (สีแดงสวยๆ)
        toast.className = `
            fixed top-5 right-5 z-[9999] 
            bg-white border-l-4 border-red-500 
            shadow-2xl rounded-lg p-4 
            flex items-start gap-3 
            transform transition-all duration-500 translate-x-full
            max-w-sm w-full
        `;

        toast.innerHTML = `
            <div class="text-red-500 bg-red-50 p-2 rounded-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-siren"><path d="M7 12a5 5 0 0 1 5-5v0a5 5 0 0 1 5 5v6H7v-6Z"/><path d="M5 20a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v2H5v-2Z"/><path d="M21 12h1"/><path d="M18.5 4.5 18 5"/><path d="M2 12h1"/><path d="M12 2v1"/><path d="M4.929 4.929l.707.707"/><path d="M12 12v6"/></svg>
            </div>
            <div class="flex-1">
                <h4 class="font-bold text-slate-800 text-sm">${title}</h4>
                <p class="text-xs text-slate-500 mt-1">${message}</p>
            </div>
            <button onclick="this.parentElement.remove()" class="text-slate-400 hover:text-red-500">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
            </button>
        `;

        document.body.appendChild(toast);

        // Animation เลื่อนเข้ามา
        setTimeout(() => {
            toast.classList.remove('translate-x-full');
        }, 100);

        // สั่งเล่นเสียงทันทีที่ข้อความเด้ง
        const audio = document.getElementById('sosSound');
        if (audio) {
            audio.currentTime = 0;
            audio.play().catch(e => console.log("Audio blocked", e));
        }

        // ลบออกอัตโนมัติเมื่อผ่านไป 10 วินาที
        setTimeout(() => {
            toast.classList.add('translate-x-full'); // เลื่อนกลับไปขวาก่อนลบ
            setTimeout(() => toast.remove(), 500);
        }, 10000);
    }

    // --- 3. ระบบตรวจสอบข้อมูล (Polling) ---
    // จำ ID ล่าสุดไว้ เพื่อไม่ให้เด้งซ้ำอันเดิม
    let lastAlertId = localStorage.getItem('last_alert_id') || 0;

    async function monitorSystem() {
        try {
            const res = await fetch('api/get_alerts.php'); // ดึงข้อมูล
            const alerts = await res.json();

            // กรองเอาเฉพาะอันที่สถานะเป็น 'pending' (ยังไม่รับเรื่อง)
            const pendingAlerts = alerts.filter(a => a.status !== 'resolved');

            if (pendingAlerts.length > 0) {
                // เอาอันล่าสุด (ตัวแรกสุด หรือตัวที่มี ID มากสุด)
                const latest = pendingAlerts[0];

                // ถ้า ID ของอันล่าสุด มากกว่าที่เคยจำไว้ -> แสดงว่ามีอันใหม่มา!
                if (parseInt(latest.id) > parseInt(lastAlertId)) {

                    showToast("แจ้งเหตุฉุกเฉิน!", `${latest.message} (${latest.time})`);

                    // อัปเดตความจำ
                    lastAlertId = latest.id;
                    localStorage.setItem('last_alert_id', lastAlertId);
                }
            }

        } catch (e) {
            console.error("Monitor Error:", e);
        }
    }

    // ทำงานทุกๆ 3 วินาที
    setInterval(monitorSystem, 3000);

    // รันครั้งแรกทันที
    monitorSystem();
});
document.addEventListener('DOMContentLoaded', () => {

    if (!document.getElementById('sosSound')) {
        const audio = document.createElement('audio');
        audio.id = 'sosSound';
        audio.src = 'alert.mp3'; 
        audio.preload = 'auto';
        document.body.appendChild(audio);
    }

    document.addEventListener('click', () => {
        const audio = document.getElementById('sosSound');
        if (audio) {
            audio.play().then(() => {
                audio.pause();
                audio.currentTime = 0;
            }).catch(() => { });
        }
    }, { once: true });

    function showToast(title, message) {
        const toast = document.createElement('div');
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

        setTimeout(() => {
            toast.classList.remove('translate-x-full');
        }, 100);

        const audio = document.getElementById('sosSound');
        if (audio) {
            audio.currentTime = 0;
            audio.play().catch(e => console.log("Audio blocked", e));
        }

        setTimeout(() => {
            toast.classList.add('translate-x-full'); 
            setTimeout(() => toast.remove(), 500);
        }, 10000);
    }
    let lastAlertId = localStorage.getItem('last_alert_id') || 0;

    async function monitorSystem() {
        try {
            const res = await fetch('api/get_alerts.php'); 
            const alerts = await res.json();

            const pendingAlerts = alerts.filter(a => a.status !== 'resolved');

            if (pendingAlerts.length > 0) {
                const latest = pendingAlerts[0];

                if (parseInt(latest.id) > parseInt(lastAlertId)) {

                    showToast("แจ้งเหตุฉุกเฉิน!", `${latest.message} (${latest.time})`);

                    lastAlertId = latest.id;
                    localStorage.setItem('last_alert_id', lastAlertId);
                }
            }

        } catch (e) {
            console.error("Monitor Error:", e);
        }
    }

    setInterval(monitorSystem, 3000);
    monitorSystem();
});
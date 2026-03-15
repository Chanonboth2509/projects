document.addEventListener('DOMContentLoaded', () => {

    if (!document.getElementById('sosSound')) {
        const audio = document.createElement('audio');
        audio.id = 'sosSound';
        audio.src = 'alert.mp3'; 
        audio.loop = true; 
        audio.preload = 'auto';
        document.body.appendChild(audio);
    }

    document.addEventListener('click', () => {
        const audio = document.getElementById('sosSound');
        if (audio && audio.paused && audio.getAttribute('data-playing') === 'true') {
            audio.play().catch(() => { });
        }
    }, { once: true });

    function showToast(title, message) {
    }
    
    let lastAlertId = localStorage.getItem('last_alert_id') || 0;

    async function monitorSystem() {
        try {
            const res = await fetch('api/get_alerts.php', {
                headers: { 'ngrok-skip-browser-warning': 'true', 'Accept': 'application/json' }
            }); 
            
            const alerts = await res.json();
            const audio = document.getElementById('sosSound');
            const pendingAlerts = alerts.filter(a => a.status !== 'resolved');

            if (pendingAlerts.length > 0) {
                audio.setAttribute('data-playing', 'true');
                if (audio.paused) {
                    audio.play().catch(e => console.log("เสียงถูกบล็อก: รอการคลิกจากแอดมิน"));
                }

                const latest = pendingAlerts[0];
                if (parseInt(latest.id) > parseInt(lastAlertId)) {
                    showToast("🚨 แจ้งเหตุฉุกเฉิน!", `${latest.message} (${latest.time})`);
                    lastAlertId = latest.id;
                    localStorage.setItem('last_alert_id', lastAlertId);
                }
            } else {
                audio.setAttribute('data-playing', 'false');
                audio.pause();
                audio.currentTime = 0;
            }

        } catch (e) { console.error("Monitor Error:", e); }
    }

    setInterval(monitorSystem, 3000);
    monitorSystem();
});
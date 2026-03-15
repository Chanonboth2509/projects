
document.addEventListener('DOMContentLoaded', async () => {
    const currentPath = window.location.pathname;
    if (currentPath.includes('login.html') || currentPath.includes('register.html')) {
        return; 
    }

    try {
        const res = await fetch('api/check_auth.php');
        const data = await res.json();
        
        if (!data.auth) {
            window.location.replace('login.html');
        } else {
            const adminNameElements = document.querySelectorAll('.admin-name-display');
            adminNameElements.forEach(el => el.innerText = data.user);
            const emailEl = document.getElementById('admin-email');
            if (emailEl && data.email) {
                emailEl.innerText = data.email;
            }
        }
    } catch (error) {
        console.error("Auth check failed:", error);
        window.location.replace('login.html');
    }
});

window.handleLogout = async function() {
    if(confirm('คุณต้องการออกจากระบบใช่หรือไม่?')) {
        try {
            await fetch('api/logout.php'); 
            window.location.replace('login.html');
        } catch (e) {
            console.error('Logout error', e);
        }
    }
}
class DataManager {
    constructor() {
        
    }
    async getMembers() {
        try {
            const response = await fetch('api/members.php');
            return await response.json();
        } catch (error) {
            console.error('Error:', error);
            return [];
        }
    }

    async addMember(member) {
        await fetch('api/members.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(member)
        });
    }

    async updateMember(member) {
        await this.addMember(member);
    }

    async deleteMember(id) {
        await fetch(`api/members.php?id=${id}`, {
            method: 'DELETE'
        });
    }

    async getDevices() {
        try {
            const response = await fetch('api/devices.php');
            return await response.json();
        } catch (error) {
            return [];
        }
    }

    async addDevice(device) {
        await fetch('api/devices.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(device)
        });
    }
    getNotifications() { return []; }
}

const db = new DataManager();
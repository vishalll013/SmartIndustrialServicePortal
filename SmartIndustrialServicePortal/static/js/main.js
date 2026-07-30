// Theme management
document.addEventListener('DOMContentLoaded', () => {
    const currentTheme = localStorage.getItem('theme') || 'light';
    if (currentTheme === 'dark') {
        document.body.classList.add('dark-theme');
    }

    const themeToggleBtn = document.getElementById('theme-toggle');
    if (themeToggleBtn) {
        themeToggleBtn.addEventListener('click', () => {
            document.body.classList.toggle('dark-theme');
            const theme = document.body.classList.contains('dark-theme') ? 'dark' : 'light';
            localStorage.setItem('theme', theme);
        });
    }

    // Flash message close buttons
    const closeButtons = document.querySelectorAll('.flash-close');
    closeButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            const flashMsg = e.target.closest('.flash-message');
            if (flashMsg) {
                flashMsg.remove();
            }
        });
    });

    // Auto-dismiss flash messages after 5 seconds
    const flashMessages = document.querySelectorAll('.flash-message');
    flashMessages.forEach(msg => {
        setTimeout(() => {
            msg.style.opacity = '0';
            msg.style.transform = 'translateY(-10px)';
            msg.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            setTimeout(() => msg.remove(), 500);
        }, 5000);
    });
});

// CSV Export Helper
function exportTableToCSV(tableId, filename) {
    const table = document.getElementById(tableId);
    if (!table) return;

    let csvContent = "";
    const rows = table.querySelectorAll("tr");

    rows.forEach(row => {
        const cols = row.querySelectorAll("th, td");
        const rowData = [];
        cols.forEach(col => {
            // Remove tabs, newlines, and escape double quotes
            let text = col.innerText.replace(/(\r\n|\n|\r)/gm, " ").trim();
            text = text.replace(/"/g, '""');
            // If action buttons are in table, exclude them
            if (col.classList.contains('actions-column') || col.classList.contains('no-export')) {
                return;
            }
            rowData.push('"' + text + '"');
        });
        if (rowData.length > 0) {
            csvContent += rowData.join(",") + "\n";
        }
    });

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement("a");
    if (link.download !== undefined) {
        const url = URL.createObjectURL(blob);
        link.setAttribute("href", url);
        link.setAttribute("download", filename);
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
}

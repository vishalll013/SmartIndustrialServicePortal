document.addEventListener('DOMContentLoaded', () => {
    const titleInput = document.getElementById('title');
    const descInput = document.getElementById('description');
    const prioritySelect = document.getElementById('priority');
    const aiSuggestionBox = document.getElementById('ai-suggestion-box');
    const suggestionText = document.getElementById('ai-suggestion-text');
    const applyBtn = document.getElementById('ai-suggestion-apply');

    if (!titleInput || !descInput || !prioritySelect || !aiSuggestionBox) return;

    const criticalKeywords = ['fire', 'shock', 'spark', 'explosion', 'high voltage', 'toxic', 'gas leak', 'hazardous', 'safety barrier', 'injury', 'blackout', 'power failure', 'emergency', 'blast', 'boiler'];
    const highKeywords = ['leak', 'burst', 'server down', 'outage', 'crane malfunction', 'engine failure', 'broken', 'accident', 'offline', 'shut down'];
    const mediumKeywords = ['flickering', 'jam', 'ac not cooling', 'slow', 'noise', 'jammed', 'light', 'wiring'];
    const lowKeywords = ['dust', 'trash', 'cleaning', 'paint', 'coffee', 'housekeeping', 'dirty', 'maintenance'];

    function analyzeText() {
        const text = (titleInput.value + ' ' + descInput.value).toLowerCase();
        let suggestedPriority = '';

        // Match critical keywords first
        if (criticalKeywords.some(keyword => text.includes(keyword))) {
            suggestedPriority = 'Critical';
        } else if (highKeywords.some(keyword => text.includes(keyword))) {
            suggestedPriority = 'High';
        } else if (mediumKeywords.some(keyword => text.includes(keyword))) {
            suggestedPriority = 'Medium';
        } else if (lowKeywords.some(keyword => text.includes(keyword))) {
            suggestedPriority = 'Low';
        }

        if (suggestedPriority && suggestedPriority !== prioritySelect.value) {
            suggestionText.textContent = suggestedPriority;
            aiSuggestionBox.style.display = 'flex';
        } else {
            aiSuggestionBox.style.display = 'none';
        }
    }

    // Bind event listeners
    titleInput.addEventListener('input', analyzeText);
    descInput.addEventListener('input', analyzeText);
    prioritySelect.addEventListener('change', () => {
        aiSuggestionBox.style.display = 'none';
    });

    if (applyBtn) {
        applyBtn.addEventListener('click', (e) => {
            e.preventDefault();
            const value = suggestionText.textContent;
            prioritySelect.value = value;
            aiSuggestionBox.style.display = 'none';
            
            // Add flash visual feedback to the select element
            prioritySelect.style.outline = '2px solid var(--info)';
            setTimeout(() => {
                prioritySelect.style.outline = 'none';
            }, 1000);
        });
    }
});

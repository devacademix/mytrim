document.addEventListener('DOMContentLoaded', () => {
    const subscribeForm = document.getElementById('subscribe-form');
    const emailInput = document.getElementById('email-input');
    const formFeedback = document.getElementById('form-feedback');

    if (subscribeForm) {
        subscribeForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const email = emailInput.value.trim();
            if (email) {
                formFeedback.className = 'feedback-msg success';
                formFeedback.textContent = '✨ Thank you! You are now on our VIP launch list.';
                emailInput.value = '';
                setTimeout(() => {
                    formFeedback.textContent = '';
                }, 5000);
            }
        });
    }
});

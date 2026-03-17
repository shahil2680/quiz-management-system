<%-- global-utils.jsp: Dark Mode Toggle, Toast Notifications, Loading Spinners, Session Timeout Warning --%>

    <!-- Toast Notification Container -->
    <div class="toast-container position-fixed top-0 end-0 p-3" style="z-index:9999;">
        <div id="globalToast" class="toast align-items-center border-0" role="alert" aria-live="assertive"
            aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body" id="globalToastBody">Notification</div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>

    <!-- Session Timeout Modal -->
    <div class="modal fade" id="sessionTimeoutModal" tabindex="-1" data-bs-backdrop="static">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content border-warning">
                <div class="modal-header bg-warning text-dark py-2">
                    <h6 class="modal-title mb-0"><i class="bi bi-clock-fill me-2"></i>Session Expiring Soon</h6>
                </div>
                <div class="modal-body text-center py-4">
                    <p class="mb-1">Your session will expire in</p>
                    <h2 id="sessionCountdown" class="text-danger fw-bold">2:00</h2>
                    <p class="text-muted small">Save your work or click Stay Logged In.</p>
                </div>
                <div class="modal-footer py-2 justify-content-center">
                    <a href="." class="btn btn-warning btn-sm">Stay Logged In</a>
                    <a href="logout" class="btn btn-outline-secondary btn-sm">Logout</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Dark Mode Toggle Button -->
    <button id="darkModeToggle" class="btn btn-sm btn-outline-secondary position-fixed"
        style="bottom:20px;right:20px;z-index:8000;border-radius:50%;width:42px;height:42px;padding:0;"
        title="Toggle Dark Mode" onclick="toggleDarkMode()">
        <i class="bi bi-moon-fill" id="darkModeIcon"></i>
    </button>

    <style>
        /* Dark Mode Styles */
        body.dark-mode {
            background-color: #1a1d23 !important;
            color: #e0e0e0 !important;
        }

        body.dark-mode .navbar-custom,
        body.dark-mode nav {
            background: #2c2f38 !important;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3) !important;
        }

        body.dark-mode .card,
        body.dark-mode .card-dashboard {
            background: #2c2f38 !important;
            color: #e0e0e0 !important;
            border: 1px solid #3a3d47 !important;
        }

        body.dark-mode .card-header,
        body.dark-mode .table-light {
            background: #363942 !important;
            color: #e0e0e0 !important;
        }

        body.dark-mode .form-control,
        body.dark-mode .form-select {
            background: #363942 !important;
            color: #e0e0e0 !important;
            border-color: #4a4d5a !important;
        }

        body.dark-mode .option-item {
            background: #363942 !important;
            border-color: #4a4d5a !important;
        }

        body.dark-mode .text-muted {
            color: #9a9da8 !important;
        }

        body.dark-mode .table {
            color: #e0e0e0;
        }

        body.dark-mode .page-link {
            background: #2c2f38;
            border-color: #4a4d5a;
            color: #adb5bd;
        }

        body.dark-mode .search-card,
        body.dark-mode .upload-area {
            background: #2c2f38 !important;
        }

        #darkModeToggle {
            transition: all 0.3s;
        }

        body.dark-mode #darkModeToggle {
            background: #363942;
            border-color: #4a4d5a;
            color: #ffd700;
        }

        /* Loading Spinner Overlay */
        #loadingOverlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.7);
            z-index: 9998;
            align-items: center;
            justify-content: center;
            flex-direction: column;
        }

        body.dark-mode #loadingOverlay {
            background: rgba(26, 29, 35, 0.7);
        }

        #loadingOverlay.show {
            display: flex;
        }
    </style>

    <!-- Loading Spinner Overlay -->
    <div id="loadingOverlay">
        <div class="spinner-border text-primary" style="width:3rem;height:3rem;" role="status"></div>
        <p class="mt-3 text-muted">Loading...</p>
    </div>

    <script>
        // ====== DARK MODE ======
        function toggleDarkMode() {
            document.body.classList.toggle('dark-mode');
            const isDark = document.body.classList.contains('dark-mode');
            localStorage.setItem('darkMode', isDark ? 'on' : 'off');
            document.getElementById('darkModeIcon').className = isDark ? 'bi bi-sun-fill' : 'bi bi-moon-fill';
        }

        // Apply saved dark mode preference
        (function () {
            if (localStorage.getItem('darkMode') === 'on') {
                document.body.classList.add('dark-mode');
                const icon = document.getElementById('darkModeIcon');
                if (icon) icon.className = 'bi bi-sun-fill';
            }
        })();

        // ====== TOAST NOTIFICATIONS ======
        function showToast(message, type) {
            const toast = document.getElementById('globalToast');
            const body = document.getElementById('globalToastBody');
            if (!toast || !body) return;
            body.textContent = message;
            toast.className = 'toast align-items-center border-0 text-white bg-' + (type || 'success');
            const bsToast = new bootstrap.Toast(toast, { delay: 3500 });
            bsToast.show();
        }

        // Auto-show toast from URL params
        (function () {
            const params = new URLSearchParams(window.location.search);
            if (params.get('success')) showToast('Operation successful!', 'success');
            if (params.get('error') === 'alreadyAttempted') showToast('You have already attempted this quiz!', 'danger');
            if (params.get('error')) showToast('An error occurred. Please try again.', 'danger');
            if (params.get('deleted')) showToast('Deleted successfully!', 'warning');
            if (params.get('saved')) showToast('Saved successfully!', 'success');
        })();

        // ====== LOADING SPINNER on form submits ======
        document.addEventListener('DOMContentLoaded', function () {
            const forms = document.querySelectorAll('form[method="post"]');
            forms.forEach(function (form) {
                form.addEventListener('submit', function (e) {
                    // Don't show on delete confirmations that were cancelled
                    const overlay = document.getElementById('loadingOverlay');
                    if (overlay) overlay.classList.add('show');
                    // Auto-hide after 8 seconds as safety fallback
                    setTimeout(function () {
                        if (overlay) overlay.classList.remove('show');
                    }, 8000);
                });
            });
        });

        // ====== SESSION TIMEOUT WARNING ======
        (function () {
            // Spring default session = 30 min, warn at 28 min
            const SESSION_DURATION_MS = 30 * 60 * 1000;
            const WARN_BEFORE_MS = 2 * 60 * 1000;
            let warningTimer, countdownInterval;
            let countdownSeconds = 120;

            const pageLoadTime = Date.now();

            warningTimer = setTimeout(function () {
                const modal = new bootstrap.Modal(document.getElementById('sessionTimeoutModal'));
                modal.show();
                countdownInterval = setInterval(function () {
                    countdownSeconds--;
                    const m = Math.floor(countdownSeconds / 60);
                    const s = countdownSeconds % 60;
                    const el = document.getElementById('sessionCountdown');
                    if (el) el.textContent = m + ':' + (s < 10 ? '0' : '') + s;
                    if (countdownSeconds <= 0) {
                        clearInterval(countdownInterval);
                        window.location.href = 'logout';
                    }
                }, 1000);
            }, SESSION_DURATION_MS - WARN_BEFORE_MS);

            // Reset timer on user activity
            ['click', 'keypress', 'scroll', 'mousemove'].forEach(function (evt) {
                document.addEventListener(evt, function () {
                    clearTimeout(warningTimer);
                    warningTimer = setTimeout(function () {
                        const modal = new bootstrap.Modal(document.getElementById('sessionTimeoutModal'));
                        modal.show();
                    }, SESSION_DURATION_MS - WARN_BEFORE_MS);
                }, { passive: true });
            });
        })();
    </script>
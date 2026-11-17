(function () {
    var cryptoKey = '9090909090909090';
    var cryptoIV = '9090909090909090';

    var currentServiceId = null;
    var pendingSortOrder = 'asc';
    var startedSortOrder = 'asc';
    var employeeSortOrder = 'asc';
    var currentRequestId = null;
    var activeFetchControllers = [];
    var pendingAbortController = null;
    var startedAbortController = null;
    var lastEmployeeRequest = null;
    var employeeListMode = 'normal';
    var employeeCache = [];
    var listTimers = {};
    var taskIndex = {};
    var endingTasks = {};

    var pendingFilters = {};
    var startedFilters = {};
    var employeeFilters = { filterUserName: '', filterHospital: '', filterShift: '', filterStatus: '' };

    var countdownInterval = null;
    var countdownTimer = 30;
    var REFRESH_INTERVAL = 30000;
    window.AutoRefresh = null;

    var selectedBreakDuration = null;
    var processingUsers = { restStart: {}, restEnd: {}, mealStart: {}, mealEnd: {} };
    var cooldownUsers = { restStart: {}, restEnd: {}, mealStart: {}, mealEnd: {} };
    var breakModal = null;

    var isModalVisible = false;
    var isActionInProgress = false;
    var selectedEmployeeId = null;
    var selectedCategoryPorter = 0;
    var selectedEquipmentPorter = 0;
    var dropdownData = {};
    var currentTask = null;
    var ariaFixed = false;

    function esc(v) {
        return String(v == null ? '' : v)
            .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    }

    function activeServiceId() {
        var b = document.querySelector('.services-btn-icon.active');
        return b ? b.id.replace('divService', '') : '';
    }

    function Encrypt(Value) {
        var key = CryptoJS.enc.Utf8.parse(CryptoKey);
        var iv = CryptoJS.enc.Utf8.parse(CryptoPwd);
        var enc = CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(Value), key, {
            keySize: 128 / 8,
            iv: iv,
            mode: CryptoJS.mode.CBC,
            padding: CryptoJS.pad.Pkcs7
        });
        return enc.toString();
    }

    function encryptAES(text) {
        var key = CryptoJS.enc.Utf8.parse(cryptoKey);
        var iv = CryptoJS.enc.Utf8.parse(cryptoIV);
        return CryptoJS.AES.encrypt(text, key, {
            iv: iv,
            mode: CryptoJS.mode.CBC,
            padding: CryptoJS.pad.Pkcs7
        }).toString();
    }

    function encryptQS(value) {
        if (value === null || value === undefined || value === '') return '';
        return encodeURIComponent(encryptAES(value.toString()));
    }

    function encryptString(str) {
        return btoa(unescape(encodeURIComponent(str)));
    }

    function encryptPayload(payload) {
        var out = {};
        for (var key in payload) {
            var val = payload[key] !== null && payload[key] !== undefined ? payload[key].toString() : '';
            out[key] = encryptString(val);
        }
        return out;
    }

    function parseServiceText(text) {
        try {
            return JSON.parse(String(text).replace(/\[\]$/, ''));
        } catch (e) {
            return { success: true, message: text };
        }
    }

    function postService(processName, body) {
        return fetch('/Index/Service/Service.aspx?' + new URLSearchParams({ Process: Encrypt(processName) }), {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body)
        }).then(function (r) { return r.text(); }).then(parseServiceText);
    }

    function getModalInstance(id) {
        var el = document.getElementById(id);
        return el ? bootstrap.Modal.getOrCreateInstance(el) : null;
    }

    function flashModal(id, ms) {
        var m = getModalInstance(id);
        if (!m) return;
        m.show();
        setTimeout(function () { m.hide(); }, ms);
    }

    function showSuccessModal(message) {
        var lbl = document.getElementById('LBLSuccessMessage');
        if (lbl) lbl.textContent = message;
        if (document.activeElement && typeof document.activeElement.blur === 'function') document.activeElement.blur();
        flashModal('modalSuccess', 1500);
    }

    function showTaskResumedModal() { flashModal('modalTaskResumed', 2000); }
    function showTaskCopiedModal() { flashModal('modalTaskCopied', 2000); }

    function showTaskEndedModal(message) {
        var lbl = document.getElementById('LBLTaskEndedMessage');
        if (lbl && message) lbl.textContent = message;
        flashModal('modalTaskEnded', 1500);
    }

    function showAlertModal(message, ms) {
        document.getElementById('spanErrorMessage').innerText = message;
        flashModal('modalAlert', ms || 2000);
    }

    function showEmployeeActionSuccess(message) {
        var modalEl = document.getElementById('modalGenericSuccess');
        modalEl.classList.add('level-2');
        var m = bootstrap.Modal.getOrCreateInstance(modalEl);
        document.getElementById('LBLGenericSuccessResult').textContent = message;
        m.show();
        setTimeout(function () {
            m.hide();
            document.getElementById('LBLGenericSuccessResult').textContent = '';
            if (window.RefreshAll) window.RefreshAll();
            setTimeout(function () { modalEl.classList.remove('level-2'); }, 300);
        }, 2000);
    }

    function showPorterWarningModal(message) {
        document.getElementById('porterWarningText').innerText = message || 'Porter is already in a task.';
        var m = bootstrap.Modal.getOrCreateInstance(document.getElementById('porterWarningModal'));
        m.show();
        setTimeout(function () { m.hide(); }, 1000);
    }

    function closePorterWarningModal() {
        var inst = bootstrap.Modal.getInstance(document.getElementById('porterWarningModal'));
        if (inst) inst.hide();
    }

    function cleanupBackdrops() {
        if (!document.querySelector('.modal.show')) {
            document.querySelectorAll('.modal-backdrop').forEach(function (bd) { bd.remove(); });
            document.body.classList.remove('modal-open');
            document.body.style.removeProperty('overflow');
            document.body.style.removeProperty('padding-right');
            document.body.style.removeProperty('margin-right');
        }
    }

    function hideAllModals() {
        document.querySelectorAll('.modal.show').forEach(function (m) {
            var inst = bootstrap.Modal.getInstance(m);
            if (inst) inst.hide();
        });
    }

    function setRootServices(ele) {
        $('.services-btn-icon').removeClass('active');
        $(ele).addClass('active');
        var rgbColor = $(ele).data('color');
        sessionStorage.setItem('ServiceCode', ServiceCode);
        var rgbaColor = rgbColor.replace('rgb', 'rgba').replace(')', ', 0.1)');
        $('#DivKitchenFilters').css('visibility', (ServiceCode == '2') ? 'visible' : 'hidden');
        setServiceUpdates(ServiceCode);
        $(':root').css('--active-color', rgbColor);
        $(':root').css('--active-bg-color', rgbaColor);
    }

    function setInnerServices(ele) {
        $('.services-btn-icon-modal').removeClass('active');
        $(ele).addClass('active');
        var rgbColor = $(ele).data('color');
        var rgbaColor = rgbColor.replace('rgb', 'rgba').replace(')', ', 0.1)');
        $(':root').css('--active-color-modal', rgbColor);
        $(':root').css('--active-bg-color-modal', rgbaColor);
    }

    function setRequestChanges(svcCode, Process) {
        switch (svcCode) {
            case '1':
                if (Process === 'New' || Process === 'Update') LoadCategories('');
                $('#containerMP').css('display', 'inline-block');
                $('#containerPatient').css('display', 'inline-block');
                $('#divQuantity').css('visibility', 'hidden');
                $('#txtFromLoc').val('');
                $('#txtFromLoc').prop('readonly', false);
                setTimeout(function () { $('#txtFromLoc').focus(); }, 500);
                LoadEquipment('a', svcCode);
                $('#verifyDeliverySection').hide();
                $('#suggesstionTo').hide();
                $('#lblKPITS').html('-');
                $('#lblKPITE').html('-');
                $('.message-menu-item').hide();
                $('#containerCat, #containerKPI, #tdKPICompletion, #tdKPIResponse, #parentcontainerMP').css('background-color', '#6dadff');
                break;
            case '2':
                $('#containerMP').css('display', 'inline-block');
                setDefaultCategoryIfService2();
                $('#containerPatient').css('display', 'none');
                $('#divQuantity').css('visibility', 'visible');
                $('#verifyDeliverySection').show();
                BindLocation('9028', 'RECEIPT & DISTRIBUTION', 'SF', 'NO', '', '');
                setTimeout(function () {
                    $('#txtFromLoc').val('RECEIPT & DISTRIBUTION').attr('data-locid', '9028').trigger('input').trigger('change');
                    if (Process !== 'Update') setRequestChanges(activeServiceId(), 'Update');
                }, 300);
                LoadEquipment('Tr', svcCode);
                $('#suggesstionFrom').hide();
                setTimeout(function () { $('#txtFromLoc').focus(); }, 500);
                $('#lblKPITS').html('-');
                $('#lblKPITE').html('-');
                $('.message-menu-item').show();
                $('#containerCat, #containerKPI, #tdKPICompletion, #tdKPIResponse, #parentcontainerMP').css('background-color', '#6dadff');
                break;
        }
        if (Process == 'New') {
            LoadPresetRemarks();
            LoadEquipmentOnInit(svcCode);
        }
    }

    function setDefaultLocationIfService2() {
        if (activeServiceId() === '2') {
            BindLocation('9028', 'RECEIPT & DISTRIBUTION', 'SF', 'NO', '', '');
            setTimeout(function () {
                var $f = $('#txtFromLoc');
                if (!$f.val() || $f.val().trim() === '') {
                    $f.val('RECEIPT & DISTRIBUTION').attr('data-locid', '9028').trigger('input').trigger('change');
                }
                $('#suggesstionFrom').hide();
                $f.focus();
            }, 300);
            $('#txtFromLoc').off('input change').on('input change', function () {
                if ($(this).val().trim().toUpperCase() === 'RECEIPT & DISTRIBUTION') $(this).attr('data-locid', '9028');
                else $(this).removeAttr('data-locid');
            });
        }
    }

    function setDefaultCategoryIfService2() {
        if (activeServiceId() === '2') {
            var t = document.getElementById('chkMultiPorter');
            if (t) t.checked = false;
            ReqCat = '503';
            LoadCategories('goo');
            setTimeout(function () {
                var chk = document.getElementById('chkCat503');
                if (chk) {
                    chk.checked = true;
                    chk.dispatchEvent(new Event('change'));
                }
            }, 300);
        }
    }

    function setPagerEmpty() {
        valuePage.curPage = 0;
        valuePage.totalPages = 0;
        btnNextPg.disabled = true;
        btnLastPg.disabled = true;
        btnPrevPg.disabled = true;
        btnFirstPg.disabled = true;
        $('.page-container').css('display', 'none');
    }

    function setIndexscreen(fromPorterIcon) {
        var IsUser = $('#chkUserRequest').prop('checked');
        $('#divUserHeaders').css('display', IsUser ? 'inline-flex' : 'none');
        $('#divRequestHeaders').css('display', IsUser ? 'none' : 'inline-flex');
        $('#taskfileters').css('display', IsUser ? 'none' : '');
        if (IsUser) {
            getPorterStatus('0');
        } else if (fromPorterIcon) {
            Select('divPendingPercentage', 'PENDING');
        } else {
            setRequestUsers('Tasks');
        }
    }

    function setServiceUpdates(svcCode) {
        switch (svcCode) {
            case '2':
                $('#pageLinkPlanner').html('<a href="../Planner/SheduledBreakfast.aspx"> <span> <img src="../images/spiral-calendar.png" alt="Planner"></span> Shed. Breakfast </a> ');
                break;
            default:
                $('#pageLinkPlanner').html('<a href="../Planner/Planner.aspx"> <span> <img src="../images/spiral-calendar.png" alt="Planner"></span> Planner </a>');
        }
        if (callFrom == 'Parent') setIndexscreen();
    }

    function LoadProcess(RequestStatusID) {
    }

    function ReloadLinks() {
        if (sessionStorage.getItem('ROLE') == null) window.location = '../Login.aspx';
    }

    function fixAllAriaHiddenWarnings() {
        if (ariaFixed) return;
        ariaFixed = true;

        $('.modal').on('show.bs.modal shown.bs.modal', function () {
            $(this).removeAttr('aria-hidden');
        }).on('hide.bs.modal', function () {
            if (document.activeElement && this.contains(document.activeElement)) document.activeElement.blur();
        }).on('hidden.bs.modal', function () {
            $(this).attr('aria-hidden', 'true');
            if (document.activeElement && this.contains(document.activeElement)) document.activeElement.blur();
        });

        $(document).on('click', 'button, .btn, [data-bs-dismiss="modal"]', function () {
            $(this).blur();
        });

        if (window.bootstrap && bootstrap.Modal && bootstrap.Modal.prototype && !bootstrap.Modal.prototype.__patched) {
            var originalShow = bootstrap.Modal.prototype.show;
            var originalHide = bootstrap.Modal.prototype.hide;
            bootstrap.Modal.prototype.show = function () {
                if (this._element) this._element.removeAttribute('aria-hidden');
                return originalShow.apply(this, arguments);
            };
            bootstrap.Modal.prototype.hide = function () {
                if (this._element) {
                    var focused = this._element.querySelector(':focus');
                    if (focused) focused.blur();
                }
                return originalHide.apply(this, arguments);
            };
            bootstrap.Modal.prototype.__patched = true;
        }

        var observer = new MutationObserver(function (mutations) {
            mutations.forEach(function (m) {
                if (m.type === 'attributes' && m.attributeName === 'aria-hidden') {
                    var t = $(m.target);
                    if (t.is(':visible') && t.attr('aria-hidden') === 'true') t.removeAttr('aria-hidden');
                }
            });
        });
        $('.modal').each(function () {
            observer.observe(this, { attributes: true, attributeFilter: ['aria-hidden'] });
        });
    }

    function saveUIState() {
        var iconBar = document.getElementById('iconBar');
        var hamburger = document.getElementById('hamburger');
        var leftPanel = document.querySelector('.screen-left-panel');
        var hospitalImg = document.getElementById('hospitalImg');
        localStorage.setItem('iconBarHidden', iconBar ? iconBar.classList.contains('hidden') : false);
        localStorage.setItem('hamburgerHidden', hamburger ? hamburger.classList.contains('hidden') : false);
        localStorage.setItem('leftPanelHidden', leftPanel ? leftPanel.classList.contains('hidden') : false);
        localStorage.setItem('hospitalImgHidden', hospitalImg ? hospitalImg.classList.contains('hidden') : false);
    }

    function cleanupAbortControllers() {
        if (pendingAbortController) { pendingAbortController.abort(); pendingAbortController = null; }
        if (startedAbortController) { startedAbortController.abort(); startedAbortController = null; }
        activeFetchControllers.forEach(function (c) { c.abort(); });
        activeFetchControllers = [];
    }

    function fetchWithAbort(url, options) {
        options = options || {};
        var controller = new AbortController();
        options.signal = controller.signal;
        activeFetchControllers.push(controller);
        return fetch(url, options).finally(function () {
            activeFetchControllers = activeFetchControllers.filter(function (c) { return c !== controller; });
        }).catch(function (error) {
            if (error.name !== 'AbortError') console.error('Fetch error:', error);
        });
    }

    function abortAllFetchRequests() {
        activeFetchControllers.forEach(function (c) { c.abort(); });
        activeFetchControllers.length = 0;
    }

    function AbortAllActiveRuquests() {
        if (!$.xhrPool) return;
        $($.xhrPool).each(function (i, jqXHR) {
            jqXHR.abort();
            $.xhrPool.splice(i, 1);
        });
    }

    function loadingBlock(text) {
        return '<div class="text-center p-4"><div class="spinner-border text-info" role="status" style="width: 2rem; height: 2rem;"><span class="visually-hidden">Loading...</span></div><div class="mt-2 fw-semibold text-muted small">' + text + '</div></div>';
    }

    function emptyBlock(title, sub) {
        return '<div class="text-center p-4"><i class="bi bi-inbox fs-1 mb-3 text-muted opacity-50 d-block"></i><div class="h6 fw-semibold text-muted mb-1">' + title + '</div><small class="text-muted">' + sub + '</small></div>';
    }

    function errorBlock() {
        return '<div class="text-center p-4"><i class="bi bi-exclamation-triangle fs-1 mb-3 text-danger d-block"></i><div class="h6 fw-semibold text-danger">Failed to load tasks</div><small class="text-muted">Please try again</small></div>';
    }

    function isPrebookChecked() {
        var c = document.getElementById('showPrebookedCheckbox');
        return !!(c && c.checked);
    }

    function reloadTasks(serviceId) {
        currentServiceId = String(serviceId);
        var search = document.getElementById('pendingFilter').value.trim();
        var list = document.getElementById('pendingList');
        if (list && list.children.length === 0) list.innerHTML = loadingBlock('Loading tasks...');
        else if (list) list.classList.add('refreshing');
        document.getElementById('containerDates').style.display = 'none';
        document.getElementById('containerTimes').style.display = 'none';
        fetchAndRenderTasks('2', 'pendingList', serviceId, search, pendingSortOrder);
    }

    function reloadStartedTasks(serviceId) {
        currentServiceId = String(serviceId);
        var search = document.getElementById('startedFilter').value.trim();
        var list = document.getElementById('startedList');
        if (list && list.children.length === 0) list.innerHTML = loadingBlock('Loading tasks...');
        else if (list) list.classList.add('refreshing');
        fetchAndRenderTasks('4', 'startedList', serviceId, search, startedSortOrder);
    }

    function reloadPrebookTasks(serviceId) {
        currentServiceId = String(serviceId);
        var search = document.getElementById('pendingFilter').value.trim();
        var list = document.getElementById('pendingList');
        if (list && list.children.length === 0) list.innerHTML = loadingBlock('Loading pre-booked tasks...');
        else if (list) list.classList.add('refreshing');
        fetchAndRenderTasks('15', 'pendingList', serviceId, search, pendingSortOrder);
        document.getElementById('containerDates').style.display = 'block';
        document.getElementById('containerTimes').style.display = 'block';
    }

    function getCurrentTaskLoader(serviceId) {
        return isPrebookChecked() ? function () { reloadPrebookTasks(serviceId); } : function () { reloadTasks(serviceId); };
    }

    function fetchAndRenderTasks(status, listId, serviceId, search, sortOrder) {
        sortOrder = sortOrder || 'asc';
        var listContainer = document.getElementById(listId);
        if (!listContainer) return;
        clearTimeout(listTimers[listId]);

        listTimers[listId] = setTimeout(function () {
            var isPending = listId === 'pendingList';
            var prev = isPending ? pendingAbortController : startedAbortController;
            if (prev && !prev.signal.aborted) prev.abort();
            var controller = new AbortController();
            if (isPending) pendingAbortController = controller; else startedAbortController = controller;
            var requestId = Date.now();

            if (isPending && isPrebookChecked()) status = '15';

            listContainer.setAttribute('data-loading-id', requestId);

            var payload = {
                userId: sessionStorage.getItem('ID'),
                roleId: '1',
                status: Array.isArray(status) ? status.join(',') : (status || ''),
                pageIndex: '0',
                pageSize: '300',
                search: search || '',
                serviceId: serviceId || '',
                SortOrder: sortOrder
            };
            var f = isPending ? pendingFilters : startedFilters;
            Object.keys(f).forEach(function (k) { if (f[k]) payload[k] = f[k]; });

            var opts = {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ payload: encryptPayload(payload) }),
                signal: controller.signal
            };
            if (isPending) opts.priority = 'high';

            fetch('/Index/Service/Service.aspx?Process=' + encodeURIComponent(Encrypt('GetUserRequests')), opts)
                .then(function (response) {
                    if (!response.ok) throw new Error('HTTP error! status: ' + response.status);
                    return response.json();
                })
                .then(function (data) {
                    if (String(serviceId) !== currentServiceId || listContainer.getAttribute('data-loading-id') != requestId) return;
                    listContainer.classList.remove('loading');
                    listContainer.innerHTML = '';
                    if (data.d && Array.isArray(data.d)) {
                        if (data.d.length > 0) {
                            requestAnimationFrame(function () { renderTasksFromSP(data.d, listId); });
                        } else {
                            listContainer.innerHTML = emptyBlock(isPending ? 'No pending tasks found' : 'No started tasks found', 'No tasks match your filters');
                        }
                    } else {
                        listContainer.innerHTML = errorBlock();
                    }
                    listContainer.removeAttribute('data-loading-id');
                })
                .catch(function (err) {
                    if (listContainer.getAttribute('data-loading-id') != requestId) return;
                    listContainer.classList.remove('loading');
                    if (err.name === 'AbortError') {
                        listContainer.removeAttribute('data-loading-id');
                        return;
                    }
                    console.error('Error fetching tasks:', err);
                    if (listContainer.children.length === 0) listContainer.innerHTML = errorBlock();
                    listContainer.removeAttribute('data-loading-id');
                });
        }, 200);
    }

    function parseTimeDifference(str) {
        var match = /(-?)(\d+)h\s+(\d+)m/.exec(str);
        if (!match) return 0;
        var sign = match[1] === '-' ? -1 : 1;
        return sign * (parseInt(match[2], 10) * 60 + parseInt(match[3], 10));
    }

    function renderTasksFromSP(tasks, listId) {
        var taskList = document.getElementById(listId);
        if (!taskList) return;

        var spinner = taskList.querySelector('.spinner-border');
        if (spinner) {
            var sc = spinner.closest('.text-center');
            if (sc) sc.remove();
        }
        var hasExistingData = taskList.children.length > 0;
        taskList.classList.remove('refreshing');

        if (!tasks || tasks.length === 0) {
            if (!hasExistingData) taskList.innerHTML = emptyBlock('No tasks found', 'No tasks match your filters');
            return;
        }

        var fragment = document.createDocumentFragment();
        var template = document.getElementById('taskRowTemplate');
        var seen = {};

        tasks.forEach(function (task) {
            if (seen[task.REQUESTID]) return;
            seen[task.REQUESTID] = true;
            taskIndex[task.REQUESTID] = task;

            var row = template.content.firstElementChild.cloneNode(true);
            var rid = esc(task.REQUESTID);

            row.querySelector('.task-category').textContent = task.CATEGORYNAME + ' #' + task.REQUESTID;
            row.querySelector('.task-from').textContent = task.FROM;
            row.querySelector('.task-to').textContent = task.TO;
            row.querySelector('.task-equipment-name').textContent = task.EquipmentName;
            row.querySelector('.task-patient-name').textContent = task.PATIENTNAME || 'N/A';
            row.querySelector('.task-contact-no').innerHTML = task.CONTACTNO ? '<i class="bi bi-telephone text-dark"></i> ' + esc(task.CONTACTNO) : '';

            var reqEl = row.querySelector('.task-requestor-info');
            reqEl.innerHTML = '<div class="d-flex align-items-center gap-1 requestor-info" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#requestorModal" title="View full Remarks"><i class="bi bi-journal-text text-dark"></i><span></span></div>';
            var reqInner = reqEl.firstElementChild;
            reqInner.setAttribute('data-requestor', task.REQUESTDESKREMARKS || 'No Remarks');
            reqInner.querySelector('span').textContent = task.REQUESTOR || task.REQUESTORNAME || 'N/A';

            row.querySelector('.task-porter-name').textContent = task.PORTERNAME || 'N/A';
            row.querySelector('.task-multiporter-info').innerHTML = (task.ISMULTIPORTER || '').toLowerCase() === 'yes'
                ? '<div class="d-flex align-items-center gap-1"><i class="bi bi-person-plus-fill" style="color:grey;"></i> Assistant Required</div>' : '';
            row.querySelector('.task-prebook-info').innerHTML = (task.ISPREBOOK || '').toLowerCase() === 'yes'
                ? '<div class="d-flex align-items-center gap-1"><i class="bi bi-calendar-check-fill" style="color:grey;"></i> Prebooked Task - ' + esc(task.REQUESTTIME || '') + '</div>' : '';
            row.querySelector('.task-status').textContent = task.REQUESTSTATUS || 'Status';

            var dropdownEl = row.querySelector('.task-dropdown-menu');
            if (listId === 'pendingList') {
                dropdownEl.innerHTML =
                    '<li><a class="dropdown-item edit-task" href="#" data-request-id="' + rid + '"><i class="bi bi-pencil-square me-2"></i> Edit Task</a></li>' +
                    '<li><a class="dropdown-item hold-task" href="#" data-request-id="' + rid + '"><i class="bi bi-pause-circle me-2"></i> Hold task</a></li>' +
                    '<li><a class="dropdown-item resume-task ' + (task.REQUESTSTATUS === 'On-Hold' ? '' : 'disabled faded') + '" href="#" data-request-id="' + rid + '"><i class="bi bi-play-circle me-2"></i> Resume task</a></li>' +
                    '<li><a class="dropdown-item assign-task" href="#" data-request-id="' + rid + '"><i class="bi bi-person-plus me-2"></i> Assign</a></li>' +
                    '<li><a class="dropdown-item show-details-btn" href="#" data-request-id="' + rid + '"><i class="bi bi-journal-text me-2"></i> Show details</a></li>' +
                    '<li><a class="dropdown-item copy-task" href="#" data-request-id="' + rid + '"><i class="bi bi-clipboard me-2"></i> Copy task</a></li>' +
                    '<li><a class="dropdown-item text-danger cancel-task" href="#" data-request-id="' + rid + '"><i class="bi bi-trash me-2"></i> Cancel task</a></li>';
            } else {
                dropdownEl.innerHTML =
                    '<li><a class="dropdown-item reassign-task" href="#" data-request-id="' + rid + '"><i class="bi bi-arrow-left-right me-2"></i> Reassign</a></li>' +
                    '<li><a class="dropdown-item edit-task" href="#" data-request-id="' + rid + '"><i class="bi bi-pencil-square me-2"></i> Edit Task</a></li>' +
                    '<li><a class="dropdown-item show-details-btn" href="#" data-request-id="' + rid + '"><i class="bi bi-journal-text me-2"></i> Show details</a></li>' +
                    '<li><a class="dropdown-item hold-task" href="#" data-request-id="' + rid + '"><i class="bi bi-pause-circle me-2"></i> Hold task</a></li>' +
                    '<li><a class="dropdown-item copy-task" href="#" data-request-id="' + rid + '"><i class="bi bi-clipboard me-2"></i> Copy task</a></li>' +
                    '<li><a class="dropdown-item text-danger cancel-task" href="#" data-request-id="' + rid + '"><i class="bi bi-trash me-2"></i> Cancel task</a></li>' +
                    '<li><a class="dropdown-item text-danger end-task" href="#" data-request-id="' + rid + '"><i class="bi bi-stop-circle me-2"></i> End task</a></li>';
            }

            var badgeEl = row.querySelector('.task-badge');
            var timeDiff = parseTimeDifference(task.TimeDifference || '0h 0m');
            badgeEl.style.backgroundColor = timeDiff < 0 ? '#FADBD8' : '#E2F6D9';
            badgeEl.style.color = timeDiff < 0 ? '#922B21' : '#196F3D';
            badgeEl.textContent = task.TimeDifference || '0m';

            fragment.appendChild(row);
        });

        if (fragment.children.length > 0) {
            taskList.innerHTML = '';
            taskList.appendChild(fragment);
        } else if (!hasExistingData) {
            taskList.innerHTML = emptyBlock('No tasks found', 'No tasks match your filters');
        }
    }

    function openHoldTaskModal(requestId) {
        var modalEl = document.getElementById('modalTaskHold');
        if (!modalEl) return;
        modalEl.setAttribute('data-request-id', requestId);
        var holdModal = bootstrap.Modal.getOrCreateInstance(modalEl);
        var btn = document.getElementById('btnConfirmHold');
        $('#loadHoldReasons').val(null).trigger('change');
        var nb = btn.cloneNode(true);
        btn.parentNode.replaceChild(nb, btn);
        nb.addEventListener('click', function () {
            var reason = $('#loadHoldReasons').val();
            if (!reason) { alert('Please select a reason.'); return; }
            holdModal.hide();
            postService('SETONHOLDTASKS', {
                requestId: Encrypt(requestId.toString()),
                reason: Encrypt(reason),
                userId: Encrypt(sessionStorage.getItem('ID')),
                porterIds: Encrypt(''),
                miIndex: Encrypt('0')
            }).then(function (data) {
                if (data.success) {
                    showSuccessModal('Task put on hold successfully!');
                    if (window.RefreshAll) window.RefreshAll();
                } else {
                    alert('Failed to put task on hold: ' + (data.message || 'Unknown error'));
                }
            }).catch(function (err) { alert('Network error: ' + err.message); });
        });
        holdModal.show();
    }

    function openCancelTaskModal(requestId) {
        var modalEl = document.getElementById('modalTaskCancel');
        if (!modalEl) return;
        modalEl.setAttribute('data-request-id', requestId);
        var cancelModal = bootstrap.Modal.getOrCreateInstance(modalEl);
        var btn = document.getElementById('btnConfirmCancelTask');
        document.getElementById('ddlCancelReasons').value = '';
        var nb = btn.cloneNode(true);
        btn.parentNode.replaceChild(nb, btn);
        nb.addEventListener('click', function () {
            var reason = document.getElementById('ddlCancelReasons').value.trim();
            if (!reason) { alert('Please select a reason for cancellation.'); return; }
            cancelModal.hide();
            postService('CANCELREQUEST', {
                requestId: Encrypt(requestId),
                prebook: Encrypt('NO'),
                reason: Encrypt(reason),
                porterIds: Encrypt(''),
                userId: Encrypt(sessionStorage.getItem('ID') || ''),
                miIndex: Encrypt('0')
            }).then(function (data) {
                if (data.success) {
                    showSuccessModal('Task cancelled successfully!');
                    if (window.RefreshAll) window.RefreshAll();
                } else {
                    alert('Failed to cancel task: ' + (data.message || 'Unknown error'));
                }
            }).catch(function (err) { alert('Network error: ' + err.message); });
        });
        cancelModal.show();
    }

    function setResponseFailure(requestId, reason) {
        $.ajax({
            type: 'GET',
            url: '/Index/Service/Service.aspx?Process=' + encodeURIComponent(encryptAES('SetResponseFailure')) +
                '&requestId=' + encodeURIComponent(encryptAES(requestId.toString())) +
                '&reason=' + encodeURIComponent(reason),
            dataType: 'json',
            error: function (xhr, status, error) { console.error('Error setting response failure:', error); }
        });
    }

    function askKpiReason(requestId, onProceed, onAbort) {
        var kpiModalEl = document.getElementById('kpiModal');
        var kpiModal = bootstrap.Modal.getOrCreateInstance(kpiModalEl);
        var ddl = document.getElementById('ddlKPIReasons');
        ddl.value = '';
        var actionBtn = document.getElementById('kpiModalActionBtn');
        var nb = actionBtn.cloneNode(true);
        actionBtn.parentNode.replaceChild(nb, actionBtn);
        var proceeded = false;
        nb.addEventListener('click', function () {
            var reason = ddl.value.trim();
            if (!reason) { alert('Please select a reason for the negative KPI before proceeding.'); return; }
            proceeded = true;
            setResponseFailure(requestId, reason);
            kpiModal.hide();
            onProceed();
        });
        $(kpiModalEl).one('hidden.bs.modal', function () {
            if (!proceeded && onAbort) onAbort();
        });
        kpiModal.show();
    }

    function openAssignForTask() {
        var filterInput = document.getElementById('assignEmployeeFilter');
        var container = document.getElementById('freeEmployeeList');
        if (filterInput) filterInput.value = '';
        if (container) container.innerHTML = '';
        hideAllModals();
        bootstrap.Modal.getOrCreateInstance(document.getElementById('assignModal')).show();
    }

    function completeTask(requestId) {
        var encRequestId = Encrypt(requestId);
        return fetch('/Index/Service/Service.aspx?Process=' + encodeURIComponent(Encrypt('GetSingleRequestDetails')) + '&requestId=' + encodeURIComponent(encRequestId))
            .then(function (r) { return r.text(); })
            .then(function (text) {
                var details;
                try { details = JSON.parse(text); } catch (e) { throw new Error('Failed to parse task details'); }
                if (!Array.isArray(details) || details.length === 0) throw new Error('No task details found');
                var porterId = details[0].PORTERID;
                if (!porterId) throw new Error('No porter assigned to this task. Cannot end task.');
                var n = new Date();
                var p = function (v) { return String(v).padStart(2, '0'); };
                var endTime = p(n.getMonth() + 1) + '/' + p(n.getDate()) + '/' + n.getFullYear() + ' ' + p(n.getHours()) + ':' + p(n.getMinutes()) + ':' + p(n.getSeconds());
                return postService('COMPLETETASK', {
                    requestId: encRequestId,
                    userId: Encrypt(porterId.toString()),
                    requestStatus: Encrypt('COMPLETETASK'),
                    porterRemarks: Encrypt(''),
                    startTime: Encrypt(''),
                    endTime: Encrypt(endTime),
                    remarksId: Encrypt(''),
                    name: Encrypt(''),
                    phoneNo: Encrypt(''),
                    catSignFName: Encrypt(''),
                    catPhotoFName: Encrypt(''),
                    ackPhotoTimeStamp: Encrypt(''),
                    ackLocStamp: Encrypt(''),
                    process: Encrypt('COMPLETETASK')
                });
            })
            .then(function (result) {
                if (result.success) {
                    showTaskEndedModal('Task ended successfully');
                    if (window.RefreshAll) window.RefreshAll();
                } else {
                    throw new Error(result.message || 'Unknown error');
                }
            })
            .catch(function (err) {
                console.error('Complete task failed:', err);
                alert(err.message || 'Error completing task');
            });
    }

    function bindTaskListActions(listId) {
        $('#' + listId).on('click', '.hold-task, .cancel-task, .resume-task, .copy-task, .assign-task, .show-details-btn, .end-task', function (e) {
            e.preventDefault();
            var el = this;
            var id = el.getAttribute('data-request-id');
            var task = taskIndex[id] || {};
            var cl = el.classList;

            if (cl.contains('hold-task')) {
                openHoldTaskModal(id);
            } else if (cl.contains('cancel-task')) {
                openCancelTaskModal(id);
            } else if (cl.contains('resume-task')) {
                if (cl.contains('disabled')) return;
                postService('RELEASEONHOLD', { requestId: Encrypt(id), userId: Encrypt(sessionStorage.getItem('ID')) })
                    .then(function (data) {
                        if (data.success) {
                            showTaskResumedModal();
                            if (window.RefreshAll) window.RefreshAll();
                        } else {
                            alert('Failed to resume task: ' + (data.message || 'Unknown error'));
                        }
                    }).catch(function (err) { alert('Network error: ' + err.message); });
            } else if (cl.contains('copy-task')) {
                postService('COPYTASK', { requestId: Encrypt(id) })
                    .then(function (data) {
                        if (data.success) {
                            showTaskCopiedModal();
                            if (window.RefreshAll) window.RefreshAll();
                        } else {
                            alert('Error copying task: ' + (data.message || 'Unknown error'));
                        }
                    }).catch(function (err) { alert('Network error: ' + err.message); });
            } else if (cl.contains('assign-task')) {
                currentRequestId = id;
                var responseKPI = parseInt(task.RESPONSEKPICAL || '-1', 10);
                if (responseKPI < 0) askKpiReason(id, openAssignForTask);
                else openAssignForTask();
            } else if (cl.contains('show-details-btn')) {
                fetchTaskDetailsAndShow(id);
            } else if (cl.contains('end-task')) {
                if (endingTasks[id]) return;
                var completionKPI = parseInt(task.COMPLETIONKPICAL || '-19090909090909', 10);
                if (completionKPI === -19090909090909) return;
                endingTasks[id] = true;
                var done = function () { delete endingTasks[id]; };
                if (completionKPI < 0) {
                    hideAllModals();
                    askKpiReason(id, function () { completeTask(id).then(done); }, done);
                } else {
                    completeTask(id).then(done);
                }
            }
        });
    }

    function fetchTaskDetailsAndShow(requestId) {
        fetch('/Index/Service/Service.aspx?Process=' + encodeURIComponent(encryptAES('GetSingleRequestDetails')) + '&requestId=' + encodeURIComponent(encryptAES(requestId)))
            .then(function (response) {
                if (!response.ok) throw new Error('HTTP error! status: ' + response.status);
                return response.json();
            })
            .then(function (tasks) {
                var task = tasks && tasks.length > 0 ? tasks[0] : null;
                var content = document.getElementById('taskDetailsContent');
                if (!task) {
                    content.innerHTML = "<p class='text-danger'>No details found for Request ID: " + esc(requestId) + '</p>';
                    return;
                }
                var line = function (label, value) { return '<p><strong>' + label + ':</strong> ' + esc(value) + '</p>'; };
                content.innerHTML = '<div class="task-details p-3">' +
                    line('Request ID', task.REQUESTID || 'N/A') +
                    line('Request Date', task.Requestdate || 'N/A') +
                    line('Category Name', task.CATEGORYNAME || 'N/A') +
                    line('Remarks', task.RequestDeskRemarks || 'N/A') +
                    line('From', task.FROM || task.FROM_LOCATION || 'N/A') +
                    line('To', task.TO || task.TO_LOCATION || 'N/A') +
                    line('Patient Name', task.PATIENTNAME || 'N/A') +
                    line('Requestor', task.REQUESTORNAME || 'N/A') +
                    line('Equipment Name', task.EquipmentName || 'N/A') +
                    line('Porter Description', task.IsMultiPorterDescription || 'N/A') +
                    line('Task Description', (task.PreBookedTaskDescription || 'Default Task') + ' - ' + (task.REQUESTTIME || '')) +
                    line('Porter', task.PORTERNAME || 'Unassigned') +
                    line('Contact No', task.CONTACTNO || 'N/A') +
                    line('Status', task.REQUESTSTATUS || 'N/A') +
                    line('Time Difference', task.TimeDifference || 'N/A') +
                    '</div>';
                getModalInstance('taskDetailsModal').show();
            })
            .catch(function (err) {
                console.error('Error fetching task details:', err);
                var c = document.getElementById('taskDetailsContent');
                if (c) c.innerHTML = "<p class='text-danger'>Failed to load details. Please try again.</p>";
            });
    }

    function sortPendingTasks(order) {
        if (order !== 'asc' && order !== 'desc') return;
        pendingSortOrder = order;
        var sid = activeServiceId();
        if (sid) getCurrentTaskLoader(sid)();
    }

    function sortStartedTasks(order) {
        if (order !== 'asc' && order !== 'desc') return;
        startedSortOrder = order;
        var sid = activeServiceId();
        if (sid) reloadStartedTasks(sid);
    }

    function sortTasks(sortOrder) {
        var f = document.getElementById('employeeFilter');
        employeeSortOrder = sortOrder;
        loadEmployeesList(f ? f.value.trim() : '', activeServiceId(), sortOrder);
    }

    function resetFilterState() {
        pendingFilters = {};
        startedFilters = {};
    }

    function refreshColumns(withFilterReset) {
        var sid = activeServiceId();
        var empInput = document.getElementById('employeeFilter');
        var empFilter = empInput ? empInput.value : '';
        getCurrentTaskLoader(sid)();
        reloadStartedTasks(sid);
        var p = loadEmployeesList(withFilterReset ? '' : empFilter, sid, employeeSortOrder);
        return p;
    }

    window.RefreshTasks = async function (filter, serviceId) {
        if (isRefreshing) return;
        isRefreshing = true;
        clearInterval(window.AutoRefresh);
        cleanupAbortControllers();
        abortAllFetchRequests();
        LoaderOn();
        try {
            var cb = document.getElementById('showPrebookedCheckbox');
            if (cb) cb.checked = false;
            var heading = document.querySelector('[data-heading="pending"]');
            if (heading) heading.textContent = 'Pending';
            ['pendingFilter', 'startedFilter', 'employeeFilter'].forEach(function (id) {
                var i = document.getElementById(id);
                if (i) i.value = '';
            });
            resetFilterState();
            var sid = serviceId || activeServiceId();
            reloadTasks(sid);
            reloadStartedTasks(sid);
            await loadEmployeesList('', sid, employeeSortOrder);
        } catch (err) {
            console.error('Error in RefreshTasks:', err);
        } finally {
            LoaderOff(600);
            saveUIState();
            RestartTimer_AutoRefresh();
            isRefreshing = false;
        }
    };

    window.NewAutoRefresh = async function () {
        cleanupAbortControllers();
        try {
            await refreshColumns(false);
        } catch (err) {
            console.error('Error during refresh:', err);
        }
    };

    window.RefreshAll = window.NewAutoRefresh;

    function fn_refreshAll() {
        if (isRefreshing) return;
        isRefreshing = true;
        cleanupAbortControllers();
        abortAllFetchRequests();
        LoaderOn();
        setTimeout(function () {
            window.NewAutoRefresh();
            LoaderOff(800);
            isRefreshing = false;
        }, 250);
    }

    function loadEmployeesList(filter, serviceId, sortOrder) {
        filter = filter || '';
        serviceId = serviceId || '';
        sortOrder = sortOrder || employeeSortOrder;

        var container = document.getElementById('employeeList');
        if (!container) return Promise.resolve();
        if (lastEmployeeRequest) lastEmployeeRequest.abort();

        var requestId = Date.now().toString();
        container.setAttribute('data-loading-id', requestId);

        if (container.children.length === 0) {
            container.innerHTML = '<div id="employeeSpinner" class="text-center p-4 loading-spinner"><div class="spinner-border text-info" role="status" style="width: 2rem; height: 2rem;"><span class="visually-hidden">Loading...</span></div><div class="mt-2 fw-semibold text-muted small">Loading employees...</div></div>';
        } else {
            container.classList.add('refreshing');
        }

        if (String(serviceId) === '2') serviceId = '3';

        var url = '/Index/Service/Service.aspx?Process=' + encodeURIComponent(Encrypt('fetchEmployees')) +
            '&filter=' + encodeURIComponent(Encrypt(filter)) +
            '&serviceId=' + encodeURIComponent(Encrypt(serviceId.toString())) +
            '&sortOrder=' + encodeURIComponent(Encrypt(sortOrder));

        var controller = new AbortController();
        lastEmployeeRequest = controller;

        return fetch(url, { signal: controller.signal })
            .then(function (response) {
                if (!response.ok) throw new Error('HTTP error ' + response.status);
                return response.text();
            })
            .then(function (text) {
                if (container.getAttribute('data-loading-id') !== requestId) return;
                container.classList.remove('refreshing');
                var data;
                try {
                    data = JSON.parse(text);
                } catch (e) {
                    container.innerHTML = "<div class='text-center p-4'><div class='h6 fw-semibold text-danger mb-2'>Failed to load employees</div><small class='text-muted'>Invalid response format</small></div>";
                    container.removeAttribute('data-loading-id');
                    return;
                }
                if (data && Array.isArray(data) && data.length > 0) {
                    container.innerHTML = '';
                    bindEmployeeData(data, serviceId);
                } else if (container.children.length === 0) {
                    container.innerHTML = "<div id='employeeNoData' class='text-center p-4'><div class='h6 fw-semibold text-muted mb-2'>No employees found</div><small class='text-muted'>No employees match your filters</small></div>";
                }
                container.removeAttribute('data-loading-id');
            })
            .catch(function (err) {
                if (container.getAttribute('data-loading-id') !== requestId) return;
                container.classList.remove('refreshing');
                if (err.name !== 'AbortError') {
                    console.error('Employee load error:', err);
                    if (container.children.length === 0) {
                        container.innerHTML = "<div class='text-center p-4'><div class='h6 fw-semibold text-danger mb-2'>Failed to load employees</div><small class='text-muted'>Please try again</small></div>";
                    }
                }
                container.removeAttribute('data-loading-id');
            });
    }

    window.employeeLoader = loadEmployeesList;

    function formatLoginTime(raw) {
        if (raw && String(raw).indexOf('/Date(') > -1) {
            var ts = parseInt(String(raw).replace(/\/Date\((\d+)\)\//, '$1'));
            if (!isNaN(ts)) {
                return new Date(ts).toLocaleString(undefined, { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: true });
            }
        }
        return 'N/A';
    }

    function showEmployeeDetails(emp) {
        var workTime = 'N/A';
        if (emp.WORKTIME && !isNaN(emp.WORKTIME)) {
            var total = parseInt(emp.WORKTIME, 10);
            workTime = Math.floor(total / 60) + ' hours ' + (total % 60) + ' min';
        }
        document.getElementById('employeeDetailModalLabel').textContent = 'Employee Name: ' + (emp.USERNAME || 'N/A');
        var line = function (label, value) { return '<p><strong>' + label + ':</strong> ' + esc(value) + '</p>'; };
        document.getElementById('employeeDetailBody').innerHTML =
            line('Username', emp.USERNAME || 'N/A') +
            line('Logined Time', formatLoginTime(emp.LoginedTime)) +
            line('Email', emp.EMAIL || 'N/A') +
            line('Role', emp.ROLE || 'N/A') +
            line('Device', emp.DEVICE || 'N/A') +
            line('Hospital Name', emp.HOSPITALNAME1 || 'N/A') +
            line('Shift', emp.ALL_DAY || 'N/A') +
            line('SLA', emp.SLA || 'N/A') +
            line('Work Time', workTime) +
            line('Location', emp.ZoneName || 'N/A') +
            line('Status', emp.STATUS || 'N/A') +
            line('Task Id', emp.RequestIDs ? emp.RequestIDs.split(',').map(function (id) { return '#' + id.trim(); }).join(', ') : 'Not Assigned');
        getModalInstance('employeeDetailModal').show();
    }

    function bindEmployeeData(data, serviceId) {
        var container = document.getElementById('employeeList');
        employeeListMode = 'normal';
        employeeCache = data || [];

        if (!data || data.length === 0) {
            if (container.children.length === 0) container.innerHTML = "<p class='text-center text-muted py-4'>No employee data found.</p>";
            return;
        }

        var spinner = container.querySelector('.spinner-border');
        if (spinner) {
            var sc = spinner.closest('.text-center');
            if (sc) sc.remove();
        }
        container.classList.remove('refreshing');

        var html = data.map(function (emp) {
            var serviceLabel = 'N/A';
            if (emp.EQ_SERVICEID) {
                var labels = emp.EQ_SERVICEID.toString().split(',').map(function (id) {
                    id = id.trim();
                    return id === '1' ? 'QAH' : id === '3' ? 'R&D' : '';
                }).filter(Boolean);
                serviceLabel = labels.join(' | ');
            }

            var status = (emp.STATUS || '').toLowerCase();
            var isCheckedOut = status === 'checked out';
            var isOnBreak = status === 'on break';
            var isOnMeal = status === 'on meal';
            var isOnTask = !!(emp.STATUS && emp.STATUS.indexOf('On task') === 0);
            var inactive = isOnMeal || isCheckedOut || isOnBreak;

            var statusColor = emp.STATUS === 'Free' ? '#196F3D' : isOnTask ? '#A14C00' : inactive ? '#666' : '#000';
            var statusBg = emp.STATUS === 'Free' ? '#E2F6D9' : isOnTask ? '#FFF5E5' : inactive ? '#F0F0F0' : '#EAEAEA';

            var dis = function (ok) { return ok ? '' : 'disabled-option'; };
            var restLabel = isOnBreak ? 'End rest break' : 'Take rest break';
            var restAction = isOnBreak ? 'end' : 'start';
            var restOk = isOnBreak || (!isOnMeal && !isCheckedOut && !isOnTask);
            var mealLabel = isOnMeal ? 'End meal break' : 'Take meal break';
            var mealAction = isOnMeal ? 'end' : 'start';
            var mealOk = isOnMeal || (!isOnBreak && !isCheckedOut && !isOnTask);
            var assignOk = !inactive;
            var checkInOk = isCheckedOut;
            var checkOutOk = !inactive;
            var id = esc(emp.ID);
            var name = esc(emp.USERNAME || '');
            var st = esc((emp.STATUS || '').toLowerCase());

            return '<div class="employee-card border rounded p-2 mb-2 shadow-sm d-flex align-items-center justify-content-between">' +
                '<div class="fw-bold flex-shrink-0" style="min-width: 120px;">' + (name || 'N/A') + '</div>' +
                '<div class="text-muted small d-flex align-items-center flex-grow-1 mx-3"><i class="bi bi-clock me-1"></i> ' + esc(emp.WORKTIME || '0') +
                '<span class="mx-3"><i class="bi bi-geo-alt-fill me-1"></i> ' + esc(emp.LOCATION || 'N/A') + '</span>' +
                '<span class="mx-3"><i class="bi bi-person-badge me-1"></i> ' + esc(serviceLabel) + '</span></div>' +
                '<span>' + esc(emp.ACTION || '') + '</span>' +
                '<div class="d-flex align-items-center flex-shrink-0 dropdown">' +
                '<button class="btn btn-link text-muted p-0 m-0" type="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="bi bi-three-dots fs-5"></i></button>' +
                '<ul class="dropdown-menu dropdown-menu-end">' +
                '<li><a class="dropdown-item d-flex align-items-center openAssignRequestModal ' + dis(assignOk) + '" href="#" data-employee="' + id + '" data-type="porter"><i class="bi bi-person-plus me-2"></i> Assign</a></li>' +
                '<li><a class="dropdown-item d-flex align-items-center openAssignRequestModal ' + dis(assignOk) + '" href="#" data-employee="' + id + '" data-type="assistant"><i class="bi bi-people me-2"></i> Assign assistant</a></li>' +
                '<li><a class="dropdown-item d-flex align-items-center openBulkAssignModal ' + dis(assignOk) + '" href="#" data-employee="' + id + '" data-type="bulk"><i class="bi bi-person-lines-fill me-2"></i> Bulk Assign</a></li>' +
                '<li><a class="dropdown-item d-flex align-items-center take-rest-break ' + dis(restOk) + '" href="#" data-id="' + id + '" data-status="' + st + '" data-name="' + name + '" data-action="' + restAction + '"><i class="bi bi-cup-hot me-2"></i> ' + restLabel + '</a></li>' +
                '<li><a class="dropdown-item d-flex align-items-center take-meal-break ' + dis(mealOk) + '" href="#" data-id="' + id + '" data-status="' + st + '" data-name="' + name + '" data-action="' + mealAction + '"><i class="fas fa-utensils me-2"></i> ' + mealLabel + '</a></li>' +
                '<li class="message-menu-item"><a class="dropdown-item d-flex align-items-center send-message ' + dis(assignOk) + '" href="#" data-id="' + id + '"><i class="bi bi-chat-dots me-2"></i> Message</a></li>' +
                '<li><a class="dropdown-item d-flex align-items-center check-in ' + dis(checkInOk) + '" href="#" data-id="' + id + '" data-name="' + name + '"><i class="bi bi-box-arrow-in-right me-2"></i> Check In</a></li>' +
                '<li><a class="dropdown-item d-flex align-items-center check-out ' + dis(checkOutOk) + '" href="#" data-id="' + id + '" data-name="' + name + '"><i class="bi bi-box-arrow-right me-2"></i> Check Out</a></li>' +
                '<li><a class="dropdown-item d-flex align-items-center show-details" href="#" data-username="' + name + '"><i class="bi bi-journal-text me-2"></i> Show details</a></li>' +
                '</ul>' +
                '<span class="badge ms-2" style="background-color: ' + statusBg + '; color: ' + statusColor + ';">' + esc(emp.STATUS || 'N/A') + '</span>' +
                '</div></div>';
        }).join('');

        container.innerHTML = '';
        container.appendChild(document.createRange().createContextualFragment(html));

        var svc = activeServiceId();
        container.querySelectorAll('.message-menu-item').forEach(function (item) {
            if (svc === '1') item.style.display = 'none';
            else if (svc === '2') item.style.display = 'list-item';
        });

        syncButtonStates();
    }

    function syncButtonStates() {
        document.querySelectorAll('.take-rest-break, .take-meal-break').forEach(function (btn) {
            var userId = parseInt(btn.dataset.id, 10);
            var action = btn.dataset.action;
            if (!action) return;
            var type = btn.classList.contains('take-rest-break') ? 'rest' : 'meal';
            var key = type + action.charAt(0).toUpperCase() + action.slice(1);
            var locked = (processingUsers[key] && processingUsers[key][userId]) || (cooldownUsers[key] && cooldownUsers[key][userId]);
            btn.disabled = !!locked;
        });
    }

    function startCooldown(actionType, userId) {
        cooldownUsers[actionType][userId] = true;
        setTimeout(function () {
            delete cooldownUsers[actionType][userId];
            delete processingUsers[actionType][userId];
            syncButtonStates();
        }, 30000);
    }

    function initBreakHandlers() {
        var breakModalEl = document.getElementById('breakDurationModal');
        breakModal = bootstrap.Modal.getOrCreateInstance(breakModalEl);

        $(document).on('click', '.take-rest-break, .take-meal-break', function (e) {
            if (employeeListMode !== 'normal') return;
            var button = this;
            e.preventDefault();
            var userId = parseInt(button.dataset.id, 10);
            var action = button.dataset.action;
            var type = button.classList.contains('take-rest-break') ? 'rest' : 'meal';
            if (!userId || !action) return;
            var actionType = type + action.charAt(0).toUpperCase() + action.slice(1);
            if (processingUsers[actionType][userId] || cooldownUsers[actionType][userId]) return;

            if (action === 'end') {
                processingUsers[actionType][userId] = true;
                syncButtonStates();
                fetch('/Index/Service/Service.aspx?Process=' + encodeURIComponent(Encrypt(type === 'rest' ? 'EndRestBreak' : 'EndMealBreak')), {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                    body: JSON.stringify({ id: Encrypt(userId.toString()) })
                })
                    .then(function (res) { return res.text(); })
                    .then(function (text) {
                        var result = JSON.parse(text.replace(/\[\]$/, ''));
                        if (result.success) {
                            showEmployeeActionSuccess('Porter ' + userId + ': ' + result.message);
                            button.dataset.status = 'available';
                            button.dataset.action = 'start';
                            startCooldown(actionType, userId);
                        } else {
                            showEmployeeActionSuccess('Error: ' + result.message);
                            delete processingUsers[actionType][userId];
                            syncButtonStates();
                        }
                    })
                    .catch(function (err) {
                        console.error('End break error:', err);
                        alert('Network error: ' + err.message);
                        delete processingUsers[actionType][userId];
                        syncButtonStates();
                    });
            } else {
                hideAllModals();
                document.getElementById('breakType').value = type;
                document.getElementById('breakUserId').value = userId;
                document.getElementById('breakDurationInput').value = '';
                selectedBreakDuration = null;
                document.getElementById('confirmBreakBtn').disabled = true;
                breakModal.show();
            }
        });

        document.getElementById('breakDurationInput').addEventListener('input', function () {
            var value = parseInt(this.value, 10);
            selectedBreakDuration = (!isNaN(value) && value > 0 && value <= 180) ? value : null;
            document.getElementById('confirmBreakBtn').disabled = !selectedBreakDuration;
        });

        document.getElementById('confirmBreakBtn').addEventListener('click', function () {
            var btn = this;
            var type = document.getElementById('breakType').value;
            var userId = parseInt(document.getElementById('breakUserId').value, 10);
            var actionType = type + 'Start';
            if (!selectedBreakDuration || !userId) return;
            if (processingUsers[actionType][userId] || cooldownUsers[actionType][userId]) return;

            btn.disabled = true;
            processingUsers[actionType][userId] = true;
            syncButtonStates();

            fetch('/Index/Service/Service.aspx?Process=' + encodeURIComponent(Encrypt(type === 'rest' ? 'TriggerPorterBreak' : 'TriggerPorterMealBreak')), {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=utf-8' },
                body: JSON.stringify({
                    request: {
                        id: Encrypt(userId.toString()),
                        duration: Encrypt(selectedBreakDuration.toString()),
                        end: Encrypt('false')
                    }
                })
            })
                .then(function (res) { return res.text(); })
                .then(function (text) {
                    var result = JSON.parse(text.replace(/\[\]$/, ''));
                    if (result.message && result.message.indexOf('Porter is already in Task') > -1) {
                        showPorterWarningModal(result.message);
                    } else if (result.success) {
                        showEmployeeActionSuccess('Porter ' + userId + ': ' + result.message);
                        var breakBtn = document.querySelector('[data-id="' + userId + '"][data-action="start"]');
                        if (breakBtn) {
                            breakBtn.dataset.status = type === 'rest' ? 'on break' : 'on meal';
                            breakBtn.dataset.action = 'end';
                        }
                        startCooldown(actionType, userId);
                    } else {
                        showEmployeeActionSuccess('Error: ' + result.message);
                        delete processingUsers[actionType][userId];
                        syncButtonStates();
                    }
                    breakModal.hide();
                    if (window.RefreshAll) window.RefreshAll();
                })
                .catch(function (err) {
                    console.error('Break error:', err);
                    alert('Network error: ' + err.message);
                    delete processingUsers[actionType][userId];
                    btn.disabled = false;
                    syncButtonStates();
                });
        });
    }

    function assignPorterSilent(requestId, porterId) {
        var UID = sessionStorage.getItem('ID');
        if (!UID) return Promise.reject(new Error('UID missing'));
        return postService('ASSIGNPORTER', {
            requestId: Encrypt(requestId.toString()),
            porterId: Encrypt(porterId.toString()),
            requestorId: Encrypt(UID)
        });
    }

    function assignPorterToTask(requestId, porterId) {
        return new Promise(function (resolve, reject) {
            if (isActionInProgress) return resolve();
            isActionInProgress = true;
            assignPorterSilent(requestId, porterId).then(function (data) {
                var successModalEl = document.getElementById('modalEmployeeActionSuccess');
                var successModal = bootstrap.Modal.getOrCreateInstance(successModalEl);

                if (isModalVisible) { isActionInProgress = false; return resolve(); }

                if (data.message && data.message.indexOf('Same Porter is already assigned to this Task') > -1) {
                    document.getElementById('porterWarningText').textContent = 'Porter is already assigned to this task.';
                    var wm = bootstrap.Modal.getOrCreateInstance(document.getElementById('porterWarningModal'));
                    wm.show();
                    setTimeout(function () { wm.hide(); }, 2000);
                    isActionInProgress = false;
                    return resolve();
                }

                if (data.success === true || (data.message && data.message.indexOf('Thread was being aborted') > -1)) {
                    document.getElementById('lblEmployeeActionResult').textContent = 'Porter assigned successfully for RequestID: ' + requestId;
                    isModalVisible = true;
                    successModal.show();
                    if (window.RefreshAll) window.RefreshAll();
                    setTimeout(function () {
                        successModal.hide();
                        isModalVisible = false;
                        isActionInProgress = false;
                        resolve();
                    }, 1500);
                    return;
                }

                isActionInProgress = false;
                reject(new Error('Failed to assign porter.'));
            }).catch(function (error) {
                console.error('Fetch error:', error);
                isActionInProgress = false;
                reject(error);
            });
        });
    }

    function initEmployeeListEvents() {
        $('#employeeList').on('click', '.show-details', function (e) {
            e.preventDefault();
            var username = this.getAttribute('data-username');
            if (employeeListMode === 'normal' && username !== null) {
                var emp = employeeCache.filter(function (x) { return x.USERNAME === username; })[0];
                if (emp) showEmployeeDetails(emp);
            } else {
                var id = $(this).data('id');
                $.ajax({
                    type: 'POST',
                    url: '/Index/Service/Service.aspx/GetEmployeeDetailsById',
                    data: JSON.stringify({ id: id }),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (emp) { showEmployeeDetails(JSON.parse(emp.d)); }
                });
            }
        });

        $('#employeeList').on('click', '.check-in, .check-out', function (e) {
            e.preventDefault();
            var isIn = this.classList.contains('check-in');
            var porterId = this.dataset.id;
            var porterName = this.dataset.name || 'Porter';
            if (employeeListMode === 'normal') {
                if (isIn) handleCheckInClick(porterId, porterName);
                else handleCheckOutClick(porterId, porterName);
                return;
            }
            if (!porterId) { showEmployeeActionSuccess('Invalid porter details.'); return; }
            if (isIn) {
                triggerPorterAction('TriggerCheckIn', porterId, function (message) {
                    showEmployeeActionSuccess(message);
                    if (window.RefreshAll) window.RefreshAll();
                });
            } else {
                triggerPorterAction('TriggerCheckOut', porterId, function (message) {
                    if (message.indexOf('Porter is already in Task') > -1) {
                        showPorterWarningModal(message);
                    } else {
                        showEmployeeActionSuccess('Porter ' + porterName + ': ' + message);
                        if (window.RefreshAll) window.RefreshAll();
                    }
                });
            }
        });

        $('#employeeList').on('click', '.take-rest-break, .take-meal-break', function (e) {
            if (employeeListMode !== 'filtered') return;
            e.preventDefault();
            var porterId = $(this).data('id');
            var proc = this.classList.contains('take-rest-break') ? 'TriggerPorterBreakFilter' : 'TriggerPorterMealBreakFilter';
            triggerPorterAction(proc, porterId, function (message) { showEmployeeActionSuccess(message); });
        });
    }

    function triggerPorterAction(processName, porterId, callback) {
        $.ajax({
            url: '/Index/Service/Service.aspx?Process=' + encodeURIComponent(Encrypt(processName)),
            method: 'POST',
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify({ id: Encrypt(porterId.toString()) }),
            dataType: 'text',
            success: function (text) {
                var result;
                try {
                    result = JSON.parse(text.replace(/\[\]$/, ''));
                } catch (e) {
                    console.error('JSON ERROR:', text);
                    callback('Response parse error');
                    return;
                }
                if (result.success !== false) callback(result.message || 'Success');
                else callback('Error: ' + (result.message || 'Unknown error'));
            },
            error: function (xhr, status, error) {
                console.error('AJAX Error:', error);
                callback('Network error: ' + error);
            }
        });
    }

    function initBulkAssign() {
        var modal = document.getElementById('bulkAssignModal');
        if (!modal) return;

        var el = {
            list: document.getElementById('bulkRequestList'),
            search: document.getElementById('bulkRequestSearch'),
            selectAll: document.getElementById('btnSelectAll'),
            clearAll: document.getElementById('clearAllSelections'),
            bulkAssign: document.getElementById('btnBulkAssign'),
            selectedCount: document.getElementById('selectedCount'),
            bulkAssignCount: document.getElementById('bulkAssignCount'),
            closeBtn: document.getElementById('btnCloseBulkAssignModal')
        };
        if (!el.list) return;

        var loadId = 0, controller = null;
        var selectedTasks = {};
        var assignedTasks = {};

        function getModal() {
            return bootstrap.Modal.getOrCreateInstance(modal, { backdrop: true, keyboard: true });
        }

        function selectedSize() { return Object.keys(selectedTasks).length; }

        function updateCount() {
            var count = selectedSize();
            if (el.selectedCount) el.selectedCount.textContent = count;
            if (el.bulkAssignCount) el.bulkAssignCount.textContent = count;
            if (el.bulkAssign) {
                el.bulkAssign.disabled = count === 0;
                el.bulkAssign.innerHTML = '<i class="bi bi-person-check-fill me-2"></i> Bulk Assign (' + count + ')';
            }
        }

        function setChecked(node, checked) {
            if (!node) return;
            var svg = node.querySelector('svg');
            node.classList.toggle('checked', checked);
            if (!svg) return;
            if (checked) {
                svg.style.display = 'block';
                svg.style.animation = 'none';
                void svg.offsetHeight;
                svg.style.animation = 'pop 0.2s ease-out';
            } else {
                svg.style.display = 'none';
                svg.style.animation = '';
            }
        }

        function toggleTask(node, taskId) {
            var id = String(taskId);
            if (assignedTasks[id]) return;
            var isChecked = node.classList.contains('checked');
            setChecked(node, !isChecked);
            if (isChecked) delete selectedTasks[id]; else selectedTasks[id] = true;
            updateCount();
        }

        function resetState() {
            if (controller) { controller.abort(); controller = null; }
            el.list.innerHTML = '';
            if (el.search) el.search.value = '';
            selectedTasks = {};
            assignedTasks = {};
            updateCount();
            cleanupBackdrops();
        }

        function getPorterIds(req) {
            return {
                porter: req.PorterId != null ? req.PorterId : (req.PORTERID != null ? req.PORTERID : (req.porterId != null ? req.porterId : (req.PorterID != null ? req.PorterID : 0))),
                sub: req.SubPorterId != null ? req.SubPorterId : (req.SUBPORTERID != null ? req.SUBPORTERID : (req.subPorterId != null ? req.subPorterId : (req.SubPorterID != null ? req.SubPorterID : 0)))
            };
        }

        function isAssignedTo(ids) {
            return Number(ids.porter) === Number(window.G_PORTER_ID) || Number(ids.sub) === Number(window.G_PORTER_ID);
        }

        async function loadTasks(filter) {
            filter = filter || '';
            if (!window.G_PORTER_ID || !window.G_SERVICE_ID) {
                el.list.innerHTML = '<li class="list-group-item text-center py-3 text-muted">No tasks available</li>';
                return;
            }
            var reqId = ++loadId;
            if (controller) controller.abort();
            controller = new AbortController();

            el.list.style.opacity = '0';
            el.list.innerHTML = '<li class="list-group-item text-center py-3"><div class="spinner-border text-primary spinner-border-sm" role="status"></div><p class="mt-2 text-muted small">Loading...</p></li>';

            try {
                var res = await fetch('/Index/Service/Service.aspx?Process=' + encodeURIComponent(Encrypt('getPendingRequests')), {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ serviceId: Encrypt(window.G_SERVICE_ID), toZoneFilter: Encrypt(filter), porterId: Encrypt(window.G_PORTER_ID) }),
                    signal: controller.signal
                });
                if (reqId !== loadId) return;

                var raw = await res.text();
                var tasks = [];
                try {
                    var parsed = JSON.parse(raw.trim().replace(/\[\]$/, ''));
                    tasks = Array.isArray(parsed) ? parsed : (parsed && parsed.d ? JSON.parse(parsed.d) : []);
                } catch (e) {
                    console.error('Parse error:', e);
                    el.list.innerHTML = '<li class="list-group-item text-danger text-center py-3">Error loading data</li>';
                    el.list.style.opacity = '1';
                    return;
                }

                assignedTasks = {};
                tasks.sort(function (a, b) {
                    return (isAssignedTo(getPorterIds(b)) ? 1 : 0) - (isAssignedTo(getPorterIds(a)) ? 1 : 0);
                });

                if (tasks.length === 0) {
                    el.list.innerHTML = '<li class="list-group-item text-center text-muted py-4">No pending tasks</li>';
                    el.list.style.opacity = '1';
                    updateCount();
                    return;
                }

                var fragment = document.createDocumentFragment();
                tasks.forEach(function (task) {
                    var id = task.TASKID || task.TaskId || 'N/A';
                    var category = task.CategoryName || task.Category || 'N/A';
                    var zone = task.ToZone || 'N/A';
                    var loc = task.ToLocation || 'N/A';
                    var assigned = isAssignedTo(getPorterIds(task));
                    if (assigned && id !== 'N/A') assignedTasks[String(id)] = true;
                    var checked = assigned || selectedTasks[String(id)];

                    var li = document.createElement('li');
                    li.className = 'list-group-item p-2 mb-1 ' + (assigned ? 'assigned-task' : '');
                    li.innerHTML = '<div class="d-flex justify-content-between align-items-center"><div style="font-size: 13px; line-height: 1.5; cursor: pointer;" class="task-info"><strong>' + esc(category) + '</strong><span class="text-muted mx-1">|</span><span style="color: #d32f2f; font-weight: 600;">#' + esc(id) + '</span><span class="text-muted mx-1">|</span><span>' + esc(zone) + '</span><span class="text-muted mx-1">→</span><span>' + esc(loc) + '</span></div><div class="tick-wrapper ' + (checked ? 'checked' : '') + '" data-id="' + esc(id) + '" data-assigned="' + assigned + '" ' + (assigned ? 'style="pointer-events:none; opacity:0.5;"' : '') + '><svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg></div></div>';
                    fragment.appendChild(li);
                });
                el.list.innerHTML = '';
                el.list.appendChild(fragment);
                el.list.style.opacity = '1';
                updateCount();
            } catch (err) {
                if (err.name !== 'AbortError') {
                    el.list.innerHTML = '<li class="list-group-item text-danger text-center py-3">' + esc(err.message) + '</li>';
                    el.list.style.opacity = '1';
                }
            }
        }

        if (el.search) {
            var searchTimeout;
            el.search.addEventListener('input', function () {
                var self = this;
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(function () { loadTasks(self.value.trim().toLowerCase()); }, 300);
            });
        }

        if (el.selectAll) {
            el.selectAll.addEventListener('click', function () {
                el.list.querySelectorAll('.tick-wrapper:not([data-assigned="true"])').forEach(function (n) {
                    var id = n.dataset.id;
                    if (id && id !== 'N/A') { setChecked(n, true); selectedTasks[String(id)] = true; }
                });
                updateCount();
            });
        }

        if (el.clearAll) {
            el.clearAll.addEventListener('click', function () {
                selectedTasks = {};
                el.list.querySelectorAll('.tick-wrapper:not([data-assigned="true"])').forEach(function (n) { setChecked(n, false); });
                updateCount();
            });
        }

        el.list.addEventListener('click', function (e) {
            var wrapper = e.target.closest('.tick-wrapper');
            if (!wrapper) return;
            if (wrapper.dataset.assigned === 'true') { e.preventDefault(); return; }
            var id = wrapper.dataset.id;
            if (id && id !== 'N/A') { e.preventDefault(); e.stopPropagation(); toggleTask(wrapper, id); }
        });

        if (el.bulkAssign) {
            el.bulkAssign.addEventListener('click', async function () {
                var ids = Object.keys(selectedTasks);
                if (ids.length === 0 || !window.G_PORTER_ID) return;
                var original = this.innerHTML;
                this.disabled = true;
                this.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Assigning ' + ids.length + '...';

                var success = 0, fail = 0;
                for (var i = 0; i < ids.length; i++) {
                    try {
                        var data = await assignPorterSilent(ids[i], window.G_PORTER_ID);
                        var ok = data.success === true || (data.message && (data.message.indexOf('Same Porter is already assigned to this Task') > -1 || data.message.indexOf('Thread was being aborted') > -1));
                        if (!ok) throw new Error(data.message || 'Failed to assign porter.');
                        success++;
                    } catch (e) {
                        console.error('Failed:', ids[i], e);
                        fail++;
                    }
                }

                selectedTasks = {};
                this.innerHTML = original;
                await loadTasks(el.search ? el.search.value.trim().toLowerCase() : '');

                if (fail > 0) {
                    alert('Assigned ' + success + ' task(s). ' + fail + ' failed.');
                } else if (success > 0) {
                    var lbl = document.getElementById('LBLGenericSuccessResult');
                    if (lbl) lbl.textContent = 'Successfully assigned ' + success + ' task(s)!';
                    var m = getModalInstance('modalGenericSuccess');
                    m.show();
                    setTimeout(function () {
                        m.hide();
                        cleanupBackdrops();
                        if (window.RefreshAll) window.RefreshAll();
                    }, 2000);
                }
            });
        }

        modal.addEventListener('shown.bs.modal', async function () {
            cleanupBackdrops();
            if (el.search) el.search.value = '';
            selectedTasks = {};
            assignedTasks = {};
            updateCount();
            await loadTasks('');
        });
        modal.addEventListener('hidden.bs.modal', function () {
            resetState();

        });
        modal.addEventListener('hide.bs.modal', cleanupBackdrops);

        if (el.closeBtn) {
            el.closeBtn.addEventListener('click', function (e) {
                e.preventDefault();
                getModal().hide();

                el.list.innerHTML = '';
            });
        }

        modal.addEventListener('click', function (e) {

        });

        window.addEventListener('beforeunload', function () {
            if (controller) controller.abort();
            cleanupBackdrops();
        });
        window.cleanupBulkBackdrops = cleanupBackdrops;

        updateCount();

        document.addEventListener('click', function (e) {
            var bulkBtn = e.target.closest('.openBulkAssignModal');
            if (bulkBtn) {
                e.preventDefault();
                cleanupBackdrops();
                window.G_PORTER_ID = bulkBtn.dataset.employee;
                window.G_SERVICE_ID = activeServiceId() || '1';
                hideAllModals();
                getModal().show();
                return;
            }

            var assignBtn = e.target.closest('.openAssignRequestModal');
            if (assignBtn) {
                e.preventDefault();
                e.stopPropagation();
                e.stopImmediatePropagation();
                hideAllModals();

                var porterId = assignBtn.dataset.employee || '';
                var assignType = assignBtn.dataset.type || 'task';
                var serviceId = activeServiceId() || '1';
                var requestList = document.getElementById('pendingRequestList');
                if (requestList) requestList.innerHTML = '<li class="list-group-item text-center py-4"><div class="spinner-border spinner-border-sm text-primary me-2" role="status"></div>Loading...</li>';

                var procName = assignType === 'assistant' ? 'GetAssistantRequests' : 'GetPendingTasks';

                fetch('/Index/Service/Service.aspx?Process=' + encodeURIComponent(Encrypt(procName)), {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                    body: JSON.stringify({ serviceId: serviceId })
                })
                    .then(function (res) { return res.json(); })
                    .then(function (data) {
                        var requests = [];
                        try { requests = data.d ? JSON.parse(data.d) : data.data || []; } catch (err) { console.error('JSON parse error:', err); }
                        requestList.innerHTML = '';
                        if (requests.length > 0) {
                            requests.slice(0, 100).forEach(function (req) {
                                var taskId = req.TASKID || 'N/A';
                                var categoryName = req.CategoryName || req.Category || 'N/A';
                                var li = document.createElement('li');
                                li.className = 'list-group-item d-flex justify-content-between align-items-center px-3 py-2';
                                li.innerHTML = '<span class="flex-grow-1 pe-3"><span style="color: #34495E; font-weight: 600; font-size: 0.9rem;">Task Type</span> - <strong style="color: #1F3A93; font-weight: 700;">#' + esc(categoryName) + '</strong><span class="text-muted mx-2">|</span><span style="color: #7F8C8D; font-weight: 600;">Task ID</span> <strong style="color: #2C3E50; font-weight: 700;">#' + esc(taskId) + '</strong></span><button class="btn btn-sm assignTaskBtn" data-taskid="' + esc(taskId) + '" data-porterid="' + esc(porterId) + '" style="background: linear-gradient(90deg, #3498DB, #2E86C1); color: #ffffff; font-weight: 600; border-radius: 5px; border: none; padding: 4px 12px; transition: all 0.3s ease;">Assign</button>';
                                requestList.appendChild(li);
                            });
                        } else {
                            requestList.innerHTML = '<li class="list-group-item text-center text-muted py-5">No pending requests.</li>';
                        }
                    })
                    .catch(function (err) {
                        console.error('Fetch error:', err);
                        if (requestList) requestList.innerHTML = '<li class="list-group-item text-center text-danger py-4">Error loading requests</li>';
                    })
                    .finally(function () {
                        var arModal = document.getElementById('assignRequestModal');
                        if (!arModal) return;
                        var inst = bootstrap.Modal.getInstance(arModal);
                        if (inst) inst.dispose();
                        window.assignRequestModal = new bootstrap.Modal(arModal, { backdrop: 'static', keyboard: false });
                        window.assignRequestModal.show();
                        var title = document.getElementById('assignRequestModalLabel');
                        if (title) title.textContent = assignType === 'assistant' ? 'Pending Assistant Requests' : 'Pending Requests';
                    });
                return;
            }

            var taskBtn = e.target.closest('.assignTaskBtn');
            if (!taskBtn) return;
            e.preventDefault();
            e.stopPropagation();
            e.stopImmediatePropagation();
            var tId = taskBtn.dataset.taskid;
            var pId = taskBtn.dataset.porterid;
            if (!tId || !pId) return;

            taskBtn.disabled = true;
            taskBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Assigning...';
            assignPorterToTask(tId, pId)
                .then(function () {
                    taskBtn.innerHTML = 'Assigned ✓';
                    taskBtn.style.background = '#d4edda';
                    taskBtn.style.color = 'black';
                    if (window.assignRequestModal) window.assignRequestModal.hide();
                })
                .catch(function (err) {
                    console.error('Assign failed:', err);
                    taskBtn.disabled = false;
                    taskBtn.innerHTML = 'Assign';
                    taskBtn.style.background = 'linear-gradient(90deg, #3498DB, #2E86C1)';
                    taskBtn.style.color = '#ffffff';
                });
        }, false);

        var closeAssign = document.getElementById('btnCloseAssignModal');
        if (closeAssign) {
            closeAssign.addEventListener('click', function () {
                var inst = bootstrap.Modal.getInstance(document.getElementById('assignRequestModal'));
                if (inst) inst.hide();
                setTimeout(cleanupBackdrops, 10);
            });
        }
    }

    function loadAvailablePorters(filter, serviceId) {
        filter = filter || '';
        var container = document.getElementById('freeEmployeeList');
        container.innerHTML = '<p class="text-muted">Loading available porters...</p>';
        if (!serviceId) serviceId = activeServiceId();

        $.ajax({
            type: 'GET',
            url: '/Index/Service/Service.aspx',
            data: {
                Process: Encrypt('GetEmployeeDataAssign'),
                filter: encodeURIComponent(Encrypt(filter)),
                serviceId: encodeURIComponent(Encrypt(serviceId))
            },
            dataType: 'json',
            success: function (data) {
                container.innerHTML = '';
                if (!data || data.length === 0) {
                    container.innerHTML = '<p>No free porters found.</p>';
                    return;
                }
                data.forEach(function (emp) {
                    var item = document.createElement('div');
                    item.className = 'd-flex justify-content-between align-items-center mb-2 p-2 border rounded shadow-sm';
                    item.innerHTML = '<span><span style="color: #34495E; font-weight: 600;">#Username</span> - <strong style="color: #1F3A93; font-weight: 700;">' + esc(emp.USERNAME) + '</strong> | <span style="color: #7F8C8D; font-weight: 600;">#Division</span> - <strong style="color: #2C3E50;">' + esc(emp.HOSPITALNAME1) + '</strong></span>' +
                        '<button type="button" class="btn btn-sm assignPorterBtn" data-porter-id="' + esc(emp.ID) + '" style="background: linear-gradient(90deg, #3498DB, #2E86C1); color: #ffffff; font-weight: 600; border-radius: 12px; border: none; padding: 5px 16px; font-size: 0.85rem; box-shadow: 0 4px 12px rgba(46, 134, 193, 0.5); display: inline-flex; align-items: center; justify-content: center;">Assign</button>';
                    container.appendChild(item);
                });
            },
            error: function (xhr, status, error) {
                console.error('Failed to load porters:', error);
                container.innerHTML = '<p class="text-danger">Failed to load porters.</p>';
            }
        });
    }

    function initAssignModal() {
        var assignModalEl = document.getElementById('assignModal');
        var assignFilter = document.getElementById('assignEmployeeFilter');

        assignModalEl.addEventListener('shown.bs.modal', function () {
            loadAvailablePorters();
            assignFilter.focus();
        });
        assignModalEl.addEventListener('hidden.bs.modal', function () {

            document.getElementById('freeEmployeeList').innerHTML = '';
            assignFilter.value = '';
        });
        assignFilter.addEventListener('input', function () {
            loadAvailablePorters(assignFilter.value.trim());
        });

        $('#freeEmployeeList').on('click', '.assignPorterBtn', function (e) {
            e.preventDefault();
            var porterId = $(this).data('porter-id');
            if (!currentRequestId) return;
            assignPorterToTask(currentRequestId, porterId);
            var inst = bootstrap.Modal.getInstance(assignModalEl);
            if (inst) inst.hide();
            cleanupBackdrops();
            document.getElementById('freeEmployeeList').innerHTML = '';
        });
    }

    function showPorterAssignedModal(requestId) {
        $('#LBLPorterAssignedResult').html('Porter assigned for Task ID - <b>#' + esc(requestId) + '</b>');
        flashModal('modalPorterAssigned', 2000);
    }

    function initReassign() {
        var reassignModalEl = document.getElementById('reassignModal');
        var reassignFilter = document.getElementById('reassignEmployeeFilter');
        var container = document.getElementById('FreeEmployeeList');
        var successModalEl = document.getElementById('modalEmployeeActionSuccess');
        var porterFetchController = null;
        var filterTimeout = null;

        var porterState = { assigned: [], requestId: null, remainingChances: 0, hasLoadedInitially: false };

        if (!document.getElementById('porterCardStyles')) {
            var style = document.createElement('style');
            style.id = 'porterCardStyles';
            style.innerHTML = '.porter-card{display:flex;justify-content:space-between;align-items:center;padding:10px 15px;border-radius:8px;border:1px solid #e0e0e0;background-color:#fff;transition:background .2s,box-shadow .2s,transform .2s;cursor:pointer}.porter-card:hover{background-color:#f8fbff;box-shadow:0 2px 8px rgba(0,0,0,.08);transform:translateY(-2px)}#FreeEmployeeList .tick-wrapper{width:24px;height:24px;border-radius:4px;border:2px solid #28a745;display:flex;justify-content:center;align-items:center;background-color:#fff;cursor:pointer;transition:background .25s,border .25s,transform .2s}#FreeEmployeeList .tick-wrapper.checked{background-color:#28a745;border-color:#28a745;transform:scale(1.1)}#FreeEmployeeList .tick-wrapper svg{display:none}#FreeEmployeeList .tick-wrapper.checked svg{display:block}.fade-in{opacity:0;animation:fadeIn .3s ease forwards}';
            document.head.appendChild(style);
        }

        reassignModalEl.addEventListener('shown.bs.modal', function () {
            var requestId = Number(reassignModalEl.getAttribute('data-request-id'));
            if (!requestId) return;
            var assigned = [];
            var p = reassignModalEl.getAttribute('data-porter');
            var s = reassignModalEl.getAttribute('data-subporter');
            if (p) assigned.push(Number(p));
            if (s) assigned.push(Number(s));
            porterState.requestId = requestId;
            porterState.assigned = assigned;
            porterState.remainingChances = 0;
            porterState.hasLoadedInitially = false;
            container.innerHTML = '<p class="text-muted text-center py-3">Loading available porters...</p>';
            loadPortersForReassign('', requestId);
        });

        reassignFilter.addEventListener('input', function () {
            var self = this;
            clearTimeout(filterTimeout);
            filterTimeout = setTimeout(function () {
                if (porterState.requestId && porterState.hasLoadedInitially) {
                    loadPortersForReassign(self.value.trim().toLowerCase(), porterState.requestId);
                }
            }, 300);
        });

        $(document).on('click', '.reassign-task', function (e) {
            e.preventDefault();
            var requestId = this.dataset.requestId;
            if (!requestId) return;
            fetch('/Index/Service/Service.aspx?Process=' + encodeURIComponent(Encrypt('GetSingleRequestDetails')) + '&requestId=' + encodeURIComponent(Encrypt(requestId)))
                .then(function (res) { return res.ok ? res.text() : Promise.reject(res.status); })
                .then(function (text) {
                    var tasks = JSON.parse(text);
                    if (!Array.isArray(tasks) || !tasks.length) return;
                    var task = tasks[0];
                    reassignModalEl.dataset.requestId = requestId;
                    reassignModalEl.dataset.porter = task.PORTERID != null ? task.PORTERID : '';
                    reassignModalEl.dataset.subporter = task.SUBPORTERID != null ? task.SUBPORTERID : '';
                    var modal = bootstrap.Modal.getInstance(reassignModalEl) || new bootstrap.Modal(reassignModalEl, { focus: false });
                    modal.show();
                })
                .catch(function (err) { console.error('Failed:', err); });
        });

        async function loadPortersForReassign(filter, requestId) {
            if (!container || !requestId) return;
            if (porterFetchController) porterFetchController.abort();
            porterFetchController = new AbortController();
            var signal = porterFetchController.signal;
            container.innerHTML = '<p class="text-muted text-center py-3">Loading available porters...</p>';

            try {
                var res = await fetch('/Index/Service/Service.aspx?Process=' + encodeURIComponent(encryptAES('GetEmployeeDataAssign')) +
                    '&filter=' + encodeURIComponent(encryptAES(filter)) +
                    '&serviceId=' + encodeURIComponent(encryptAES(activeServiceId())), { signal: signal });
                var data = await res.json();
                if (signal.aborted) return;

                if (!data || data.length === 0) {
                    container.innerHTML = '<p class="text-center text-muted py-3">No free porters found.</p>';
                    return;
                }
                if (filter) {
                    data = data.filter(function (emp) { return emp.USERNAME && emp.USERNAME.toLowerCase().indexOf(filter) > -1; });
                }
                data.sort(function (a, b) {
                    return (porterState.assigned.indexOf(Number(a.ID)) > -1 ? 0 : 1) - (porterState.assigned.indexOf(Number(b.ID)) > -1 ? 0 : 1);
                });

                container.innerHTML = '';
                data.forEach(function (emp) {
                    var isAssigned = porterState.assigned.indexOf(Number(emp.ID)) > -1;
                    var item = document.createElement('div');
                    item.className = 'porter-card mb-2 fade-in';
                    item.innerHTML = '<div class="porter-info"><div class="fw-bold text-dark">' + esc(emp.USERNAME) + '</div><small class="text-muted">' + esc(emp.HOSPITALNAME1 || '') + '</small></div>' +
                        '<div class="tick-wrapper ' + (isAssigned ? 'checked' : '') + '" data-id="' + esc(emp.ID) + '"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12" /></svg></div>';
                    var tick = item.querySelector('.tick-wrapper');
                    tick.addEventListener('click', function (e) {
                        e.stopPropagation();
                        if (!tick.classList.contains('checked') && porterState.remainingChances <= 0) {
                            e.preventDefault();
                            return;
                        }
                        handleTickToggle(tick);
                    });
                    item.addEventListener('click', function (e) {
                        if (!e.target.closest('.tick-wrapper')) handleTickToggle(tick);
                    });
                    container.appendChild(item);
                });
                porterState.hasLoadedInitially = true;
            } catch (err) {
                if (err.name !== 'AbortError') {
                    console.error('Failed to load porters:', err);
                    container.innerHTML = '<p class="text-danger text-center py-3">Failed to load porters.</p>';
                }
            }
        }

        function handleTickToggle(tickEl) {
            if (!tickEl) return;
            var porterId = Number(tickEl.dataset.id);
            var newState = !tickEl.classList.contains('checked');
            tickEl.classList.toggle('checked', newState);

            if (newState) {
                if (porterState.assigned.indexOf(porterId) === -1) {
                    porterState.assigned.push(porterId);
                    porterState.remainingChances = Math.max(0, porterState.remainingChances - 1);
                }
            } else {
                var idx = porterState.assigned.indexOf(porterId);
                if (idx > -1) {
                    porterState.assigned.splice(idx, 1);
                    porterState.remainingChances++;
                }
            }

            tickEl.style.pointerEvents = 'none';
            setTimeout(function () { tickEl.style.pointerEvents = 'auto'; }, 250);
            updateTaskPorter(porterState.requestId, porterId, newState ? 'reassign' : 'remove');
        }

        function updateTaskPorter(requestId, porterId, process) {
            var isChecked = process === 'reassign';
            var userId = sessionStorage.getItem('ID') || 0;
            if (!userId) { console.error('No USERID in session'); return; }

            postService('UpdatePorterAssignment', {
                requestId: Encrypt(requestId.toString()),
                porterId: Encrypt(porterId.toString()),
                isChecked: Encrypt(isChecked.toString()),
                userId: Encrypt(userId.toString())
            }).then(function (data) {
                if (data.success) {
                    var porterName = data.porterName || 'Unknown Porter';
                    document.getElementById('lblEmployeeActionResult').textContent = isChecked
                        ? 'Porter: ' + porterName + ' reassigned for RequestID: ' + requestId
                        : 'Porter: ' + porterName + ' removed from RequestID: ' + requestId;
                    var sm = bootstrap.Modal.getOrCreateInstance(successModalEl);
                    sm.show();
                    if (window.RefreshAll) window.RefreshAll();
                    setTimeout(function () { sm.hide(); }, 1500);
                } else {
                    console.error('Update failed:', data.message);
                }
            }).catch(function (err) { console.error('Fetch error:', err); });
        }

        reassignModalEl.addEventListener('hidden.bs.modal', function () {

            container.innerHTML = '';
            porterState.assigned = [];
            porterState.remainingChances = 0;
            porterState.requestId = null;
            porterState.hasLoadedInitially = false;
        });
    }

    function LoadEquipment(val, serviceId) {
        if (!serviceId) serviceId = activeServiceId();
        var isTrolleyMode = (serviceId === '2');
        if (!val || val.trim() === '') val = isTrolleyMode ? 'Tr' : 'a';

        var url = hurl + 'SERVICE/Service.aspx?Process=' + encodeURIComponent(Encrypt('fetchEquipment')) +
            '&VAL=' + encodeURIComponent(Encrypt(val)) +
            '&VAL1=' + encodeURIComponent(Encrypt(ReqCat || '')) +
            '&SERVICEID=' + encodeURIComponent(Encrypt(serviceId));

        resetMultiPorter();
        $('#EquipmentCategories').html("<p class='text-white'></p>");

        $.ajax({
            url: url,
            type: 'POST',
            dataType: 'json',
            success: function (data) {
                if (!data || data.length === 0) {
                    $('#EquipmentCategories').html("<p class='text-white'></p>");
                    return;
                }
                var sorted = data;
                if (isTrolleyMode) {
                    var trolley = null, others = [];
                    $.each(data, function (_, item) {
                        if (item.VALUE && item.VALUE.toLowerCase() === 'trolley') trolley = item; else others.push(item);
                    });
                    sorted = trolley ? [trolley].concat(others) : others;
                }
                $('#EquipmentCategories').html('<ul>' + equipmentItemsHtml(sorted) + '</ul>');
                if (isTrolleyMode) {
                    var t = sorted.filter(function (i) { return i.VALUE && i.VALUE.toLowerCase() === 'trolley'; })[0];
                    if (t) $('#chkEquip' + t.Id).prop('checked', true);
                }
            },
            error: function (xhr) {
                console.error('Equipment load error:', xhr.responseText);
                $('#EquipmentCategories').html("<p class='text-white'>Failed to load equipment</p>");
            }
        });
    }

    function equipmentItemsHtml(items) {
        return items.map(function (value) {
            var imgPath = value.IMAGEPATH || '../images/no-image.png';
            var isTwoPorter = value.AssistantRequired || false;
            return '<li><input type="checkbox" id="chkEquip' + esc(value.Id) + '" class="equipment-checkbox" onchange="onEquipmentSelect(\'' + esc(value.Id) + '\', ' + isTwoPorter + ')"><span><img src="../images/check.png" alt="check"></span><img src="' + esc(imgPath) + '" alt="' + esc(value.VALUE) + '"><p>' + esc(value.VALUE) + '</p></li>';
        }).join('');
    }

    function resetMultiPorter() {
        $('#chkMultiPorter').prop({ checked: false, disabled: false });
        $('#chkMultiPorterImg').attr('src', '../images/NoMCheck.jpg');
        selectedEquipmentPorter = 0;
    }

    function updateMultiPorter() {
        var $m = $('#chkMultiPorter');
        var $img = $('#chkMultiPorterImg');
        if (selectedEquipmentPorter === 1) {
            $m.prop({ checked: true, disabled: true });
            $img.attr('src', '../images/MCheck.jpg');
        } else if (selectedCategoryPorter === 1) {
            $m.prop({ checked: true, disabled: false });
            $img.attr('src', '../images/MCheck.jpg');
        } else {
            $m.prop({ checked: false, disabled: false });
            $img.attr('src', '../images/NoMCheck.jpg');
        }
        if (typeof setMultiPorter === 'function') setMultiPorter();
    }

    function CatSelection(ele, id, isTwoPorterTask, value, quantity, TS, TE) {
        clearAllCheckBox('ReqCategories');
        $(ele).prop('checked', true);
        ReqCat = id;
        selectedCategoryPorter = isTwoPorterTask === '1' ? 1 : 0;
        updateMultiPorter();
        if (TS && TE) {
            $('#lblKPITS').html((TS !== '-' && TS !== '0') ? (TS + '<br/><span style="font-size:13px;">(min)</span>') : '10');
            $('#lblKPITE').html((TE !== '-' && TE !== '0') ? (TE + '<br/><span style="font-size:13px;">(min)</span>') : '5');
        }
    }

    function clearAllCheckBox(containerId) {
        $('#' + containerId + ' input[type=checkbox]').prop('checked', false);
    }

    function onEquipmentSelect(id, assistantRequired) {
        var $clicked = $('#chkEquip' + id);
        if ($clicked.is(':checked')) {
            $('#EquipmentCategories input[type=checkbox]').not($clicked).prop('checked', false);
        }
        selectedEquipmentPorter = [true, 'true', 1, '1'].indexOf(assistantRequired) > -1 ? 1 : 0;
        updateMultiPorter();
    }

    function searchEquipment(input) {
        var serviceId = activeServiceId() || '1';
        $.ajax({
            async: true,
            type: 'GET',
            url: hurl + 'SERVICE/Service.aspx?Process=' + encodeURIComponent(encryptAES('fetchEquipment')) +
                '&VAL=' + encodeURIComponent(encryptAES(input.value)) +
                '&VAL1=' + encodeURIComponent(encryptAES(ReqCat || '')) +
                '&SERVICEID=' + encodeURIComponent(encryptAES(serviceId)),
            dataType: 'json',
            success: function (data) {
                if (!data || data.length === 0) {
                    $('#EquipmentCategories').html("<p class='text-white'>No Equipment Found</p>");
                    return;
                }
                $('#EquipmentCategories').html('<ul>' + equipmentItemsHtml(data) + '</ul>');
            },
            error: function (xhr, status, error) { console.error('Error fetching equipment:', error); }
        });
    }

    function LoadEquipmentOnInit(serviceId) {
        ReqCat = ReqCat || '';
        LoadEquipment('', serviceId);
    }

    function getSelectedEquipIDs() {
        var ids = [];
        $('#EquipmentCategories input[type=checkbox]:checked').each(function () {
            var id = $(this).attr('id');
            if (id && id.indexOf('chkEquip') === 0) {
                var equipId = id.replace('chkEquip', '');
                if (equipId && equipId !== 'undefined') ids.push(equipId);
            }
        });
        return ids.length > 0 ? ids[0] : '';
    }

    function InsertRequest() {
        setMultiPorter();
        var selectedEquip = getSelectedEquipIDs();
        var UID = sessionStorage.getItem('ID');
        var PBDTime = (RPreBook == '2') ? formatDate('txtReqdate', 'txtReqTime') : '';
        var dlRemarkTxt = selectedText('search_Remarks');
        var PatientName = $('#txtPatientName').val(),
            PatientHN = $('#txtPatientHNO').val(),
            PatientDOB = $('#txtPatientDOB').val(),
            ContactNo = $('#txtContactNumber').val(),
            Remarks = dlRemarkTxt + '_' + $('#txtRemarks').val();
        var ReqtrName = $('#txtRequestorName').val().trim();
        var ServiceID = $('#divRService2').hasClass('active') ? '2' : '1';
        var qty = $('#txtQty').val();
        var Kitchen = $('#txtKitchen').val() || '0';

        var requestUrl = hurl + 'SERVICE/Service.aspx?Process=' + Encrypt('INSERTREQUEST') +
            '&PBDATE=' + encryptQS(PBDTime) +
            '&CATEGORY=' + encryptQS(ReqCat) +
            '&FROM=' + encryptQS(RFromID) +
            '&TO=' + encryptQS(RToID) +
            '&MULTIPORTER=' + encryptQS(IsMTPR) +
            '&PATIENTNAME=' + encryptQS(PatientName + '_' + PatientHN + '_' + PatientDOB) +
            '&REMARKS=' + encryptQS(Remarks) +
            '&USERID=' + encryptQS(UID) +
            '&HALT1=' + encryptQS(RHalt1) +
            '&HALT2=' + encryptQS(RHalt2) +
            '&PRIORITY=' + encryptQS('0') +
            '&EXTRAFIELDS=' + encryptQS(IsRTC + '_' + ContactNo) +
            '&Qty=' + encryptQS(qty || '0') +
            '&REQUESTOR=' + encryptQS(ReqtrName) +
            '&SERVICEID=' + encryptQS(ServiceID) +
            '&EQUIPMENT=' + encryptQS(selectedEquip.split(',')[0]);

        $.ajax({
            async: true,
            url: requestUrl,
            type: 'POST',
            data: new FormData(),
            processData: false,
            contentType: false,
            dataType: 'json',
            success: function (data) {
                var parts = data[0].RESULT.split('_');
                var status = parts[0];
                var ReqNB = parts[1] || '';

                if (status === 'TRUE' && (!PBDTime || PBDTime === '')) {
                    var msg = (RHalt1 === '0' && RHalt2 === '0') ? 'Task Created Successfully.. Task ID. #' + ReqNB : 'Task(s) Created Successfully.. Task IDs. ' + ReqNB;
                    $('#LBLRequestResult').html(msg);
                    flashModal('modalReqAlert', 3500);
                    HideModalPopUp('addTask');
                    ReloadLinks();
                    window.RefreshAll();
                    setRequestUsers('Tasks');
                } else if (status === 'TRUE_PREBOOK' || PBDTime.length > 0) {
                    $('#LBLRequestResult').html('Pre-Book Task Created - Request ID: #' + ReqNB);
                    flashModal('modalReqAlert', 3500);
                    HideModalPopUp('addTask');
                    ReloadLinks();
                    window.RefreshAll();
                    setRequestUsers('Tasks');
                } else if (status === 'FALSE') {
                    showAlertModal('A similar/same request has already been raised.', 3500);
                } else {
                    console.warn('Unexpected status:', status);
                }
            },
            error: function (err) { alert('Error occurred: ' + (err.responseText || 'Unknown')); }
        });
    }

    function UpdateRequest() {
        var ReqID = document.getElementById('HFERID').value, ReqNB = document.getElementById('HFERNO').value, StatusID = document.getElementById('HFStatusID').value;
        var IsMitigation = '0';
        var CancelledRemarks = selectedText('search_CancelRemarks') + '_' + $('#txtCanceRemarks').val();
        var CompletedRemarks = '';
        var Remarks = selectedText('search_Remarks') + '_' + $('#txtRemarks').val();
        var ReqtrName = $('#txtRequestorName').val().trim(), kitchen = $('#txtFromLoc').val().trim();
        var UID = sessionStorage.getItem('ID');
        var PBDTime = (RPreBook == '2') ? formatDate('txtReqdate', 'txtReqTime') : '';
        var PatientName = $('#txtPatientName').val(), PatientHN = $('#txtPatientHNO').val(), PatientDOB = $('#txtPatientDOB').val(), ContactNo = $('#txtContactNumber').val();
        var qty = $('#txtQty').val();
        var E = function (v) { return encodeURIComponent(Encrypt(v)); };

        $.ajax({
            async: true,
            url: hurl + 'SERVICE/Service.aspx?Process=UPDATEREQUEST&PBDATE=' + E(PBDTime) + '&CATEGORY=' + E(ReqCat) + '&FROM=' + E(RFromID) + '&TO=' + E(RToID) +
                '&MULTIPORTER=' + E(IsMTPR + '_' + OIsMTPR) + '&PATIENTNAME=' + E(PatientName + '_' + PatientHN + '_' + PatientDOB) + '&REMARKS=' + E(Remarks) + '&USERID=' + E(UID) +
                '&PRIORITY= ' + E('0') + '&EXTRAFIELDS=' + E(IsRTC + '_' + IsMitigation + '_' + ContactNo) + '&REQUESTID=' + E(ReqID) + '&STATUS=' + E(StatusID) +
                '&COMPLETEREMARKS=' + E(CompletedRemarks) + '&CANCELREMARKS=' + E(CancelledRemarks) + '&Qty=' + E(qty) + '&REQUESTOR=' + E(ReqtrName) +
                '&KITCHEN=' + E(kitchen) + '&SERVICEID=' + E(ServiceCode) + '&MODIFIEDVALUS=' + E(getModifiedValues()),
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                if (data[0].RESULT.split('_')[0] === 'TRUE') {
                    $('#LBLRequestResult').html('Request Updated Successfully.. Req No. #' + ReqNB);
                    HideModalPopUp('addTask');
                    flashModal('modalReqAlert', 3500);
                    LoadProcess(CProcess);
                }
            },
            error: function (xhr) { console.error('UpdateRequest failed:', xhr.responseText); }
        });
    }

    function submitRequest() {
        var fromLoc = document.getElementById('txtFromLoc').value.trim();
        var toLoc = document.getElementById('txtToLoc').value.trim();
        var catChecked = document.querySelector('input[type="checkbox"][id^="chkCat"]:checked');
        var errorMessage = '';

        if (fromLoc === '') errorMessage += 'Please select a From Location.\n';
        if (toLoc === '') errorMessage += 'Please select a To Location.\n';
        if (!catChecked) errorMessage += 'Please select a Task Type.\n';

        if (errorMessage !== '') {
            showAlertModal(errorMessage, 2000);
            return;
        }

        var btn = document.getElementById('btnReqSubmit');
        if (btn) btn.disabled = true;

        if (document.getElementById('HFERID').value.length > 0) UpdateRequest();
        else InsertRequest();
    }

    function RaiseDuplicate(ReqID) {
        AbortAllActiveRuquests();
        var UID = sessionStorage.getItem('ID');
        $.ajax({
            async: true,
            url: hurl + 'SERVICE/Service.aspx?Process=DUPLICATEREQUEST&REQUESTID=' + encodeURIComponent(Encrypt(ReqID)) + '&USERID=' + encodeURIComponent(Encrypt(UID)),
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                if (!data || !data[0] || !data[0].RESULT) { console.error('Invalid data returned from server'); return; }
                var parts = data[0].RESULT.split('_');
                if (parts[0] === 'TRUE') {
                    $('#LBLRequestResult').html(RHalt1 === '0' && RHalt2 === '0'
                        ? 'Request Raised Successfully.. Req No. #' + parts[1]
                        : 'Request(s) Raised Successfully.. Req Nos. ' + parts[1]);
                    HideModalPopUp('addTask');
                    flashModal('modalReqAlert', 3500);
                    Select('divPendingPercentage', 'PENDING');
                    setRequestUsers('Tasks');
                } else if (parts[0] === 'FALSET') {
                    showAlertModal('A similar/same request has already been raised.', 3500);
                }
            },
            error: function (xhr, status, error) {
                console.error('Error in RaiseDuplicate:', error);
                showAlertModal('An error occurred while processing the request.', 3500);
            }
        });
    }

    function populateSelect(selectId, items, selectedValue) {
        var select = document.getElementById(selectId);
        if (!select) return;
        select.innerHTML = '';
        var def = document.createElement('option');
        def.value = '';
        def.textContent = 'Select items...';
        select.appendChild(def);
        (items || []).forEach(function (item) {
            if (item && item.trim() !== '') {
                var o = document.createElement('option');
                o.value = item;
                o.textContent = item;
                if (item === selectedValue) o.selected = true;
                select.appendChild(o);
            }
        });
    }

    function valueOf(id) {
        var e = document.getElementById(id);
        return e ? e.value || '' : '';
    }

    function loadFilterDropdowns(serviceId) {
        var cur = {
            taskId: valueOf('taskIdSelect'), taskType: valueOf('taskTypeSelect'), equipmentType: valueOf('equipmentSelect'),
            requestStatus: valueOf('requestStatusSelect'), fromLocation: valueOf('fromLocationSelect'), toLocation: valueOf('toLocationSelect'),
            fromZone: valueOf('fromZoneSelect'), toZone: valueOf('toZoneSelect'), employee: valueOf('employeeSelect')
        };
        $.ajax({
            url: '/Index/Service/Service.aspx',
            method: 'GET',
            dataType: 'json',
            data: {
                Process: Encrypt('GETFILTEROPTIONS'),
                serviceId: Encrypt(serviceId || ''),
                isPrebooked: Encrypt(isPrebookChecked() ? '1' : '0')
            },
            success: function (data) {
                if (!data) return;
                populateSelect('taskIdSelect', data.taskIds, cur.taskId);
                populateSelect('taskTypeSelect', data.taskTypes, cur.taskType);
                populateSelect('equipmentSelect', data.equipmentTypes, cur.equipmentType);
                populateSelect('requestStatusSelect', data.requestStatuses, cur.requestStatus);
                populateSelect('fromLocationSelect', data.fromLocations, cur.fromLocation);
                populateSelect('toLocationSelect', data.toLocations, cur.toLocation);
                populateSelect('fromZoneSelect', data.fromZones, cur.fromZone);
                populateSelect('toZoneSelect', data.toZones, cur.toZone);
                populateSelect('employeeSelect', data.employees, cur.employee);
            },
            error: function (xhr, status, error) { console.error('Failed to load filter data:', error); }
        });
    }

    function loadStartedFilterDropdowns(serviceId) {
        var cur = {
            taskId: valueOf('taskIdSelectStarted'), taskType: valueOf('taskTypeSelectStarted'), equipmentType: valueOf('equipmentSelectStarted'),
            fromLocation: valueOf('fromLocationSelectStarted'), toLocation: valueOf('toLocationSelectStarted'), employee: valueOf('employeeSelectStarted')
        };
        $.ajax({
            url: '/Index/Service/Service.aspx',
            method: 'GET',
            dataType: 'json',
            data: { Process: Encrypt('GETSTARTFILTEROPTIONS'), serviceId: Encrypt(serviceId || '') },
            success: function (data) {
                if (!data) return;
                populateSelect('taskIdSelectStarted', data.taskIds, cur.taskId);
                populateSelect('taskTypeSelectStarted', data.taskTypes, cur.taskType);
                populateSelect('equipmentSelectStarted', data.equipmentTypes, cur.equipmentType);
                populateSelect('fromLocationSelectStarted', data.fromLocations, cur.fromLocation);
                populateSelect('toLocationSelectStarted', data.toLocations, cur.toLocation);
                populateSelect('employeeSelectStarted', data.employees, cur.employee);
            },
            error: function () { alert('Failed to load started filter data.'); }
        });
    }

    function populateEmployeeFilterOptions(serviceId) {
        var adjusted = (serviceId === '2') ? '3' : (serviceId || '');
        var cur = {
            userName: valueOf('employeeUserName'), hospital: valueOf('employeeHospital'),
            shift: valueOf('employeeShift'), status: valueOf('employeeStatus')
        };
        $.ajax({
            url: '/Index/Service/Service.aspx',
            method: 'GET',
            dataType: 'json',
            data: { Process: Encrypt('GETEMPLOYEEFILTEROPTIONS'), serviceId: Encrypt(adjusted) },
            success: function (data) {
                if (!data) return;
                populateSelect('employeeUserName', data.userNames, cur.userName);
                populateSelect('employeeHospital', data.hospitals, cur.hospital);
                populateSelect('employeeShift', data.shifts, cur.shift);
                populateSelect('employeeStatus', data.statuses, cur.status);
            },
            error: function () { alert('Failed to load employee filter options.'); }
        });
    }

    function loadFilteredEmployees(serviceId, f) {
        f = f || {};
        var adjusted = (serviceId == 2) ? '3' : (serviceId || '');
        $.ajax({
            url: '/Index/Service/Service.aspx',
            method: 'GET',
            dataType: 'json',
            data: {
                Process: Encrypt('GETFILTEREDEMPLOYEES'),
                serviceId: Encrypt(adjusted),
                userName: Encrypt(f.filterUserName || ''),
                hospital: Encrypt(f.filterHospital || ''),
                shift: Encrypt(f.filterShift || ''),
                status: Encrypt(f.filterStatus || '')
            },
            success: function (response) {
                var employees = response || [];
                var $list = $('#employeeList');
                $list.empty();
                employeeListMode = 'filtered';

                if (employees.length === 0) {
                    $list.append('<div class="text-muted">No employees found.</div>');
                    return;
                }

                var html = employees.map(function (emp) {
                    var serviceLabel = 'N/A';
                    if (emp.eq_serviceid) {
                        var labels = emp.eq_serviceid.toString().split(',').map(function (id) {
                            id = id.trim();
                            return id === '1' ? 'QAH' : id === '3' ? 'R&D' : '';
                        }).filter(Boolean);
                        if (labels.length > 0) serviceLabel = labels.join(' | ');
                    }
                    var status = (emp.status || '').toLowerCase();
                    var isCheckedOut = status === 'checked out';
                    var isOnBreak = status === 'on break';
                    var isOnMeal = status === 'on meal';
                    var isOnTask = status.indexOf('on task') === 0;
                    var disRest = isOnMeal || isOnTask || isCheckedOut;
                    var disMeal = isOnBreak || isOnTask || isCheckedOut;
                    var disIn = !isCheckedOut;
                    var disOut = isCheckedOut || isOnBreak || isOnMeal || isOnTask;
                    var restLabel = emp.status === 'On Break' ? 'End rest break' : 'Take rest break';
                    var mealLabel = emp.status === 'On Meal' ? 'End meal break' : 'Take meal break';
                    var inactive = ['On Meal', 'Checked out', 'On Break'].indexOf(emp.status) > -1;
                    var isTask = emp.status && emp.status.indexOf('On task') === 0;
                    var statusColor = emp.status === 'Free' ? '#196F3D' : isTask ? '#A14C00' : inactive ? '#666' : '#000';
                    var statusBg = emp.status === 'Free' ? '#E2F6D9' : isTask ? '#FFF5E5' : inactive ? '#F0F0F0' : '#EAEAEA';
                    var id = esc(emp.id);

                    return '<div class="employee-card border rounded p-2 mb-2 shadow-sm d-flex align-items-center justify-content-between">' +
                        '<div class="fw-bold flex-shrink-0" style="min-width: 120px;">' + esc(emp.username || 'N/A') + '</div>' +
                        '<div class="text-muted small d-flex align-items-center flex-grow-1 mx-3"><i class="bi bi-clock me-1"></i> ' + esc(emp.worktime || '0') +
                        '<span class="mx-3"><i class="bi bi-geo-alt-fill me-1"></i> ' + esc(emp.location || 'N/A') + '</span>' +
                        '<span class="mx-3"><i class="bi bi-person-badge me-1"></i> ' + esc(serviceLabel) + '</span></div>' +
                        '<span>' + esc(emp.action || '') + '</span>' +
                        '<div class="d-flex align-items-center flex-shrink-0 dropdown">' +
                        '<button class="btn btn-link text-muted p-0 m-0" type="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="bi bi-three-dots fs-5"></i></button>' +
                        '<ul class="dropdown-menu dropdown-menu-end">' +
                        (!isCheckedOut ?
                            '<li><a class="dropdown-item d-flex align-items-center take-rest-break ' + (disRest ? 'disabled-option' : '') + '" href="#" data-id="' + id + '"><i class="bi bi-cup-hot me-2"></i> ' + restLabel + '</a></li>' +
                            '<li><a class="dropdown-item d-flex align-items-center take-meal-break ' + (disMeal ? 'disabled-option' : '') + '" href="#" data-id="' + id + '"><i class="fas fa-utensils me-2"></i> ' + mealLabel + '</a></li>' +
                            '<li><a class="dropdown-item d-flex align-items-center check-out ' + (disOut ? 'disabled-option' : '') + '" href="#" data-id="' + id + '"><i class="bi bi-box-arrow-right me-2"></i> Check Out</a></li>' : '') +
                        '<li><a class="dropdown-item d-flex align-items-center check-in ' + (disIn ? 'disabled-option' : '') + '" href="#" data-id="' + id + '"><i class="bi bi-box-arrow-in-right me-2"></i> Check In</a></li>' +
                        '<li><a class="dropdown-item d-flex align-items-center show-details" href="#" data-id="' + id + '"><i class="bi bi-journal-text me-2"></i> Show details</a></li>' +
                        '</ul>' +
                        '<span class="badge ms-2" style="background-color: ' + statusBg + '; color: ' + statusColor + ';">' + esc(emp.status || 'N/A') + '</span>' +
                        '</div></div>';
                }).join('');

                $list.append(html);
            },
            error: function (xhr, status, error) { alert('Failed to load employees: ' + error); }
        });
    }

    function loadHoldReasons() {
        $.ajax({
            type: 'GET',
            url: '/Index/Service/Service.aspx?Process=' + encodeURIComponent(encryptAES('GetHoldReasons')),
            dataType: 'json',
            success: function (response) {
                var $s = $('#loadHoldReasons');
                $s.empty().append('<option value="">-- Select Reason --</option>');
                $.each(response, function (i, item) {
                    $s.append($('<option></option>').val(item.HoldReason).text(item.HoldReason));
                });
            },
            error: function (xhr, status, error) { console.error('Error:', error); }
        });
    }

    function loadCancelReasons() {
        $.ajax({
            type: 'GET',
            url: '/Index/Service/Service.aspx?Process=' + encodeURIComponent(encryptAES('GetCancelReasons')),
            dataType: 'json',
            success: function (response) {
                var $s = $('#ddlCancelReasons');
                $s.empty().append('<option value="">-- Select Reason --</option>');
                $.each(response, function (i, item) {
                    $s.append($('<option></option>').val(item.CancelReason).text(item.CancelReason));
                });
                $s.css('text-transform', 'none');
            },
            error: function (xhr, status, error) { console.error('Error loading cancel reasons:', error); }
        });
    }

    function loadKPIReasons() {
        $.ajax({
            type: 'GET',
            url: '/Index/Service/Service.aspx?Process=' + encodeURIComponent(Encrypt('GetResponseFailuresReasons')),
            dataType: 'json',
            success: function (response) {
                var $d = $('#ddlKPIReasons');
                $d.empty().append('<option value="">-- Select Reason --</option>');
                response.forEach(function (item) {
                    $d.append($('<option></option>').val(item.ResponseFailureReason).text(item.ResponseFailureReason));
                });
            }
        });
    }

    function OnChangeRemarksHC(selectElem, textAreaId) {
        var v = selectElem.value;
        var t = document.getElementById(textAreaId);
        t.value = v;
        t.style.display = v !== '' ? 'block' : 'none';
    }

    function initEditTask() {
        var editTaskModalEl = document.getElementById('editTaskModal');
        var updateBtn = document.getElementById('updateTaskBtn');

        function setOptions(selectId, items, textKey) {
            var select = document.getElementById(selectId);
            if (!select) return;
            var placeholder = select.querySelector('option[disabled]');
            select.innerHTML = '';
            if (placeholder) select.appendChild(placeholder);
            items.forEach(function (item) {
                var o = document.createElement('option');
                o.value = item.Id;
                o.textContent = item[textKey];
                select.appendChild(o);
            });
        }

        function populateDropdowns(res) {
            setOptions('editCategoryName', res.categories, 'CategoryName');
            setOptions('editEquipmentType', res.equipment, 'Name');
            setOptions('editFromLocation', res.locations, 'ZoneName');
            setOptions('editToLocation', res.locations, 'ZoneName');
            setOptions('editRemarks', res.remarks, 'MESSAGE');
        }

        function loadEditTaskDropdowns(serviceId) {
            if (dropdownData[serviceId] && dropdownData[serviceId].isLoaded) {
                populateDropdowns(dropdownData[serviceId].data);
                return Promise.resolve();
            }
            return fetch('/Index/Service/Service.aspx/GetDropdownData', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=utf-8' },
                body: JSON.stringify({ serviceId: serviceId })
            })
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    var res = JSON.parse(data.d);
                    dropdownData[serviceId] = { isLoaded: true, data: res };
                    populateDropdowns(res);
                })
                .catch(function (err) { console.error('Error loading dropdown data:', err); });
        }

        function setSelectValue(selectId, value) {
            var select = document.getElementById(selectId);
            if (!select) return;
            var option = Array.prototype.slice.call(select.options).filter(function (o) { return o.textContent === value; })[0];
            if (option) select.value = option.value;
        }

        function loadTaskDetails(requestId) {
            return fetch('/Index/Service/Service.aspx?Process=' + encodeURIComponent(Encrypt('GetSingleRequestDetails')) + '&requestId=' + encodeURIComponent(Encrypt(requestId)))
                .then(function (res) { return res.json(); })
                .then(function (tasks) {
                    var task = tasks && tasks.length > 0 ? tasks[0] : null;
                    if (!task) return;
                    currentTask = task;

                    document.getElementById('editRequestId').value = task.REQUESTID || '';
                    setSelectValue('editCategoryName', task.CATEGORYNAME);
                    setSelectValue('editEquipmentType', task.EquipmentName || '');
                    setSelectValue('editFromLocation', task.FROM || task.FROM_LOCATION || '');
                    setSelectValue('editToLocation', task.TO || task.TO_LOCATION || '');
                    document.getElementById('editPatientName').value = task.PATIENTNAME || '';
                    if (task.REQUESTEDATE) document.getElementById('txtReqdates').value = task.REQUESTEDATE;
                    if (task.REQUESTTIME) document.getElementById('txtReqTimes').value = task.REQUESTTIME;

                    if (task.RequestDeskRemarks) {
                        document.getElementById('editRemarksText').value = task.RequestDeskRemarks.split(',')
                            .map(function (r) { return r.trim(); }).filter(Boolean).join(', ');
                    }
                    var rs = document.getElementById('editRemarks');
                    if (rs) rs.selectedIndex = 0;
                })
                .catch(function (err) { console.error(err); });
        }

        document.addEventListener('click', async function (e) {
            var target = e.target.closest('.edit-task');
            if (!target) return;
            e.preventDefault();
            var requestId = target.getAttribute('data-request-id');
            if (!requestId) return console.error('requestId is missing');

            document.getElementById('taskIdDisplay').textContent = '#' + requestId;
            var editModal = bootstrap.Modal.getOrCreateInstance(editTaskModalEl);
            var serviceId = activeServiceId();
            try {
                await loadEditTaskDropdowns(serviceId);
                await loadTaskDetails(requestId);
                document.getElementById('editRemarksText').value = '';
                editModal.show();
            } catch (err) {
                console.error('Error loading modal data:', err);
            }
        });

        document.getElementById('editRemarks').addEventListener('change', function () {
            var selected = this.options[this.selectedIndex].text.trim();
            var input = document.getElementById('editRemarksText');
            if (!selected) return;
            var existing = input.value.split(',').map(function (v) { return v.trim(); }).filter(Boolean);
            if (existing.indexOf(selected) === -1) {
                existing.unshift(selected);
                input.value = existing.join(', ');
            }
        });

        updateBtn.addEventListener('click', function (e) {
            e.preventDefault();
            if (!currentTask) return;

            var reqDate = document.getElementById('txtReqdates').value;
            var reqTime = document.getElementById('txtReqTimes').value;
            if (reqDate.indexOf('/') > -1) {
                var p = reqDate.split('/');
                reqDate = p[1] + '/' + p[0] + '/' + p[2];
            }

            var payload = {
                categoryId: parseInt(document.getElementById('editCategoryName').value, 10) || 0,
                equipmentTypeId: parseInt(document.getElementById('editEquipmentType').value, 10) || 0,
                requestLocationId: parseInt(document.getElementById('editFromLocation').value, 10) || 0,
                destinationLocationId: parseInt(document.getElementById('editToLocation').value, 10) || 0,
                requestDeskRemarks: document.getElementById('editRemarksText').value.trim(),
                updatedBy: parseInt(sessionStorage.getItem('ID'), 10),
                patientName: document.getElementById('editPatientName').value || '',
                requestId: currentTask.REQUESTID,
                requestDate: reqDate + ' ' + reqTime
            };

            var finish = function () {
                var inst = bootstrap.Modal.getInstance(editTaskModalEl);
                if (inst) inst.hide();
                showTaskEndedModal('Task updated successfully!');
                window.RefreshAll();
            };

            fetch('/Index/Service/Service.aspx/UpdateRequestMaster', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ payload: encryptPayload(payload) })
            })
                .then(function (res) { return res.json(); })
                .then(finish)
                .catch(function (err) { console.error(err); finish(); });
        });
    }

    function isAutoRefreshEnabled() {
        var chk = document.getElementById('chkAutoRefresh');
        return !!(chk && chk.checked === true);
    }

    function stopAutoRefresh() {
        if (window.AutoRefresh !== null) { clearInterval(window.AutoRefresh); window.AutoRefresh = null; }
        if (countdownInterval !== null) { clearInterval(countdownInterval); countdownInterval = null; }
        countdownTimer = 30;
        var badge = document.getElementById('refreshCountdown');
        if (badge) {
            badge.style.display = 'none';
            badge.classList.remove('is-critical');
        }
    }

    function startAutoRefresh() {
        if (!isAutoRefreshEnabled() || document.hidden) return;
        stopAutoRefresh();
        var badge = document.getElementById('refreshCountdown');
        var secondsSpan = document.getElementById('countdownSeconds');
        if (!badge || !secondsSpan) return;

        badge.style.display = 'inline-block';
        badge.classList.remove('is-critical');
        countdownTimer = 30;
        secondsSpan.textContent = countdownTimer;

        window.AutoRefresh = setInterval(function () {
            if (!isAutoRefreshEnabled() || document.hidden) return;
            fn_refreshAll();
        }, REFRESH_INTERVAL);

        countdownInterval = setInterval(function () {
            if (!isAutoRefreshEnabled()) return;
            countdownTimer--;
            secondsSpan.textContent = countdownTimer;
            badge.classList.toggle('is-critical', countdownTimer <= 5 && countdownTimer > 0);

            if (countdownTimer <= 5 && countdownTimer > 0) {
                secondsSpan.classList.add('blink-timer');
            } else {
                secondsSpan.classList.remove('blink-timer');
            }

            if (countdownTimer <= 0) {
                countdownTimer = 30;
                secondsSpan.textContent = countdownTimer;
                badge.classList.remove('is-critical');
                secondsSpan.classList.remove('blink-timer');
            }
        }, 1000);
    }

    function RestartTimer_AutoRefresh() {
        if (isAutoRefreshEnabled()) startAutoRefresh(); else stopAutoRefresh();
    }

    function initAutoRefresh() {
        $('#chkAutoRefresh').prop('checked', false);
        var badge = document.getElementById('refreshCountdown');
        if (badge) badge.style.display = 'none';

        $('#chkAutoRefresh').on('change', function () {
            sessionStorage.setItem('autoRefreshEnabled', this.checked);
            if (!this.checked) abortAllFetchRequests();
            RestartTimer_AutoRefresh();
        });

        document.addEventListener('show.bs.modal', function () { stopAutoRefresh(); });
        document.addEventListener('hidden.bs.modal', function () { RestartTimer_AutoRefresh(); });
        document.addEventListener('show.bs.dropdown', function () { stopAutoRefresh(); });
        document.addEventListener('hide.bs.dropdown', function () { if (isAutoRefreshEnabled()) startAutoRefresh(); });

        document.addEventListener('visibilitychange', function () {
            if (document.hidden) return;
            var sid = activeServiceId();
            var pl = document.getElementById('pendingList');
            var sl = document.getElementById('startedList');
            if (pl && pl.children.length === 0) reloadTasks(sid);
            if (sl && sl.children.length === 0) reloadStartedTasks(sid);
            RestartTimer_AutoRefresh();
        });
    }

    function initFilters() {
        $('.filter-icon').on('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            var $panel = $(this).closest('.filter-wrapper').find('.filter-panel');
            var isOpen = $panel.css('display') === 'block';
            $('.filter-panel').not($panel).hide();

            if (isOpen) {
                $panel.hide();
                RestartTimer_AutoRefresh();
            } else {
                var sid = activeServiceId();
                if (this.id === 'openFilterModal') loadFilterDropdowns(sid);
                else if (this.id === 'openStartedFilterModal') loadStartedFilterDropdowns(sid);
                else if (this.id === 'openEmployeeFilterModal') populateEmployeeFilterOptions(sid);
                $panel.show();
                stopAutoRefresh();
            }
        });

        $('.filter-panel').on('click', function (e) { e.stopPropagation(); });

        $(document).on('click', function (e) {
            if ($(e.target).closest('.filter-panel, .filter-icon').length) return;
            var anyOpen = false;
            $('.filter-panel').each(function () {
                if ($(this).css('display') === 'block') { anyOpen = true; $(this).hide(); }
            });
            if (anyOpen) RestartTimer_AutoRefresh();
        });

        $('.filter-panel .btn-grey').on('click', function () {
            $(this).closest('.filter-panel').hide();
            RestartTimer_AutoRefresh();
        });

        $('.filter-panel .apply-filters').on('click', function () {
            var $panel = $(this).closest('.filter-panel');
            var $column = $panel.closest('.column-container');
            var sid = activeServiceId();

            if ($column.find('#pendingList').length) {
                pendingFilters = {
                    filterTaskId: valueOf('taskIdSelect'),
                    filterTaskType: valueOf('taskTypeSelect'),
                    filterEquipmentType: valueOf('equipmentSelect'),
                    filterRequestStatus: valueOf('requestStatusSelect'),
                    filterFromLocation: valueOf('fromLocationSelect'),
                    filterToLocation: valueOf('toLocationSelect'),
                    filterFromZone: valueOf('fromZoneSelect'),
                    filterToZone: valueOf('toZoneSelect'),
                    filterEmployee: valueOf('employeeSelect')
                };
                document.getElementById('pendingList').innerHTML = '';
                getCurrentTaskLoader(sid)();
            } else if ($column.find('#startedList').length) {
                startedFilters = {
                    filterTaskId: valueOf('taskIdSelectStarted'),
                    filterTaskType: valueOf('taskTypeSelectStarted'),
                    filterEquipmentType: valueOf('equipmentSelectStarted'),
                    filterFromLocation: valueOf('fromLocationSelectStarted'),
                    filterToLocation: valueOf('toLocationSelectStarted'),
                    filterEmployee: valueOf('employeeSelectStarted')
                };
                document.getElementById('startedList').innerHTML = '';
                reloadStartedTasks(sid);
            } else if ($column.find('#employeeList').length) {
                employeeFilters = {
                    filterUserName: valueOf('employeeUserName'),
                    filterHospital: valueOf('employeeHospital'),
                    filterShift: valueOf('employeeShift'),
                    filterStatus: valueOf('employeeStatus')
                };
                loadFilteredEmployees(sid, employeeFilters);
            }

            $panel.hide();
            RestartTimer_AutoRefresh();
        });

        $('.filter-panel .clear-filters').on('click', function (e) {
            e.preventDefault();
            var $panel = $(this).closest('.filter-panel');
            var $column = $panel.closest('.column-container');
            var sid = activeServiceId();
            $panel.find('select').each(function () { this.selectedIndex = 0; });
            $panel.hide();

            if ($column.find('#pendingList').length) {
                pendingFilters = {};
                reloadTasks(sid);
            } else if ($column.find('#startedList').length) {
                startedFilters = {};
                reloadStartedTasks(sid);
            } else if ($column.find('#employeeList').length) {
                employeeFilters = { filterUserName: '', filterHospital: '', filterShift: '', filterStatus: '' };
                loadEmployeesList('', sid, employeeSortOrder);
            }
            RestartTimer_AutoRefresh();
        });
    }

    function onWindowLoad(fn) {
        if (document.readyState === 'complete') fn();
        else window.addEventListener('load', fn);
    }

    function initLeftPanel() {
        var iconBar = document.querySelector('.icon-bar');
        var hamburger = document.getElementById('hamburger');
        var leftPanel = document.querySelector('.screen-left-panel');
        var hospitalImg = document.querySelector('.hospital-img');
        if (!iconBar || !hamburger || !leftPanel || !hospitalImg) return;

        var hideTimeout = null;
        var isHovered = false;

        function hidePanel() {
            if (isHovered) return;
            hospitalImg.classList.add('hidden');
            leftPanel.classList.add('hidden');
            iconBar.classList.remove('hidden');
            hamburger.classList.remove('hidden');
        }

        function showPanel() {
            clearTimeout(hideTimeout);
            hamburger.classList.add('hidden');
            iconBar.classList.add('hidden');
            leftPanel.classList.remove('hidden');
            setTimeout(function () { hospitalImg.classList.remove('hidden'); }, 300);
            hideTimeout = setTimeout(hidePanel, 4000);
        }

        onWindowLoad(function () {
            leftPanel.classList.remove('hidden');
            hospitalImg.classList.remove('hidden');
            hamburger.classList.add('hidden');
            iconBar.classList.add('hidden');
            hideTimeout = setTimeout(hidePanel, 4000);
        });

        [leftPanel, hospitalImg].forEach(function (node) {
            node.addEventListener('mouseenter', function () {
                isHovered = true;
                clearTimeout(hideTimeout);
            });
            node.addEventListener('mouseleave', function () {
                isHovered = false;
                clearTimeout(hideTimeout);
                hideTimeout = setTimeout(hidePanel, 3000);
            });
        });

        hamburger.addEventListener('click', showPanel);
    }

    function initBasicHandlers() {
        $('#chkPreBook').on('change', function () {
            var isPreBook = $(this).prop('checked');
            $('#containerDate').css('display', isPreBook ? 'block' : 'none');
            $('#containerTime').css('display', isPreBook ? 'block' : 'none');
            RPreBook = isPreBook ? '2' : '0';
            var cw = document.querySelector('.custom-calendar-wrap');
            if (cw) cw.classList.toggle('prebook-on', isPreBook);
        });

        $('#chkMultiPorter').on('change', function () {
            $('#chkMultiPorterImg').attr('src', $(this).is(':checked') ? '../images/MCheck.jpg' : '../images/NoMCheck.jpg');
            IsMTPR = $(this).prop('checked') ? '1' : '0';
        });

        $('#chkUserRequest').on('change', function () { setIndexscreen(true); });
        $('#chkHaywoodRequests').on('change', function () {
            IsHaywood = $('#chkHaywoodRequests').prop('checked');
            setIndexscreen(false);
        });

        $('#ModalAddTask').on('hidden.bs.modal', function () { if (typeof clearMT === 'function') clearMT(); });
        $('#floor-map-popup').on('hidden.bs.modal', function () { if (typeof ReloadMap !== 'undefined') clearInterval(window.ReloadMap); });

        $('#txtFromLoc').on('keyup', function () {
            if (ServiceCode != '3' && typeof loadsuggesstion === 'function') loadsuggesstion('from', $(this).val());
        });
        $('#txtToLoc').on('keyup', function () {
            if (typeof loadsuggesstion === 'function') loadsuggesstion('to', $(this).val());
        });

        $('#modalTaskHold').on('show.bs.modal', loadHoldReasons);
        $('#modalTaskCancel').on('show.bs.modal', loadCancelReasons);

        $('#chkPreBook').trigger('change');
    }

    function initKeyFilters() {
        var regex = /^[a-zA-Z0-9]+$/;
        var allowed = ['*', ',', '.', '-', '_'];
        $('textarea, input[type=search]').on('keypress', function (event) {
            var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);
            if (!regex.test(key) && event.which !== 32 && event.which !== 13 && allowed.indexOf(key) === -1) {
                event.preventDefault();
                return false;
            }
        });
    }

    function initTaskColumns() {
        var debounceTimers = {};
        function debounced(key, fn) {
            clearTimeout(debounceTimers[key]);
            debounceTimers[key] = setTimeout(fn, 600);
        }

        var pendingFilter = document.getElementById('pendingFilter');
        if (pendingFilter) {
            pendingFilter.addEventListener('input', function () {
                debounced('p', function () { getCurrentTaskLoader(activeServiceId())(); });
            });
        }

        var startedFilter = document.getElementById('startedFilter');
        if (startedFilter) {
            startedFilter.addEventListener('input', function () {
                debounced('s', function () { reloadStartedTasks(activeServiceId()); });
            });
        }

        var employeeInput = document.getElementById('employeeFilter');
        if (employeeInput) {
            employeeInput.addEventListener('input', function () {
                var self = this;
                debounced('e', function () { loadEmployeesList(self.value.trim(), activeServiceId(), employeeSortOrder); });
            });
        }

        $('#showPrebookedCheckbox').on('change', function () {
            var heading = document.querySelector('[data-heading="pending"]');
            var sid = activeServiceId();
            if (this.checked) {
                if (heading) heading.textContent = 'Pre-booked';
                reloadPrebookTasks(sid);
            } else {
                if (heading) heading.textContent = 'Pending';
                reloadTasks(sid);
            }
        });

        document.querySelectorAll('.sort-option').forEach(function (item) {
            item.addEventListener('click', function (e) {
                e.preventDefault();
                sortPendingTasks(this.getAttribute('data-order'));
            });
        });

        document.querySelectorAll('.started-sort-option').forEach(function (item) {
            item.addEventListener('click', function (e) {
                e.preventDefault();
                sortStartedTasks(this.getAttribute('data-order'));
            });
        });

        bindTaskListActions('pendingList');
        bindTaskListActions('startedList');

        $(document).on('click', '.requestor-info', function () {
            var content = document.getElementById('requestorModalContent');
            if (content) content.textContent = this.getAttribute('data-requestor') || 'N/A';
        });
    }

    function initServiceButtons() {
        $('.services-btn-icon').on('click', function () {
            ServiceCode = this.id.replace('divService', '');
            callFrom = 'Parent';
            sessionStorage.setItem('ServiceCode', ServiceCode);
            setRootServices(this);
            $('#pendingList, #startedList, #employeeList').empty();
            reloadTasks(ServiceCode);
            reloadStartedTasks(ServiceCode);
            loadEmployeesList('', ServiceCode, employeeSortOrder);
        });

        $('.services-btn-icon-modal').on('click', function () {
            var Process = ($('#TaskHeader').html() == 'New Task') ? 'New' : 'Edit';
            var selServiceCode = this.id.replace('divRService', '');
            if (Process == 'New' || EServiceCode == selServiceCode) {
                var eleParent = $('#divService' + selServiceCode);
                ServiceCode = selServiceCode;
                callFrom = 'innerElement';
                setRequestChanges(selServiceCode, Process);
                setRootServices(eleParent);
                setInnerServices(this);
            }
        });

        var stored = sessionStorage.getItem('ServiceCode');
        if (stored == null || stored == '0' || !document.getElementById('divService' + stored)) stored = '1';
        ServiceCode = stored;
        $('#divService' + stored).trigger('click');
        $('.services-btn-icon-modal').first().trigger('click');
    }

    function initMessaging() {
        var messageModalEl = document.getElementById('messageModal');
        if (!messageModalEl) return;
        var messageModal = bootstrap.Modal.getOrCreateInstance(messageModalEl);

        $(document).on('click', '.send-message', function (e) {
            e.preventDefault();
            selectedEmployeeId = this.getAttribute('data-id');
            var msgText = document.getElementById('messageText');
            if (msgText) msgText.value = '';
            messageModal.show();
        });

        var sendBtn = document.getElementById('sendMessageBtn');
        if (sendBtn) {
            sendBtn.addEventListener('click', function () {
                var message = document.getElementById('messageText').value.trim();
                if (!message) { alert('Please enter a message.'); return; }

                var serviceId = activeServiceId() || 0;
                var showDone = function () {
                    messageModal.hide();
                    $('#lblEmployeeActionResult').text('Message sent successfully!');
                    flashModal('modalEmployeeActionSuccess', 1500);
                };

                $.ajax({
                    type: 'POST',
                    url: '/Index/Service/Service.aspx?Process=' + encodeURIComponent(encryptAES('SENDMESSAGE')),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    data: JSON.stringify({
                        porterId: Encrypt(selectedEmployeeId),
                        userId: Encrypt(sessionStorage.getItem('ID')),
                        message: Encrypt(message),
                        serviceId: Encrypt(serviceId)
                    }),
                    success: function (data) {
                        var result = data.d || data;
                        if (!result || result === 'Success') showDone();
                        else alert('Failed to send message: ' + result);
                    },
                    error: showDone
                });
            });
        }
    }

    function displayUserName() {
        var name = sessionStorage.getItem('NAME');
        if (!name) {
            window.location = '../Login.aspx';
            return false;
        }
        var el = document.getElementById('userName');
        if (el) el.textContent = name.toUpperCase();
        return true;
    }

    $(function () {
        if (!displayUserName()) return;

        if (typeof InitChangePassword === 'function') InitChangePassword();
        if (typeof LoadNewRequest === 'function') LoadNewRequest();

        fixAllAriaHiddenWarnings();
        initBasicHandlers();
        initKeyFilters();
        initTaskColumns();
        initEmployeeListEvents();
        initBreakHandlers();
        initBulkAssign();
        initAssignModal();
        initReassign();
        initEditTask();
        initMessaging();
        initFilters();
        initAutoRefresh();
        initLeftPanel();
        loadKPIReasons();
        initServiceButtons();

        if (typeof LoaderOn === 'function') LoaderOn();
        if (typeof LoaderOff === 'function') LoaderOff(1000);

        $.xhrPool = [];
        $.ajaxSetup({
            beforeSend: function (jqXHR) { $.xhrPool.push(jqXHR); },
            complete: function (jqXHR) {
                var i = $.xhrPool.indexOf(jqXHR);
                if (i > -1) $.xhrPool.splice(i, 1);
            }
        });
    });

    Object.assign(window, {
        Encrypt: Encrypt,
        encryptAES: encryptAES,
        encryptQS: encryptQS,
        setRootServices: setRootServices,
        setInnerServices: setInnerServices,
        setRequestChanges: setRequestChanges,
        setDefaultLocationIfService2: setDefaultLocationIfService2,
        setDefaultCategoryIfService2: setDefaultCategoryIfService2,
        setPagerEmpty: setPagerEmpty,
        setIndexscreen: setIndexscreen,
        setServiceUpdates: setServiceUpdates,
        LoadProcess: LoadProcess,
        ReloadLinks: ReloadLinks,
        saveUIState: saveUIState,
        cleanupAbortControllers: cleanupAbortControllers,
        fetchWithAbort: fetchWithAbort,
        abortAllFetchRequests: abortAllFetchRequests,
        AbortAllActiveRuquests: AbortAllActiveRuquests,
        fetchAndRenderTasks: fetchAndRenderTasks,
        reloadTasks: reloadTasks,
        reloadStartedTasks: reloadStartedTasks,
        reloadPrebookTasks: reloadPrebookTasks,
        fetchTaskDetailsAndShow: fetchTaskDetailsAndShow,
        sortTasks: sortTasks,
        fn_refreshAll: fn_refreshAll,
        loadEmployeesList: loadEmployeesList,
        loadEmployees: loadFilteredEmployees,
        loadFilteredEmployees: loadFilteredEmployees,
        showEmployeeDetails: showEmployeeDetails,
        bindEmployeeData: bindEmployeeData,
        triggerPorterAction: triggerPorterAction,
        assignPorterToTask: assignPorterToTask,
        loadAvailablePorters: loadAvailablePorters,
        showPorterAssignedModal: showPorterAssignedModal,
        showPorterWarningModal: showPorterWarningModal,
        closePorterWarningModal: closePorterWarningModal,
        showEmployeeActionSuccess: showEmployeeActionSuccess,
        LoadEquipment: LoadEquipment,
        resetMultiPorter: resetMultiPorter,
        updateMultiPorter: updateMultiPorter,
        CatSelection: CatSelection,
        clearAllCheckBox: clearAllCheckBox,
        onEquipmentSelect: onEquipmentSelect,
        searchEquipment: searchEquipment,
        LoadEquipmentOnInit: LoadEquipmentOnInit,
        getSelectedEquipIDs: getSelectedEquipIDs,
        InsertRequest: InsertRequest,
        UpdateRequest: UpdateRequest,
        submitRequest: submitRequest,
        RaiseDuplicate: RaiseDuplicate,
        populateSelect: populateSelect,
        loadFilterDropdowns: loadFilterDropdowns,
        loadStartedFilterDropdowns: loadStartedFilterDropdowns,
        populateEmployeeFilterOptions: populateEmployeeFilterOptions,
        loadHoldReasons: loadHoldReasons,
        loadCancelReasons: loadCancelReasons,
        loadKPIReasons: loadKPIReasons,
        OnChangeRemarksHC: OnChangeRemarksHC,
        startAutoRefresh: startAutoRefresh,
        stopAutoRefresh: stopAutoRefresh,
        RestartTimer_AutoRefresh: RestartTimer_AutoRefresh
    });

})();

function LoaderOn() {
    $('.loaderElement').css("display", "inline-block");
}

function LoaderOff(Interval) {
    setTimeout(function () {
        $('.loaderElement').css("display", "none");
    }, Interval);
}
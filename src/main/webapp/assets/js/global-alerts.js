(function(){
  function ensureContainer(){
    var container = document.getElementById('adminAlerts');
    if (!container){
      container = document.createElement('div');
      container.id = 'adminAlerts';
      container.className = 'admin-alerts';
      container.setAttribute('aria-live','polite');
      container.setAttribute('aria-atomic','true');
      document.body.appendChild(container);
    }
    return container;
  }

  function showAdminError(msg){
    var container = ensureContainer();
    var alertEl = document.createElement('div');
    alertEl.className = 'admin-alert admin-alert-error';
    alertEl.setAttribute('role','alert');
    var msgNode = document.createElement('div');
    msgNode.className = 'admin-alert-message';
    msgNode.appendChild(document.createTextNode(msg));
    var closeBtn = document.createElement('button');
    closeBtn.type = 'button';
    closeBtn.className = 'admin-alert-close';
    closeBtn.setAttribute('aria-label','Close');
    closeBtn.innerHTML = '\u00D7';
    alertEl.appendChild(msgNode);
    alertEl.appendChild(closeBtn);
    container.appendChild(alertEl);
    requestAnimationFrame(function(){ alertEl.classList.add('show'); });
    closeBtn.addEventListener('click', function(){ hideAlert(alertEl); });
    setTimeout(function(){ hideAlert(alertEl); }, 6000);
  }

  function showAdminSuccess(msg){
    var container = ensureContainer();
    var alertEl = document.createElement('div');
    alertEl.className = 'admin-alert admin-alert-success';
    alertEl.setAttribute('role','status');
    var msgNode = document.createElement('div');
    msgNode.className = 'admin-alert-message';
    msgNode.appendChild(document.createTextNode(msg));
    var closeBtn = document.createElement('button');
    closeBtn.type = 'button';
    closeBtn.className = 'admin-alert-close';
    closeBtn.setAttribute('aria-label','Close');
    closeBtn.innerHTML = '\u00D7';
    alertEl.appendChild(msgNode);
    alertEl.appendChild(closeBtn);
    container.appendChild(alertEl);
    requestAnimationFrame(function(){ alertEl.classList.add('show'); });
    closeBtn.addEventListener('click', function(){ hideAlert(alertEl); });
    setTimeout(function(){ hideAlert(alertEl); }, 4500);
  }

  function hideAlert(el){
    if (!el) return;
    el.classList.remove('show');
    el.addEventListener('transitionend', function(){ if (el.parentNode) el.parentNode.removeChild(el); });
  }

  // expose
  window.showAdminError = showAdminError;
  window.showAdminSuccess = showAdminSuccess;

  // override window.alert to route to admin alerts when available
  window._adminAlertQueue = window._adminAlertQueue || [];
  var nativeAlert = window.alert;
  window._nativeAlert = nativeAlert;
  window.alert = function(msg){
    if (window.showAdminError){
      try { window.showAdminError(String(msg)); } catch(e){ nativeAlert(msg); }
    } else {
      window._adminAlertQueue.push(msg);
    }
  };

  // flush queued messages
  if (window._adminAlertQueue && window._adminAlertQueue.length){
    window._adminAlertQueue.forEach(function(m){
      try { window.showAdminError(String(m)); } catch(e) { /* ignore */ }
    });
    window._adminAlertQueue = [];
  }
})();

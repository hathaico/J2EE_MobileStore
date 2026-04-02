<%@ page contentType="text/html;charset=UTF-8" language="java" %>
        </div><!-- /.admin-content -->
    </div><!-- /.admin-main -->
</div><!-- /.admin-wrapper -->

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Admin CSS for alerts -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-alerts.css">

<!-- Admin Alerts container -->
<div id="adminAlerts" class="admin-alerts" aria-live="polite" aria-atomic="true"></div>

<!-- Admin JS -->
<script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
<script>
  // Override window.alert to route to admin alerts when available. Queue messages if helper not ready yet.
  window._adminAlertQueue = window._adminAlertQueue || [];
  (function(){
    var nativeAlert = window.alert;
    window.alert = function(msg){
      if (window.showAdminError){
        try { window.showAdminError(String(msg)); } catch(e){ nativeAlert(msg); }
      } else {
        window._adminAlertQueue.push(msg);
      }
    };
    window._nativeAlert = nativeAlert;
  })();
</script>
<script src="${pageContext.request.contextPath}/assets/js/admin-forms.js"></script>
</body>
</html>

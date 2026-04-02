# VNPay Sandbox Setup

This guide helps you run card payment flow using VNPay sandbox in `J2EE_MobileStore`.

## 1. Required Variables

You must provide:

- `VNPAY_TMN_CODE`
- `VNPAY_HASH_SECRET`
- Optional: `VNPAY_PAY_URL` (default is sandbox URL)
- Optional: `VNPAY_DEV_MODE=true` to simulate payment success when credentials are not configured

Default sandbox URL already used by code:

- `https://sandbox.vnpayment.vn/paymentv2/vpcpay.html`

## 2. Quick Setup (PowerShell - current terminal)

Use this when starting app from the same terminal session:

```powershell
$env:VNPAY_TMN_CODE = "YOUR_TMN_CODE"
$env:VNPAY_HASH_SECRET = "YOUR_HASH_SECRET"
$env:VNPAY_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html"
```

Then run your app normally.

## 2.1 One-click Local Dev Mode (No VNPay account required)

If you want to test checkout quickly without real VNPay sandbox credentials:

```powershell
$env:VNPAY_DEV_MODE = "true"
```

Behavior in dev mode:

- When `VNPAY_TMN_CODE`/`VNPAY_HASH_SECRET` are missing, app will mark card payment as success immediately.
- Mock flow is allowed only for local requests (`127.0.0.1`, `::1`, or private LAN IP) for safer testing.
- Order is updated to paid and redirected to success page with a mock-payment note.
- When credentials are configured, normal VNPay redirect flow is still used.

## 3. Alternative Setup (JVM args)

The code also supports Java system properties:

```powershell
mvn -DskipTests -DVNPAY_TMN_CODE=YOUR_TMN_CODE -DVNPAY_HASH_SECRET=YOUR_HASH_SECRET spring-boot:run
```

If you are not using Spring Boot run command, add `-D...` to your Java startup command similarly.

## 4. Test Flow

1. Login as customer.
2. Add product to cart.
3. Go to checkout.
4. Choose `Thẻ ngân hàng (ATM/Visa/Mastercard)`.
5. Submit order.
6. App redirects to `/payment/vnpay/create?orderId=...` then VNPay sandbox.
7. Complete payment in VNPay sandbox.
8. VNPay redirects back to `/payment/vnpay/return`.
9. Order payment status is updated to `PAID` when response code is successful.

## 5. Verify Result in DB

Check payment status:

```sql
SELECT order_id, payment_method, payment_status, status, total_amount
FROM orders
ORDER BY order_id DESC
LIMIT 10;
```

## 6. Common Issues

- `vnpay_not_configured`:
  - Missing `VNPAY_TMN_CODE` or `VNPAY_HASH_SECRET`.
  - Set `VNPAY_DEV_MODE=true` if you want local mock payment.
- Return shows payment failed:
  - Wrong secret key, signature mismatch, or sandbox transaction canceled.
- No redirect to VNPay:
  - Check server logs for order creation and `/payment/vnpay/create` errors.

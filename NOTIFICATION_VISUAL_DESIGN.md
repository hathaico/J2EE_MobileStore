# 🎨 Notification System - Visual Design Reference

## Before & After Comparison

### ❌ OLD Bootstrap Alerts

```html
<!-- Old alert HTML -->
<div class="alert alert-success alert-dismissible fade show" role="alert">
    <i class="bi bi-check-circle-fill me-2"></i>
    Đã đăng xuất thành công!
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
```

**Issues with Bootstrap alerts**:
- Basic, flat design
- Takes up horizontal space in document flow
- Requires manual integration on each page
- Limited customization
- Not visually appealing for modern design

---

### ✅ NEW Popup Notifications

```javascript
// New notification system
window.NotificationSystem.success('Đã đăng xuất thành công!', 'Tạm biệt!');
```

**Advantages**:
- Modern popup design with gradient
- Fixed position (doesn't affect layout)
- Globally available on all pages
- Fully customizable and scalable
- Beautiful animations

---

## 🎨 Visual Elements

### SUCCESS Notification
```
┌─ (Green border left) ─────────────────────────────────┐
│ ✓✓ │ Thành Công!                              │ ✕   │
│    │ Sản phẩm đã được thêm vào giỏ hàng      │     │
│    │ ←────── Progress Bar ────────→          │     │
└────────────────────────────────────────────────────────┘
📍 Position: Top-right corner
🎨 Color: Green gradient background (#F0FDF4 to #ECFDF5)
⏱️  Duration: 5 seconds auto-close
```

### ERROR Notification
```
┌─ (Red border left) ───────────────────────────────────┐
│ ⚠️  │ Lỗi!                                   │ ✕   │
│    │ Có lỗi xảy ra khi lưu dữ liệu          │     │
│    │ ←────── Progress Bar ────────→          │     │
└────────────────────────────────────────────────────────┘
📍 Position: Top-right corner
🎨 Color: Red gradient background (#FEF2F2 to #FEE2E2)
⏱️  Duration: Persistent (must close manually)
```

### INFO Notification
```
┌─ (Blue border left) ──────────────────────────────────┐
│ ⓘ  │ Thông Báo                              │ ✕   │
│    │ Bạn có 3 đơn hàng chưa xác nhận        │     │
│    │ ←────── Progress Bar ────────→          │     │
└────────────────────────────────────────────────────────┘
📍 Position: Top-right corner
🎨 Color: Blue gradient background (#EFF6FF to #DBEAFE)
⏱️  Duration: 5 seconds auto-close
```

### WARNING Notification
```
┌─ (Yellow border left) ────────────────────────────────┐
│ ⚠️  │ Cảnh Báo                               │ ✕   │
│    │ Sản phẩm này sắp hết hàng              │     │
│    │ ←────── Progress Bar ────────→          │     │
└────────────────────────────────────────────────────────┘
📍 Position: Top-right corner
🎨 Color: Yellow gradient background (#FFFBEB to #FEF3C7)
⏱️  Duration: 5 seconds auto-close
```

---

## 📐 Dimensions & Spacing

```
┌─ Notification Container ────────────────────────────────┐
│                                                          │
│  ┌─ Individual Notification (400px max) ─────────────┐  │
│  │                                                   │  │
│  │  ┌────┐  ◻ Title (0.95rem bold)         │ ✕    │  │
│  │  │Icon│  Message text (0.85rem)         │      │  │
│  │  │ 28px │ Max length 2-3 lines          │      │  │
│  │  │24-32 │                               │      │  │
│  │  └────┘  Progress bar (3px height)  │      │  │
│  │     ◼────────────────────────────────│      │  │
│  │                                                   │  │
│  └─────────────────────────────────────────────────┘  │
│  Gap: 12px (between notifications)                    │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

### Spacing
| Element | Value |
|---------|-------|
| Container top | 20px |
| Container right | 20px |
| Notification padding | 16px |
| Icon size | 28px |
| Icon-to-content gap | 14px |
| Title-to-message gap | 4px |
| Between notifications | 12px |
| Max width | 400px |

---

## 🎯 Icon Types

| Type | Icon Class | Icon |
|------|-----------|------|
| Success | `bi-check-circle-fill` | ✓ |
| Error | `bi-exclamation-circle-fill` | ⚠️ |
| Info | `bi-info-circle-fill` | ⓘ |
| Warning | `bi-exclamation-triangle-fill` | ⚠️ |

---

## 🎨 Color Palette

### Success (Green)
```
Border: #10B981
Icon BG: rgba(16, 185, 129, 0.1)
Icon Color: #10B981
Title Color: #047857
Message Color: #065F46
Gradient BG: linear-gradient(135deg, #F0FDF4 0%, #ECFDF5 100%)
```

### Error (Red)
```
Border: #EF4444
Icon BG: rgba(239, 68, 68, 0.1)
Icon Color: #EF4444
Title Color: #991B1B
Message Color: #7F1D1D
Gradient BG: linear-gradient(135deg, #FEF2F2 0%, #FEE2E2 100%)
```

### Info (Blue)
```
Border: #2563EB
Icon BG: rgba(37, 99, 235, 0.1)
Icon Color: #2563EB
Title Color: #1e40af
Message Color: #1e40af
Gradient BG: linear-gradient(135deg, #EFF6FF 0%, #DBEAFE 100%)
```

### Warning (Yellow)
```
Border: #F59E0B
Icon BG: rgba(245, 158, 11, 0.1)
Icon Color: #F59E0B
Title Color: #92400E
Message Color: #78350F
Gradient BG: linear-gradient(135deg, #FFFBEB 0%, #FEF3C7 100%)
```

---

## 🎬 Animation Sequences

### Entrance Animation (slideInRight)

```
0%    25%    50%    75%    100%
|     |      |      |      |
■     ■      ■      ■      ■     → X Position
0px   100px  200px  300px  400px
opacity: 0%  25%   50%   75%   100%
Duration: 300ms (ease-out)
```

### Exit Animation (slideOutRight)

```
0%    25%    50%    75%    100%
|     |      |      |      |
■     ■      ■      ■      ■     → X Position
0px   100px  200px  300px  400px
opacity: 100% 75%  50%   25%   0%
Duration: 300ms (ease-out)
```

### Progress Bar Animation

```
Width: 100% → 0% over 5 seconds
■■■■■■■■■■■  →  ■■■■■■■  →  ■■■  →  (empty)
Duration: 5000ms (linear)
```

---

## 📱 Responsive Breakpoints

### Desktop (> 991px)
```
       ┌─────────────────────┐
       │  Notification(400px)│
       │         OR          │
       │  Stack of 3+        │
       │         OR          │
       │  Positioned top-right
       │  20px from edges    │
       └─────────────────────┘
                    ▲
                    │ 20px
                    │
                 [Right Edge]
```

### Tablet/Mobile (≤ 991px)
```
┌─────────────────────────────────┐
│  Notification (full - 24px)     │
│  Stack vertically              │
│  Located below navbar          │
│  12px side margins             │
│  Top positioned 70px           │
└─────────────────────────────────┘
    ▲
    │ 70px (below navbar)
    │
[Navbar]
```

---

## ⏱️ Timing & Duration

| Action | Duration | Easing |
|--------|----------|--------|
| Slide In | 300ms | ease-out |
| Slide Out | 300ms | ease-out |
| Auto Close | 5000ms | - |
| Progress Bar | 5000ms | linear |
| Remove from DOM | 300ms | - |

---

## 🔊 State Changes

### Initial State
```javascript
notification {
  opacity: 0,
  transform: translateX(400px)  // Off-screen right
}
```

### Active State
```javascript
notification {
  opacity: 1,
  transform: translateX(0)  // On screen
  // Progress bar at 100% width
}
```

### Removing State
```javascript
notification.classList.add('removing')
// Triggers slideOutRight animation
// setTimeout(..., 300ms) → element.remove()
```

---

## 🎯 Use Cases & Examples

### e-Commerce Actions
```
✅ Added to cart → Success (auto-close)
❌ Out of stock → Error (persistent)
⚠️ Low stock → Warning (auto-close)
ℹ️ New sale starts → Info (auto-close)
```

### User Actions
```
✅ Profile updated → Success (auto-close)
❌ Email exists → Error (persistent)
⚠️ Password weak → Warning (persistent)
ℹ️ Verify email → Info (persistent)
```

### Admin Actions
```
✅ Product added → Success (auto-close)
❌ Upload failed → Error (persistent)
⚠️ Stock low → Warning (auto-close)
ℹ️ New order → Info (auto-close)
```

---

## 📊 Comparison: Old vs New

| Feature | Bootstrap Alert | New Popup |
|---------|---|---|
| **Visual Design** | Basic, flat | Modern, gradient |
| **Position** | Inline (affects layout) | Fixed (top-right) |
| **Animation** | Fade (300ms) | Slide (300ms) |
| **Auto-close** | Manual only | Configurable (5s) |
| **Stacking** | Single only | Multiple supported |
| **Mobile Support** | Limited | Fully responsive |
| **Z-index** | Normal | 9999 (always visible) |
| **Customization** | Bootstrap theme | Fully customizable |
| **Integration** | Per-page | Global system |
| **User Experience** | Intrusive | Non-intrusive |

---

## 🚀 Performance Metrics

| Metric | Value |
|--------|-------|
| CSS Size | ~2.5 KB |
| JS Size | ~3 KB |
| Animation GPU | Yes (transform, opacity) |
| DOM Operations | ~3 per notification |
| Reflows | Minimal |
| Memory | ~2KB per notification |

---

## ✨ Accessibility Features

- ✓ ARIA labels on close button
- ✓ High contrast colors (WCAG AA compliant)
- ✓ Semantic HTML structure
- ✓ Keyboard accessible (Tab, Enter, Escape)
- ✓ Screen reader friendly
- ✓ Clear visual hierarchy

---

## 🎨 Future Enhancement Ideas

1. **Sound Notification**
   - Short beep for info/success
   - Alert sound for errors

2. **Desktop Notifications**
   - Use Web Notifications API
   - Request permission from user

3. **Notification History**
   - Keep center sidebar
   - Show past 10 notifications

4. **Custom Themes**
   - Dark mode support
   - Custom color schemes

5. **Rich Content**
   - HTML content support
   - Action buttons in notification

6. **Analytics**
   - Track notification interactions
   - User engagement metrics

---

**Version**: 1.0  
**Created**: April 1, 2026  
**Status**: ✅ Production Ready

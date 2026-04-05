# Hướng Dẫn Sử Dụng Training Dataset & Fine-Tuning AI

## 📊 Tổng Quan

Mình đã setup **3-layer AI training** cho MobileStore chatbot:

1. **Layer 1: System Prompt** – Embed trong `chatbot.js`, mỗi request DeepSeek lấy
2. **Layer 2: Training Dataset** – File `CHATBOT_TRAINING_DATASET.json` (structured Q&A)
3. **Layer 3: Live Backend Data** – Dữ liệu thực từ DB (giá, stock, khuyến mãi)

---

## 🎯 Cách Sử Dụng từng Layer

### Layer 1: System Prompt (Chatbot.js)

**File**: `src/main/webapp/assets/js/chatbot.js` → `buildAiMessages()` function

**Mục đích**: Định hướng AI cách xử lý mỗi intent

**Cách update**:
```javascript
const systemPrompt = [
    '=== MOBILESTORE CHATBOT TRAINING ===',
    // ... thêm rules/examples mới ở đây
].join('\n');
```

**Khi nào update**: Khi cần thêm intent mới hoặc thay đổi tone

---

### Layer 2: Training Dataset (JSON)

**File**: `CHATBOT_TRAINING_DATASET.json`

**Cấu trúc**:
```json
{
  "intents": [
    {
      "id": 1,
      "name": "GREETING",
      "keywords": ["xin chào", "hi"],
      "examples": [
        {
          "user": "Xin chào",
          "expected": "Xin chào! Mình là MobileStore Bot..."
        }
      ]
    }
  ],
  "master_data": { ... }
}
```

**Cách expand**:

1. **Thêm intent mới**:
```json
{
  "id": 10,
  "name": "WARRANTY_EXTENSION",
  "keywords": ["bảo hành thêm", "mở rộng bảo hành"],
  "examples": [
    {
      "user": "Bảo hành mở rộng giá bao nhiêu?",
      "expected": "Bảo hành mở rộng sang năm thứ 2: 2,990,000 VND (all models). Bạn muốn thêm không?"
    }
  ]
}
```

2. **Thêm example cho intent hiện tại**:
```json
"examples": [
  { ... },
  {
    "user": "Chào",
    "expected": "Chào bạn! Có gì mình giúp được?"
  }
]
```

3. **Update master_data** (giá, khuyến mãi):
```json
"products": [
  {
    "id": 4,
    "name": "Xiaomi 14 Ultra",
    "price": 21990000,
    ...
  }
]
```

**Khi nào update**: Hàng tuần (giá, stock), hoặc khi thêm intent/khuyến mãi mới

---

## 🤖 Cách Fine-Tune với External AI Models

### Cách 1: Fine-Tune DeepSeek API (OpenAI Format)

**Điều kiện**: Có DeepSeek API key + budget tokens for fine-tuning

**Bước**:

1. **Chuẩn bị training data** từ `CHATBOT_TRAINING_DATASET.json`:
```bash
# Convert JSON → JSONL format cho fine-tuning
# Mỗi line = 1 training example
{"messages": [{"role": "system", "content": "..."}, {"role": "user", "content": "Xin chào"}, {"role": "assistant", "content": "Xin chào! Mình là..."}]}
```

2. **Upload & Fine-tune via DeepSeek CLI**:
```bash
# Using OpenAI CLI compatible tool
openai api fine_tunes.create \
  -t training_data.jsonl \
  -m deepseek-reasoner \
  --learning_rate 0.1
```

3. **Sử dụng model fine-tuned**:
```javascript
// Trong buildAiMessages()
const model = "ft:deepseek-reasoner:2026-04-06:xxxxx"; // your fine-tuned model
```

---

### Cách 2: Use LLaMA-2 Locally (Free Alternative)

Nếu muốn fine-tune **offline** (không phụ thuộc API):

1. **Setup LLaMA-2 + Ollama**:
```bash
curl -fsSL https://ollama.ai/install.sh | sh
ollama pull llama2
```

2. **Fine-tune data**:
```python
from peft import LoraConfig, get_peft_model
from transformers import AutoModelForCausalLM, AutoTokenizer

model_name = "meta-llama/Llama-2-7b-hf"
model = AutoModelForCausalLM.from_pretrained(model_name)

# Load training data từ CHATBOT_TRAINING_DATASET.json
# Fine-tune model...
```

3. **Host locally hoặc deploy**:
```bash
ollama create mobilestore-bot -f Modelfile
ollama serve
```

---

### Cách 3: Use OpenAI GPT-4 Fine-Tuning

1. **Convert training data**:
```python
import json

# Load from CHATBOT_TRAINING_DATASET.json
with open('CHATBOT_TRAINING_DATASET.json') as f:
    data = json.load(f)

# Convert to OpenAI format
training_data = []
for intent in data['intents']:
    for example in intent['examples']:
        training_data.append({
            "messages": [
                {"role": "system", "content": "Bạn là trợ lý bán hàng MobileStore..."},
                {"role": "user", "content": example['user']},
                {"role": "assistant", "content": example['expected']}
            ]
        })

# Save
with open('training_gpt4.jsonl', 'w') as f:
    for item in training_data:
        f.write(json.dumps(item) + '\n')
```

2. **Upload & Fine-tune**:
```bash
openai api fine_tunes.create -t training_gpt4.jsonl -m gpt-4
```

3. **Use in chatbot**:
```javascript
// Update in buildAiMessages()
const model = "ft:gpt-4-turbo-2024-04-09:personal:mobilestore:xxxxx";
```

---

## 📈 Mô Hình 3-Layer Training

```
┌─────────────────────────────────────────────────────┐
│  USER QUESTION                                      │
│  "iPhone 15 giá bao nhiêu?"                        │
└────────────────────┬────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
   ┌────▼─────────┐    ┌────────▼─────────┐
   │ Layer 1:      │    │ Layer 2:         │
   │ System Prompt │    │ Training Dataset │
   │ (Chatbot.js)  │    │ (JSON)           │
   │               │    │                  │
   │ • Intent      │    │ • Intents        │
   │   rules       │    │ • Q&A examples   │
   │ • Tone guides │    │ • Keywords       │
   │ • Examples    │    │ • Master data    │
   └────┬──────────┘    └────────┬─────────┘
        │                        │
        └────────────┬───────────┘
                     │
            ┌────────▼──────────┐
            │  DeepSeek API     │
            │  (+ Live Backend  │
            │   Layer 3)        │
            └────────┬──────────┘
                     │
        ┌────────────▼────────────┐
        │   AI Response           │
        │  "iPhone 15 Pro Max     │
        │   hiện giá 35,990,000   │
        │   VND (giảm 1M)..."     │
        └────────────────────────┘
```

---

## 🔄 Quy Trình Update Training

### Hàng Tuần
1. Kiểm tra `CHATBOT_TRAINING_DATASET.json` → Update giá/stock từ backend
2. Xem chat logs → Thêm Q&A mới nếu có user hỏi gì lạ

### Hàng Tháng
1. Phân tích user intents → Có intent mới không?
2. Update `buildAiMessages()` system prompt nếu cần thêm rule
3. A/B test 2 versions của prompt, so sánh accuracy

### Hàng Quý
1. Fine-tune model (nếu dùng external model) bằng all data tích lũy
2. Review tone guidelines → Có cần điều chỉnh?
3. Measure metrics: BLEU score, user satisfaction, error rate

---

## 📊 Metrics Theo Dõi

```
┌─────────────────────────────────────────────────┐
│  METRICS TO TRACK                               │
├─────────────────────────────────────────────────┤
│ 1. Accuracy Rate                                │
│    - % câu trả lời chính xác (theo rating)   │
│    - Target: > 85%                             │
│                                                 │
│ 2. Intent Recognition Rate                     │
│    - % user query match đúng intent           │
│    - Target: > 90%                             │
│                                                 │
│ 3. Fallback Rate                               │
│    - % request fallback sang backend           │
│    - Target: < 15% (nên < 10%)                 │
│                                                 │
│ 4. Response Time                               │
│    - Avg latency (DeepSeek API call)          │
│    - Target: < 3 seconds                       │
│                                                 │
│ 5. User Satisfaction (CSAT)                    │
│    - Avg rating từ "Helpful?" button           │
│    - Target: > 4.5/5                           │
└─────────────────────────────────────────────────┘
```

---

## 🚀 Best Practices

### Do ✅
- **Regular rotation**: Luôn thêm new examples từ real user conversations
- **Version control**: Dùng git để track changes trong `CHATBOT_TRAINING_DATASET.json`
- **A/B testing**: Test 2 system prompts, so sánh output trước rollout
- **Error log review**: Weekly check ~stderr logs để catch bad responses
- **Master data sync**: Đảm bảo giá, stock trong JSON = DB (run sync job daily)

### Don't ❌
- **Hardcode data**: Không hard-code giá trong system prompt (dùng `serializeBackendData()`)
- **Over-training**: Từ 20-50 examples per intent là đủ (quá nhiều → overfitting)
- **Role confusion**: Luôn mark "user" vs "assistant" role in examples, không trộn lẫn
- **Stale data**: Không để training data cũ hơn 2 tuần, nếu có price change

---

## 📝 Template Thêm Intent Mới

Khi muốn thêm intent mới (VD: "Hỏi về phụ kiện"):

1. **Update `CHATBOT_TRAINING_DATASET.json`**:
```json
{
  "id": 11,
  "name": "ACCESSORIES",
  "keywords": ["phụ kiện", "case", "charger", "tai nghe"],
  "examples": [
    {
      "user": "Bạn có tai nghe nào không?",
      "expected": "Có! Chúng tôi bán:\n1. AirPods Pro - 5M\n2. Sony WH-1000XM5 - 8M\n3. Samsung Galaxy Buds 2 - 2M"
    }
  ]
}
```

2. **Update `chatbot.js` system prompt**:
```javascript
'11. ACCESSORIES: "Bạn có tai nghe?", "Mua case ở đâu?" → Liệt kê phụ kiện, giá, gợi ý theo model phone'
```

3. **Test locally** → Rebuild → Deploy

---

## 📞 Support & Questions

Nếu có vấn đề:
- **Training accuracy thấp?** → Review examples trong JSON, add more edge cases
- **DeepSeek API timeout?** → Reduce prompt size hoặc upgrade API tier
- **Users complain response không relevant?** → Check `serializeBackendData()`, ensure backend data quality

---

**Last Updated**: 06/04/2026  
**Owner**: MobileStore Dev Team

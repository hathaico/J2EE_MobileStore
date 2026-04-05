import { useMemo, useState } from "react";
import { ComparisonPanel } from "./components/ComparisonPanel";
import { Composer } from "./components/Composer";
import { MessageBubble } from "./components/MessageBubble";
import { ProductCard } from "./components/ProductCard";
import { QuickActions } from "./components/QuickActions";
import { runAgent } from "./lib/agent";
import { loadContext, loadPreferences, saveContext, savePreferences } from "./lib/memory";
import { streamText } from "./lib/api";
import type { ChatMessage, ProductCardModel, UserPreferences } from "./types/chat";

function nowTime(): string {
  const now = new Date();
  return `${String(now.getHours()).padStart(2, "0")}:${String(now.getMinutes()).padStart(2, "0")}`;
}

function uid(): string {
  return Math.random().toString(36).slice(2, 10);
}

export default function App() {
  const [messages, setMessages] = useState<ChatMessage[]>([
    {
      id: uid(),
      role: "assistant",
      text: "Welcome. I am MobileStore Bot. Ask me to find, compare, and recommend products.",
      time: nowTime(),
      state: "success"
    }
  ]);
  const [products, setProducts] = useState<ProductCardModel[]>([]);
  const [comparison, setComparison] = useState<ProductCardModel[]>([]);
  const [isBusy, setIsBusy] = useState(false);
  const [error, setError] = useState<string>("");

  const context = useMemo(() => loadContext(), []);
  const [prefs, setPrefs] = useState<UserPreferences>(() => loadPreferences());

  const send = async (text: string) => {
    setError("");
    setIsBusy(true);

    const userMessage: ChatMessage = {
      id: uid(),
      role: "user",
      text,
      time: nowTime(),
      state: "success"
    };
    setMessages((prev) => [...prev, userMessage]);

    const streamId = uid();
    setMessages((prev) => [
      ...prev,
      {
        id: streamId,
        role: "assistant",
        text: "Planning...",
        time: nowTime(),
        state: "loading"
      }
    ]);

    try {
      const result = await runAgent(text, prefs, context);

      if (/samsung|apple|xiaomi|oppo/i.test(text)) {
        const favoriteBrand = (text.match(/samsung|apple|xiaomi|oppo/i)?.[0] || "").toUpperCase();
        const nextPrefs = { ...prefs, favoriteBrand };
        setPrefs(nextPrefs);
        savePreferences(nextPrefs);
      }

      saveContext(result.updatedContext);
      setProducts(result.products);
      setComparison(result.comparison);

      for await (const chunk of streamText(result.answer)) {
        setMessages((prev) =>
          prev.map((m) => (m.id === streamId ? { ...m, text: chunk, state: "loading" } : m))
        );
      }

      setMessages((prev) =>
        prev.map((m) => (m.id === streamId ? { ...m, state: "success", time: nowTime() } : m))
      );
    } catch (e) {
      setError("Action failed. Please retry.");
      setMessages((prev) =>
        prev.map((m) =>
          m.id === streamId
            ? { ...m, text: "Error: could not complete this action.", state: "error", time: nowTime() }
            : m
        )
      );
    } finally {
      setIsBusy(false);
    }
  };

  const inlineMode = comparison.length < 2;

  return (
    <main className="bot-shell">
      <header className="top">
        <div>
          <h1>MobileStore Bot</h1>
          <p>Generative UI + Agentic Pattern + Streaming</p>
        </div>
        <div className="state-box">
          <span className={`dot ${isBusy ? "loading" : "success"}`} />
          {isBusy ? "Processing" : "Ready"}
        </div>
      </header>

      {error && <div className="error-banner">{error}</div>}

      <section className={`layout ${inlineMode ? "inline-mode" : "compare-mode"}`}>
        <div className="panel chat-panel">
          <div className="messages">
            {messages.map((msg) => (
              <MessageBubble key={msg.id} message={msg} />
            ))}
          </div>

          <QuickActions onAction={send} />
          <Composer onSubmit={send} disabled={isBusy} />
        </div>

        <div className="panel content-panel">
          {!inlineMode && <ComparisonPanel products={comparison} />}

          <div className="cards-head">
            <h3>{inlineMode ? "Inline product cards" : "Candidate products"}</h3>
            <small>Tool-use data from product API</small>
          </div>

          <div className="cards-grid">
            {products.map((p) => (
              <ProductCard
                key={p.id}
                product={p}
                onViewDetail={(id) => send(`xem chi tiet san pham ${id}`)}
                onCompare={(id) => send(`so sanh san pham ${id}`)}
              />
            ))}
          </div>
        </div>
      </section>

      <footer className="flow-note">
        UX flow: Welcome -&gt; Quick suggestions -&gt; Intent -&gt; Component rendering -&gt; Follow-up or End.
      </footer>
    </main>
  );
}

import type { Product } from "../types/chat";

function apiBase(): string {
  const path = window.location.pathname.includes("/MobileStore") ? "/MobileStore" : "";
  return `${window.location.protocol}//${window.location.host}${path}`;
}

export async function fetchProducts(keyword: string): Promise<Product[]> {
  const q = keyword.trim().toLowerCase();
  const base = apiBase();

  try {
    const response = await fetch(`${base}/api/products`, {
      headers: { Accept: "application/json" }
    });

    if (!response.ok) {
      throw new Error(`Product API HTTP ${response.status}`);
    }

    const data = (await response.json()) as { status: string; data: Product[] };
    const all = Array.isArray(data.data) ? data.data : [];

    if (!q) return all.slice(0, 6);

    return all
      .filter((p) => {
        const name = (p.productName || "").toLowerCase();
        const brand = (p.brand || "").toLowerCase();
        const desc = (p.description || "").toLowerCase();
        return name.includes(q) || brand.includes(q) || desc.includes(q);
      })
      .slice(0, 6);
  } catch {
    return [];
  }
}

export async function askChatbot(message: string): Promise<string> {
  const base = apiBase();
  const response = await fetch(`${base}/api/chatbot/message`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json"
    },
    body: JSON.stringify({ userMessage: message, userId: "react-ui" })
  });

  if (!response.ok) {
    throw new Error(`Chatbot API HTTP ${response.status}`);
  }

  const data = (await response.json()) as { message?: string };
  return data.message || "I can help you with product search, comparison and recommendation.";
}

export async function* streamText(text: string): AsyncGenerator<string, void, unknown> {
  const tokens = text.split(" ");
  let acc = "";
  for (const token of tokens) {
    acc = acc ? `${acc} ${token}` : token;
    await new Promise((resolve) => setTimeout(resolve, 30));
    yield acc;
  }
}

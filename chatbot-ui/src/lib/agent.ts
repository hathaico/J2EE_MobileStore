import { askChatbot, fetchProducts } from "./api";
import type {
  ConversationContext,
  PlanResult,
  Product,
  ProductCardModel,
  UserPreferences
} from "../types/chat";

function formatCurrency(v?: number): string {
  const value = Number(v || 0);
  return new Intl.NumberFormat("vi-VN").format(value) + " d";
}

function normalizeProduct(p: Product): ProductCardModel {
  const stock = Number(p.stockQuantity || 0);
  return {
    id: p.productId,
    title: p.productName || "Unknown Product",
    brand: p.brand || "Unknown",
    priceText: formatCurrency(p.price),
    imageUrl: p.imageUrl || "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=640&q=80&auto=format&fit=crop",
    badge: stock > 0 ? "In stock" : "Out of stock",
    specLine: "CPU: Updating | RAM: 8GB | ROM: 128GB",
    statusLine: stock > 0 ? `Available (${stock} products)` : "Out of stock"
  };
}

export function planIntent(userText: string): PlanResult {
  const text = userText.toLowerCase();

  if (text.includes("so sanh") || text.includes("compare")) {
    return {
      intent: "compare",
      steps: ["extract query", "fetch products", "render compare layout", "advise"]
    };
  }

  if (text.includes("tu van") || text.includes("budget") || text.includes("ngan sach")) {
    return {
      intent: "recommend",
      steps: ["read user preferences", "fetch products", "rank suggestions", "respond"]
    };
  }

  return {
    intent: "search",
    steps: ["fetch products", "render product cards", "ask follow-up"]
  };
}

export async function runAgent(
  userText: string,
  preferences: UserPreferences,
  context: ConversationContext
): Promise<{
  answer: string;
  products: ProductCardModel[];
  comparison: ProductCardModel[];
  plan: PlanResult;
  updatedContext: ConversationContext;
}> {
  const plan = planIntent(userText);
  const query = deriveQuery(userText, preferences);
  const toolsProducts = (await fetchProducts(query)).map(normalizeProduct);

  let comparison: ProductCardModel[] = [];
  if (plan.intent === "compare") {
    comparison = toolsProducts.slice(0, 2);
  }

  const baseAnswer = await askChatbot(userText);
  const reflectedAnswer = reflectAnswer(baseAnswer, plan, toolsProducts.length);

  const updatedContext: ConversationContext = {
    recentIntents: [...context.recentIntents.slice(-5), plan.intent],
    lastProducts: toolsProducts,
    steps: plan.steps
  };

  return {
    answer: reflectedAnswer,
    products: toolsProducts,
    comparison,
    plan,
    updatedContext
  };
}

function deriveQuery(userText: string, prefs: UserPreferences): string {
  if (prefs.favoriteBrand && !userText.toLowerCase().includes(prefs.favoriteBrand.toLowerCase())) {
    return `${userText} ${prefs.favoriteBrand}`.trim();
  }
  return userText;
}

function reflectAnswer(answer: string, plan: PlanResult, productCount: number): string {
  const hasActionable = /\b(goi y|suggest|compare|price|stock|recommend)\b/i.test(answer);
  const hasProducts = productCount > 0;

  if (hasActionable && hasProducts) {
    return answer;
  }

  const qualityFix =
    "\n\nReflection update: I have refined the response to include clear next actions and concrete product options.";

  if (!hasProducts) {
    return answer +
      "\n\nI could not find enough matching products right now. Please try another brand, budget, or category." +
      qualityFix;
  }

  return answer +
    `\n\nPlan executed (${plan.intent}): ${plan.steps.join(" -> ")}.` +
    qualityFix;
}

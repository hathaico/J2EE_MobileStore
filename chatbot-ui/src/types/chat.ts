export type Role = "user" | "assistant" | "system";

export type ActionState = "idle" | "loading" | "success" | "error";

export interface Product {
  productId: number;
  productName: string;
  brand?: string;
  price?: number;
  stockQuantity?: number;
  imageUrl?: string;
  description?: string;
}

export interface ProductCardModel {
  id: number;
  title: string;
  brand: string;
  priceText: string;
  imageUrl: string;
  badge: string;
  specLine: string;
  statusLine: string;
}

export interface ChatMessage {
  id: string;
  role: Role;
  text: string;
  time: string;
  state?: ActionState;
  products?: ProductCardModel[];
  suggestions?: string[];
  comparison?: ProductCardModel[];
}

export interface UserPreferences {
  favoriteBrand?: string;
  budget?: number;
  prefersGaming?: boolean;
}

export interface ConversationContext {
  recentIntents: string[];
  lastProducts: ProductCardModel[];
  steps: string[];
}

export interface PlanResult {
  intent: string;
  steps: string[];
}

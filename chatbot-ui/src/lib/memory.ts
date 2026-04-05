import type { ConversationContext, UserPreferences } from "../types/chat";

const PREF_KEY = "mobilestore-bot-preferences";
const CTX_KEY = "mobilestore-bot-context";

const emptyContext: ConversationContext = {
  recentIntents: [],
  lastProducts: [],
  steps: []
};

export function loadPreferences(): UserPreferences {
  try {
    const raw = localStorage.getItem(PREF_KEY);
    if (!raw) return {};
    return JSON.parse(raw) as UserPreferences;
  } catch {
    return {};
  }
}

export function savePreferences(prefs: UserPreferences): void {
  localStorage.setItem(PREF_KEY, JSON.stringify(prefs));
}

export function loadContext(): ConversationContext {
  try {
    const raw = sessionStorage.getItem(CTX_KEY);
    if (!raw) return emptyContext;
    return JSON.parse(raw) as ConversationContext;
  } catch {
    return emptyContext;
  }
}

export function saveContext(context: ConversationContext): void {
  sessionStorage.setItem(CTX_KEY, JSON.stringify(context));
}

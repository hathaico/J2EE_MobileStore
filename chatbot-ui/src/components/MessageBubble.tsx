import type { ChatMessage } from "../types/chat";

type Props = {
  message: ChatMessage;
};

export function MessageBubble({ message }: Props) {
  return (
    <div className={`message ${message.role === "user" ? "right" : "left"}`}>
      <div className={`bubble state-${message.state || "idle"}`}>
        {message.text}
      </div>
      <span className="time">{message.time}</span>
    </div>
  );
}

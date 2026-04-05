import { useState } from "react";

type Props = {
  onSubmit: (text: string) => void;
  disabled?: boolean;
};

export function Composer({ onSubmit, disabled }: Props) {
  const [value, setValue] = useState("");

  return (
    <form
      className="composer"
      onSubmit={(e) => {
        e.preventDefault();
        const text = value.trim();
        if (!text || disabled) return;
        onSubmit(text);
        setValue("");
      }}
    >
      <input
        value={value}
        onChange={(e) => setValue(e.target.value)}
        placeholder="Nhap tin nhan cua ban..."
        disabled={disabled}
      />
      <button type="submit" disabled={disabled || !value.trim()}>
        Gui
      </button>
    </form>
  );
}

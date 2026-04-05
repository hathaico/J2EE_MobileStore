type Props = {
  onAction: (text: string) => void;
};

const quickActions = [
  "Tu van theo ngan sach",
  "So sanh san pham",
  "Xem khuyen mai"
];

export function QuickActions({ onAction }: Props) {
  return (
    <div className="quick-actions">
      {quickActions.map((item) => (
        <button key={item} type="button" onClick={() => onAction(item)}>
          {item}
        </button>
      ))}
    </div>
  );
}

import type { ProductCardModel } from "../types/chat";

type Props = {
  products: ProductCardModel[];
};

export function ComparisonPanel({ products }: Props) {
  if (products.length < 2) return null;

  return (
    <section className="compare-panel">
      <h3>Side-by-side compare</h3>
      <div className="compare-grid">
        {products.map((p) => (
          <div key={p.id} className="compare-item">
            <h4>{p.title}</h4>
            <p>{p.priceText}</p>
            <p>{p.specLine}</p>
            <p>{p.statusLine}</p>
          </div>
        ))}
      </div>
    </section>
  );
}

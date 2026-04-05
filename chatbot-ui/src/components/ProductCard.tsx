import type { ProductCardModel } from "../types/chat";

type Props = {
  product: ProductCardModel;
  onViewDetail: (id: number) => void;
  onCompare: (id: number) => void;
};

export function ProductCard({ product, onViewDetail, onCompare }: Props) {
  return (
    <article className="product-card">
      <img src={product.imageUrl} alt={product.title} className="product-image" />
      <div className="product-body">
        <div className="product-top">
          <span className={`badge ${product.badge === "In stock" ? "badge-ok" : "badge-off"}`}>
            {product.badge}
          </span>
          <span className="brand">{product.brand}</span>
        </div>

        <h4>{product.title}</h4>
        <p className="price">{product.priceText}</p>
        <p className="spec">{product.specLine}</p>
        <p className="status">{product.statusLine}</p>

        <div className="card-actions">
          <button onClick={() => onViewDetail(product.id)} type="button">
            Xem chi tiet
          </button>
          <button className="ghost" onClick={() => onCompare(product.id)} type="button">
            So sanh
          </button>
        </div>
      </div>
    </article>
  );
}

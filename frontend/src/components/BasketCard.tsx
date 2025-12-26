import { Link } from 'react-router-dom';

export interface BasketSummary {
  id: string;
  name: string;
  description: string;
  cagr: number;
  maxDrawdown: number;
  volatility: number;
  tags: string[];
}

interface BasketCardProps {
  basket: BasketSummary;
}

export function BasketCard({ basket }: BasketCardProps) {
  return (
    <article className="card-glass group flex flex-col justify-between p-5 transition-transform duration-200 hover:-translate-y-0.5">
      <div>
        <div className="mb-3 flex items-center justify-between gap-2">
          <h3 className="text-base font-semibold tracking-tight text-slate-50">
            {basket.name}
          </h3>
          <span className="rounded-full bg-emerald-500/10 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.16em] text-emerald-300">
            Quant Basket
          </span>
        </div>
        <p className="mb-4 text-xs leading-relaxed text-slate-300">{basket.description}</p>

        <dl className="mb-4 grid grid-cols-3 gap-3 text-xs">
          <div className="rounded-xl bg-slate-900/80 p-3">
            <dt className="text-[10px] uppercase tracking-[0.16em] text-slate-400">
              5Y CAGR
            </dt>
            <dd className="mt-1 text-sm font-semibold text-emerald-400">
              {basket.cagr.toFixed(1)}%
            </dd>
          </div>
          <div className="rounded-xl bg-slate-900/80 p-3">
            <dt className="text-[10px] uppercase tracking-[0.16em] text-slate-400">
              Max Drawdown
            </dt>
            <dd className="mt-1 text-sm font-semibold text-rose-400">
              {basket.maxDrawdown.toFixed(1)}%
            </dd>
          </div>
          <div className="rounded-xl bg-slate-900/80 p-3">
            <dt className="text-[10px] uppercase tracking-[0.16em] text-slate-400">
              Volatility
            </dt>
            <dd className="mt-1 text-sm font-semibold text-sky-400">
              {basket.volatility.toFixed(1)}%
            </dd>
          </div>
        </dl>

        <div className="flex flex-wrap gap-1.5">
          {basket.tags.map((tag) => (
            <span
              key={tag}
              className="rounded-full bg-slate-900/80 px-2.5 py-1 text-[10px] font-medium uppercase tracking-[0.16em] text-slate-300"
            >
              {tag}
            </span>
          ))}
        </div>
      </div>

      <div className="mt-5 flex items-center justify-between border-t border-slate-800/80 pt-3">
        <button className="button-primary h-9 px-4 text-xs">
          Add to Basket
        </button>
        <Link
          to={`/baskets/${basket.id}`}
          className="button-ghost h-9 px-4 text-[11px] uppercase tracking-[0.16em]"
        >
          View Details
        </Link>
      </div>
    </article>
  );
}

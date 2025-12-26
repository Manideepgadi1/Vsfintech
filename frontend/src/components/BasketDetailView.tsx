import type { BasketSummary } from './BasketCard';

interface BasketDetailViewProps {
  basket: BasketSummary;
}

export function BasketDetailView({ basket }: BasketDetailViewProps) {
  return (
    <section className="grid gap-6 lg:grid-cols-[minmax(0,2fr)_minmax(0,1.2fr)]">
      <div className="card-glass p-6">
        <div className="mb-4 flex items-start justify-between gap-3">
          <div>
            <h1 className="text-xl font-semibold tracking-tight text-slate-50">
              {basket.name}
            </h1>
            <p className="mt-2 text-sm leading-relaxed text-slate-300">
              {basket.description}
            </p>
          </div>
          <span className="rounded-full bg-primary-600/10 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.16em] text-primary-300">
            Live Strategy
          </span>
        </div>

        <div className="mb-5 grid gap-4 sm:grid-cols-3">
          <div className="rounded-2xl bg-slate-900/80 p-4">
            <p className="text-[10px] uppercase tracking-[0.18em] text-slate-400">
              5Y CAGR
            </p>
            <p className="mt-2 text-xl font-semibold text-emerald-400">
              {basket.cagr.toFixed(1)}%
            </p>
            <p className="mt-1 text-[11px] text-slate-400">Net of costs, pre-tax</p>
          </div>
          <div className="rounded-2xl bg-slate-900/80 p-4">
            <p className="text-[10px] uppercase tracking-[0.18em] text-slate-400">
              Max Drawdown
            </p>
            <p className="mt-2 text-xl font-semibold text-rose-400">
              {basket.maxDrawdown.toFixed(1)}%
            </p>
            <p className="mt-1 text-[11px] text-slate-400">Historical worst-case peak-to-trough</p>
          </div>
          <div className="rounded-2xl bg-slate-900/80 p-4">
            <p className="text-[10px] uppercase tracking-[0.18em] text-slate-400">
              Volatility
            </p>
            <p className="mt-2 text-xl font-semibold text-sky-400">
              {basket.volatility.toFixed(1)}%
            </p>
            <p className="mt-1 text-[11px] text-slate-400">Annualised standard deviation</p>
          </div>
        </div>

        <div className="rounded-2xl border border-slate-800/80 bg-slate-950/40 p-4 text-xs text-slate-300">
          <h2 className="mb-2 text-[11px] font-semibold uppercase tracking-[0.18em] text-slate-400">
            Strategy Overview
          </h2>
          <p className="leading-relaxed">
            This basket is systematically constructed using factor screens, liquidity filters, and
            robust risk controls on the underlying index constituents. Allocations are refreshed
            on a rule-based schedule with tight execution windows and slippage-aware sizing.
          </p>
        </div>
      </div>

      <aside className="card-glass flex flex-col gap-4 p-6">
        <div>
          <h3 className="text-sm font-semibold tracking-tight text-slate-50">
            Allocate to Basket
          </h3>
          <p className="mt-2 text-xs text-slate-300">
            Configure your deployment size and review a summary before confirming.
          </p>
        </div>
        <form className="space-y-4">
          <div className="space-y-1.5 text-xs">
            <label className="block text-[11px] font-medium uppercase tracking-[0.16em] text-slate-400">
              Investment Amount
            </label>
            <div className="flex items-center gap-2 rounded-2xl bg-slate-900/80 px-3 py-2.5">
              <span className="text-[11px] font-semibold text-slate-400">₹</span>
              <input
                type="number"
                defaultValue={250000}
                className="h-7 w-full bg-transparent text-sm text-slate-50 outline-none placeholder:text-slate-500"
              />
            </div>
          </div>

          <div className="space-y-1.5 text-xs">
            <label className="block text-[11px] font-medium uppercase tracking-[0.16em] text-slate-400">
              Time Horizon
            </label>
            <select className="h-9 w-full rounded-2xl border border-slate-800 bg-slate-950/60 px-3 text-xs text-slate-100 outline-none">
              <option>3+ years</option>
              <option>5+ years</option>
              <option>7+ years</option>
            </select>
          </div>

          <div className="rounded-2xl border border-slate-800/90 bg-slate-950/70 p-3 text-[11px] text-slate-300">
            <div className="flex items-center justify-between">
              <span>Projected 5Y value</span>
              <span className="font-semibold text-emerald-400">₹ 4.1L</span>
            </div>
            <div className="mt-1 flex items-center justify-between">
              <span>Expected max drawdown</span>
              <span className="font-semibold text-rose-400">-18.4%</span>
            </div>
          </div>

          <button type="button" className="button-primary w-full text-xs">
            Add to Checkout
          </button>
        </form>
      </aside>
    </section>
  );
}

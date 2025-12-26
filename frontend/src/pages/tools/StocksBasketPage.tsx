import type { FC } from 'react';

export const StocksBasketPage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">EQUITY BASKETS</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Thematic &amp; Factor-Based Stock Baskets
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          Research-driven equity baskets targeting specific themes, sectors, or factor exposures
          with regular rebalancing.
        </p>
      </section>

      <div className="card-glass p-8 text-center">
        <h2 className="text-lg font-semibold text-slate-900 dark:text-slate-50">
          Curated Stock Portfolios
        </h2>
        <p className="mt-2 text-sm text-slate-600 dark:text-slate-300">
          Thematic and factor baskets
        </p>
      </div>
    </div>
  );
};

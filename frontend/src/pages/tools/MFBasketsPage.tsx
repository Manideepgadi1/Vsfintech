import type { FC } from 'react';

export const MFBasketsPage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">FUND BASKETS</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Curated Mutual Fund Baskets
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          Pre-built portfolios of mutual funds designed for specific goals, risk profiles, and
          investment horizons.
        </p>
      </section>

      <div className="card-glass p-8 text-center">
        <h2 className="text-lg font-semibold text-slate-900 dark:text-slate-50">
          Ready-Made MF Portfolios
        </h2>
        <p className="mt-2 text-sm text-slate-600 dark:text-slate-300">
          Goal-based mutual fund combinations
        </p>
      </div>
    </div>
  );
};

import type { FC } from 'react';

export const MFStocksPage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">MF & STOCKS</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Mutual Funds &amp; Direct Equity Integration
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          Combine mutual funds and direct stock positions in a unified portfolio view with
          overlap analysis and rebalancing recommendations.
        </p>
      </section>

      <div className="card-glass p-8 text-center">
        <h2 className="text-lg font-semibold text-slate-900 dark:text-slate-50">
          Integrated Portfolio Analysis
        </h2>
        <p className="mt-2 text-sm text-slate-600 dark:text-slate-300">
          MF + Stocks consolidated view
        </p>
      </div>
    </div>
  );
};

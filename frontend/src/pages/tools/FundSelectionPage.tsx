import type { FC } from 'react';

export const FundSelectionPage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">FUND SELECTION</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Smart Fund Selection Framework
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          Our proprietary framework for selecting top-tier mutual funds based on consistency,
          risk management, and long-term performance.
        </p>
      </section>

      <div className="grid gap-6 lg:grid-cols-3">
        <div className="card-glass p-6">
          <h3 className="text-sm font-semibold text-slate-900 dark:text-slate-50">
            Performance Consistency
          </h3>
          <p className="mt-2 text-xs text-slate-600 dark:text-slate-300">
            Funds evaluated across multiple time horizons for stable, repeatable results.
          </p>
        </div>
        <div className="card-glass p-6">
          <h3 className="text-sm font-semibold text-slate-900 dark:text-slate-50">
            Risk-Adjusted Returns
          </h3>
          <p className="mt-2 text-xs text-slate-600 dark:text-slate-300">
            Sharpe ratio, Sortino ratio, and downside capture analysis.
          </p>
        </div>
        <div className="card-glass p-6">
          <h3 className="text-sm font-semibold text-slate-900 dark:text-slate-50">
            Expense &amp; Portfolio Quality
          </h3>
          <p className="mt-2 text-xs text-slate-600 dark:text-slate-300">
            Low-cost funds with concentrated, conviction-based holdings.
          </p>
        </div>
      </div>
    </div>
  );
};

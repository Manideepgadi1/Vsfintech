import type { FC } from 'react';

export const NasdaqPage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">NASDAQ</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          NASDAQ Index &amp; US Market Analysis
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          Track NASDAQ-100 constituents, sector rotation, and global tech trends impacting
          Indian tech stocks.
        </p>
      </section>

      <div className="card-glass p-8 text-center">
        <h2 className="text-lg font-semibold text-slate-900 dark:text-slate-50">
          Global Market Insights
        </h2>
        <p className="mt-2 text-sm text-slate-600 dark:text-slate-300">
          NASDAQ tracking and correlation analysis
        </p>
      </div>
    </div>
  );
};

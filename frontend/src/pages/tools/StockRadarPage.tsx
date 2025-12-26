import type { FC } from 'react';

export const StockRadarPage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">STOCK RADAR</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Real-Time Stock Monitoring &amp; Alerts
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          Track momentum, breakouts, and key technical levels across Indian equities with our
          proprietary stock radar system.
        </p>
      </section>

      <div className="card-glass p-8 text-center">
        <div className="mx-auto mb-4 h-16 w-16 rounded-full bg-primary-500/10 flex items-center justify-center">
          <svg className="h-8 w-8 text-primary-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
          </svg>
        </div>
        <h2 className="text-lg font-semibold text-slate-900 dark:text-slate-50">
          Stock Monitoring Dashboard
        </h2>
        <p className="mt-2 text-sm text-slate-600 dark:text-slate-300">
          Real-time tracking and alerts interface
        </p>
      </div>
    </div>
  );
};

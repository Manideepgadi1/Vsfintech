import type { FC } from 'react';

export const Fundscreener2Page: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">ADVANCED FUND SCREENER</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Advanced Multi-Factor Fund Screening
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          Enhanced version of our fund screener with advanced filters, comparative analysis,
          and portfolio overlap detection.
        </p>
      </section>

      <div className="card-glass p-8 text-center">
        <div className="mx-auto mb-4 h-16 w-16 rounded-full bg-primary-500/10 flex items-center justify-center">
          <svg className="h-8 w-8 text-primary-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
          </svg>
        </div>
        <h2 className="text-lg font-semibold text-slate-900 dark:text-slate-50">
          Coming Soon
        </h2>
        <p className="mt-2 text-sm text-slate-600 dark:text-slate-300">
          Advanced screening interface in development
        </p>
      </div>
    </div>
  );
};

import type { FC } from 'react';

// You can add your calculated Fundoscope items here
const fundoscopeData = [
  // Example structure - replace with your actual data
  // {
  //   fundName: 'Fund Name',
  //   category: 'Equity',
  //   returns: { '1y': 15.5, '3y': 12.3, '5y': 14.2 },
  //   risk: 'Medium',
  //   rating: 5,
  // },
];

export const FundoscopePage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">FUNDOSCOPE</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Advanced Fund Analysis &amp; Research
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          Deep-dive analytics on mutual funds with our proprietary scoring system. Fundoscope
          combines quantitative metrics, risk-adjusted returns, and portfolio concentration
          analysis to help you identify standout funds.
        </p>
      </section>

      {fundoscopeData.length === 0 ? (
        <div className="card-glass p-12 text-center">
          <div className="mx-auto mb-4 h-16 w-16 rounded-full bg-primary-500/10 flex items-center justify-center">
            <svg className="h-8 w-8 text-primary-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
            </svg>
          </div>
          <h2 className="text-lg font-semibold text-slate-900 dark:text-slate-50">
            Ready for Your Data
          </h2>
          <p className="mt-2 text-sm text-slate-600 dark:text-slate-300">
            This page is set up to display your calculated Fundoscope items. Add your data to the
            <code className="mx-1 rounded bg-slate-200 px-1.5 py-0.5 text-xs dark:bg-slate-800">
              fundoscopeData
            </code>
            array in <code className="rounded bg-slate-200 px-1.5 py-0.5 text-xs dark:bg-slate-800">
              FundoscopePage.tsx
            </code>
          </p>
          <div className="mt-6 flex flex-wrap gap-3 justify-center">
            <button className="button-primary px-5 py-2.5 text-xs">
              Import Data
            </button>
            <button className="button-ghost px-5 py-2.5 text-xs">
              View Documentation
            </button>
          </div>
        </div>
      ) : (
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {fundoscopeData.map((fund, idx) => (
            <article key={idx} className="card-glass p-5 animate-fade-in-up" style={{ animationDelay: `${idx * 0.1}s` }}>
              {/* Your fund card content will go here */}
              <pre className="text-xs">{JSON.stringify(fund, null, 2)}</pre>
            </article>
          ))}
        </div>
      )}
    </div>
  );
};

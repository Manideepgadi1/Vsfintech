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

      {/* Analysis Tools Grid */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {/* 1. Right Sector */}
        <a
          href="http://82.25.105.18/right-sector"
          target="_blank"
          rel="noopener noreferrer"
          className="card-glass group relative overflow-hidden p-6 transition-all duration-300 hover:shadow-xl hover:scale-105 hover:border-primary-300"
        >
          <div className="absolute inset-0 bg-gradient-to-br from-primary-500/10 to-transparent opacity-0 transition-opacity duration-300 group-hover:opacity-100" />
          <div className="relative">
            <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-xl bg-primary-500/10 transition-all duration-300 group-hover:scale-110">
              <svg className="h-6 w-6 text-primary-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 className="text-base font-semibold text-slate-900 dark:text-slate-50">Right Sector</h3>
            <p className="mt-2 text-xs text-slate-600 dark:text-slate-300">
              Identify optimal sectors for investment based on market trends and data analytics.
            </p>
          </div>
        </a>

        {/* 2. Right Amount (Bar-Line) */}
        <a
          href="http://82.25.105.18/right-amount"
          target="_blank"
          rel="noopener noreferrer"
          className="card-glass group relative overflow-hidden p-6 transition-all duration-300 hover:shadow-xl hover:scale-105 hover:border-primary-300"
        >
          <div className="absolute inset-0 bg-gradient-to-br from-emerald-500/10 to-transparent opacity-0 transition-opacity duration-300 group-hover:opacity-100" />
          <div className="relative">
            <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-xl bg-emerald-500/10 transition-all duration-300 group-hover:scale-110">
              <svg className="h-6 w-6 text-emerald-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 12l3-3 3 3 4-4M8 21l4-4 4 4M3 4h18M4 4h16v12a1 1 0 01-1 1H5a1 1 0 01-1-1V4z" />
              </svg>
            </div>
            <h3 className="text-base font-semibold text-slate-900 dark:text-slate-50">Right Amount</h3>
            <p className="mt-2 text-xs text-slate-600 dark:text-slate-300">
              Determine optimal investment amounts with bar and line chart visualizations.
            </p>
          </div>
        </a>

        {/* 3. Sector Heatmap */}
        <a
          href="http://82.25.105.18/sector-heatmap"
          target="_blank"
          rel="noopener noreferrer"
          className="card-glass group relative overflow-hidden p-6 transition-all duration-300 hover:shadow-xl hover:scale-105 hover:border-primary-300"
        >
          <div className="absolute inset-0 bg-gradient-to-br from-orange-500/10 to-transparent opacity-0 transition-opacity duration-300 group-hover:opacity-100" />
          <div className="relative">
            <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-xl bg-orange-500/10 transition-all duration-300 group-hover:scale-110">
              <svg className="h-6 w-6 text-orange-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 5a1 1 0 011-1h4a1 1 0 011 1v7a1 1 0 01-1 1H5a1 1 0 01-1-1V5zM14 5a1 1 0 011-1h4a1 1 0 011 1v7a1 1 0 01-1 1h-4a1 1 0 01-1-1V5zM4 16a1 1 0 011-1h4a1 1 0 011 1v3a1 1 0 01-1 1H5a1 1 0 01-1-1v-3zM14 16a1 1 0 011-1h4a1 1 0 011 1v3a1 1 0 01-1 1h-4a1 1 0 01-1-1v-3z" />
              </svg>
            </div>
            <h3 className="text-base font-semibold text-slate-900 dark:text-slate-50">Sector Heatmap</h3>
            <p className="mt-2 text-xs text-slate-600 dark:text-slate-300">
              Visual heatmap analysis of sector performance and correlations.
            </p>
          </div>
        </a>

        {/* 4. Risk Reward */}
        <a
          href="http://82.25.105.18/risk-reward"
          target="_blank"
          rel="noopener noreferrer"
          className="card-glass group relative overflow-hidden p-6 transition-all duration-300 hover:shadow-xl hover:scale-105 hover:border-primary-300"
        >
          <div className="absolute inset-0 bg-gradient-to-br from-red-500/10 to-transparent opacity-0 transition-opacity duration-300 group-hover:opacity-100" />
          <div className="relative">
            <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-xl bg-red-500/10 transition-all duration-300 group-hover:scale-110">
              <svg className="h-6 w-6 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v13m0-13V6a2 2 0 112 2h-2zm0 0V5.5A2.5 2.5 0 109.5 8H12zm-7 4h14M5 12a2 2 0 110-4h14a2 2 0 110 4M5 12v7a2 2 0 002 2h10a2 2 0 002-2v-7" />
              </svg>
            </div>
            <h3 className="text-base font-semibold text-slate-900 dark:text-slate-50">Risk Reward</h3>
            <p className="mt-2 text-xs text-slate-600 dark:text-slate-300">
              Analyze risk-reward ratios to make informed investment decisions.
            </p>
          </div>
        </a>

        {/* 5. Risk Return */}
        <a
          href="http://82.25.105.18/risk-return"
          target="_blank"
          rel="noopener noreferrer"
          className="card-glass group relative overflow-hidden p-6 transition-all duration-300 hover:shadow-xl hover:scale-105 hover:border-primary-300"
        >
          <div className="absolute inset-0 bg-gradient-to-br from-purple-500/10 to-transparent opacity-0 transition-opacity duration-300 group-hover:opacity-100" />
          <div className="relative">
            <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-xl bg-purple-500/10 transition-all duration-300 group-hover:scale-110">
              <svg className="h-6 w-6 text-purple-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
              </svg>
            </div>
            <h3 className="text-base font-semibold text-slate-900 dark:text-slate-50">Risk Return</h3>
            <p className="mt-2 text-xs text-slate-600 dark:text-slate-300">
              Comprehensive risk-return analysis for portfolio optimization.
            </p>
          </div>
        </a>

        {/* 6. Riskometer */}
        <a
          href="http://82.25.105.18/riskometer"
          target="_blank"
          rel="noopener noreferrer"
          className="card-glass group relative overflow-hidden p-6 transition-all duration-300 hover:shadow-xl hover:scale-105 hover:border-primary-300"
        >
          <div className="absolute inset-0 bg-gradient-to-br from-blue-500/10 to-transparent opacity-0 transition-opacity duration-300 group-hover:opacity-100" />
          <div className="relative">
            <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-xl bg-blue-500/10 transition-all duration-300 group-hover:scale-110">
              <svg className="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 className="text-base font-semibold text-slate-900 dark:text-slate-50">Riskometer</h3>
            <p className="mt-2 text-xs text-slate-600 dark:text-slate-300">
              Measure and monitor investment risk levels with precision.
            </p>
          </div>
        </a>

        {/* 7. Multi Chart */}
        <a
          href="http://82.25.105.18/multichart"
          target="_blank"
          rel="noopener noreferrer"
          className="card-glass group relative overflow-hidden p-6 transition-all duration-300 hover:shadow-xl hover:scale-105 hover:border-primary-300"
        >
          <div className="absolute inset-0 bg-gradient-to-br from-indigo-500/10 to-transparent opacity-0 transition-opacity duration-300 group-hover:opacity-100" />
          <div className="relative">
            <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-xl bg-indigo-500/10 transition-all duration-300 group-hover:scale-110">
              <svg className="h-6 w-6 text-indigo-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 12l3-3 3 3 4-4M8 21l4-4 4 4M3 4h18M4 4h16v12a1 1 0 01-1 1H5a1 1 0 01-1-1V4z" />
              </svg>
            </div>
            <h3 className="text-base font-semibold text-slate-900 dark:text-slate-50">Multi Chart</h3>
            <p className="mt-2 text-xs text-slate-600 dark:text-slate-300">
              Compare multiple investments with advanced multi-chart visualizations.
            </p>
          </div>
        </a>
      </div>

      {fundoscopeData.length === 0 ? (
        <div className="card-glass p-8 text-center mt-8">
          <p className="text-sm text-slate-600 dark:text-slate-300">
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

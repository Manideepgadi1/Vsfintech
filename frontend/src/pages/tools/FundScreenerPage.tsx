import type { FC } from 'react';

export const FundScreenerPage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">BASIC FUND SCREENER</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Filter &amp; Discover Mutual Funds
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          Screen thousands of mutual funds using customizable filters including returns, expense
          ratios, AUM, fund manager tenure, and more.
        </p>
      </section>

      <div className="card-glass p-6">
        <div className="grid gap-4 md:grid-cols-3">
          <div>
            <label className="block text-xs font-medium text-slate-700 dark:text-slate-300 mb-2">
              Category
            </label>
            <select className="w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm dark:border-slate-700 dark:bg-slate-900">
              <option>All Categories</option>
              <option>Equity</option>
              <option>Debt</option>
              <option>Hybrid</option>
            </select>
          </div>
          <div>
            <label className="block text-xs font-medium text-slate-700 dark:text-slate-300 mb-2">
              Min 3Y Returns (%)
            </label>
            <input
              type="number"
              placeholder="e.g., 12"
              className="w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm dark:border-slate-700 dark:bg-slate-900"
            />
          </div>
          <div>
            <label className="block text-xs font-medium text-slate-700 dark:text-slate-300 mb-2">
              Max Expense Ratio (%)
            </label>
            <input
              type="number"
              placeholder="e.g., 1.5"
              className="w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm dark:border-slate-700 dark:bg-slate-900"
            />
          </div>
        </div>
        <button className="button-primary mt-4 px-6 py-2.5 text-xs">
          Apply Filters
        </button>
      </div>

      <div className="card-glass p-8 text-center">
        <p className="text-sm text-slate-600 dark:text-slate-300">
          Results will appear here after applying filters
        </p>
      </div>
    </div>
  );
};

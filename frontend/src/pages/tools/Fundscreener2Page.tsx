import type { FC } from 'react';

export const Fundscreener2Page: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">PMS SCREENER</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Portfolio Management Services Screener
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          Advanced screening tool for Portfolio Management Services with comprehensive filters, 
          comparative analysis, and portfolio overlap detection.
        </p>
      </section>

      {/* PMS Screener Tool Card */}
      <div className="card-glass p-6 space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-semibold text-slate-900 dark:text-slate-50">
            Our PMS Screener
          </h2>
          <a
            href="http://82.25.105.18/pms-screener"
            target="_blank"
            rel="noopener noreferrer"
            className="button-primary px-4 py-2 text-xs"
          >
            Open in New Tab
          </a>
        </div>
        <p className="text-sm text-slate-600 dark:text-slate-300">
          Use our advanced PMS screening tool to filter and analyze Portfolio Management Services.
        </p>
        
        {/* Embedded iframe */}
        <div className="relative w-full" style={{ height: '800px' }}>
          <iframe
            src="http://82.25.105.18/pms-screener"
            className="w-full h-full rounded-lg border-2 border-slate-200 dark:border-slate-700"
            title="PMS Screener"
            sandbox="allow-same-origin allow-scripts allow-forms"
          />
        </div>
      </div>
    </div>
  );
};

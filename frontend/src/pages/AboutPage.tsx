import type { FC } from 'react';

export const AboutPage: FC = () => {
  return (
    <div className="space-y-10">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">ABOUT VS FINTECH</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          A collaboration of data analytics and capital markets
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          VS Fintech is a SEBI Registered Research Analyst firm built at the intersection of
          quantitative data science and practical capital‑markets experience. We combine
          institutional‑grade analytics with a warm, advisory‑first approach to help you make
          more informed investment decisions.
        </p>
      </section>

      <section className="grid gap-6 md:grid-cols-2">
        <div className="card-glass p-6">
          <h2 className="text-base font-semibold text-slate-900 dark:text-slate-50">Who we are</h2>
          <p className="mt-2 text-sm leading-relaxed text-slate-600 dark:text-slate-300">
            A focused team of analysts and market practitioners who live and breathe markets,
            committed to transparent research and disciplined, long‑term thinking.
          </p>
        </div>
        <div className="card-glass p-6">
          <h2 className="text-base font-semibold text-slate-900 dark:text-slate-50">What we do</h2>
          <p className="mt-2 text-sm leading-relaxed text-slate-600 dark:text-slate-300">
            We design and track curated equity strategies, including AlphaNifty, thematic and
            sector baskets, and other research‑backed ideas to support your investment journey.
          </p>
        </div>
        <div className="card-glass p-6">
          <h2 className="text-base font-semibold text-slate-900 dark:text-slate-50">Why it matters</h2>
          <p className="mt-2 text-sm leading-relaxed text-slate-600 dark:text-slate-300">
            Markets are noisy. Our goal is to convert that noise into structured intelligence
            so that your decisions are driven by data, not headlines or emotions.
          </p>
        </div>
        <div className="card-glass p-6">
          <h2 className="text-base font-semibold text-slate-900 dark:text-slate-50">Our mission</h2>
          <p className="mt-2 text-sm leading-relaxed text-slate-600 dark:text-slate-300">
            To empower individuals and families to reach their &ldquo;happiness goals&rdquo; using
            research‑driven strategies, risk management, and consistent investor education.
          </p>
        </div>
      </section>

      <section className="grid gap-6 lg:grid-cols-[1.4fr,1fr]">
        <div className="card-glass p-6">
          <h2 className="text-base font-semibold text-slate-900 dark:text-slate-50">
            Data analytics, ML and risk discipline
          </h2>
          <p className="mt-2 text-sm leading-relaxed text-slate-600 dark:text-slate-300">
            Our research stack blends data analytics, machine‑learning signals and
            risk‑management rules. We continuously monitor factor behaviour, index trends and
            market breadth to keep strategies aligned with evolving conditions.
          </p>
          <ul className="mt-4 grid gap-2 text-sm text-slate-600 dark:text-slate-300 sm:grid-cols-2">
            <li className="flex items-start gap-2">
              <span className="mt-1 h-1.5 w-1.5 rounded-full bg-emerald-500" />
              Quantitative screening and rule‑based entries
            </li>
            <li className="flex items-start gap-2">
              <span className="mt-1 h-1.5 w-1.5 rounded-full bg-emerald-500" />
              Continuous tracking of drawdowns and volatility
            </li>
            <li className="flex items-start gap-2">
              <span className="mt-1 h-1.5 w-1.5 rounded-full bg-emerald-500" />
              ML‑assisted pattern and regime detection
            </li>
            <li className="flex items-start gap-2">
              <span className="mt-1 h-1.5 w-1.5 rounded-full bg-emerald-500" />
              Focus on capital protection alongside returns
            </li>
          </ul>
        </div>
        <div className="card-glass flex flex-col justify-between p-6">
          <div>
            <h3 className="text-sm font-semibold text-slate-900 dark:text-slate-50">At a glance</h3>
            <dl className="mt-4 space-y-3 text-sm text-slate-600 dark:text-slate-300">
              <div className="flex items-center justify-between">
                <dt>Experience</dt>
                <dd className="font-medium text-slate-900 dark:text-slate-50">5+ years</dd>
              </div>
              <div className="flex items-center justify-between">
                <dt>Investor journeys touched</dt>
                <dd className="font-medium text-slate-900 dark:text-slate-50">1000s</dd>
              </div>
              <div className="flex items-center justify-between">
                <dt>Focus</dt>
                <dd className="font-medium text-slate-900 dark:text-slate-50">Goal‑based wealth creation</dd>
              </div>
            </dl>
          </div>
          <p className="mt-6 text-xs text-slate-500 dark:text-slate-400">
            VS Fintech is a SEBI Registered Research Analyst. Investments in the securities
            market are subject to market risks. Please read all related documents carefully
            before investing.
          </p>
        </div>
      </section>
    </div>
  );
};

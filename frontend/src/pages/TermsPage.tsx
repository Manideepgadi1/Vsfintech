import type { FC } from 'react';

export const TermsPage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">POLICY</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Terms and conditions
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          Please read this summary carefully to understand the general nature of
          services offered by VS Fintech and the limitations associated with the
          use of this website and related content.
        </p>
      </section>

      <section className="space-y-4 text-sm leading-relaxed text-slate-600 dark:text-slate-300">
        <p>
          VS Fintech operates as a SEBI Registered Research Analyst. Content
          shared on this website, in reports, model portfolios or any
          communication is for informational and educational purposes only and
          should not be treated as personalised investment, tax or legal advice.
        </p>
        <p>
          Markets are subject to risks and past performance is not indicative of
          future results. Investors should carefully evaluate their own
          objectives, financial situation and risk tolerance, and consult
          qualified professionals where necessary, before making investment
          decisions.
        </p>
        <p>
          By accessing this website or using any VS Fintech service, you agree
          not to redistribute proprietary content without permission and you
          acknowledge that any decisions you take are at your own risk.
        </p>
        <p className="text-xs text-slate-500 dark:text-slate-400">
          This is a simplified overview. Detailed terms, disclaimers and
          regulatory disclosures, where applicable, may be provided separately
          and will override in case of any inconsistency.
        </p>
      </section>
    </div>
  );
};

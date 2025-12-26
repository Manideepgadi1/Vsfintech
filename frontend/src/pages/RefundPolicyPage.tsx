import type { FC } from 'react';

export const RefundPolicyPage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">POLICY</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Cancellation and refund policy
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          The information below provides a general, simplified view on how
          subscription cancellations or refunds may be handled for certain
          services offered by VS Fintech.
        </p>
      </section>

      <section className="space-y-4 text-sm leading-relaxed text-slate-600 dark:text-slate-300">
        <p>
          Many of our research and analytics services are subscription‑based in
          nature. The specific terms relating to billing cycles, renewal,
          cancellation timelines and any applicable refunds are typically
          outlined at the time of subscription or in associated documentation.
        </p>
        <p>
          As a general principle, once research reports, model portfolios or
          digital content have been delivered or accessed, fees may not be
          refundable. Where legally required, or where explicitly mentioned in
          the respective service terms, prorated or full refunds may be
          considered on a case‑by‑case basis.
        </p>
        <p>
          To request clarification about a particular service or to raise a
          concern, you can reach us using the contact details provided on this
          website. Please include your name, contact information and relevant
          transaction or subscription details.
        </p>
        <p className="text-xs text-slate-500 dark:text-slate-400">
          This summary is for information purposes only and does not replace any
          specific product‑wise terms, agreements or regulatory documents that
          may apply.
        </p>
      </section>
    </div>
  );
};

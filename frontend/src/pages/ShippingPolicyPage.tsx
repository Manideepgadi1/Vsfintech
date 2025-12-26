import type { FC } from 'react';

export const ShippingPolicyPage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">POLICY</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Shipping and delivery policy
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          As VS Fintech primarily offers digital research and analytics
          services, there is typically no physical shipping involved. Access is
          generally provided electronically through online platforms, email or
          other digital channels.
        </p>
      </section>

      <section className="space-y-4 text-sm leading-relaxed text-slate-600 dark:text-slate-300">
        <p>
          Where login‑based products or subscriptions are offered, details on
          activation timelines, credentials and mode of delivery are usually
          communicated at the time of onboarding or purchase.
        </p>
        <p>
          If any physical documents or welcome kits are dispatched in specific
          cases, the relevant terms, expected timelines and tracking information
          (if applicable) will be shared separately.
        </p>
        <p className="text-xs text-slate-500 dark:text-slate-400">
          This is a generic description meant for convenience and does not
          replace any specific communication or product‑wise conditions that may
          be issued by VS Fintech or its partners.
        </p>
      </section>
    </div>
  );
};

import type { FC } from 'react';

export const PrivacyPolicyPage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">POLICY</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Privacy policy
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          This page provides a high‑level overview of how VS Fintech may
          collect, use and protect personal information shared with us through
          our website, applications or communication channels.
        </p>
      </section>

      <section className="space-y-4 text-sm leading-relaxed text-slate-600 dark:text-slate-300">
        <p>
          VS Fintech may collect basic contact information that you choose to
          share with us (such as name, email address, phone number or city) when
          you submit forms, request a callback or communicate with our team.
        </p>
        <p>
          Such information is generally used to respond to your queries,
          provide services you have requested, share relevant updates and
          maintain regulatory records where required. We do not sell your
          personal information to third parties.
        </p>
        <p>
          We may also use standard analytics tools to understand aggregated
          website usage trends. These tools typically rely on cookies or similar
          technologies. You can manage cookie preferences using your browser
          settings.
        </p>
        <p>
          Reasonable safeguards are used to help protect personal information;
          however, no method of transmission over the Internet or method of
          electronic storage is fully secure. Please avoid sharing sensitive
          personal details (such as passwords or OTPs) with anyone claiming to
          represent VS Fintech.
        </p>
        <p className="text-xs text-slate-500 dark:text-slate-400">
          This summary is for general information only and does not replace any
          detailed privacy policy, terms or disclosures that may be provided by
          VS Fintech or its partners from time to time.
        </p>
      </section>
    </div>
  );
};

import type { FC } from 'react';
import { Link } from 'react-router-dom';

const services = [
  {
    title: 'Equity research & stock baskets',
    description:
      'Curated, research‑backed equity baskets including AlphaNifty and thematic strategies built on data and risk controls.',
  },
  {
    title: 'Goal‑based investment guidance',
    description:
      'Align portfolios to life goals such as education, retirement, travel and financial freedom with a structured roadmap.',
  },
  {
    title: 'Data‑driven market analytics',
    description:
      'Indices, breadth, factors and regimes monitored through quantitative models so that noise becomes insight.',
  },
  {
    title: 'HNI & advanced strategies',
    description:
      'Support for PMS, unlisted opportunities and HNI‑oriented ideas with a focus on suitability and risk awareness.',
  },
  {
    title: 'Education & investor communication',
    description:
      'Simple, timely updates that help you understand what you own and why you own it.',
  },
  {
    title: 'Risk management framework',
    description:
      'Clear entry, review and exit rules designed to protect capital during adverse market phases.',
  },
];

export const ServicesPage: FC = () => {
  return (
    <div className="space-y-10">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">WHAT WE OFFER</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Guidance and strategies across your investing journey
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          From first‑time investors to experienced market participants, VS Fintech combines
          research, technology and human insight to support decisions across equity, baskets and
          goal‑based planning.
        </p>
      </section>

      <section className="grid gap-6 md:grid-cols-2 xl:grid-cols-3">
        {services.map((service) => (
          <article key={service.title} className="card-glass h-full p-6">
            <h2 className="text-base font-semibold text-slate-900 dark:text-slate-50">
              {service.title}
            </h2>
            <p className="mt-3 text-sm leading-relaxed text-slate-600 dark:text-slate-300">
              {service.description}
            </p>
          </article>
        ))}
      </section>

      <section className="card-glass flex flex-col gap-4 p-6 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h2 className="text-base font-semibold text-slate-900 dark:text-slate-50">
            Explore our research baskets
          </h2>
          <p className="mt-2 text-sm text-slate-600 dark:text-slate-300">
            See sample strategies, understand how we think about risk and return, and explore
            how baskets can support your own plan.
          </p>
        </div>
        <div className="flex gap-3">
          <Link
            to="/baskets"
            className="button-primary inline-flex items-center justify-center px-4 py-2 text-xs font-semibold uppercase tracking-[0.16em]"
          >
            View baskets
          </Link>
          <a
            href="tel:+917207123400"
            className="button-ghost inline-flex items-center justify-center px-4 py-2 text-xs font-semibold uppercase tracking-[0.16em]"
          >
            Call VS Fintech
          </a>
        </div>
      </section>
    </div>
  );
};

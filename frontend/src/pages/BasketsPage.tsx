import { BasketCard, type BasketSummary } from '../components/BasketCard';

const MOCK_BASKETS: BasketSummary[] = [
  {
    id: 'alpha-nifty-core',
    name: 'AlphaNifty Core',
    description:
      'Core equity basket targeting excess returns over NIFTY using factor and regime models.',
    cagr: 17.8,
    maxDrawdown: -15.3,
    volatility: 11.4,
    tags: ['NIFTY', 'factor', 'long-only'],
  },
  {
    id: 'alpha-nifty-plus',
    name: 'AlphaNifty Plus',
    description:
      'Aggressive basket overlaying factor and momentum signals on top of NIFTY universe.',
    cagr: 22.1,
    maxDrawdown: -19.7,
    volatility: 15.8,
    tags: ['momentum', 'overlay'],
  },
];

export function BasketsPage() {
  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <h1 className="text-xl font-semibold tracking-tight text-slate-50">Index Baskets</h1>
          <p className="mt-1 text-sm text-slate-300">
            Curated, quant-driven baskets on NSE &amp; BSE universes with transparent methodology.
          </p>
        </div>
        <div className="flex gap-2 text-xs">
          <button className="button-ghost h-9">Filter</button>
          <button className="button-ghost h-9">Export (coming soon)</button>
        </div>
      </div>

      <section className="grid gap-4 md:grid-cols-2">
        {MOCK_BASKETS.map((basket) => (
          <BasketCard key={basket.id} basket={basket} />
        ))}
      </section>
    </div>
  );
}

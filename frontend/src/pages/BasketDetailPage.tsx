import { useParams } from 'react-router-dom';
import { BasketDetailView } from '../components/BasketDetailView';
import type { BasketSummary } from '../components/BasketCard';

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

export function BasketDetailPage() {
  const { basketId } = useParams<{ basketId: string }>();
  const basket = MOCK_BASKETS.find((b) => b.id === basketId) ?? MOCK_BASKETS[0];

  return <BasketDetailView basket={basket} />;
}

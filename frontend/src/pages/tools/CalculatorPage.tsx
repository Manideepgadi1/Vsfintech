import type { FC } from 'react';
import { useState } from 'react';
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend, ArcElement } from 'chart.js';
import { Bar, Pie } from 'react-chartjs-2';

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend, ArcElement);

type CalculatorType = 'sip' | 'lumpsum' | 'goal';

export const CalculatorPage: FC = () => {
  const [activeCalc, setActiveCalc] = useState<CalculatorType>('sip');

  return (
    <div className="space-y-8">
      {/* Header */}
      <section className="text-center space-y-4">
        <p className="text-xs font-semibold tracking-[0.2em] text-primary-600 uppercase">
          Investment Calculators
        </p>
        <h1 className="text-3xl font-bold text-slate-900 tracking-tight sm:text-4xl">
          Plan Your Financial Future
        </h1>
        <p className="mx-auto max-w-2xl text-sm leading-relaxed text-slate-600">
          Calculate your investment returns with our comprehensive calculators for SIP, Lumpsum, and Goal-based planning
        </p>
      </section>

      {/* Calculator Type Selector */}
      <div className="flex justify-center gap-3 flex-wrap">
        <button
          onClick={() => setActiveCalc('sip')}
          className={`px-6 py-3 rounded-xl font-semibold text-sm transition-all duration-300 ${
            activeCalc === 'sip'
              ? 'bg-primary-600 text-white shadow-lg shadow-primary-600/30'
              : 'bg-white text-slate-700 border border-slate-200 hover:border-primary-400'
          }`}
        >
          SIP Calculator
        </button>
        <button
          onClick={() => setActiveCalc('lumpsum')}
          className={`px-6 py-3 rounded-xl font-semibold text-sm transition-all duration-300 ${
            activeCalc === 'lumpsum'
              ? 'bg-primary-600 text-white shadow-lg shadow-primary-600/30'
              : 'bg-white text-slate-700 border border-slate-200 hover:border-primary-400'
          }`}
        >
          Lumpsum Calculator
        </button>
        <button
          onClick={() => setActiveCalc('goal')}
          className={`px-6 py-3 rounded-xl font-semibold text-sm transition-all duration-300 ${
            activeCalc === 'goal'
              ? 'bg-primary-600 text-white shadow-lg shadow-primary-600/30'
              : 'bg-white text-slate-700 border border-slate-200 hover:border-primary-400'
          }`}
        >
          Goal Calculator
        </button>
      </div>

      {/* Calculator Content */}
      {activeCalc === 'sip' && <SIPCalculator />}
      {activeCalc === 'lumpsum' && <LumpsumCalculator />}
      {activeCalc === 'goal' && <GoalCalculator />}
    </div>
  );
};

// SIP Calculator Component
const SIPCalculator: FC = () => {
  const [amount, setAmount] = useState(10000);
  const [rate, setRate] = useState(12);
  const [years, setYears] = useState(10);
  const [frequency, setFrequency] = useState(12);
  const [stepUpType, setStepUpType] = useState<'none' | 'amount' | 'percent'>('none');
  const [stepUpValue, setStepUpValue] = useState(0);
  const [results, setResults] = useState<any>(null);

  const calculateSIP = () => {
    const ratePerPeriod = rate / 100 / frequency;
    const totalPeriods = years * frequency;
    let currentSIP = amount;
    let invested = 0;
    let maturity = 0;

    const yearlyData = [];
    let yearInvested = 0;

    for (let i = 1; i <= totalPeriods; i++) {
      maturity = (maturity + currentSIP) * (1 + ratePerPeriod);
      invested += currentSIP;
      yearInvested += currentSIP;

      if (i % frequency === 0) {
        yearlyData.push({
          year: i / frequency,
          invested: Math.round(invested),
          value: Math.round(maturity),
        });
        yearInvested = 0;

        if (stepUpType === 'amount') currentSIP += stepUpValue;
        if (stepUpType === 'percent') currentSIP += currentSIP * (stepUpValue / 100);
      }
    }

    setResults({
      corpus: Math.round(maturity),
      invested: Math.round(invested),
      returns: Math.round(maturity - invested),
      yearlyData,
    });
  };

  const reset = () => {
    setAmount(10000);
    setRate(12);
    setYears(10);
    setFrequency(12);
    setStepUpType('none');
    setStepUpValue(0);
    setResults(null);
  };

  const chartData = results
    ? {
        labels: results.yearlyData.map((d: any) => `Year ${d.year}`),
        datasets: [
          {
            label: 'Invested',
            data: results.yearlyData.map((d: any) => d.invested),
            backgroundColor: 'rgba(74, 144, 226, 0.8)',
          },
          {
            label: 'Portfolio Value',
            data: results.yearlyData.map((d: any) => d.value),
            backgroundColor: 'rgba(16, 185, 129, 0.8)',
          },
        ],
      }
    : null;

  return (
    <div className="grid gap-6 lg:grid-cols-2">
      {/* Input Card */}
      <div className="bg-white rounded-2xl shadow-lg border border-slate-200 p-6 space-y-4">
        <h3 className="text-lg font-bold text-slate-900">Investment Details</h3>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            SIP Amount (₹)
          </label>
          <input
            type="number"
            value={amount}
            onChange={(e) => setAmount(Number(e.target.value))}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          />
        </div>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            Contribution Frequency
          </label>
          <select
            value={frequency}
            onChange={(e) => setFrequency(Number(e.target.value))}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          >
            <option value={12}>Monthly</option>
            <option value={4}>Quarterly</option>
            <option value={2}>Half-Yearly</option>
            <option value={1}>Yearly</option>
          </select>
        </div>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            Expected Annual Return (%)
          </label>
          <input
            type="number"
            value={rate}
            onChange={(e) => setRate(Number(e.target.value))}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          />
        </div>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            Investment Period (Years)
          </label>
          <input
            type="number"
            value={years}
            onChange={(e) => setYears(Number(e.target.value))}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          />
        </div>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            Step-Up Type
          </label>
          <select
            value={stepUpType}
            onChange={(e) => setStepUpType(e.target.value as any)}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          >
            <option value="none">No Step-Up</option>
            <option value="amount">Amount (₹)</option>
            <option value="percent">Percentage (%)</option>
          </select>
        </div>

        {stepUpType !== 'none' && (
          <div>
            <label className="block text-sm font-semibold text-slate-700 mb-2">
              Annual Step-Up {stepUpType === 'amount' ? '(₹)' : '(%)'}
            </label>
            <input
              type="number"
              value={stepUpValue}
              onChange={(e) => setStepUpValue(Number(e.target.value))}
              className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
            />
          </div>
        )}

        <div className="flex gap-3 pt-2">
          <button
            onClick={calculateSIP}
            className="flex-1 bg-primary-600 hover:bg-primary-700 text-white font-semibold py-2.5 rounded-lg transition-colors duration-200"
          >
            Calculate
          </button>
          <button
            onClick={reset}
            className="px-6 bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold py-2.5 rounded-lg transition-colors duration-200"
          >
            Reset
          </button>
        </div>

        {results && (
          <div className="mt-6 p-4 bg-primary-50 border-l-4 border-primary-600 rounded-lg space-y-2">
            <div className="flex justify-between">
              <span className="font-semibold text-slate-700">Corpus:</span>
              <span className="font-bold text-primary-600">
                ₹{results.corpus.toLocaleString()}
              </span>
            </div>
            <div className="flex justify-between">
              <span className="font-semibold text-slate-700">Total Invested:</span>
              <span className="font-bold text-slate-900">
                ₹{results.invested.toLocaleString()}
              </span>
            </div>
            <div className="flex justify-between">
              <span className="font-semibold text-slate-700">Total Returns:</span>
              <span className="font-bold text-green-600">
                ₹{results.returns.toLocaleString()}
              </span>
            </div>
          </div>
        )}
      </div>

      {/* Chart Card */}
      <div className="bg-white rounded-2xl shadow-lg border border-slate-200 p-6 space-y-4">
        <div>
          <h3 className="text-lg font-bold text-slate-900">Yearly Growth</h3>
          <p className="text-xs text-slate-600">Invested vs Portfolio Value</p>
        </div>

        {chartData ? (
          <div className="h-80">
            <Bar
              data={chartData}
              options={{
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                  legend: {
                    position: 'top' as const,
                  },
                },
              }}
            />
          </div>
        ) : (
          <div className="h-80 flex items-center justify-center text-slate-400">
            <div className="text-center">
              <svg
                className="mx-auto h-12 w-12 mb-4"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                />
              </svg>
              <p className="text-sm">Calculate to see chart</p>
            </div>
          </div>
        )}

        {results && (
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-slate-200">
                  <th className="text-left py-2 font-semibold text-slate-700">Year</th>
                  <th className="text-right py-2 font-semibold text-slate-700">Invested</th>
                  <th className="text-right py-2 font-semibold text-slate-700">Value</th>
                  <th className="text-right py-2 font-semibold text-slate-700">Returns</th>
                </tr>
              </thead>
              <tbody>
                {results.yearlyData.map((row: any) => (
                  <tr key={row.year} className="border-b border-slate-100">
                    <td className="py-2 text-slate-600">Year {row.year}</td>
                    <td className="py-2 text-right text-slate-900">
                      ₹{row.invested.toLocaleString()}
                    </td>
                    <td className="py-2 text-right text-slate-900">
                      ₹{row.value.toLocaleString()}
                    </td>
                    <td className="py-2 text-right text-green-600">
                      ₹{(row.value - row.invested).toLocaleString()}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};

// Lumpsum Calculator Component  
const LumpsumCalculator: FC = () => {
  const [amount, setAmount] = useState(100000);
  const [rate, setRate] = useState(12);
  const [years, setYears] = useState(10);
  const [results, setResults] = useState<any>(null);

  const calculateLumpsum = () => {
    let maturity = amount;
    const yearlyData = [];

    for (let y = 1; y <= years; y++) {
      maturity *= 1 + rate / 100;
      yearlyData.push({
        year: y,
        invested: amount,
        value: Math.round(maturity),
      });
    }

    setResults({
      corpus: Math.round(maturity),
      invested: amount,
      returns: Math.round(maturity - amount),
      yearlyData,
    });
  };

  const reset = () => {
    setAmount(100000);
    setRate(12);
    setYears(10);
    setResults(null);
  };

  const chartData = results
    ? {
        labels: results.yearlyData.map((d: any) => `Year ${d.year}`),
        datasets: [
          {
            label: 'Invested',
            data: results.yearlyData.map((d: any) => d.invested),
            backgroundColor: 'rgba(74, 144, 226, 0.8)',
          },
          {
            label: 'Portfolio Value',
            data: results.yearlyData.map((d: any) => d.value),
            backgroundColor: 'rgba(16, 185, 129, 0.8)',
          },
        ],
      }
    : null;

  return (
    <div className="grid gap-6 lg:grid-cols-2">
      {/* Input Card */}
      <div className="bg-white rounded-2xl shadow-lg border border-slate-200 p-6 space-y-4">
        <h3 className="text-lg font-bold text-slate-900">Investment Details</h3>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            Investment Amount (₹)
          </label>
          <input
            type="number"
            value={amount}
            onChange={(e) => setAmount(Number(e.target.value))}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          />
        </div>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            Expected Annual Return (%)
          </label>
          <input
            type="number"
            value={rate}
            onChange={(e) => setRate(Number(e.target.value))}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          />
        </div>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            Investment Duration (Years)
          </label>
          <input
            type="number"
            value={years}
            onChange={(e) => setYears(Number(e.target.value))}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          />
        </div>

        <div className="flex gap-3 pt-2">
          <button
            onClick={calculateLumpsum}
            className="flex-1 bg-primary-600 hover:bg-primary-700 text-white font-semibold py-2.5 rounded-lg transition-colors duration-200"
          >
            Calculate
          </button>
          <button
            onClick={reset}
            className="px-6 bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold py-2.5 rounded-lg transition-colors duration-200"
          >
            Reset
          </button>
        </div>

        {results && (
          <div className="mt-6 p-4 bg-primary-50 border-l-4 border-primary-600 rounded-lg space-y-2">
            <div className="flex justify-between">
              <span className="font-semibold text-slate-700">Corpus:</span>
              <span className="font-bold text-primary-600">
                ₹{results.corpus.toLocaleString()}
              </span>
            </div>
            <div className="flex justify-between">
              <span className="font-semibold text-slate-700">Total Invested:</span>
              <span className="font-bold text-slate-900">
                ₹{results.invested.toLocaleString()}
              </span>
            </div>
            <div className="flex justify-between">
              <span className="font-semibold text-slate-700">Total Returns:</span>
              <span className="font-bold text-green-600">
                ₹{results.returns.toLocaleString()}
              </span>
            </div>
          </div>
        )}
      </div>

      {/* Chart Card */}
      <div className="bg-white rounded-2xl shadow-lg border border-slate-200 p-6 space-y-4">
        <div>
          <h3 className="text-lg font-bold text-slate-900">Yearly Growth</h3>
          <p className="text-xs text-slate-600">Invested vs Portfolio Value</p>
        </div>

        {chartData ? (
          <div className="h-80">
            <Bar
              data={chartData}
              options={{
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                  legend: {
                    position: 'top' as const,
                  },
                },
              }}
            />
          </div>
        ) : (
          <div className="h-80 flex items-center justify-center text-slate-400">
            <div className="text-center">
              <svg
                className="mx-auto h-12 w-12 mb-4"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                />
              </svg>
              <p className="text-sm">Calculate to see chart</p>
            </div>
          </div>
        )}

        {results && (
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-slate-200">
                  <th className="text-left py-2 font-semibold text-slate-700">Year</th>
                  <th className="text-right py-2 font-semibold text-slate-700">Invested</th>
                  <th className="text-right py-2 font-semibold text-slate-700">Value</th>
                  <th className="text-right py-2 font-semibold text-slate-700">Returns</th>
                </tr>
              </thead>
              <tbody>
                {results.yearlyData.map((row: any) => (
                  <tr key={row.year} className="border-b border-slate-100">
                    <td className="py-2 text-slate-600">Year {row.year}</td>
                    <td className="py-2 text-right text-slate-900">
                      ₹{row.invested.toLocaleString()}
                    </td>
                    <td className="py-2 text-right text-slate-900">
                      ₹{row.value.toLocaleString()}
                    </td>
                    <td className="py-2 text-right text-green-600">
                      ₹{(row.value - row.invested).toLocaleString()}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};

// Goal Calculator Component
const GoalCalculator: FC = () => {
  const [goalName, setGoalName] = useState('');
  const [currentCost, setCurrentCost] = useState(5000000);
  const [inflation, setInflation] = useState(6);
  const [returns, setReturns] = useState(12);
  const [yearsToGoal, setYearsToGoal] = useState(10);
  const [lumpsum, setLumpsum] = useState(0);
  const [sipGrowth, setSipGrowth] = useState(10);
  const [results, setResults] = useState<any>(null);

  const calculateGoal = () => {
    // Future cost calculation
    const futureCost = currentCost * Math.pow(1 + inflation / 100, yearsToGoal);

    // Lumpsum future value
    const lumpsumFV = lumpsum * Math.pow(1 + returns / 100, yearsToGoal);

    // Remaining amount needed
    const remaining = futureCost - lumpsumFV;

    // Calculate required SIP with step-up
    const monthlyRate = returns / 100 / 12;
    const months = yearsToGoal * 12;

    let requiredSIP = 0;
    if (remaining > 0) {
      // Simplified SIP calculation (constant SIP for approximation)
      const fvFactor = ((Math.pow(1 + monthlyRate, months) - 1) / monthlyRate) * (1 + monthlyRate);
      requiredSIP = remaining / fvFactor;
    }

    setResults({
      futureCost: Math.round(futureCost),
      lumpsumFV: Math.round(lumpsumFV),
      remaining: Math.round(remaining),
      requiredSIP: Math.round(requiredSIP),
    });
  };

  const reset = () => {
    setGoalName('');
    setCurrentCost(5000000);
    setInflation(6);
    setReturns(12);
    setYearsToGoal(10);
    setLumpsum(0);
    setSipGrowth(10);
    setResults(null);
  };

  const pieData = results
    ? {
        labels: ['Lumpsum Contribution', 'SIP Contributions'],
        datasets: [
          {
            data: [results.lumpsumFV, results.futureCost - results.lumpsumFV],
            backgroundColor: ['rgba(74, 144, 226, 0.8)', 'rgba(16, 185, 129, 0.8)'],
          },
        ],
      }
    : null;

  return (
    <div className="grid gap-6 lg:grid-cols-2">
      {/* Input Card */}
      <div className="bg-white rounded-2xl shadow-lg border border-slate-200 p-6 space-y-4">
        <h3 className="text-lg font-bold text-slate-900">Goal Details</h3>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            Goal Name
          </label>
          <input
            type="text"
            value={goalName}
            onChange={(e) => setGoalName(e.target.value)}
            placeholder="e.g., Child's Education"
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          />
        </div>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            Current Cost (₹)
          </label>
          <input
            type="number"
            value={currentCost}
            onChange={(e) => setCurrentCost(Number(e.target.value))}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          />
        </div>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            Inflation Rate (%)
          </label>
          <input
            type="number"
            value={inflation}
            onChange={(e) => setInflation(Number(e.target.value))}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          />
        </div>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            Expected Returns (%)
          </label>
          <input
            type="number"
            value={returns}
            onChange={(e) => setReturns(Number(e.target.value))}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          />
        </div>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            Years to Goal
          </label>
          <input
            type="number"
            value={yearsToGoal}
            onChange={(e) => setYearsToGoal(Number(e.target.value))}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          />
        </div>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            Existing Lumpsum (₹)
          </label>
          <input
            type="number"
            value={lumpsum}
            onChange={(e) => setLumpsum(Number(e.target.value))}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          />
        </div>

        <div>
          <label className="block text-sm font-semibold text-slate-700 mb-2">
            SIP Growth Rate (%)
          </label>
          <input
            type="number"
            value={sipGrowth}
            onChange={(e) => setSipGrowth(Number(e.target.value))}
            className="w-full px-4 py-2.5 rounded-lg border border-slate-300 bg-white text-slate-900 focus:ring-2 focus:ring-primary-500 focus:border-transparent outline-none"
          />
        </div>

        <div className="flex gap-3 pt-2">
          <button
            onClick={calculateGoal}
            className="flex-1 bg-primary-600 hover:bg-primary-700 text-white font-semibold py-2.5 rounded-lg transition-colors duration-200"
          >
            Calculate
          </button>
          <button
            onClick={reset}
            className="px-6 bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold py-2.5 rounded-lg transition-colors duration-200"
          >
            Reset
          </button>
        </div>

        {results && (
          <div className="mt-6 p-4 bg-primary-50 border-l-4 border-primary-600 rounded-lg space-y-2">
            <div className="flex justify-between">
              <span className="font-semibold text-slate-700">Future Cost:</span>
              <span className="font-bold text-primary-600">
                ₹{results.futureCost.toLocaleString()}
              </span>
            </div>
            <div className="flex justify-between">
              <span className="font-semibold text-slate-700">Lumpsum FV:</span>
              <span className="font-bold text-slate-900">
                ₹{results.lumpsumFV.toLocaleString()}
              </span>
            </div>
            <div className="flex justify-between">
              <span className="font-semibold text-slate-700">Required Monthly SIP:</span>
              <span className="font-bold text-green-600">
                ₹{results.requiredSIP.toLocaleString()}
              </span>
            </div>
          </div>
        )}
      </div>

      {/* Chart Card */}
      <div className="bg-white rounded-2xl shadow-lg border border-slate-200 p-6 space-y-4">
        <div>
          <h3 className="text-lg font-bold text-slate-900">Goal Breakdown</h3>
          <p className="text-xs text-slate-600">
            {goalName || 'Your Goal'} - Contribution Split
          </p>
        </div>

        {pieData ? (
          <div className="h-80 flex items-center justify-center">
            <Pie
              data={pieData}
              options={{
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                  legend: {
                    position: 'bottom' as const,
                  },
                },
              }}
            />
          </div>
        ) : (
          <div className="h-80 flex items-center justify-center text-slate-400">
            <div className="text-center">
              <svg
                className="mx-auto h-12 w-12 mb-4"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                />
              </svg>
              <p className="text-sm">Calculate to see breakdown</p>
            </div>
          </div>
        )}

        {results && (
          <div className="space-y-3">
            <div className="p-4 bg-slate-50 rounded-lg">
              <div className="text-sm font-semibold text-slate-700 mb-2">Goal Summary</div>
              <div className="space-y-1 text-sm">
                <div className="flex justify-between">
                  <span className="text-slate-600">Time Horizon:</span>
                  <span className="font-semibold text-slate-900">{yearsToGoal} years</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-600">Current Cost:</span>
                  <span className="font-semibold text-slate-900">
                    ₹{currentCost.toLocaleString()}
                  </span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-600">Inflation Impact:</span>
                  <span className="font-semibold text-orange-600">
                    ₹{(results.futureCost - currentCost).toLocaleString()}
                  </span>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

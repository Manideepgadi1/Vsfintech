import { Link } from 'react-router-dom';
import { CountUpNumber } from '../components/CountUpNumber';

const approachItems = [
  {
    title: 'Right Time',
    body: 'We analyse market cycles and signals to choose better entry and exit points, aiming to grow capital while containing risk.',
  },
  {
    title: 'Right Fund',
    body: 'Our research selects funds that fit your goals and risk profile, with an eye on consistency and downside protection.',
  },
  {
    title: 'Right Mix',
    body: 'We balance equity, debt and other assets to create resilient portfolios that can ride through full market cycles.',
  },
];

const instruments = [
  'Stocks',
  'Mutual Funds',
  'Bonds',
  'PMS / Unlisted Shares',
  'HNI Services',
  'Insurance',
  'Equity',
];

const happinessGoals = [
  'World tour',
  'Child education',
  'Happy home',
  'Happy car / vehicle',
  'Happy retirement',
  'Health & wellness',
  'Financial freedom',
];

const testimonials = [
  {
    name: 'Rishindra Kumar',
    role: 'CTO, Tech Innovations Ltd',
    quote:
      "VS Fintech's data-driven approach to investment management has significantly improved our portfolio performance. Their machine learning algorithms have consistently outperformed traditional investment strategies.",
  },
  {
    name: 'Anusha R.',
    role: 'Entrepreneur',
    quote:
      '"VS Fintech helped turn a modest fund into a meaningful 3‑year outcome. The process felt guided yet transparent throughout."',
  },
  {
    name: 'Varma K.',
    role: 'Senior Analyst',
    quote:
      '"The investment strategies gave us focused exposure without the day‑to‑day noise. Research notes made it easy to stay invested."',
  },
];

const awards = [
  {
    title: 'Most Innovative Startup of the Year',
    icon: '🏆',
  },
  {
    title: 'Fastest Growing Mutual Fund Startup of the Year',
    icon: '🥇',
  },
  {
    title: 'Excellence in Digital Mutual Fund Innovation',
    icon: '⭐',
  },
  {
    title: 'Excellence in Goal-Based Mutual investing',
    icon: '🏅',
  },
];

const analyticsPillars = [
  {
    title: 'Data analytics',
    body: 'Transform raw market data into clean, usable factor and risk inputs.',
  },
  {
    title: 'Machine‑learning algorithms',
    body: 'Use ML to detect regimes and patterns that traditional screens can miss.',
  },
  {
    title: 'Investment strategies',
    body: 'Turn insights into portfolios aligned with investor goals and risk levels.',
  },
  {
    title: 'Risk mitigation',
    body: 'Focus on drawdowns, liquidity, and position sizing to protect capital.',
  },
];

export function HomePage() {
  return (
    <div className="space-y-16 bg-white">
      {/* Hero – AlphaNifty + VS Fintech positioning */}
      <section className="gradient-hero rounded-3xl border border-slate-200/80 px-6 py-10 shadow-2xl shadow-primary-500/10 transition-all duration-500 hover:shadow-3xl hover:shadow-primary-500/20 sm:px-8 lg:px-10 dark:border-slate-800/80 animate-fade-in">
        <div className="grid gap-10 lg:grid-cols-[minmax(0,1.4fr)_minmax(0,1fr)] lg:items-center">
          <div className="space-y-6">
            <p className="mb-3 inline-flex items-center gap-2 rounded-full border border-primary-400/40 bg-primary-50 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.18em] text-primary-700 shadow-sm transition-all duration-300 hover:shadow-md hover:scale-105 dark:border-primary-500/40 dark:bg-primary-500/10 dark:text-primary-100 animate-fade-in-up">
              <span className="h-1.5 w-1.5 rounded-full bg-primary-500 animate-pulse shadow-sm shadow-primary-500" />
              AlphaNifty – India&apos;s intelligent investment engine
            </p>
            <h1 className="text-3xl font-bold tracking-tight text-slate-900 sm:text-4xl lg:text-5xl dark:text-slate-50 animate-fade-in-up stagger-1">
              Invest smart.
              <span className="text-primary-600 dark:text-primary-500"> Grow fast. </span>
              Stay data‑driven.
            </h1>
            <p className="mt-4 max-w-xl text-sm leading-relaxed text-slate-700 dark:text-slate-300">
              VS Fintech combines data analytics, capital‑markets experience, and ML‑driven
              models to build transparent strategies for Indian investors. From mutual funds to
              equity research, everything starts with data.
            </p>
            <div className="mt-6 flex flex-wrap gap-4">
              <a
                href="https://play.google.com/store/apps/details?id=com.alphanifty.alphanifty&pcampaignid=web_share"
                target="_blank"
                rel="noreferrer"
                className="group relative inline-flex items-center justify-center overflow-hidden rounded-xl bg-gradient-to-br from-primary-500 to-primary-600 px-8 py-3.5 text-sm font-semibold text-white shadow-lg shadow-primary-500/30 transition-all duration-300 hover:shadow-xl hover:shadow-primary-500/40 hover:scale-105 active:scale-95"
              >
                <span className="absolute inset-0 w-full h-full bg-gradient-to-br from-primary-400 to-primary-500 opacity-0 transition-opacity duration-300 group-hover:opacity-100"></span>
                <span className="relative flex items-center gap-2">
                  <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M17.9 10.9C17.6 10.6 17.2 10.4 16.7 10.4H14.8V6.1C14.8 5.3 14.1 4.6 13.3 4.6H10.7C9.9 4.6 9.2 5.3 9.2 6.1V10.4H7.3C6.4 10.4 5.9 11.5 6.5 12.1L11.1 16.7C11.6 17.2 12.4 17.2 12.9 16.7L17.5 12.1C17.8 11.8 18 11.4 18 11C18 10.9 17.9 10.9 17.9 10.9M4 19.2H20V21.2H4V19.2Z"/>
                  </svg>
                  Start with AlphaNifty App
                </span>
              </a>
              <a
                href="http://82.25.105.18/alphanifty"
                target="_blank"
                rel="noopener noreferrer"
                className="group relative inline-flex items-center justify-center overflow-hidden rounded-xl border-2 border-primary-500 bg-white px-8 py-3.5 text-sm font-semibold text-primary-600 shadow-md transition-all duration-300 hover:bg-primary-50 hover:shadow-lg hover:scale-105 active:scale-95 dark:bg-slate-900 dark:text-primary-400 dark:hover:bg-slate-800"
              >
                <span className="relative flex items-center gap-2">
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
                  </svg>
                  Launch AlphaNifty Platform
                  <svg className="w-4 h-4 transition-transform duration-300 group-hover:translate-x-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                  </svg>
                </span>
              </a>
            </div>
          </div>

          <div className="card-glass relative overflow-hidden p-5 text-xs text-slate-700 shadow-lg transition-all duration-500 hover:shadow-2xl hover:scale-[1.02] dark:text-slate-300">
            <div className="absolute -right-10 -top-10 h-40 w-40 rounded-full bg-primary-500/20 blur-3xl animate-pulse" />
            <p className="text-[11px] font-bold uppercase tracking-[0.2em] text-primary-700 dark:text-slate-400">
              HOW WE INVEST
            </p>
            <div className="mt-3 space-y-3">
              {approachItems.map((item, idx) => (
                <div
                  key={item.title}
                  className="group flex items-start justify-between gap-3 rounded-2xl bg-gradient-to-br from-slate-50 to-slate-100/50 px-3 py-2.5 shadow-md transition-all duration-300 hover:shadow-lg hover:scale-105 hover:from-primary-50 hover:to-primary-100/50 dark:bg-slate-900/80 dark:hover:bg-slate-800/90 animate-fade-in-up"
                  style={{ animationDelay: `${idx * 0.1}s` }}
                >
                  <div>
                    <p className="text-[11px] font-bold uppercase tracking-[0.18em] text-slate-800 dark:text-slate-300">
                      {item.title}
                    </p>
                    <p className="mt-1 text-[11px] leading-relaxed text-slate-600 dark:text-slate-300">
                      {item.body}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Our Investment Approach – highlighted section */}
      <section className="space-y-6">
        <div className="space-y-2">
          <h2 className="text-sm font-semibold uppercase tracking-[0.18em] text-slate-400">
            OUR INVESTMENT APPROACH
          </h2>
          <p className="text-sm text-slate-700 dark:text-slate-300">
            A simple idea from your current site – the right time, the right fund and the
            right mix, supported by data.
          </p>
        </div>
        <div className="grid gap-4 md:grid-cols-3">
          {approachItems.map((item, idx) => (
            <article
              key={item.title}
              className="card-glass group flex flex-col justify-between px-5 py-4 text-xs text-slate-700 shadow-md transition-all duration-500 hover:shadow-2xl hover:scale-105 hover:border-primary-300 dark:text-slate-200 animate-fade-in-up"
              style={{ animationDelay: `${idx * 0.15}s` }}
            >
              <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-slate-500 dark:text-slate-400">
                {item.title}
              </p>
              <p className="mt-2 leading-relaxed">{item.body}</p>
            </article>
          ))}
        </div>
      </section>

      {/* Fundoscope - Investment Tools */}
      <section className="space-y-6 animate-fade-in-up">
        <div className="text-center space-y-3">
          <h2 className="text-2xl font-bold tracking-tight text-slate-900 dark:text-slate-50">
            <span className="text-primary-600 dark:text-primary-500">Fundoscope</span> - Investment Analysis Tools
          </h2>
          <p className="text-sm text-slate-600 dark:text-slate-300 max-w-2xl mx-auto">
            Comprehensive suite of tools to analyze, compare, and select the right investment options for your portfolio.
          </p>
        </div>
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          <a
            href="http://82.25.105.18:9004"
            target="_blank"
            rel="noopener noreferrer"
            className="card-glass group flex flex-col items-center justify-center px-6 py-6 text-center shadow-md transition-all duration-300 hover:shadow-2xl hover:scale-110 hover:border-primary-400 hover:bg-gradient-to-br hover:from-primary-50 hover:to-primary-100/50 dark:hover:bg-slate-800 animate-scale-in"
          >
            <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center mb-3 shadow-lg group-hover:shadow-xl group-hover:scale-110 transition-all">
              <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 className="font-bold text-sm text-slate-900 dark:text-slate-50 group-hover:text-primary-600 dark:group-hover:text-primary-400">Right Sector</h3>
            <p className="text-xs text-slate-600 dark:text-slate-400 mt-1">Sector Analysis Dashboard</p>
          </a>

          <a
            href="http://82.25.105.18:9002"
            target="_blank"
            rel="noopener noreferrer"
            className="card-glass group flex flex-col items-center justify-center px-6 py-6 text-center shadow-md transition-all duration-300 hover:shadow-2xl hover:scale-110 hover:border-primary-400 hover:bg-gradient-to-br hover:from-green-50 hover:to-green-100/50 dark:hover:bg-slate-800 animate-scale-in"
            style={{ animationDelay: '0.1s' }}
          >
            <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-green-500 to-green-600 flex items-center justify-center mb-3 shadow-lg group-hover:shadow-xl group-hover:scale-110 transition-all">
              <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <h3 className="font-bold text-sm text-slate-900 dark:text-slate-50 group-hover:text-green-600 dark:group-hover:text-green-400">Right Amount</h3>
            <p className="text-xs text-slate-600 dark:text-slate-400 mt-1">Investment Amount Calculator</p>
          </a>

          <a
            href="http://82.25.105.18:9003"
            target="_blank"
            rel="noopener noreferrer"
            className="card-glass group flex flex-col items-center justify-center px-6 py-6 text-center shadow-md transition-all duration-300 hover:shadow-2xl hover:scale-110 hover:border-primary-400 hover:bg-gradient-to-br hover:from-purple-50 hover:to-purple-100/50 dark:hover:bg-slate-800 animate-scale-in"
            style={{ animationDelay: '0.2s' }}
          >
            <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-purple-500 to-purple-600 flex items-center justify-center mb-3 shadow-lg group-hover:shadow-xl group-hover:scale-110 transition-all">
              <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 5a1 1 0 011-1h4a1 1 0 011 1v7a1 1 0 01-1 1H5a1 1 0 01-1-1V5zM14 5a1 1 0 011-1h4a1 1 0 011 1v7a1 1 0 01-1 1h-4a1 1 0 01-1-1V5zM4 16a1 1 0 011-1h4a1 1 0 011 1v3a1 1 0 01-1 1H5a1 1 0 01-1-1v-3zM14 16a1 1 0 011-1h4a1 1 0 011 1v3a1 1 0 01-1 1h-4a1 1 0 01-1-1v-3z" />
              </svg>
            </div>
            <h3 className="font-bold text-sm text-slate-900 dark:text-slate-50 group-hover:text-purple-600 dark:group-hover:text-purple-400">Sector Heatmap</h3>
            <p className="text-xs text-slate-600 dark:text-slate-400 mt-1">Visual Sector Performance</p>
          </a>

          <a
            href="http://82.25.105.18:5000"
            target="_blank"
            rel="noopener noreferrer"
            className="card-glass group flex flex-col items-center justify-center px-6 py-6 text-center shadow-md transition-all duration-300 hover:shadow-2xl hover:scale-110 hover:border-primary-400 hover:bg-gradient-to-br hover:from-orange-50 hover:to-orange-100/50 dark:hover:bg-slate-800 animate-scale-in"
            style={{ animationDelay: '0.3s' }}
          >
            <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-orange-500 to-orange-600 flex items-center justify-center mb-3 shadow-lg group-hover:shadow-xl group-hover:scale-110 transition-all">
              <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
              </svg>
            </div>
            <h3 className="font-bold text-sm text-slate-900 dark:text-slate-50 group-hover:text-orange-600 dark:group-hover:text-orange-400">Risk-Reward</h3>
            <p className="text-xs text-slate-600 dark:text-slate-400 mt-1">Risk-Reward Analysis</p>
          </a>

          <a
            href="http://82.25.105.18:9005"
            target="_blank"
            rel="noopener noreferrer"
            className="card-glass group flex flex-col items-center justify-center px-6 py-6 text-center shadow-md transition-all duration-300 hover:shadow-2xl hover:scale-110 hover:border-primary-400 hover:bg-gradient-to-br hover:from-indigo-50 hover:to-indigo-100/50 dark:hover:bg-slate-800 animate-scale-in"
            style={{ animationDelay: '0.4s' }}
          >
            <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-indigo-500 to-indigo-600 flex items-center justify-center mb-3 shadow-lg group-hover:shadow-xl group-hover:scale-110 transition-all">
              <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 12l3-3 3 3 4-4M8 21l4-4 4 4M3 4h18M4 4h16v12a1 1 0 01-1 1H5a1 1 0 01-1-1V4z" />
              </svg>
            </div>
            <h3 className="font-bold text-sm text-slate-900 dark:text-slate-50 group-hover:text-indigo-600 dark:group-hover:text-indigo-400">Risk-Return</h3>
            <p className="text-xs text-slate-600 dark:text-slate-400 mt-1">Risk-Return Dashboard</p>
          </a>

          <a
            href="http://82.25.105.18:5002"
            target="_blank"
            rel="noopener noreferrer"
            className="card-glass group flex flex-col items-center justify-center px-6 py-6 text-center shadow-md transition-all duration-300 hover:shadow-2xl hover:scale-110 hover:border-primary-400 hover:bg-gradient-to-br hover:from-red-50 hover:to-red-100/50 dark:hover:bg-slate-800 animate-scale-in"
            style={{ animationDelay: '0.5s' }}
          >
            <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-red-500 to-red-600 flex items-center justify-center mb-3 shadow-lg group-hover:shadow-xl group-hover:scale-110 transition-all">
              <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
              </svg>
            </div>
            <h3 className="font-bold text-sm text-slate-900 dark:text-slate-50 group-hover:text-red-600 dark:group-hover:text-red-400">Riskometer</h3>
            <p className="text-xs text-slate-600 dark:text-slate-400 mt-1">Risk Assessment Tool</p>
          </a>

          <a
            href="http://82.25.105.18:9006"
            target="_blank"
            rel="noopener noreferrer"
            className="card-glass group flex flex-col items-center justify-center px-6 py-6 text-center shadow-md transition-all duration-300 hover:shadow-2xl hover:scale-110 hover:border-primary-400 hover:bg-gradient-to-br hover:from-teal-50 hover:to-teal-100/50 dark:hover:bg-slate-800 animate-scale-in"
            style={{ animationDelay: '0.6s' }}
          >
            <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-teal-500 to-teal-600 flex items-center justify-center mb-3 shadow-lg group-hover:shadow-xl group-hover:scale-110 transition-all">
              <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 className="font-bold text-sm text-slate-900 dark:text-slate-50 group-hover:text-teal-600 dark:group-hover:text-teal-400">Multi Chart</h3>
            <p className="text-xs text-slate-600 dark:text-slate-400 mt-1">Multi-Index Comparison</p>
          </a>

          <a
            href="http://82.25.105.18:3003"
            target="_blank"
            rel="noopener noreferrer"
            className="card-glass group flex flex-col items-center justify-center px-6 py-6 text-center shadow-md transition-all duration-300 hover:shadow-2xl hover:scale-110 hover:border-primary-400 hover:bg-gradient-to-br hover:from-cyan-50 hover:to-cyan-100/50 dark:hover:bg-slate-800 animate-scale-in"
            style={{ animationDelay: '0.7s' }}
          >
            <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-cyan-500 to-cyan-600 flex items-center justify-center mb-3 shadow-lg group-hover:shadow-xl group-hover:scale-110 transition-all">
              <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </div>
            <h3 className="font-bold text-sm text-slate-900 dark:text-slate-50 group-hover:text-cyan-600 dark:group-hover:text-cyan-400">PMS Screener</h3>
            <p className="text-xs text-slate-600 dark:text-slate-400 mt-1">Fund Screening Tool</p>
          </a>
        </div>
      </section>

      {/* What we cover */}
      <section className="space-y-6 animate-fade-in-up">
        <div className="flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between">
          <div>
            <h2 className="text-sm font-bold uppercase tracking-[0.18em] text-primary-700 dark:text-slate-400">
              GUIDANCE PROVIDED FOR
            </h2>
            <p className="mt-1 text-sm text-slate-600 dark:text-slate-300">
              One research layer across instruments – from mutual funds to equity research.
            </p>
          </div>
        </div>
        <div className="grid gap-4 sm:grid-cols-3 lg:grid-cols-4">
          {instruments.map((label, idx) => (
            <article
              key={label}
              className="card-glass group flex items-center justify-between px-4 py-3 text-xs text-slate-700 shadow-md transition-all duration-300 hover:shadow-xl hover:scale-105 dark:text-slate-200 animate-scale-in hover:border-primary-300 hover:bg-primary-50/50 dark:hover:bg-slate-800"
              style={{ animationDelay: `${idx * 0.05}s` }}
            >
              <span className="font-bold transition-colors group-hover:text-primary-600 dark:group-hover:text-primary-400">{label}</span>
              <span className="text-[10px] font-medium uppercase tracking-[0.18em] text-slate-500 dark:text-slate-400">
                Research‑driven
              </span>
            </article>
          ))}
        </div>
      </section>

      {/* Unlocking investment opportunities together */}
      <section className="grid gap-8 lg:grid-cols-[minmax(0,1.3fr)_minmax(0,1fr)] animate-fade-in-up">
        <div className="space-y-3 animate-slide-in-left">
          <h2 className="text-sm font-bold uppercase tracking-[0.18em] text-primary-700 dark:text-slate-400">
            UNLOCKING INVESTMENT OPPORTUNITIES TOGETHER
          </h2>
          <p className="text-lg font-bold tracking-tight text-slate-900 dark:text-slate-50">
            A single research engine across products and goals.
          </p>
          <p className="text-sm leading-relaxed text-slate-700 dark:text-slate-300">
            Echoing your current website: VS Fintech uses advanced analytics and machine
            learning to power transparent strategies. The idea is simple – combine data,
            experience and clear communication so investors know what they own and why.
          </p>
        </div>
        <div className="card-glass p-5 text-sm text-slate-700 shadow-lg transition-all duration-500 hover:shadow-2xl hover:scale-105 dark:text-slate-300 animate-scale-in stagger-1">
          <ul className="space-y-2">
            <li className="flex items-start gap-2 transition-all duration-300 hover:translate-x-2"><span className="text-primary-600 font-bold">•</span> Research‑backed mutual‑fund journeys through the AlphaNifty app.</li>
            <li className="flex items-start gap-2 transition-all duration-300 hover:translate-x-2"><span className="text-primary-600 font-bold">•</span> Thematic investment strategies that package themes and factors into explainable portfolios.</li>
            <li className="flex items-start gap-2 transition-all duration-300 hover:translate-x-2"><span className="text-primary-600 font-bold">•</span> Support for HNI and advisor workflows, not just DIY investors.</li>
            <li className="flex items-start gap-2 transition-all duration-300 hover:translate-x-2"><span className="text-primary-600 font-bold">•</span> Transparent narratives and regular communication instead of jargon.</li>
          </ul>
        </div>
      </section>

      {/* Mission & about */}
      <section className="grid gap-8 lg:grid-cols-2" id="mission">
        <div className="space-y-3">
          <h2 className="text-sm font-bold uppercase tracking-[0.18em] text-primary-700 dark:text-slate-400">
            ABOUT VS FINTECH
          </h2>
          <p className="text-lg font-bold tracking-tight text-slate-900 dark:text-slate-50">
            A collaboration of data analytics and capital markets.
          </p>
          <p className="text-sm leading-relaxed text-slate-700 dark:text-slate-300">
            We integrate finance and technology to build strategies that aim to amplify
            returns while managing risk. Our work spans factor models, ML algorithms, and
            disciplined execution frameworks.
          </p>
        </div>
        <div className="card-glass grid grid-cols-2 gap-4 p-5 text-xs text-slate-700 dark:text-slate-300">
          <div>
            <p className="text-[10px] uppercase tracking-[0.18em] text-slate-500 dark:text-slate-400">
              Who we are
            </p>
            <p className="mt-1 font-semibold text-slate-900 dark:text-slate-50">
              Financial experts and tech builders working together.
            </p>
          </div>
          <div>
            <p className="text-[10px] uppercase tracking-[0.18em] text-slate-500 dark:text-slate-400">
              What we do
            </p>
            <p className="mt-1 font-semibold text-slate-900 dark:text-slate-50">
              AI‑powered strategies for Indian investors.
            </p>
          </div>
          <div>
            <p className="text-[10px] uppercase tracking-[0.18em] text-slate-500 dark:text-slate-400">
              Why it matters
            </p>
            <p className="mt-1 font-semibold text-slate-900 dark:text-slate-50">
              Make research‑grade investing accessible beyond institutions.
            </p>
          </div>
          <div>
            <p className="text-[10px] uppercase tracking-[0.18em] text-slate-500 dark:text-slate-400">
              Our mission
            </p>
            <p className="mt-1 font-semibold text-slate-900 dark:text-slate-50">
              Help 1M Indians move closer to financial independence.
            </p>
          </div>
        </div>
      </section>

      {/* Happiness goals */}
      <section className="space-y-6 animate-fade-in-up">
        <div className="space-y-2">
          <h2 className="text-sm font-bold uppercase tracking-[0.18em] text-primary-700 dark:text-slate-400">
            HAPPINESS GOALS
          </h2>
          <p className="text-sm text-slate-700 dark:text-slate-300">
            Goals first, products later – portfolios are built around what you are solving for.
          </p>
        </div>
        <div className="grid gap-4 md:grid-cols-3 lg:grid-cols-4">
          {happinessGoals.map((goal, idx) => (
            <article
              key={goal}
              className="card-glass group flex flex-col justify-between px-4 py-4 text-xs text-slate-700 dark:text-slate-200 animate-scale-in cursor-pointer hover:border-primary-300"
              style={{ animationDelay: `${idx * 0.08}s` }}
            >
              <p className="text-[11px] font-bold uppercase tracking-[0.18em] text-slate-700 transition-colors group-hover:text-primary-600 dark:text-slate-400 dark:group-hover:text-primary-400">
                {goal}
              </p>
              <p className="mt-2 text-[11px] leading-relaxed text-slate-600 dark:text-slate-300">
                A dedicated plan to fund this milestone while keeping the rest of your
                finances balanced.
              </p>
            </article>
          ))}
        </div>
      </section>

      {/* Data analytics, ML, strategies, risk mitigation */}
      <section className="space-y-6 animate-fade-in-up" id="analytics">
        <div className="space-y-2">
          <h2 className="text-sm font-bold uppercase tracking-[0.18em] text-primary-700 dark:text-slate-400">
            DATA ANALYTICS &amp; MACHINE LEARNING
          </h2>
          <p className="text-sm text-slate-700 dark:text-slate-300">
            The same four pillars you highlight today – now presented in a compact, premium
            layout.
          </p>
        </div>
        <div className="grid gap-4 md:grid-cols-2">
          {analyticsPillars.map((pillar, idx) => (
            <article
              key={pillar.title}
              className={`card-glass group px-5 py-4 text-sm text-slate-700 dark:text-slate-300 animate-scale-in stagger-${idx + 1} hover:border-primary-300`}
            >
              <p className="text-[11px] font-bold uppercase tracking-[0.18em] text-slate-800 transition-colors group-hover:text-primary-600 dark:text-slate-400 dark:group-hover:text-primary-400">
                {pillar.title}
              </p>
              <p className="mt-2 leading-relaxed text-slate-600 dark:text-slate-300">{pillar.body}</p>
            </article>
          ))}
        </div>
      </section>

      {/* Achievements strip */}
      <section className="grid gap-4 rounded-3xl border border-slate-100 bg-white px-6 py-6 text-xs text-slate-700 shadow-card dark:border-slate-800 dark:bg-slate-900/70 dark:text-slate-300 animate-fade-in-up">
        <div className="text-[11px] font-bold uppercase tracking-[0.18em] text-primary-700 dark:text-slate-400">
          OUR ACHIEVEMENTS (SNAPSHOT)
        </div>
        <div className="grid gap-6 sm:grid-cols-3">
          <div className="group">
            <p className="text-2xl font-bold text-primary-600 transition-all duration-500 group-hover:scale-110 dark:text-primary-400">
              <CountUpNumber end={5} suffix="+" duration={1500} /> <span className="text-lg font-semibold">years</span>
            </p>
            <p className="mt-2 text-sm leading-snug text-slate-700 dark:text-slate-300">
              Of research‑driven investing for Indian clients.
            </p>
          </div>
          <div className="group">
            <p className="text-2xl font-bold text-primary-600 transition-all duration-500 group-hover:scale-110 dark:text-primary-400">
              <CountUpNumber end={1000} suffix="s" duration={2000} />
            </p>
            <p className="mt-2 text-sm leading-snug text-slate-700 dark:text-slate-300">
              Of portfolios and journeys evaluated through AlphaNifty.
            </p>
          </div>
          <div className="group">
            <p className="text-2xl font-bold text-primary-600 transition-all duration-500 group-hover:scale-110 dark:text-primary-400">
              <CountUpNumber end={1} suffix="M+" duration={1800} /> <span className="text-lg font-semibold">goal</span>
            </p>
            <p className="mt-2 text-sm leading-snug text-slate-700 dark:text-slate-300">
              Indians we aim to help move towards financial freedom.
            </p>
          </div>
        </div>
      </section>

      {/* Awards */}
      <section className="space-y-6 rounded-3xl border border-slate-100 bg-slate-50 px-4 py-8">
        <div className="text-center">
          <h2 className="text-sm font-bold uppercase tracking-[0.18em] text-primary-700 dark:text-slate-400">
            AWARDS
          </h2>
          <p className="mt-2 text-2xl font-bold tracking-tight text-slate-900 dark:text-slate-50">
            VS FINTECH PVT LTD
          </p>
        </div>
        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
          {awards.map((award, idx) => (
            <article
              key={award.title}
              className={`card-glass group relative overflow-hidden p-6 text-center animate-scale-in stagger-${idx + 1} hover:border-primary-300`}
            >
              <div className="absolute inset-0 bg-gradient-to-br from-primary-500/10 to-transparent opacity-0 transition-opacity duration-500 group-hover:opacity-100" />
              <div className="relative">
                <div className="mb-4 text-5xl">{award.icon}</div>
                <h3 className="text-sm font-bold leading-snug text-slate-800 dark:text-slate-50">
                  {award.title}
                </h3>
              </div>
            </article>
          ))}
        </div>
      </section>

      {/* Testimonials */}
      <section className="space-y-8 rounded-3xl border border-slate-100 bg-slate-50 px-4 py-8" id="testimonials">
        <div className="text-center">
          <h2 className="text-sm font-bold uppercase tracking-[0.18em] text-primary-700 dark:text-slate-400">
            CLIENT TESTIMONIALS
          </h2>
          <p className="mt-2 text-2xl font-bold tracking-tight text-slate-900 dark:text-slate-50">
            Data‑driven advice, human conversations.
          </p>
        </div>
        <div className="grid gap-6 lg:grid-cols-3">
          {testimonials.map((t, idx) => (
            <article
              key={t.name}
              className={`card-glass group relative overflow-hidden p-6 text-sm text-slate-700 dark:text-slate-300 animate-fade-in-up stagger-${idx + 1} hover:border-primary-300`}
            >
              <div className="absolute right-4 top-4 text-6xl text-primary-600/10 transition-all duration-500 group-hover:scale-110 group-hover:text-primary-600/20">
                "
              </div>
              <div className="relative">
                <div className="mb-3 flex gap-0.5 text-amber-500">
                  {[...Array(5)].map((_, i) => (
                    <span key={i} className="text-lg">★</span>
                  ))}
                </div>
                <p className="italic leading-relaxed text-slate-700 dark:text-slate-300">{t.quote}</p>
                <div className="mt-4 border-t border-slate-200 pt-4 dark:border-slate-700">
                  <p className="font-bold text-slate-900 dark:text-slate-100">{t.name}</p>
                  <p className="mt-1 text-xs font-medium text-slate-600 dark:text-slate-400">{t.role}</p>
                </div>
              </div>
            </article>
          ))}
        </div>
      </section>

      {/* Final CTA */}
      <section id="contact" className="grid gap-8 lg:grid-cols-[minmax(0,1.2fr)_minmax(0,1fr)]">
        <div className="space-y-3">
          <h2 className="text-sm font-bold uppercase tracking-[0.18em] text-primary-700 dark:text-slate-400">
            START YOUR JOURNEY
          </h2>
          <p className="text-lg font-bold tracking-tight text-slate-900 dark:text-slate-50">
            Ready to make your money work harder?
          </p>
          <p className="text-sm leading-relaxed text-slate-700 dark:text-slate-300">
            Begin with AlphaNifty for mutual‑fund journeys, or talk to us about model
            portfolios and bespoke strategies built on the same research engine.
          </p>
          <div className="mt-2 flex flex-wrap gap-3 text-sm">
            <a
              href="mailto:vsfintech@gmail.com"
              className="button-ghost h-10 px-5 text-[11px] font-semibold uppercase tracking-[0.18em]"
            >
              Email vsfintech@gmail.com
            </a>
            <a href="tel:+917207123400" className="button-ghost h-10 px-5 text-[11px] font-semibold uppercase tracking-[0.18em]">
              Call +91‑72071‑23400
            </a>
          </div>
        </div>
        <div className="card-glass space-y-4 p-5 text-xs">
          <div className="space-y-1.5">
            <label className="text-[11px] font-bold uppercase tracking-[0.16em] text-slate-700 dark:text-slate-400">
              Name
            </label>
            <input
              type="text"
              placeholder="Your name"
              className="h-9 w-full rounded-2xl border border-slate-200 bg-white px-3 text-xs text-slate-900 outline-none transition-all placeholder:text-slate-400 focus:border-primary-400 focus:ring-2 focus:ring-primary-100 dark:border-slate-800 dark:bg-slate-950/60 dark:text-slate-100"
            />
          </div>
          <div className="space-y-1.5">
            <label className="text-[11px] font-bold uppercase tracking-[0.16em] text-slate-700 dark:text-slate-400">
              Email
            </label>
            <input
              type="email"
              placeholder="you@firm.com"
              className="h-9 w-full rounded-2xl border border-slate-200 bg-white px-3 text-xs text-slate-900 outline-none transition-all placeholder:text-slate-400 focus:border-primary-400 focus:ring-2 focus:ring-primary-100 dark:border-slate-800 dark:bg-slate-950/60 dark:text-slate-100"
            />
          </div>
          <div className="space-y-1.5">
            <label className="text-[11px] font-bold uppercase tracking-[0.16em] text-slate-700 dark:text-slate-400">
              Message
            </label>
            <textarea
              rows={3}
              placeholder="Share a line about your goals or context."
              className="w-full rounded-2xl border border-slate-200 bg-white px-3 py-2 text-xs text-slate-900 outline-none transition-all placeholder:text-slate-400 focus:border-primary-400 focus:ring-2 focus:ring-primary-100 dark:border-slate-800 dark:bg-slate-950/60 dark:text-slate-100"
            />
          </div>
          <button type="button" className="button-primary w-full text-sm font-semibold">
            Submit (placeholder)
          </button>
        </div>
      </section>
    </div>
  );
}

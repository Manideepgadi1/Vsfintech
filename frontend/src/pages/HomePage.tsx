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
  'Stock Baskets',
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
      '"The basket strategies gave us focused exposure without the day‑to‑day noise. Research notes made it easy to stay invested."',
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
      <section className="gradient-hero rounded-3xl border border-slate-200/80 px-6 py-10 shadow-elevated sm:px-8 lg:px-10 dark:border-slate-800/80 animate-fade-in">
        <div className="grid gap-10 lg:grid-cols-[minmax(0,1.4fr)_minmax(0,1fr)] lg:items-center">
          <div className="space-y-6">
            <p className="mb-3 inline-flex items-center gap-2 rounded-full border border-primary-400/40 bg-primary-50 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.18em] text-primary-700 dark:border-primary-500/40 dark:bg-primary-500/10 dark:text-primary-100 animate-fade-in-up">
              <span className="h-1.5 w-1.5 rounded-full bg-primary-500 animate-pulse" />
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
              index baskets, everything starts with research.
            </p>
            <div className="mt-6 flex flex-wrap gap-3">
              <a
                href="https://play.google.com/store/apps/details?id=com.alphanifty.alphanifty&pcampaignid=web_share"
                target="_blank"
                rel="noreferrer"
                className="button-primary h-10 px-6 text-sm"
              >
                Start with AlphaNifty app
              </a>
              <Link
                to="/baskets"
                className="button-ghost h-10 px-5 text-[11px] uppercase tracking-[0.18em]"
              >
                Explore baskets
              </Link>
            </div>
          </div>

          <div className="card-glass relative overflow-hidden p-5 text-xs text-slate-700 dark:text-slate-300">
            <div className="absolute -right-10 -top-10 h-40 w-40 rounded-full bg-primary-500/20 blur-3xl" />
            <p className="text-[11px] font-bold uppercase tracking-[0.2em] text-primary-700 dark:text-slate-400">
              HOW WE INVEST
            </p>
            <div className="mt-3 space-y-3">
              {approachItems.map((item) => (
                <div
                  key={item.title}
                  className="flex items-start justify-between gap-3 rounded-2xl bg-gradient-to-br from-slate-50 to-slate-100/50 px-3 py-2.5 dark:bg-slate-900/80"
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
          {approachItems.map((item) => (
            <article
              key={item.title}
              className="card-glass flex flex-col justify-between px-5 py-4 text-xs text-slate-700 dark:text-slate-200"
            >
              <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-slate-500 dark:text-slate-400">
                {item.title}
              </p>
              <p className="mt-2 leading-relaxed">{item.body}</p>
            </article>
          ))}
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
              One research layer across instruments – from mutual funds to stock baskets.
            </p>
          </div>
        </div>
        <div className="grid gap-4 sm:grid-cols-3 lg:grid-cols-4">
          {instruments.map((label, idx) => (
            <article
              key={label}
              className="card-glass group flex items-center justify-between px-4 py-3 text-xs text-slate-700 transition-all duration-300 dark:text-slate-200 animate-scale-in hover:border-primary-300"
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
        <div className="card-glass p-5 text-sm text-slate-700 dark:text-slate-300 animate-scale-in stagger-1">
          <ul className="space-y-2">
            <li className="flex items-start gap-2"><span className="text-primary-600 font-bold">•</span> Research‑backed mutual‑fund journeys through the AlphaNifty app.</li>
            <li className="flex items-start gap-2"><span className="text-primary-600 font-bold">•</span> Stock baskets that package themes and factors into explainable portfolios.</li>
            <li className="flex items-start gap-2"><span className="text-primary-600 font-bold">•</span> Support for HNI and advisor workflows, not just DIY investors.</li>
            <li className="flex items-start gap-2"><span className="text-primary-600 font-bold">•</span> Transparent narratives and regular communication instead of jargon.</li>
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

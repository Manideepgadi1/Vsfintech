import { NavLink, Link } from 'react-router-dom';
import { useEffect, useState } from 'react';

const navLinkBase =
  'text-sm font-medium tracking-wide transition-colors duration-200 px-3 py-1.5 rounded-full';

export function Navbar() {
  const [theme, setTheme] = useState<'light' | 'dark'>(() => {
    if (typeof window === 'undefined') return 'light';
    return (localStorage.getItem('vs-theme') as 'light' | 'dark') || 'light';
  });

  const [showToolsMenu, setShowToolsMenu] = useState(false);

  useEffect(() => {
    const root = window.document.documentElement;
    if (theme === 'dark') {
      root.classList.add('dark');
    } else {
      root.classList.remove('dark');
    }
    localStorage.setItem('vs-theme', theme);
  }, [theme]);

  const toggleTheme = () => {
    setTheme((prev) => (prev === 'dark' ? 'light' : 'dark'));
  };

  return (
    <header className="sticky top-0 z-40 border-b border-slate-200/70 bg-white/98 backdrop-blur-sm">
      <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-4 sm:px-6 lg:px-0">
        <div className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-2xl bg-primary-600 text-lg font-bold text-white shadow-sm shadow-primary-500/40">
            VS
          </div>
          <div className="flex flex-col leading-tight">
            <span className="text-sm font-bold tracking-wide text-slate-900 dark:text-slate-50">VS Fintech</span>
            <span className="text-[10px] font-semibold uppercase tracking-[0.2em] text-primary-600 dark:text-primary-400">
              Quant · Research · Baskets
            </span>
          </div>
        </div>

        <nav className="hidden items-center gap-1.5 rounded-full border border-slate-200/80 bg-white px-2 py-1.5 shadow-sm dark:border-slate-800 dark:bg-slate-900/80 dark:shadow-slate-900/60 md:flex">
          <NavLink
            to="/"
            className={({ isActive }) =>
              `${navLinkBase} ${
                isActive
                  ? 'bg-gradient-to-r from-primary-500 to-primary-600 text-white shadow-md shadow-primary-500/30'
                  : 'text-slate-700 hover:bg-white hover:text-primary-600 hover:shadow-sm dark:text-slate-300 dark:hover:bg-slate-800 dark:hover:text-white'
              }`
            }
          >
            Home
          </NavLink>
          <NavLink
            to="/baskets"
            className={({ isActive }) =>
              `${navLinkBase} ${
                isActive
                  ? 'bg-gradient-to-r from-primary-500 to-primary-600 text-white shadow-md shadow-primary-500/30'
                  : 'text-slate-700 hover:bg-white hover:text-primary-600 hover:shadow-sm dark:text-slate-300 dark:hover:bg-slate-800 dark:hover:text-white'
              }`
            }
          >
            Baskets
          </NavLink>
            <NavLink
              to="/about"
              className={({ isActive }) =>
                `${navLinkBase} ${
                  isActive
                    ? 'bg-gradient-to-r from-primary-500 to-primary-600 text-white shadow-md shadow-primary-500/30'
                    : 'text-slate-700 hover:bg-white hover:text-primary-600 hover:shadow-sm dark:text-slate-300 dark:hover:bg-slate-800 dark:hover:text-white'
                }`
              }
            >
              About
            </NavLink>
            <NavLink
              to="/profile"
              className={({ isActive }) =>
                `${navLinkBase} ${
                  isActive
                    ? 'bg-gradient-to-r from-primary-500 to-primary-600 text-white shadow-md shadow-primary-500/30'
                    : 'text-slate-700 hover:bg-white hover:text-primary-600 hover:shadow-sm dark:text-slate-300 dark:hover:bg-slate-800 dark:hover:text-white'
                }`
              }
            >
              Profile
            </NavLink>
            <NavLink
              to="/services"
              className={({ isActive }) =>
                `${navLinkBase} ${
                  isActive
                    ? 'bg-gradient-to-r from-primary-500 to-primary-600 text-white shadow-md shadow-primary-500/30'
                    : 'text-slate-700 hover:bg-white hover:text-primary-600 hover:shadow-sm dark:text-slate-300 dark:hover:bg-slate-800 dark:hover:text-white'
                }`
              }
            >
              Services
            </NavLink>
            <NavLink
              to="/gallery"
              className={({ isActive }) =>
                `${navLinkBase} ${
                  isActive
                    ? 'bg-gradient-to-r from-primary-500 to-primary-600 text-white shadow-md shadow-primary-500/30'
                    : 'text-slate-700 hover:bg-white hover:text-primary-600 hover:shadow-sm dark:text-slate-300 dark:hover:bg-slate-800 dark:hover:text-white'
                }`
              }
            >
              Gallery
            </NavLink>
            <div
              className="relative"
              onMouseEnter={() => setShowToolsMenu(true)}
              onMouseLeave={() => setShowToolsMenu(false)}
            >
              <button
                type="button"
                className={`${navLinkBase} text-slate-700 hover:bg-white hover:text-primary-600 hover:shadow-sm dark:text-slate-300 dark:hover:bg-slate-800 dark:hover:text-white flex items-center gap-1 cursor-pointer`}
              >
                Tools
                <svg className="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                </svg>
              </button>
              {showToolsMenu && (
                <div className="absolute right-0 top-full pt-2">
                  <div className="w-56 overflow-hidden rounded-2xl border border-slate-200/80 bg-white shadow-2xl dark:border-slate-800 dark:bg-slate-900">
                    <div className="space-y-1 p-2">
                      <Link
                        to="/tools/fundoscope"
                        className="block cursor-pointer rounded-xl bg-gradient-to-r from-primary-50 to-primary-100 py-2.5 px-5 text-sm font-semibold text-primary-700 transition-all hover:from-primary-100 hover:to-primary-200 hover:shadow-sm dark:from-primary-500/10 dark:to-primary-500/20 dark:text-primary-400 dark:hover:from-primary-500/20 dark:hover:to-primary-500/30"
                      >
                        Fundoscope ⭐
                      </Link>
                      {[
                        { name: 'Advanced Fund Screener', path: '/tools/fundscreener2' },
                        { name: 'Basic Fund Screener', path: '/tools/fund-screener' },
                        { name: 'Fund Selection', path: '/tools/fund-selection' },
                        { name: 'Stock Radar', path: '/tools/stock-radar' },
                        { name: 'NASDAQ', path: '/tools/nasdaq' },
                        { name: 'MF & Stocks', path: '/tools/mf-stocks' },
                        { name: 'Fund Baskets', path: '/tools/mf-baskets' },
                        { name: 'Investment Calculator', path: '/tools/calculator' },
                        { name: 'Equity Baskets', path: '/tools/stocks-basket' },
                        { name: 'Blog', path: '/blog' },
                      ].map((tool) => (
                        <Link
                          key={tool.path}
                          to={tool.path}
                          className="block cursor-pointer rounded-xl py-2.5 px-5 text-sm font-medium text-slate-700 transition-all hover:bg-slate-100 hover:text-primary-600 dark:text-slate-300 dark:hover:bg-slate-800"
                        >
                          {tool.name}
                        </Link>
                      ))}
                    </div>
                  </div>
                </div>
              )}
            </div>
          <Link
            to="/contact"
            className="button-primary hidden text-sm font-semibold md:block"
          >
            Contact Us
          </Link>
        </nav>

        <div className="flex items-center gap-3">
          <button
            onClick={toggleTheme}
            className="flex h-10 w-10 items-center justify-center rounded-xl border border-slate-200/80 bg-white text-slate-700 transition-all hover:bg-primary-50 hover:text-primary-600 hover:border-primary-200 hover:shadow-md dark:border-slate-800 dark:bg-slate-900 dark:text-slate-300 dark:hover:bg-slate-800"
            aria-label="Toggle theme"
          >
            {theme === 'dark' ? (
              <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
              </svg>
            ) : (
              <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
              </svg>
            )}
          </button>
        </div>
      </div>
    </header>
  );
}

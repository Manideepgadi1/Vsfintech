export function Footer() {
  return (
    <footer className="border-t border-slate-800/80 bg-slate-950/90">
      <div className="mx-auto flex max-w-6xl flex-col gap-4 px-4 py-6 text-xs text-slate-400 sm:px-6 lg:px-0">
        <div className="flex flex-wrap items-center justify-center gap-3 text-[11px] sm:justify-start">
          <a href="/privacy-policy" className="hover:text-slate-200">
            Privacy policy
          </a>
          <span className="h-0.5 w-0.5 rounded-full bg-slate-600" />
          <a href="/refund-policy" className="hover:text-slate-200">
            Cancellation &amp; refund policy
          </a>
          <span className="h-0.5 w-0.5 rounded-full bg-slate-600" />
          <a href="/terms-and-conditions" className="hover:text-slate-200">
            Terms &amp; conditions
          </a>
          <span className="h-0.5 w-0.5 rounded-full bg-slate-600" />
          <a href="/shipping-policy" className="hover:text-slate-200">
            Shipping &amp; delivery
          </a>
        </div>
        <div className="flex flex-col items-center justify-between gap-3 pt-2 sm:flex-row">
          <p className="tracking-wide text-center sm:text-left">
            VS Fintech · SEBI Registered Research Analyst · Markets involve risk. Please read all
            related documents carefully before investing.
          </p>
          <p className="text-center sm:text-right">
            © {new Date().getFullYear()} VS Fintech. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}

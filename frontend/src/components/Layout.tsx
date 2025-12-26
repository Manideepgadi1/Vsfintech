import type { ReactNode } from 'react';
import { Navbar } from './Navbar';
import { Footer } from './Footer';

interface LayoutProps {
  children: ReactNode;
}

export function Layout({ children }: LayoutProps) {
  return (
    <div className="flex min-h-screen flex-col bg-white text-slate-900">
      <Navbar />
      <main className="flex-1 bg-white">
        <div className="mx-auto max-w-6xl px-4 pb-16 pt-8 sm:px-6 lg:px-0 lg:pt-10">
          {children}
        </div>
      </main>
      <Footer />
    </div>
  );
}

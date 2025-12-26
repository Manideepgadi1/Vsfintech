import type { FC } from 'react';
import { Link } from 'react-router-dom';

const blogPosts = [
  {
    id: 'start-early-grow-smart-sips',
    title: 'Start Early, Grow Smart: The Power of SIPs for Beginners',
    excerpt: "The Magic of Starting Early: Meet Amit and Ravi, college friends who started their careers together. Amit began investing ₹5,000 a month in SIPs right from age 20...",
    date: '7 days ago',
    readTime: '3 min read',
    image: 'https://static.wixstatic.com/media/9b0262_52064031e2a64e0289cefadf839f90ff~mv2.png',
  },
  {
    id: 'fundoscope-data-analytics',
    title: 'Fundoscope - Innovative Data Analytics for Intelligent Investment Decisions',
    excerpt: "🏦 Fundoscope: The Future of Mutual Fund Research and Data Analytics. In today's investment landscape, data is everything. The challenge isn't access to information — it's making sense of it.",
    date: 'Oct 28',
    readTime: '2 min read',
    image: 'https://static.wixstatic.com/media/9b0262_52064031e2a64e0289cefadf839f90ff~mv2.png',
  },
  {
    id: 'finwisepro-mutual-fund-education',
    title: 'FinwisePro – Innovate. Educate. Invest. The Future of Mutual Fund Learning in India',
    excerpt: "In a world where financial independence is becoming increasingly vital, knowledge is the first investment. FinwisePro was built on a simple yet powerful idea — to educate investors before they invest.",
    date: 'Oct 28',
    readTime: '2 min read',
    image: 'https://static.wixstatic.com/media/9b0262_543224488e0249928a87c061927503a9~mv2.png',
  },
];

export const BlogPage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">BLOG</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Research Notes &amp; Market Commentary
        </h1>
        <p className="max-w-3xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          Our latest thinking on markets, fund selection, portfolio construction, and
          data-driven investing strategies.
        </p>
      </section>

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {blogPosts.map((post, idx) => (
          <Link
            key={post.id}
            to={`/blog/${post.id}`}
            className="card-glass group p-6 block animate-fade-in-up"
            style={{ animationDelay: `${idx * 0.1}s` }}
          >
            <div className="mb-4 aspect-video overflow-hidden rounded-lg bg-slate-100 dark:bg-slate-800">
              <img
                src={post.image}
                alt={post.title}
                className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"
              />
            </div>
            <div className="flex items-center gap-2 text-xs text-slate-500 dark:text-slate-400">
              <span>{post.date}</span>
              <span>•</span>
              <span>{post.readTime}</span>
            </div>
            <h3 className="mt-3 text-base font-semibold leading-snug text-slate-900 transition-colors group-hover:text-primary-600 dark:text-slate-50 dark:group-hover:text-primary-400">
              {post.title}
            </h3>
            <p className="mt-2 line-clamp-3 text-sm leading-relaxed text-slate-600 dark:text-slate-300">
              {post.excerpt}
            </p>
            <div className="mt-4 flex items-center gap-2 text-xs font-semibold text-primary-600 dark:text-primary-400">
              Read more
              <svg className="h-4 w-4 transition-transform group-hover:translate-x-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 8l4 4m0 0l-4 4m4-4H3" />
              </svg>
            </div>
          </Link>
        ))}
      </div>
    </div>
  );
};

import type { FC } from 'react';
import { useParams, Link } from 'react-router-dom';

const blogPostsData: Record<string, {
  title: string;
  date: string;
  readTime: string;
  image: string;
  content: string[];
}> = {
  'start-early-grow-smart-sips': {
    title: 'Start Early, Grow Smart: The Power of SIPs for Beginners',
    date: '7 days ago',
    readTime: '3 min read',
    image: 'https://static.wixstatic.com/media/9b0262_52064031e2a64e0289cefadf839f90ff~mv2.png',
    content: [
      "The Magic of Starting Early: Meet Amit and Ravi, college friends who started their careers together. Amit began investing ₹5,000 a month in SIPs right from age 20. Ravi thought, 'Let me wait a few years until I earn more.' He started at 30.",
      "Here's the twist:",
      "Investor: Amit | Start Age: 20 | Monthly SIP: ₹5,000 | Duration: 45 years | Total Invested: ₹27 Lakhs | Total Returns (12%): ₹8.4 Crores | Maturity Amount: ₹8.67 Crores",
      "Investor: Ravi | Start Age: 30 | Monthly SIP: ₹5,000 | Duration: 35 years | Total Invested: ₹21 Lakhs | Total Returns (12%): ₹2.54 Crores | Maturity Amount: ₹2.75 Crores",
      "By the age of 65, Amit's corpus is significantly higher than Ravi's, despite starting with the same monthly investment. The key difference? Time and the power of compounding.",
      "Why SIPs Work for Beginners:",
      "1. Discipline & Automation – Set it and forget it. Your money grows while you focus on your career.",
      "2. Rupee Cost Averaging – Market volatility doesn't scare you. You buy more units when prices are low and fewer when high.",
      "3. No Need for Big Capital – Start with just ₹500 or ₹1,000 per month.",
      "4. Compounding Magic – The earlier you start, the more your money multiplies exponentially.",
      "The Takeaway: Don't wait for the 'perfect time' or a 'big salary.' Start small, start today. Even ₹1,000 a month can become lakhs in 10–15 years.",
      "Ready to start your SIP journey? Talk to a SEBI-registered investment advisor or explore mutual funds through trusted platforms.",
      "💬 What's stopping you from starting today? Drop a comment below!",
    ],
  },
  'fundoscope-data-analytics': {
    title: 'Fundoscope - Innovative Data Analytics for Intelligent Investment Decisions',
    date: 'Oct 28',
    readTime: '2 min read',
    image: 'https://static.wixstatic.com/media/9b0262_52064031e2a64e0289cefadf839f90ff~mv2.png',
    content: [
      "🏦 Fundoscope: The Future of Mutual Fund Research and Data Analytics",
      "In today's investment landscape, data is everything. The challenge isn't access to information — it's making sense of it. That's where Fundoscope by VS Fintech Pvt. Ltd. steps in.",
      "💡 What is Fundoscope?",
      "Fundoscope is an advanced mutual fund research and analytics platform that helps investors transform raw financial data into actionable insights. It combines artificial intelligence, data visualization, and quantitative research to empower investors with clarity and confidence.",
      "🔍 Key Features:",
      "• Deep Analytics – Performance metrics, risk ratios, portfolio holdings, and more.",
      "• Fund Comparison – Side-by-side analysis of multiple funds to find the best fit for your goals.",
      "• AI-Powered Insights – Leverages machine learning to identify trends and anomalies.",
      "• Data Visualization – Charts and dashboards that make complex data easy to understand.",
      "• Real-Time Updates – Stay informed with the latest fund performance and market movements.",
      "🎯 Who Can Benefit?",
      "• Individual Investors – Make informed decisions without relying solely on advisors.",
      "• Financial Advisors – Enhance your recommendations with data-backed insights.",
      "• Wealth Managers – Streamline research and portfolio construction for clients.",
      "🚀 Why Fundoscope Matters",
      "Traditional mutual fund research relies on basic metrics like past returns and star ratings. But smart investing goes deeper — understanding volatility, drawdowns, portfolio concentration, and consistency over time.",
      "Fundoscope brings institutional-grade analytics to retail investors, democratizing access to powerful research tools.",
      "📈 The Bottom Line",
      "In a world where everyone has access to mutual funds, the real advantage lies in understanding them better. Fundoscope equips you with the tools to invest intelligently, not impulsively.",
      "Explore Fundoscope today and elevate your mutual fund research game.",
    ],
  },
  'finwisepro-mutual-fund-education': {
    title: 'FinwisePro – Innovate. Educate. Invest. The Future of Mutual Fund Learning in India',
    date: 'Oct 28',
    readTime: '2 min read',
    image: 'https://static.wixstatic.com/media/9b0262_543224488e0249928a87c061927503a9~mv2.png',
    content: [
      "In a world where financial independence is becoming increasingly vital, knowledge is the first investment. FinwisePro was built on a simple yet powerful idea — to educate investors before they invest.",
      "FinwisePro is not a trading app or a mutual fund distributor. It's an Edutech platform dedicated to teaching mutual fund investing — from understanding the basics of SIP and NAV to mastering portfolio diversification and strategy building.",
      "🎓 What Makes FinwisePro Unique?",
      "Traditional financial education is either too theoretical or too sales-driven. FinwisePro bridges that gap by offering:",
      "• Interactive Learning Modules – Bite-sized lessons on mutual funds, SIPs, tax benefits, and risk management.",
      "• Real-World Case Studies – Learn from actual investor journeys and market scenarios.",
      "• Practical Tools & Calculators – SIP calculators, goal planners, and portfolio analyzers.",
      "• Expert-Led Webinars – Live sessions with industry professionals on market trends and strategies.",
      "• Progress Tracking – Monitor your learning journey and build confidence step by step.",
      "🚀 Why Financial Education Matters",
      "Many investors jump into mutual funds without understanding how they work — leading to panic selling during market dips or blindly following tips. FinwisePro ensures that before you invest a single rupee, you understand:",
      "• What mutual funds are and how they generate returns",
      "• The difference between equity, debt, and hybrid funds",
      "• How to select funds based on your goals and risk appetite",
      "• The importance of asset allocation and rebalancing",
      "• Tax implications and exit strategies",
      "💡 Who Should Use FinwisePro?",
      "• Beginners – Starting your investment journey and want to learn the right way.",
      "• Working Professionals – Want to manage their own investments confidently.",
      "• Students & Young Investors – Building financial literacy early for long-term success.",
      "• Parents & Educators – Teaching children and students the fundamentals of investing.",
      "📈 The FinwisePro Promise",
      "We believe that informed investors make better decisions. By the time you complete our learning path, you won't just know how to invest — you'll know why you're investing and how to stay invested through market cycles.",
      "🔗 Ready to Start Your Journey?",
      "Join thousands of learners who are taking control of their financial future. Visit FinwisePro today and discover the power of educated investing.",
      "Because the best investment you can make is in yourself.",
    ],
  },
};

export const BlogPostPage: FC = () => {
  const { postId } = useParams<{ postId: string }>();
  const post = postId ? blogPostsData[postId] : null;

  if (!post) {
    return (
      <div className="space-y-8">
        <div className="card-glass p-12 text-center">
          <h1 className="text-2xl font-semibold text-slate-900 dark:text-slate-50">
            Post Not Found
          </h1>
          <p className="mt-2 text-sm text-slate-600 dark:text-slate-300">
            The blog post you're looking for doesn't exist.
          </p>
          <Link to="/blog" className="button-primary mt-6 inline-flex px-6 py-2.5 text-xs">
            Back to Blog
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-8">
      <Link
        to="/blog"
        className="inline-flex items-center gap-2 text-sm text-slate-600 hover:text-primary-600 dark:text-slate-400 dark:hover:text-primary-400"
      >
        <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
        </svg>
        Back to Blog
      </Link>

      <article className="space-y-6">
        <header className="space-y-4">
          <div className="flex items-center gap-2 text-xs text-slate-500 dark:text-slate-400">
            <span>{post.date}</span>
            <span>•</span>
            <span>{post.readTime}</span>
          </div>
          <h1 className="text-3xl font-bold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
            {post.title}
          </h1>
        </header>

        <div className="aspect-video overflow-hidden rounded-2xl">
          <img
            src={post.image}
            alt={post.title}
            className="h-full w-full object-cover"
          />
        </div>

        <div className="prose prose-slate max-w-none dark:prose-invert">
          {post.content.map((paragraph, idx) => (
            <p
              key={idx}
              className="text-sm leading-relaxed text-slate-700 dark:text-slate-300"
            >
              {paragraph}
            </p>
          ))}
        </div>

        <div className="border-t border-slate-200 pt-6 dark:border-slate-700">
          <div className="flex items-center gap-3">
            <div className="flex h-12 w-12 items-center justify-center rounded-full bg-primary-600 text-lg font-semibold text-white">
              VS
            </div>
            <div>
              <p className="text-sm font-semibold text-slate-900 dark:text-slate-50">
                VS FINTECH
              </p>
              <p className="text-xs text-slate-600 dark:text-slate-400">
                SEBI Registered Research Analyst
              </p>
            </div>
          </div>
        </div>
      </article>
    </div>
  );
};

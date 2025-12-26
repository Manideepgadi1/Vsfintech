import { Route, Routes } from 'react-router-dom';
import { Layout } from './components/Layout';
import { HomePage } from './pages/HomePage';
import { BasketsPage } from './pages/BasketsPage';
import { BasketDetailPage } from './pages/BasketDetailPage';
import { AboutPage } from './pages/AboutPage';
import { ProfilePage } from './pages/ProfilePage';
import { ServicesPage } from './pages/ServicesPage';
import { PrivacyPolicyPage } from './pages/PrivacyPolicyPage';
import { RefundPolicyPage } from './pages/RefundPolicyPage';
import { TermsPage } from './pages/TermsPage';
import { ShippingPolicyPage } from './pages/ShippingPolicyPage';
import { FundoscopePage } from './pages/tools/FundoscopePage';
import { FundScreenerPage } from './pages/tools/FundScreenerPage';
import { Fundscreener2Page } from './pages/tools/Fundscreener2Page';
import { FundSelectionPage } from './pages/tools/FundSelectionPage';
import { StockRadarPage } from './pages/tools/StockRadarPage';
import { NasdaqPage } from './pages/tools/NasdaqPage';
import { MFStocksPage } from './pages/tools/MFStocksPage';
import { MFBasketsPage } from './pages/tools/MFBasketsPage';
import { CalculatorPage } from './pages/tools/CalculatorPage';
import { StocksBasketPage } from './pages/tools/StocksBasketPage';
import { BlogPage } from './pages/BlogPage';
import { BlogPostPage } from './pages/BlogPostPage';
import { GalleryPage } from './pages/GalleryPage';

export default function App() {
  return (
    <Layout>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/baskets" element={<BasketsPage />} />
        <Route path="/baskets/:basketId" element={<BasketDetailPage />} />
        <Route path="/about" element={<AboutPage />} />
        <Route path="/profile" element={<ProfilePage />} />
        <Route path="/services" element={<ServicesPage />} />
        <Route path="/gallery" element={<GalleryPage />} />
        <Route path="/privacy-policy" element={<PrivacyPolicyPage />} />
        <Route path="/refund-policy" element={<RefundPolicyPage />} />
        <Route path="/terms-and-conditions" element={<TermsPage />} />
        <Route path="/shipping-policy" element={<ShippingPolicyPage />} />
        <Route path="/tools/fundoscope" element={<FundoscopePage />} />
        <Route path="/tools/fund-screener" element={<FundScreenerPage />} />
        <Route path="/tools/fundscreener2" element={<Fundscreener2Page />} />
        <Route path="/tools/fund-selection" element={<FundSelectionPage />} />
        <Route path="/tools/stock-radar" element={<StockRadarPage />} />
        <Route path="/tools/nasdaq" element={<NasdaqPage />} />
        <Route path="/tools/mf-stocks" element={<MFStocksPage />} />
        <Route path="/tools/mf-baskets" element={<MFBasketsPage />} />
        <Route path="/tools/calculator" element={<CalculatorPage />} />
        <Route path="/tools/stocks-basket" element={<StocksBasketPage />} />
        <Route path="/blog" element={<BlogPage />} />
        <Route path="/blog/:postId" element={<BlogPostPage />} />
      </Routes>
    </Layout>
  );
}

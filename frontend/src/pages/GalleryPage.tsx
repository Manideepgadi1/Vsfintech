import type { FC } from 'react';

const galleryImages = [
  {
    id: 1,
    url: 'https://static.wixstatic.com/media/9b0262_db309dabe47d4a6c88cc52e5cdcaed06~mv2.png/v1/fill/w_981,h_438,fp_0.50_0.53,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/VS%20Fintech%20Gallery%20Hero.png',
    title: 'VS Fintech Gallery Hero',
    category: 'Branding',
  },
  {
    id: 2,
    url: 'https://static.wixstatic.com/media/9b0262_52064031e2a64e0289cefadf839f90ff~mv2.png',
    title: 'Fundoscope Analytics Platform',
    category: 'Products',
  },
  {
    id: 3,
    url: 'https://static.wixstatic.com/media/9b0262_e8f351f64d98448d952eb719b6e5ce49~mv2.jpg/v1/crop/x_19,y_64,w_1377,h_640/fill/w_1377,h_640,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/vsf%20theme%20(4)_edited.jpg',
    title: 'Secure Happiness Program',
    category: 'Services',
  },
  {
    id: 4,
    url: 'https://static.wixstatic.com/media/9b0262_da2d68c988434fd5a6677fef0b67020d~mv2.png/v1/crop/x_0,y_1,w_1414,h_1998/fill/w_800,h_1130,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/WEALTHLY%20WEDNESDAY%20(21).png',
    title: 'Wealthy Wednesday Series',
    category: 'Events',
  },
  {
    id: 5,
    url: 'https://static.wixstatic.com/media/9b0262_a2c54c5ebb7b40b9988186bf432bc87e~mv2.png/v1/crop/x_122,y_131,w_902,h_399/fill/w_902,h_399,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/ALPHANIFTY%20BANNERS%20(2).png',
    title: 'AlphaNifty App Banner',
    category: 'Products',
  },
  {
    id: 6,
    url: 'https://static.wixstatic.com/media/9b0262_41a0acfc7e6c42ca86f4efabd65dbe44~mv2.png/v1/fill/w_800,h_500,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/ALPHANIFTY%20BANNERS%20(1).png',
    title: 'AlphaNifty Investment Engine',
    category: 'Products',
  },
  {
    id: 7,
    url: 'https://static.wixstatic.com/media/9b0262_62a706b463a64def80395a5b09a2dfbb~mv2.jpg/v1/fill/w_800,h_336,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/sip_1.jpg',
    title: 'SIP Returns Calculator',
    category: 'Tools',
  },
  {
    id: 8,
    url: 'https://static.wixstatic.com/media/9b0262_8c75b07460ff436bafad63b6d346b21d~mv2.png/v1/fill/w_800,h_533,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/myths%20and%20facts.png',
    title: 'Investment Myths vs Facts',
    category: 'Education',
  },
  {
    id: 9,
    url: 'https://static.wixstatic.com/media/9b0262_5a86dbbfb50f4ce684902dcc802c013a~mv2.png/v1/fill/w_800,h_533,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/9b0262_5a86dbbfb50f4ce684902dcc802c013a~mv2.png',
    title: 'Client Success Stories',
    category: 'Testimonials',
  },
  {
    id: 10,
    url: 'https://static.wixstatic.com/media/9b0262_543224488e0249928a87c061927503a9~mv2.png/v1/crop/x_61,y_0,w_1026,h_1026/fill/w_600,h_600,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/logo-print-hd.png',
    title: 'VS Fintech Official Logo',
    category: 'Branding',
  },
  {
    id: 11,
    url: 'https://static.wixstatic.com/media/9b0262_31f80931dff3465e86f76cb7c5c35d3f~mv2.png/v1/crop/x_11,y_239,w_480,h_470/fill/w_600,h_588,fp_0.50_0.50,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/rtrmrf.png',
    title: 'Right Time Investment Strategy',
    category: 'Services',
  },
  {
    id: 12,
    url: 'https://static.wixstatic.com/media/9b0262_43697fdc387d4bb0998eea6437f6e4fc~mv2.png/v1/fill/w_981,h_691,fp_0.50_0.33,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/bg8.png',
    title: 'Investment Platform Background',
    category: 'Branding',
  },
];

export const GalleryPage: FC = () => {
  return (
    <div className="space-y-8">
      <section className="space-y-3 text-center">
        <p className="text-xs font-semibold tracking-[0.2em] text-emerald-500">OUR GALLERY</p>
        <h1 className="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-50 sm:text-4xl">
          Celebrating Moments and Milestones
        </h1>
        <p className="mx-auto max-w-2xl text-sm leading-relaxed text-slate-600 dark:text-slate-300">
          Explore our journey through key events, achievements, product launches, and team
          celebrations at VS Fintech.
        </p>
      </section>

      <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {galleryImages.map((image, idx) => (
          <article
            key={image.id}
            className="card-glass group overflow-hidden p-0 animate-scale-in"
            style={{ animationDelay: `${idx * 0.1}s` }}
          >
            <div className="aspect-video overflow-hidden bg-slate-100 dark:bg-slate-800">
              <img
                src={image.url}
                alt={image.title}
                className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-110"
                onError={(e) => {
                  const target = e.target as HTMLImageElement;
                  target.src = 'https://via.placeholder.com/800x450/1e293b/64748b?text=VS+Fintech';
                }}
              />
            </div>
            <div className="p-4">
              <p className="text-xs font-semibold uppercase tracking-[0.16em] text-primary-600 dark:text-primary-400">
                {image.category}
              </p>
              <h3 className="mt-1 text-sm font-semibold text-slate-900 dark:text-slate-50">
                {image.title}
              </h3>
            </div>
          </article>
        ))}
      </div>

      {galleryImages.length === 0 && (
        <div className="card-glass p-12 text-center">
          <div className="mx-auto mb-4 h-16 w-16 rounded-full bg-primary-500/10 flex items-center justify-center">
            <svg className="h-8 w-8 text-primary-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
          </div>
          <h2 className="text-lg font-semibold text-slate-900 dark:text-slate-50">
            Gallery Coming Soon
          </h2>
          <p className="mt-2 text-sm text-slate-600 dark:text-slate-300">
            We're curating moments from our journey. Check back soon!
          </p>
        </div>
      )}
    </div>
  );
};

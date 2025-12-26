import type { FC } from 'react';
import { useScrollAnimation } from '../hooks/useScrollAnimation';

const teamMembers = [
  {
    id: 1,
    name: 'Mr. Srinivas Vadapalli',
    position: 'Founding Director & Chief Executive Officer (CEO)',
    image: 'https://static.wixstatic.com/media/9b0262_e6089bf371f24676a541339ce15f4b83~mv2.jpeg/v1/fill/w_400,h_600,fp_0.56_0.28,q_90,enc_auto/Srinivas.jpeg',
    bio: [
      'With over two decades of industry experience, Mr. Srinivas Vadapalli brings exceptional leadership and vision to VS Fintech. His extensive background in electrical engineering and industrial solutions has evolved into pioneering work in financial technology, where he excels in strategic planning and data analysis.',
      'As the founder and full-time director, Mr. Vadapalli oversees the company\'s strategic direction, product development, and market expansion initiatives. His core strengths in identifying market opportunities and developing innovative financial solutions have been instrumental in positioning VS Fintech as an industry leader.',
      'Mr. Vadapalli\'s foundation in data science and commitment to technological advancement continues to drive the company\'s mission to revolutionize financial services through cutting-edge technology and insightful market analysis.',
    ],
  },
  {
    id: 2,
    name: 'Mr. Rishindra Maddila',
    position: 'Director & Chief Technology Officer (CTO)',
    image: 'https://static.wixstatic.com/media/9b0262_f1cca75b7bbe4d948144be455acf0c2b~mv2.jpg/v1/fill/w_400,h_560,al_c,q_90,enc_auto/image%20(22)_edited_edited.jpg',
    bio: [
      'Mr. Rishindra Maddila, an IIT Mumbai alumnus, brings elite technical expertise to VS Fintech as our Chief Technology Officer. Prior to joining our team, he served as Senior Manager at Uber, where he honed his skills in developing scalable technology solutions for complex business challenges.',
      'At VS Fintech, Mr. Maddila leads our technology strategy, focusing on building robust data architecture, innovative financial systems, and cutting-edge cloud infrastructure. His expertise in big data analytics and AI-driven decision systems has been crucial in developing our proprietary financial technology platforms.',
      'With a passion for emerging technologies and a deep understanding of financial markets, Mr. Maddila continues to push the boundaries of what\'s possible in fintech, ensuring VS Fintech remains at the forefront of technological innovation in the financial sector.',
    ],
  },
  {
    id: 3,
    name: 'Dr. Satish Vadapalli',
    position: 'Director – Research & Chief Investment Officer (CIO)',
    image: 'https://static.wixstatic.com/media/9b0262_b82fba01ddb24de6afe6eb70179820d8~mv2.jpeg/v1/crop/x_94,y_0,w_550,h_599/fill/w_400,h_436,al_c,q_90,enc_auto/satish.jpeg',
    bio: [
      'Dr. Satish Vadapalli brings over 18 years of experience in quantitative research and market analysis to his role at VS Fintech. As our senior Equity Research Analyst, he specializes in developing sophisticated models for risk optimization and market forecasting.',
      'His groundbreaking work includes the creation of "Alphanifty," a proprietary algorithm that has significantly enhanced our equity research capabilities and investment strategies. Dr. Vadapalli\'s contributions to financial analysis have established new benchmarks in the industry for accuracy and insight.',
      'As the author of "The Monetary Management Textbook," Dr. Vadapalli is recognized as a thought leader in financial theory and practice. His academic rigor combined with practical market experience makes him an invaluable asset to our research team and clients seeking data-driven investment guidance.',
    ],
  },
  {
    id: 4,
    name: 'Ms. Sesha Prasanna Lakshmi Vadapalli',
    position: 'Director – Compliance & Corporate Affairs',
    image: 'https://static.wixstatic.com/media/9b0262_76625076d44d48dea6cba3ea2e38f61b~mv2.jpg/v1/fill/w_400,h_510,al_c,q_90,enc_auto/image%20(52)_edited.jpg',
    bio: [
      'Ms. Prasanna plays a key role on the leadership team at VS Fintech, bringing strong administrative acumen and a deep understanding of compliance oversight. Her expertise ensures that the company operates with integrity, transparency, and adherence to regulatory standards.',
      'In her role as Director, she manages stakeholder communication and builds effective bridges between the company, its partners, and its clients. Her ability to streamline processes and maintain accountability strengthens the trust and confidence that stakeholders place in VS Fintech.',
      'As the company continues to expand, Ms. Prasanna contributes to operational scalability and governance, ensuring that growth is both sustainable and well-structured. Her leadership focus lies in aligning compliance, administration, and strategic goals with the long-term vision of VS Fintech.',
    ],
  },
  {
    id: 5,
    name: 'Mr. Vaddi Manoj Kumar',
    position: 'Business Development & Marketing Head',
    image: 'https://static.wixstatic.com/media/9b0262_cc79339e4f4f4c03ab2d08a9118af2a9~mv2.jpeg/v1/fill/w_400,h_400,al_c,q_90,enc_auto/Mr_%20Manoj%20Kumar%20Vaddi.jpeg',
    bio: [
      'Mr. Vaddi Manoj Kumar, an MBA graduate with specialized training in finance, brings a dynamic blend of analytical and creative skills to VS Fintech. His background in wealth management and marketing provides a unique perspective that bridges financial analysis with effective client communication.',
      'As Junior Research Analyst and Marketing Head, Mr. Kumar plays a dual role in conducting market research and developing compelling marketing strategies that effectively communicate our financial solutions to clients. His proficiency with tools like Power BI and Google Data Studio enables him to transform complex financial data into accessible insights.',
      'Mr. Kumar\'s professional certifications and continuous pursuit of knowledge in emerging financial technologies make him an adaptable and forward-thinking member of our team, particularly skilled at identifying new market opportunities and client needs.',
    ],
  },
  {
    id: 6,
    name: 'Ms. Supriya Monika Arji',
    position: 'Fintech & Data Analyst | UI/UX Designer',
    image: 'https://static.wixstatic.com/media/9b0262_e50dc0a279134291b11884f345c37069~mv2.jpeg/v1/fill/w_400,h_450,al_c,q_90,enc_auto/supriya.jpeg',
    bio: [
      'Ms. Supriya Monika Arji brings versatility and creative problem-solving to VS Fintech as our Operations Manager and Data Analyst. Her additional expertise in Front-End Design, UI/UX Development, and Office Coordination makes her an essential team member who bridges technical operations with user experience.',
      'With exceptional skills in Figma and website design, Ms. Arji has been instrumental in developing the intuitive interfaces that make our financial tools accessible and user-friendly. Her data analysis capabilities complement her design work, ensuring that our platforms are both visually appealing and functionally powerful.',
      'As co-author of "The Monetary Management Textbook," Ms. Arji has demonstrated her deep understanding of financial principles and their practical applications. Her holistic approach to operations management and commitment to excellence continue to enhance both our internal processes and client-facing solutions.',
    ],
  },
  {
    id: 7,
    name: 'Mr. Sai Bhaskar Reddy',
    position: 'Full Stack Developer | VS Fintech',
    image: 'https://static.wixstatic.com/media/9b0262_bcf96fe877854073a76333e4ef320181~mv2.jpg/v1/fill/w_400,h_472,al_c,q_90,enc_auto/Screenshot_20240507_092255_Instagram_edited_edited.jpg',
    bio: [
      'Sai Bhaskar is a committed and versatile Full Stack Developer at VS Fintech, where he ensures the backbone of our platforms runs smoothly, securely, and efficiently. With expertise in Java, JavaScript, SQL, RESTful APIs, and data management, he is responsible for building scalable systems and robust databases that power our fintech solutions.',
      'At VS Fintech, Bhaskar plays a crucial role in developing and maintaining back-end systems, APIs, and optimized relational databases. He supports the core logic behind equity analysis, SIP automation, and goal-tracking modules, ensuring accuracy, security, and high performance at scale.',
      'Bhaskar\'s commitment to clean, efficient, and scalable code drives the delivery of smooth and reliable financial solutions. With a constant passion for learning and adapting to new technologies, he continues to strengthen VS Fintech\'s mission of building smarter, faster, and more secure fintech products.',
    ],
  },
  {
    id: 8,
    name: 'Dr. Tara Krishna Dusanapudi',
    position: 'Micro-Cap Research Advisor | VS Fintech',
    image: 'https://static.wixstatic.com/media/9b0262_1fc514d2216f44a987ba2777dc61381e~mv2.jpeg/v1/fill/w_400,h_516,al_c,q_90,enc_auto/tara.jpeg',
    bio: [
      'Dr. Tara Krishna Dusanapudi brings a unique combination of medical expertise and financial insight to VS Fintech, serving as the firm\'s Micro-Cap Research Advisor. With over a decade of experience as a stock market analyst, he specializes in uncovering high-potential opportunities within micro-cap and emerging growth companies—segments often overlooked by mainstream research.',
      'A medical doctor by training, with an MD in General Medicine, Dr. Tara applies the precision, critical thinking, and long-term vision of the healthcare field to financial markets. This disciplined and data-driven approach allows him to conduct rigorous fundamental research, assess risks effectively, and evaluate companies with the same analytical depth he once applied in medicine.',
      'At VS Fintech, Dr. Tara plays a vital role in scouting and analyzing under-the-radar micro-cap stocks, conducting detailed sector research, and monitoring market sentiment. His rare blend of clinical logic and financial acumen brings conviction, depth, and a contrarian edge to the firm\'s research-driven investment philosophy.',
    ],
  },
];

const TeamMemberCard: FC<{ member: typeof teamMembers[0]; index: number }> = ({ member, index }) => {
  const { elementRef, isVisible } = useScrollAnimation();

  return (
    <article
      ref={elementRef}
      className={`card-glass overflow-hidden transition-all duration-700 ${
        isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'
      }`}
      style={{ transitionDelay: `${index * 0.1}s` }}
    >
      <div className="grid gap-6 md:grid-cols-[200px_1fr] lg:grid-cols-[240px_1fr]">
        {/* Image Section */}
        <div className="relative overflow-hidden bg-gradient-to-br from-primary-500/10 to-emerald-500/5 flex items-center justify-center p-6">
          <div className="relative group">
            <div className="absolute inset-0 bg-gradient-to-br from-primary-400 to-emerald-400 rounded-2xl blur-xl opacity-20 group-hover:opacity-30 transition-opacity duration-500"></div>
            <img
              src={member.image}
              alt={member.name}
              className="relative w-40 h-40 md:w-48 md:h-48 lg:w-56 lg:h-56 object-cover rounded-2xl border-2 border-primary-500/20 shadow-xl transform transition-all duration-500 group-hover:scale-105 group-hover:border-primary-500/40"
              onError={(e) => {
                const target = e.target as HTMLImageElement;
                target.src = 'https://via.placeholder.com/240x240/1e293b/64748b?text=' + member.name.split(' ')[0];
              }}
            />
          </div>
        </div>

        {/* Content Section */}
        <div className="p-6 space-y-4">
          <div className="space-y-2">
            <h3 className="text-xl font-bold text-slate-900 dark:text-slate-50 tracking-tight">
              {member.name}
            </h3>
            <p className="text-sm font-semibold text-primary-600 dark:text-primary-400 tracking-wide">
              {member.position}
            </p>
          </div>

          <div className="space-y-3">
            {member.bio.map((paragraph, idx) => (
              <p
                key={idx}
                className="text-sm leading-relaxed text-slate-600 dark:text-slate-300"
              >
                {paragraph}
              </p>
            ))}
          </div>
        </div>
      </div>
    </article>
  );
};

export const ProfilePage: FC = () => {
  const { elementRef: heroRef, isVisible: heroVisible } = useScrollAnimation();

  return (
    <div className="space-y-12">
      {/* Hero Section */}
      <section
        ref={heroRef}
        className={`relative overflow-hidden rounded-3xl transition-all duration-1000 ${
          heroVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'
        }`}
      >
        {/* Background Image with Overlay */}
        <div className="absolute inset-0">
          <img
            src="https://static.wixstatic.com/media/9b0262_7e3e46ab74984726add3224e428febe8~mv2.png/v1/fill/w_981,h_388,fp_0.50_0.52,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/image%20(37).png"
            alt="VS Fintech Team"
            className="w-full h-full object-cover"
          />
          <div className="absolute inset-0 bg-gradient-to-r from-slate-900/95 via-slate-900/85 to-slate-900/75 dark:from-slate-950/95 dark:via-slate-950/90 dark:to-slate-950/80"></div>
        </div>

        {/* Hero Content */}
        <div className="relative px-8 py-20 md:py-28 lg:py-32 space-y-6 max-w-4xl">
          <div className="space-y-3">
            <p className="text-xs font-semibold tracking-[0.2em] text-primary-400 uppercase animate-fade-in">
              Our Team
            </p>
            <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold text-white tracking-tight animate-fade-in-up">
              Meet the Experts Behind VS Fintech
            </h1>
          </div>
          <p className="text-base md:text-lg leading-relaxed text-slate-300 max-w-3xl animate-fade-in-up" style={{ animationDelay: '0.2s' }}>
            Our team brings together decades of experience in financial technology, data science, market analysis, and strategic innovation. With diverse backgrounds spanning from engineering to finance, we combine technical expertise with market insight to deliver cutting-edge financial solutions that drive real results for our clients.
          </p>
        </div>
      </section>

      {/* Intro Text */}
      <section className="text-center space-y-4 px-4">
        <p className="text-lg md:text-xl text-slate-700 dark:text-slate-200 font-medium max-w-3xl mx-auto">
          We create the products of the future. Our cutting-edge technology, visionary team, and unrelenting work ethic put us miles ahead of the competition.
        </p>
      </section>

      {/* Team Members Grid */}
      <section className="space-y-8">
        {teamMembers.map((member, index) => (
          <TeamMemberCard key={member.id} member={member} index={index} />
        ))}
      </section>
    </div>
  );
};

import { Link } from 'react-router-dom'
import { Menu, Globe } from 'lucide-react'
import { useLanguage } from '@/contexts/LanguageContext'
import { useState } from 'react'

export default function LandingPage() {
  const { language, setLanguage, t } = useLanguage()
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)

  return (
    <div className="bg-gradient-to-br from-cyan-50 via-blue-50 to-slate-50 min-h-screen">
      {/* Login Link */}
      <Link 
        to="/connexion" 
        className="fixed top-5 right-5 z-[1000] text-xs text-gray-600 hover:text-cyan-700 underline opacity-70 hover:opacity-100 transition-opacity font-medium"
      >
        {t('nav.login')}
      </Link>

      {/* Navigation */}
      <nav className="fixed top-0 left-0 right-0 z-50 nav-sticky dolphin-wave">
        <div className="container mx-auto px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <svg className="w-10 h-10 text-cyan-600" fill="currentColor" viewBox="0 0 24 24">
                <path d="M19.5 12c0-1.77-.96-3.31-2.39-4.16C17.77 6.58 18 5.08 18 4.5c0-1.88-.91-2.5-2-2.5-1.45 0-2.78.76-3.92 1.64C11.35 3.23 10.68 3 10 3c-3.87 0-7 3.13-7 7 0 2.21 1.03 4.18 2.63 5.45C5.23 16.25 5 17.1 5 18c0 2.21 1.79 4 4 4 .74 0 1.43-.21 2.03-.56C12.16 22.42 13.54 23 15 23c2.21 0 4-1.79 4-4 0-.89-.3-1.72-.78-2.38 1.18-.82 1.78-2.14 1.78-3.62zm-9.5 8c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z"/>
              </svg>
              <span className="text-3xl font-bold bg-gradient-to-r from-cyan-700 via-blue-700 to-cyan-600 bg-clip-text text-transparent">Les Dauphins</span>
            </div>
            
            {/* Desktop Nav */}
            <div className="hidden md:flex items-center space-x-8">
              <a href="#histoire" className="text-gray-700 hover:text-cyan-600 transition font-medium">{t('nav.history')}</a>
              <a href="#plateau" className="text-gray-700 hover:text-cyan-600 transition font-medium">{t('nav.plateau')}</a>
              <a href="#contact" className="text-gray-700 hover:text-cyan-600 transition font-medium">{t('nav.contact')}</a>
              <button
                onClick={() => setLanguage(language === 'fr' ? 'en' : 'fr')}
                className="flex items-center space-x-2 px-4 py-2 rounded-full bg-gradient-to-r from-cyan-500 to-blue-500 text-white hover:from-cyan-600 hover:to-blue-600 transition-all shadow-md"
              >
                <Globe className="w-4 h-4" />
                <span className="font-semibold text-sm">{language === 'fr' ? 'EN' : 'FR'}</span>
              </button>
            </div>
            
            {/* Mobile Menu */}
            <button onClick={() => setMobileMenuOpen(!mobileMenuOpen)} className="md:hidden text-gray-700">
              <Menu className="w-6 h-6" />
            </button>
          </div>
          
          {mobileMenuOpen && (
            <div className="md:hidden mt-4 pb-4 space-y-3 slide-in">
              <a href="#histoire" className="block text-gray-700 hover:text-cyan-600 py-2">{t('nav.history')}</a>
              <a href="#plateau" className="block text-gray-700 hover:text-cyan-600 py-2">{t('nav.plateau')}</a>
              <a href="#contact" className="block text-gray-700 hover:text-cyan-600 py-2">{t('nav.contact')}</a>
              <button onClick={() => setLanguage(language === 'fr' ? 'en' : 'fr')} className="px-4 py-2 rounded-full bg-gradient-to-r from-cyan-500 to-blue-500 text-white text-sm">
                <Globe className="w-4 h-4 inline mr-2" />
                {language === 'fr' ? 'English' : 'Français'}
              </button>
            </div>
          )}
        </div>
      </nav>

      {/* Hero */}
      <section className="hero-gradient text-white pt-32 pb-20 mt-16 relative">
        <div className="container mx-auto px-6 relative z-10">
          <div className="text-center fade-in">
            <h1 className="text-5xl md:text-7xl font-bold mb-6 drop-shadow-lg">{t('hero.title')}</h1>
            <p className="text-xl md:text-2xl mb-8 text-cyan-100 max-w-3xl mx-auto">{t('hero.subtitle')}</p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <a href="#histoire" className="btn-ocean px-8 py-4 rounded-full font-semibold shadow-lg">{t('hero.cta1')}</a>
              <a href="#contact" className="border-2 border-white text-white px-8 py-4 rounded-full font-semibold hover:bg-white hover:text-cyan-700 transition">{t('hero.cta2')}</a>
            </div>
          </div>
        </div>
        <div className="absolute bottom-0 left-0 right-0">
          <svg viewBox="0 0 1440 120" fill="none" className="w-full">
            <path d="M0 120L60 110C120 100 240 80 360 70C480 60 600 60 720 65C840 70 960 80 1080 85C1200 90 1320 90 1380 90L1440 90V120H0Z" fill="rgba(240, 253, 255, 0.3)"/>
          </svg>
        </div>
      </section>

      {/* History */}
      <section id="histoire" className="py-20 bg-white">
        <div className="container mx-auto px-6">
          <h2 className="text-4xl md:text-5xl font-bold text-gray-800 mb-8 text-center text-ocean">{t('history.title')}</h2>
          <div className="max-w-4xl mx-auto glass-card-ocean rounded-2xl p-8 md:p-12 shadow-xl hover-lift">
            <p className="text-lg mb-6 leading-relaxed text-gray-700">{t('history.p1')}</p>
            <p className="text-lg mb-6 leading-relaxed text-gray-700">{t('history.p2')}</p>
            <p className="text-lg leading-relaxed text-gray-700">{t('history.p3')}</p>
          </div>
        </div>
      </section>

      {/* Plateau */}
      <section id="plateau" className="py-20 bg-gradient-to-br from-cyan-50 to-blue-50">
        <div className="container mx-auto px-6">
          <h2 className="text-4xl md:text-5xl font-bold text-gray-800 mb-12 text-center text-ocean">{t('plateau.title')}</h2>
          <div className="grid md:grid-cols-2 gap-8 max-w-6xl mx-auto">
            {[
              { emoji: '🏛️', title: t('plateau.mythic.title'), text: t('plateau.mythic.text'), gradient: 'from-cyan-500 to-blue-500' },
              { emoji: '🎭', title: t('plateau.culture.title'), text: t('plateau.culture.text'), gradient: 'from-teal-500 to-cyan-500' },
              { emoji: '🚇', title: t('plateau.access.title'), text: t('plateau.access.text'), gradient: 'from-blue-500 to-indigo-500' },
              { emoji: '🌍', title: t('plateau.diversity.title'), text: t('plateau.diversity.text'), gradient: 'from-cyan-500 to-teal-500' }
            ].map((item, i) => (
              <div key={i} className="glass-card rounded-2xl p-8 shadow-lg hover-lift">
                <div className={`w-12 h-12 bg-gradient-to-br ${item.gradient} rounded-full flex items-center justify-center mb-4`}>
                  <span className="text-2xl">{item.emoji}</span>
                </div>
                <h3 className="text-2xl font-bold text-gray-800 mb-4">{item.title}</h3>
                <p className="text-gray-600 leading-relaxed">{item.text}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Contact */}
      <section id="contact" className="py-20 hero-gradient text-white relative">
        <div className="container mx-auto px-6 relative z-10">
          <div className="max-w-4xl mx-auto text-center">
            <h2 className="text-4xl md:text-5xl font-bold mb-8">{t('contact.title')}</h2>
            <p className="text-xl mb-12 text-cyan-100">{t('contact.subtitle')}</p>
            <div className="grid md:grid-cols-2 gap-8 mb-12">
              <div className="glass-card text-gray-800 rounded-2xl p-8 shadow-2xl hover-lift">
                <div className="w-12 h-12 bg-gradient-to-br from-cyan-500 to-blue-500 rounded-full flex items-center justify-center mb-4">
                  <span className="text-2xl">📧</span>
                </div>
                <h3 className="text-xl font-bold mb-4">{t('contact.admin')}</h3>
                <p className="text-gray-600 mb-2"><strong>{t('contact.email')}:</strong> administration@lesdauphins.ca</p>
                <p className="text-gray-600"><strong>{t('contact.phone')}:</strong> (514) 524-7587</p>
              </div>
              <div className="glass-card text-gray-800 rounded-2xl p-8 shadow-2xl hover-lift">
                <div className="w-12 h-12 bg-gradient-to-br from-teal-500 to-cyan-500 rounded-full flex items-center justify-center mb-4">
                  <span className="text-2xl">🕐</span>
                </div>
                <h3 className="text-xl font-bold mb-4">{t('contact.hours')}</h3>
                <p className="text-gray-600 mb-2"><strong>{t('contact.weekdays')}:</strong> 9h00 - 17h00</p>
                <p className="text-gray-600"><strong>{t('contact.emergency')}:</strong> 24h/7j</p>
              </div>
            </div>
            <Link to="/connexion" className="inline-block btn-aqua px-10 py-5 rounded-full font-semibold text-lg shadow-2xl">{t('contact.portal')}</Link>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-slate-900 text-white py-12 dolphin-wave">
        <div className="container mx-auto px-6">
          <div className="grid md:grid-cols-3 gap-8">
            <div>
              <div className="flex items-center space-x-2 mb-4">
                <svg className="w-8 h-8 text-cyan-400" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M19.5 12c0-1.77-.96-3.31-2.39-4.16C17.77 6.58 18 5.08 18 4.5c0-1.88-.91-2.5-2-2.5-1.45 0-2.78.76-3.92 1.64C11.35 3.23 10.68 3 10 3c-3.87 0-7 3.13-7 7 0 2.21 1.03 4.18 2.63 5.45C5.23 16.25 5 17.1 5 18c0 2.21 1.79 4 4 4 .74 0 1.43-.21 2.03-.56C12.16 22.42 13.54 23 15 23c2.21 0 4-1.79 4-4 0-.89-.3-1.72-.78-2.38 1.18-.82 1.78-2.14 1.78-3.62zm-9.5 8c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z"/>
                </svg>
                <h4 className="text-xl font-bold">Les Dauphins</h4>
              </div>
              <p className="text-gray-400">{t('footer.description')}</p>
            </div>
            <div>
              <h4 className="text-xl font-bold mb-4">{t('footer.quickLinks')}</h4>
              <ul className="space-y-2 text-gray-400">
                <li><a href="#histoire" className="hover:text-cyan-400 transition">{t('nav.history')}</a></li>
                <li><a href="#plateau" className="hover:text-cyan-400 transition">{t('nav.plateau')}</a></li>
                <li><Link to="/connexion" className="hover:text-cyan-400 transition">{t('nav.login')}</Link></li>
              </ul>
            </div>
            <div>
              <h4 className="text-xl font-bold mb-4">{t('footer.address')}</h4>
              <p className="text-gray-400">3535, avenue Papineau<br />Montréal, QC H2K 4J9</p>
            </div>
          </div>
          <div className="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400">
            <p>&copy; 2025 Les Dauphins. {t('footer.rights')}</p>
          </div>
        </div>
      </footer>
    </div>
  )
}
